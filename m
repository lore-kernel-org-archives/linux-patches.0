Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186EE1494B8;
	Mon, 12 Aug 2024 16:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480633; cv=none; b=jBLho6v+N4li8liXZbys8qMh+NJcvjvqzduClG9sznywcoRqwRNmgcuhFzcFLTzcmewC53ig3G6EyhY0ppLv03jVWz9Us+ErCM64Ay/4beNlaY8V3akZQVbXxhJBt7Q9fGOdDRFJKoGAhGZJ2eUZuUB2I3ht4Aso0akQunnnIAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480633; c=relaxed/simple;
	bh=EIyTthacuseGh9KhzHZQRyhWz0KgqsVW/9AbfWZRg6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXXdwCpFxvIvhDaeyjfed9fBWUybeBaMyQd6wFOlh2iRX8vYToxwVC2w6uE9uBag+B3QHjCMnzcoA7cT4sO5uFamWueY8oWS0DDjeHa3XEkFctMLNHOlHkcEeZgh3I0jbdZdiKguJ2GTcFSyIUJ3urhQcZV6S5/ILqlLSOGmJ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Je2oYoI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Je2oYoI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7537DC32782;
	Mon, 12 Aug 2024 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480633;
	bh=EIyTthacuseGh9KhzHZQRyhWz0KgqsVW/9AbfWZRg6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Je2oYoI8oznGMxVEWoUiSFY62ayi+49MPA2wIY55ryzjiHa8eFbvt01R0kNoVA/Qe
	 LFZLTX1Mv7aD3POwTzOWZvL2uBYr4ptfqTIedR4pbd0eaqVLdiZasTTwzwre90uQu2
	 4RzXtguicxwsVTsVQTJAiK0DwpsqZ8BEH/2LKi/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.10 224/263] power: supply: axp288_charger: Fix constant_charge_voltage writes
Date: Mon, 12 Aug 2024 18:03:45 +0200
Message-ID: <20240812160155.112952723@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


