Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B238C63D5;
	Thu, 15 Aug 2024 14:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733005; cv=none; b=IrBBiPILdSYKA/NPeP80mkNBtTm7orpR5uaZuR2nQBXIuIgNvboLmkMM7j+xh4AsEz2jt6Mwa8tr4ACVSKuNu1iauPP7xIsCVv5a+mfq15bnPC/0z9e6qDcoTDt9gwheRVKWAPOXgRZcnDBk5xvncYtkXBUCPIUOEJy6OKLWPa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733005; c=relaxed/simple;
	bh=tSXEenGZ42zAcUABwnE/6qT6KE4kBu3wJULEWQ91I1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liQ0SeAZtqHWs9XS9Pjdts3wui7A9UFemWzHpVKt1rPh4fw/HHf2Ts394fX8RWqJbTmemjnwYGAeaRCWmClIPrCKwYJ6k5ng5NmpnmJEp9jZRzaAALLw2AUaXa+yY2RHvCh4SgMv/TCVit0EILW1/v9qxrOetrHR6lkeSQKT64o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vROfje8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vROfje8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ECEC32786;
	Thu, 15 Aug 2024 14:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723733005;
	bh=tSXEenGZ42zAcUABwnE/6qT6KE4kBu3wJULEWQ91I1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vROfje8FiKUq56XaA9WcQsfsNnVRQMWtHATxDyBCYipf1HVsNi5Mr1+SIJ0iDMjg9
	 XjjHDv+fk3paRtdzEUolNP0PY2j+/aoIVlumUpdGUBDWoS4+nazrQmBa+DX8966Obn
	 FCoEsgsNi8dzzZXN1fi+uD5/2AO001PkrYd9zcTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.10 321/352] power: supply: axp288_charger: Fix constant_charge_voltage writes
Date: Thu, 15 Aug 2024 15:26:27 +0200
Message-ID: <20240815131931.861740275@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


