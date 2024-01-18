Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAD21774B;
	Thu, 18 Jan 2024 10:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575360; cv=none; b=hd/HgQGk9D1rsW38Kg942GIxGfO0bNSW88lQzR7G1SF//RWZWCd712GVp0VkVPZMb+r/9SBKFTUzcv39tJfAhVvvr4zt5yePSoYqMHpthWgb6aHtVprp4pCmPGya3vBCsPOIYHzjZZtaIcRLZmMi5TZXbyjULkaLSDJxziOmbQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575360; c=relaxed/simple;
	bh=y/2V4EVJ74gOA0J7SCx56Hyq37hVa7249hBFZM/J+js=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=QpW4lNZYstCUAh2zv7290eZA6r52i68ZlSGBDd/etcvq0qeL1iQubQQ7q9tPEVd0cbIiKmymAFUhR9fM2ZU5ikK/g9b4fLGBDxpALsyBEGyjCkMVSLitJJSeSA1JLGE5GXrA4LWs0+31MDPJ2Mg1GdY8bEPSaXP+zabhNSOr5Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzgdy9XU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzgdy9XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31823C433F1;
	Thu, 18 Jan 2024 10:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575360;
	bh=y/2V4EVJ74gOA0J7SCx56Hyq37hVa7249hBFZM/J+js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzgdy9XUMwnxrVBoTvuDt7CWnAK2iKBs/F6+Xm03+lYc7l2F+DZpnRNedfJDlJFDb
	 vWVOSKaZOM6XaESQbvQqmVCn9va4zDieKX+Dl9zDzXTmLc06SDEU3TUkWpp0Pop0Zh
	 DmqoU6mfl1vVZ/GMEeTSt4EOSeL1Iq3pKcvbgxpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kieran Levin <ktl@framework.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/150] platform/x86/amd/pmc: Disable keyboard wakeup on AMD Framework 13
Date: Thu, 18 Jan 2024 11:48:47 +0100
Message-ID: <20240118104324.918869760@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit a55bdad5dfd1efd4ed9ffe518897a21ca8e4e193 ]

The Laptop 13 (AMD Ryzen 7040Series) BIOS 03.03 has a workaround
included in the EC firmware that will cause the EC to emit a "spurious"
keypress during the resume from s0i3 [1].

This series of keypress events can be observed in the kernel log on
resume.

```
atkbd serio0: Unknown key pressed (translated set 2, code 0x6b on isa0060/serio0).
atkbd serio0: Use 'setkeycodes 6b <keycode>' to make it known.
atkbd serio0: Unknown key released (translated set 2, code 0x6b on isa0060/serio0).
atkbd serio0: Use 'setkeycodes 6b <keycode>' to make it known.
```

In some user flows this is harmless, but if a user has specifically
suspended the laptop and then closed the lid it will cause the laptop
to wakeup. The laptop wakes up because the ACPI SCI triggers when
the lid is closed and when the kernel sees that IRQ1 is "also" active.
The kernel can't distinguish from a real keyboard keypress and wakes the
system.

Add the model into the list of quirks to disable keyboard wakeup source.
This is intentionally only matching the production BIOS version in hopes
that a newer EC firmware included in a newer BIOS can avoid this behavior.

Cc: Kieran Levin <ktl@framework.net>
Link: https://github.com/FrameworkComputer/EmbeddedController/blob/lotus-zephyr/zephyr/program/lotus/azalea/src/power_sequence.c#L313 [1]
Link: https://community.frame.work/t/amd-wont-sleep-properly/41755
Link: https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231212045006.97581-5-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index c32046dfa960..b456370166b6 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -16,12 +16,17 @@
 
 struct quirk_entry {
 	u32 s2idle_bug_mmio;
+	bool spurious_8042;
 };
 
 static struct quirk_entry quirk_s2idle_bug = {
 	.s2idle_bug_mmio = 0xfed80380,
 };
 
+static struct quirk_entry quirk_spurious_8042 = {
+	.spurious_8042 = true,
+};
+
 static const struct dmi_system_id fwbug_list[] = {
 	{
 		.ident = "L14 Gen2 AMD",
@@ -193,6 +198,16 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Laptop 15s-eq2xxx"),
 		}
 	},
+	/* https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128 */
+	{
+		.ident = "Framework Laptop 13 (Phoenix)",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Framework"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Laptop 13 (AMD Ryzen 7040Series)"),
+			DMI_MATCH(DMI_BIOS_VERSION, "03.03"),
+		}
+	},
 	{}
 };
 
@@ -245,4 +260,6 @@ void amd_pmc_quirks_init(struct amd_pmc_dev *dev)
 	if (dev->quirks->s2idle_bug_mmio)
 		pr_info("Using s2idle quirk to avoid %s platform firmware bug\n",
 			dmi_id->ident);
+	if (dev->quirks->spurious_8042)
+		dev->disable_8042_wakeup = true;
 }
-- 
2.43.0



