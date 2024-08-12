Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DA4186E38;
	Mon, 12 Aug 2024 16:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479045; cv=none; b=KQH9ST3MCRIK8nYSCIquNV+uZFWKCJeVwYo56OtML3KET7Nkz799hwklXbtcZ1pFTyp5BngMbUWXNCeYm4EQNeMgeTpoWcFAOI9Vk5Cx4e0h9MTfYIQ91R1hih9johutRCu2ZU6CTG8pCrUyCcMCzd9HxjxIfW4L8VSHk9nv2Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479045; c=relaxed/simple;
	bh=FOAwlT3rV7Ir9y0XwnDL0+lgzU2oHPNmtua/LgEH6/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVYJvk+4X2U1YurVFSRU8WAOK15YU6SJcjC5UmT8EBBei4pEm4EcOKI26iwkB1I97/70FGLg+cVgfV1OTK2ZPnGK0yDR0Bi2cYryvKHuHUeTn2ux0k3qHWOT5QTkdEIETaEqexppi07mIES6Z1MbqKJ5/Owt3pa8jGL0nyTtJsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcGwFLWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcGwFLWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EA0C32782;
	Mon, 12 Aug 2024 16:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479044;
	bh=FOAwlT3rV7Ir9y0XwnDL0+lgzU2oHPNmtua/LgEH6/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcGwFLWZ2GghmAShLCg5Iz2Ru8qKCiHmlrxUcdaA3WcswVBAZTUFVx6COkKDQPLqG
	 L8bDLvFjdA1rFWKL+piGPyxmTB+3qxh9l3DJyXoH8w9fyJMhypSpgh96zSBj3ArxyB
	 EJ/dRfY/BN6IX/IDlq1RiEZeXI6jrkbmq2TZDTGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 115/150] power: supply: axp288_charger: Fix constant_charge_voltage writes
Date: Mon, 12 Aug 2024 18:03:16 +0200
Message-ID: <20240812160129.599542652@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


