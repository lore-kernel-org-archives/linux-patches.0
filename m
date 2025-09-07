Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA0E4315A;
	Sun,  7 Sep 2025 20:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277443; cv=none; b=D6pGCR3V8iBnV8lTuvl4dgy6TCk9G1kdUcMxvRMX022hGSqPDadl+EGbhZI5KdnbA6D9VW8UPyE2IypGaNpip6661eYvC579tOtQkPU8qPCeRs/z+qxbbg2rxOELr8vVXZpDHZ8nYh5Mi4adCdpJVYnq2aTypFja1QCTlpq8/3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277443; c=relaxed/simple;
	bh=kjGeaF7TZ2PUkRO8IU3aLqhwmY/vxrtVdVqfQe+LwUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0QJOHbCfErQNZyRYZjAA+DKB2sMXQ/fgBjSYjFb5WCP3qqEDVaEmNt/Z1V0/Xmy+mTRz6CE/lysQlmNg2hHp9RY/6cRsOihd2tQpIFAwVTo4eT/hm+O2Vlj7l5k4QNYfVoLg4Pv8UG+3OArarX6yPQn8XS2TikhmZRen1Oad84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kubza1HL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kubza1HL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68450C4CEF0;
	Sun,  7 Sep 2025 20:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277442;
	bh=kjGeaF7TZ2PUkRO8IU3aLqhwmY/vxrtVdVqfQe+LwUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kubza1HL64vraRS9qR7nI0AKPN8mXWRtg8BpzN+tKT7a8h2wDzfQwAjPZ2DyZmv+7
	 YC6KoV+DOCNAjM5fzJRHOvyojTpniaLpdewIg9D621/x+ty/JwfOH0WdO0ALjLTsGP
	 RpwDzr2hCqi8TlnqkG2L37irTLgM9T0Eqxkc9xZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 017/183] platform/x86/amd: pmc: Drop SMU F/W match for Cezanne
Date: Sun,  7 Sep 2025 21:57:24 +0200
Message-ID: <20250907195616.198376634@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 5b9e07551faa7bb2f26cb039cc6e8d00bc4d0831 ]

Chris reported that even on a BIOS that has a new enough SMU F/W
version there is still a spurious IRQ1.  Although the solution was
added to SMU F/W 64.66.0 it turns out there needs to be a matching
SBIOS change to activate it.  Thus Linux shouldn't be avoiding the
IRQ1 workaround on newer SMU F/W because there is no indication the
BIOS change is in place.

Drop the match for 64.66.0+ and instead match all RN/CZN/BRC (they
all share same SMU F/W). Adjust the quirk infrastructure to allow
quirking the workaround on or off and also adjust existing quirks
to match properly.

Unfortunately this may cause some systems that did have the SBIOS
change in place to regress in keyboard wakeup but we don't have a
way to know.  If a user reports a keyboard wakeup regression they can
run with amd_pmc.disable_workarounds=1 to deactivate the workaround
and share DMI data so that their system can be quirked not to use
the workaround in the upstream kernel.

Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4449
Tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250724185156.1827592-1-superm1@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 54 ++++++++++++++---------
 drivers/platform/x86/amd/pmc/pmc.c        | 13 ------
 2 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index ded4c84f5ed14..7ffc659b27944 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -28,10 +28,15 @@ static struct quirk_entry quirk_spurious_8042 = {
 	.spurious_8042 = true,
 };
 
+static struct quirk_entry quirk_s2idle_spurious_8042 = {
+	.s2idle_bug_mmio = FCH_PM_BASE + FCH_PM_SCRATCH,
+	.spurious_8042 = true,
+};
+
 static const struct dmi_system_id fwbug_list[] = {
 	{
 		.ident = "L14 Gen2 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "20X5"),
@@ -39,7 +44,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "T14s Gen2 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "20XF"),
@@ -47,7 +52,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "X13 Gen2 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "20XH"),
@@ -55,7 +60,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "T14 Gen2 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "20XK"),
@@ -63,7 +68,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "T14 Gen1 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "20UD"),
@@ -71,7 +76,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "T14 Gen1 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "20UE"),
@@ -79,7 +84,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "T14s Gen1 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "20UH"),
@@ -87,7 +92,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "T14s Gen1 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "20UJ"),
@@ -95,7 +100,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "P14s Gen1 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "20Y1"),
@@ -103,7 +108,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "P14s Gen2 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21A0"),
@@ -111,7 +116,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "P14s Gen2 AMD",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21A1"),
@@ -152,7 +157,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "IdeaPad 1 14AMN7",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82VF"),
@@ -160,7 +165,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "IdeaPad 1 15AMN7",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82VG"),
@@ -168,7 +173,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "IdeaPad 1 15AMN7",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82X5"),
@@ -176,7 +181,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "IdeaPad Slim 3 14AMN8",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82XN"),
@@ -184,7 +189,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	},
 	{
 		.ident = "IdeaPad Slim 3 15AMN8",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82XQ"),
@@ -193,7 +198,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	/* https://gitlab.freedesktop.org/drm/amd/-/issues/4434 */
 	{
 		.ident = "Lenovo Yoga 6 13ALC6",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82ND"),
@@ -202,7 +207,7 @@ static const struct dmi_system_id fwbug_list[] = {
 	/* https://gitlab.freedesktop.org/drm/amd/-/issues/2684 */
 	{
 		.ident = "HP Laptop 15s-eq2xxx",
-		.driver_data = &quirk_s2idle_bug,
+		.driver_data = &quirk_s2idle_spurious_8042,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Laptop 15s-eq2xxx"),
@@ -285,6 +290,16 @@ void amd_pmc_quirks_init(struct amd_pmc_dev *dev)
 {
 	const struct dmi_system_id *dmi_id;
 
+	/*
+	 * IRQ1 may cause an interrupt during resume even without a keyboard
+	 * press.
+	 *
+	 * Affects Renoir, Cezanne and Barcelo SoCs
+	 *
+	 * A solution is available in PMFW 64.66.0, but it must be activated by
+	 * SBIOS. If SBIOS is known to have the fix a quirk can be added for
+	 * a given system to avoid workaround.
+	 */
 	if (dev->cpu_id == AMD_CPU_ID_CZN)
 		dev->disable_8042_wakeup = true;
 
@@ -295,6 +310,5 @@ void amd_pmc_quirks_init(struct amd_pmc_dev *dev)
 	if (dev->quirks->s2idle_bug_mmio)
 		pr_info("Using s2idle quirk to avoid %s platform firmware bug\n",
 			dmi_id->ident);
-	if (dev->quirks->spurious_8042)
-		dev->disable_8042_wakeup = true;
+	dev->disable_8042_wakeup = dev->quirks->spurious_8042;
 }
diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index 0b9b23eb7c2c3..bd318fd02ccf4 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -530,19 +530,6 @@ static int amd_pmc_get_os_hint(struct amd_pmc_dev *dev)
 static int amd_pmc_wa_irq1(struct amd_pmc_dev *pdev)
 {
 	struct device *d;
-	int rc;
-
-	/* cezanne platform firmware has a fix in 64.66.0 */
-	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
-		if (!pdev->major) {
-			rc = amd_pmc_get_smu_version(pdev);
-			if (rc)
-				return rc;
-		}
-
-		if (pdev->major > 64 || (pdev->major == 64 && pdev->minor > 65))
-			return 0;
-	}
 
 	d = bus_find_device_by_name(&serio_bus, NULL, "serio0");
 	if (!d)
-- 
2.50.1



