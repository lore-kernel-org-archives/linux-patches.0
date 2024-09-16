Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE1113DBA0;
	Mon, 16 Sep 2024 12:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488190; cv=none; b=DE+4VU8QVpru140oyDl3HItdufrvaXsqjUB1at89IY/D+ZDQj2/7wQzDwav/6I1G70cBrtHyt+OHIOjaZvMLHUn9rBKv+WuVjb1Yhr2pq73eRyppGUZmlaaZ4lyuhv645u0u2ujJgMnnKgCi7gOMUvWPYzer9MAeLrj0/6m6ODk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488190; c=relaxed/simple;
	bh=GePFtdUiW7IZ+e9JdQaAYCk5TPr52C9/vEGqnt7E4QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gYHkK4qY5yZ0LyCO66BhFb5xdovLCDvaHDsv3Lm1Y5FwbF5hya9F/jY10ne1SBKWi9ux6w8Uk+r9DknC0MI2JGm2Ie/mg4C70+aljnb9m8+9J1u3OdDuw6jwz5gD9p3gcUq1J7vZslrhmmVY4cozkLcFIpgi1h8jFE1k82+6+as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYwRkOv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYwRkOv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8657C4CEC4;
	Mon, 16 Sep 2024 12:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488190;
	bh=GePFtdUiW7IZ+e9JdQaAYCk5TPr52C9/vEGqnt7E4QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYwRkOv9Drs3EftmjXcc1xeYtFUnL9+w3L9/SaU2ipFacMgk0ahx1nWPSlX8vlOlj
	 UFfD9+aKewUCCU1HSXpZR9PwFlJsYuDDTV58IPM9NFF81JzdnzEUwW3mMiIhU3kLy6
	 5jpvbNjH+CI2QZ5jeRDQ8npTHVe9Ea7yspTsy/Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 026/121] platform/x86: asus-wmi: Add quirk for ROG Ally X
Date: Mon, 16 Sep 2024 13:43:20 +0200
Message-ID: <20240916114229.896238106@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit d2dfed310aae0739dc87b68c660357e6a4f29819 ]

The new ROG Ally X functions the same as the previus model so we can use
the same method to ensure the MCU USB devices wake and reconnect
correctly.

Given that two devices marks the start of a trend, this patch also adds
a quirk table to make future additions easier if the MCU is the same.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240805234603.38736-1-luke@ljones.dev
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index bc9c5db38324..5fe5149549cc 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -146,6 +146,20 @@ static const char * const ashs_ids[] = { "ATK4001", "ATK4002", NULL };
 
 static int throttle_thermal_policy_write(struct asus_wmi *);
 
+static const struct dmi_system_id asus_ally_mcu_quirk[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "RC71L"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "RC72L"),
+		},
+	},
+	{ },
+};
+
 static bool ashs_present(void)
 {
 	int i = 0;
@@ -4650,7 +4664,7 @@ static int asus_wmi_add(struct platform_device *pdev)
 	asus->dgpu_disable_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_DGPU);
 	asus->kbd_rgb_state_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_TUF_RGB_STATE);
 	asus->ally_mcu_usb_switch = acpi_has_method(NULL, ASUS_USB0_PWR_EC0_CSEE)
-						&& dmi_match(DMI_BOARD_NAME, "RC71L");
+						&& dmi_check_system(asus_ally_mcu_quirk);
 
 	if (asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_MINI_LED_MODE))
 		asus->mini_led_dev_id = ASUS_WMI_DEVID_MINI_LED_MODE;
-- 
2.43.0



