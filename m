Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F90086347;
	Tue, 27 May 2025 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365875; cv=none; b=EE/6xUW4RoWN5iWDQFdJQSyG4YR3pbaWdMwrAhKFg7ox2ny13H0E8UZJ6rZKvnRme/rsELuzM3d97+Rr6tzhDR0fovo4h4Iky92Zk6GUlhOaeRcL0Gye/9ZMM8TJuVOHB6u+JFsRuW15QU43Dxi0Xy37f0QlgFd+Lv+KY9xNLnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365875; c=relaxed/simple;
	bh=la1RINZRgPmU1c+EqJJDHhA9RxwumN1QYqfo50/DDuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UNtCt8K/unfci4Pw5YvS+nngUB1PLKVHW3Hcdy+LBiPNhl0xX11x5RELM0z/k6qY+25+/D7BVAvF5p0M95MZ0GDF6A/JDw6n03MQV3F6EZErAgeVQnCqT/wKgMsMntKT41hRsHSiATVpUjOlvmCK+p17BR4AQKdjZPmiVneoOt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXnqzXNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXnqzXNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E015C4CEE9;
	Tue, 27 May 2025 17:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365875;
	bh=la1RINZRgPmU1c+EqJJDHhA9RxwumN1QYqfo50/DDuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXnqzXNdPtcd7zslu8ZTs5N0slKYrZTPzl9RfswszAyrltakfnX1VYHwvlggPg7lF
	 +lCCnEQsyw2EVN2nBwcThURcud2xIdr5AWL0AiDYh5q5BuYCCRi2cxNFyVgNYNhIeb
	 Zes+hwkU2svSvfuEkjWZIcD0yc1BY7SnW7/avpGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Nikulin <pavel@noa-labs.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 510/626] platform/x86: asus-wmi: Disable OOBE state after resume from hibernation
Date: Tue, 27 May 2025 18:26:43 +0200
Message-ID: <20250527162505.688034157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Nikulin <pavel@noa-labs.com>

[ Upstream commit 77bdac73754e4c0c564c1ca80fe3d9c93b0e715a ]

ASUS firmware resets OOBE state during S4 suspend, so the keyboard
blinks during resume from hibernation. This patch disables OOBE state
after resume from hibernation.

Signed-off-by: Pavel Nikulin <pavel@noa-labs.com>
Link: https://lore.kernel.org/r/20250418140706.1691-1-pavel@noa-labs.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index a1cff9ff35a92..9d79c5ea8b495 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -304,6 +304,7 @@ struct asus_wmi {
 
 	u32 kbd_rgb_dev;
 	bool kbd_rgb_state_available;
+	bool oobe_state_available;
 
 	u8 throttle_thermal_policy_mode;
 	u32 throttle_thermal_policy_dev;
@@ -1826,7 +1827,7 @@ static int asus_wmi_led_init(struct asus_wmi *asus)
 			goto error;
 	}
 
-	if (asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_OOBE)) {
+	if (asus->oobe_state_available) {
 		/*
 		 * Disable OOBE state, so that e.g. the keyboard backlight
 		 * works.
@@ -4741,6 +4742,7 @@ static int asus_wmi_add(struct platform_device *pdev)
 	asus->egpu_enable_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_EGPU);
 	asus->dgpu_disable_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_DGPU);
 	asus->kbd_rgb_state_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_TUF_RGB_STATE);
+	asus->oobe_state_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_OOBE);
 	asus->ally_mcu_usb_switch = acpi_has_method(NULL, ASUS_USB0_PWR_EC0_CSEE)
 						&& dmi_check_system(asus_ally_mcu_quirk);
 
@@ -4994,6 +4996,13 @@ static int asus_hotk_restore(struct device *device)
 	}
 	if (!IS_ERR_OR_NULL(asus->kbd_led.dev))
 		kbd_led_update(asus);
+	if (asus->oobe_state_available) {
+		/*
+		 * Disable OOBE state, so that e.g. the keyboard backlight
+		 * works.
+		 */
+		asus_wmi_set_devstate(ASUS_WMI_DEVID_OOBE, 1, NULL);
+	}
 
 	if (asus_wmi_has_fnlock_key(asus))
 		asus_wmi_fnlock_update(asus);
-- 
2.39.5



