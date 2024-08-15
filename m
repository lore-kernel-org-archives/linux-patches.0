Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA81C19DFA4;
	Thu, 15 Aug 2024 14:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731801; cv=none; b=h8+7VWLp+IosE/0LpkPi2w+68vT90sdpAg1azrKrphUyw8/XtIRVPYeImA9dKmBYcZYGIF/+9rp5jAPl2h/hsmxyN1cZKa+rI9lSbJ86Ca6ZZpXhMtmODkRyRaS9d5PV+njL1g67OJNDV7lqgy+m41t0BS0deI5FA06UpCS9mdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731801; c=relaxed/simple;
	bh=RirPDikwhAU3cmghkEvYgOp8XuNSUeaQusRnbd/5S4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0RHoz7DFIS+oHFJHy5tZ0adkj7F06DUzXN9g1HpC92e1ei/y32AM+orqayy1QGZLkEcf6Oz8dFMlFkQIGizcEFP90C+4Kbe/N5HR+bnZuxAjGidU39thuLRx6hmlR+nBDvkL1o5CNpAMAv35QsQrM9VFUTRq/tjstCo6XIYbpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvnhWEWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvnhWEWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F981C4AF0D;
	Thu, 15 Aug 2024 14:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731801;
	bh=RirPDikwhAU3cmghkEvYgOp8XuNSUeaQusRnbd/5S4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvnhWEWe3xZXNqfjqMZQWw0st684WwgZ2pJqo1MGEDZbrMyoyFsF5qsBFDNtVkoX9
	 4i5l2dmRTRQ33tz+Y2ZgopNOuiPPn/DOty36kIuYUhNNGkHCMh3RmLbYZ4bFzij8Ku
	 lF14HXBrNHicqq91abs9BgKj+5G9MN7VIxTJKGmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.4 243/259] power: supply: axp288_charger: Fix constant_charge_voltage writes
Date: Thu, 15 Aug 2024 15:26:16 +0200
Message-ID: <20240815131912.155276288@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -371,8 +371,8 @@ static int axp288_charger_usb_set_proper
 			dev_warn(&info->pdev->dev, "set charge current failed\n");
 		break;
 	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
-		scaled_val = min(val->intval, info->max_cv);
-		scaled_val = DIV_ROUND_CLOSEST(scaled_val, 1000);
+		scaled_val = DIV_ROUND_CLOSEST(val->intval, 1000);
+		scaled_val = min(scaled_val, info->max_cv);
 		ret = axp288_charger_set_cv(info, scaled_val);
 		if (ret < 0)
 			dev_warn(&info->pdev->dev, "set charge voltage failed\n");


