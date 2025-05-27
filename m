Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2832566;
	Tue, 27 May 2025 17:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368265; cv=none; b=uKDt4wXdwmHNe1j7GHlvDpVmJElLUn9I4etxBLu5UOSuP4LRkDwVbPRIkEHmRsbUoTR5nATk7m/NQsdqSB5y6wJU1FbnBEGFm17tDo0KbSB1UezPAKsFJKyZ2YqJLY6nR320Q7hWEcwdHMxD3ccZCvyIf3K+lHkXuqEcTJzaya0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368265; c=relaxed/simple;
	bh=bYo/+2B27kNslFrqZmq0Gm6esNIUogTHoY0iJ9iQnqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dBCGB9WAmMwyQV0MDoTY1nk9wBwFtVRXMnJ3D5SNBxgmpkboTJ9FHkndglgIilJuje6T3UwAsuvq3zA4gByqbrvOHlFDPFTOrm3DNSyf6VYNXrkCrWcnHJaAFFXR36vWFq9LRx+nZMZwHBqtXlEYnjWK1Pali2GOSIJc7vQPL0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdkB/KiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdkB/KiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E46DC4CEE9;
	Tue, 27 May 2025 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368264;
	bh=bYo/+2B27kNslFrqZmq0Gm6esNIUogTHoY0iJ9iQnqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdkB/KiJzoMTLTpz3GO8b7xhxJrpyx6OHjgYVg2ZVTeihS50IjRm9+XRP9jDuB4oL
	 NUNyn9hoxBRiUB9lAPLxgs71I/puL121yik34lqf//ncHa1762LRxEP7sSj36EGSbI
	 5s9+OyvIDvR2y5X/sv+z0QdzK+Dv8ZClPB0ZSos4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Nikulin <pavel@noa-labs.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 652/783] platform/x86: asus-wmi: Disable OOBE state after resume from hibernation
Date: Tue, 27 May 2025 18:27:29 +0200
Message-ID: <20250527162539.683546665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index f66d152e265da..47cc766624d7b 100644
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
@@ -4723,6 +4724,7 @@ static int asus_wmi_add(struct platform_device *pdev)
 	asus->egpu_enable_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_EGPU);
 	asus->dgpu_disable_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_DGPU);
 	asus->kbd_rgb_state_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_TUF_RGB_STATE);
+	asus->oobe_state_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_OOBE);
 	asus->ally_mcu_usb_switch = acpi_has_method(NULL, ASUS_USB0_PWR_EC0_CSEE)
 						&& dmi_check_system(asus_ally_mcu_quirk);
 
@@ -4971,6 +4973,13 @@ static int asus_hotk_restore(struct device *device)
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



