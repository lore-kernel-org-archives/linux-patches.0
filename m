Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181FF29CA;
	Mon, 12 Aug 2024 16:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479631; cv=none; b=uCJkFQNXQEWm83J4g5LKzse1v5maBPY/ngVOvcoMuVoRxV4g/mOdZUUcV1fijKqiImNWl0stxijkNg+zmFeBKjXM3iUmFDqKG6nPT7FNiiNCDmzQlxtF+jrKN70uBBlG1csmaBu8r8uU77fvBDvAa9/SWmVYGa6j0W+YKhP0Q9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479631; c=relaxed/simple;
	bh=7YFnXbha9sbcweEb/qh8AAmyN6Z/JknCyACA1/gi/jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5a/aOqsbvZhQ1BN0Lwm7XKWav8jpHCLAym9g+jJkJCRr6RzGwTHfkRh7VZFn/2rHJsQplCfOncn9GTNG1HsgM/GrygOwn0tU7mnUzXRDDf6RxES6FzvJf4QxvFo+uFcuj3pitJGVbpWjeKEzVB9d4r2W7birkulNAgGx5icrk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EK0M3Vo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EK0M3Vo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C84C32782;
	Mon, 12 Aug 2024 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479631;
	bh=7YFnXbha9sbcweEb/qh8AAmyN6Z/JknCyACA1/gi/jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EK0M3Vo01kwLEaNaMZT4vmBQijMwU9UDO9+DoUdDBMIJosGmyZaY6R0LtuZm6EbC3
	 aGcOI7RkX/d5Uzey9zDgE8Hq1gp0LKksJ7+GhLkg/bVDMjHonuy/eUQOCzJXVAex9/
	 FgaihwFOtlBBoqXn8jEyCY3gPsWuMfPkJaPyO0Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 146/189] power: supply: axp288_charger: Fix constant_charge_voltage writes
Date: Mon, 12 Aug 2024 18:03:22 +0200
Message-ID: <20240812160137.763290784@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit b34ce4a59cfe9cd0d6f870e6408e8ec88a964585 upstream.

info->max_cv is in millivolts, divide the microvolt value being written
to constant_charge_voltage by 1000 *before* clamping it to info->max_cv.

Before this fix the code always tried to set constant_charge_voltage
to max_cv / 1000 = 4 millivolt, which ends up in setting it to 4.1V
which is the lowest supported value.

Fixes: 843735b788a4 ("power: axp288_charger: axp288 charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240717200333.56669-1-hdegoede@redhat.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/axp288_charger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -337,8 +337,8 @@ static int axp288_charger_usb_set_proper
 		}
 		break;
 	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
-		scaled_val = min(val->intval, info->max_cv);
-		scaled_val = DIV_ROUND_CLOSEST(scaled_val, 1000);
+		scaled_val = DIV_ROUND_CLOSEST(val->intval, 1000);
+		scaled_val = min(scaled_val, info->max_cv);
 		ret = axp288_charger_set_cv(info, scaled_val);
 		if (ret < 0) {
 			dev_warn(&info->pdev->dev, "set charge voltage failed\n");


