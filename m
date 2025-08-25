Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C2226A09F;
	Mon, 25 Aug 2025 12:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756124113; cv=none; b=PfRsm5ZTIMA+7Vmb0oEqI9T5bM1Jp+nqnY4JR1OY0dKQPA7Iknnhtyec+E9Co0QByTcMVTaE90AGUU7NHokbgfCIrjlh5yYLmnQXVqQmI4gxKj7u83shi0NSj3HG0aT6iWnVMQxSauqT9MNAQAZ6ILag22qH8u0SDmFkpHvpVUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756124113; c=relaxed/simple;
	bh=I1v5FGDEpmLOz/xWeQas7bSx+T6EsGdIIPVu/1iJbCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qmRtl9xyFHlm1kdtMwU4JQ2nbuULDUKA2WJ+KsmTXabgdlysMfycWLpi5zo92m+5sw04GkMxT1J3POesxhAoSrMWK/qtSWoCuY+uU4CZAKEQ2IW/MND/W7YMgrcMEQ0TjYT5H6eCi5ZpKY1QadPpHnpWge+8QVLJ5I/Sr/SPcUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezCW5Q64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezCW5Q64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3B2C113D0;
	Mon, 25 Aug 2025 12:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756124113;
	bh=I1v5FGDEpmLOz/xWeQas7bSx+T6EsGdIIPVu/1iJbCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezCW5Q64XPnJXg2gtCf84HVf7LpxgXhaZGgIu517KAbpSs84QrrK2QVb4bdm5OeFE
	 39nHDdUJfA6Tt33sInXHTaKL2udF0by1E8r3UCLB7cY4Ypm9m9PsrWyM2VUwg3Woe6
	 u8YQ1xFUzODa6JlwMg8z/1aQ6U9HNCu7MSiu9J8lM5gkviTwIkzEx+8UCR1EiRJIea
	 0h4z0Ml/6JKrElMRxbr+Rf08bY9jv4BkhtkmtdAcsIVJRpBDmLV5BKzehKkHWrEHEu
	 7/9LkcW7GZ4HHvL3FhTQy+6rVEfmZvemPVXOo+Opq7HXjSZXzCzAwHb2DJ1sORaF91
	 /Z6QH3W+YynRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shyam-sundar.S-k@amd.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16] platform/x86/amd: pmc: Drop SMU F/W match for Cezanne
Date: Mon, 25 Aug 2025 08:14:54 -0400
Message-ID: <20250825121505.2983941-5-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250825121505.2983941-1-sashal@kernel.org>
References: <20250825121505.2983941-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.3
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Now I have a better understanding. Let me analyze the commit to
determine if it should be backported:

**Backport Status: YES**

## Extensive Explanation:

This commit should be backported to stable kernel trees for the
following reasons:

### 1. **Fixes a Real User-Impacting Bug**
The commit addresses a spurious IRQ1 (keyboard interrupt) issue that
causes unintended system wakeups from suspend. The commit message
references a specific bug report
(https://gitlab.freedesktop.org/drm/amd/-/issues/4449) where users are
experiencing this problem. This directly impacts user experience with
system suspend/resume functionality.

### 2. **Regression Fix for Previous Workaround**
The code shows this is fixing an incomplete workaround that was
previously implemented. The original workaround avoided applying the
IRQ1 disable on SMU firmware version 64.66.0+, assuming the firmware fix
was sufficient. However, the commit message reveals that:
- The SMU firmware fix requires a matching SBIOS change to be activated
- Linux has no way to detect if the SBIOS change is present
- This means systems with newer SMU firmware but without the SBIOS
  change still experience the spurious IRQ1 issue

### 3. **Limited Scope and Low Risk**
The changes are confined to the AMD PMC driver quirks handling:
- Removes the SMU firmware version check from `amd_pmc_wa_irq1()`
  function
- Adjusts the quirk infrastructure to allow both s2idle bug and spurious
  8042 fixes
- Updates DMI matches to use the combined quirk where appropriate
- The changes are self-contained within the platform-specific driver

### 4. **Hardware-Specific Fix**
The fix targets specific AMD CPU models (Renoir/Cezanne/Barcelo -
RN/CZN/BRC) that share the same SMU firmware. This hardware-specific
nature means:
- It won't affect other platforms
- The risk is limited to AMD systems that already have the issue
- The workaround provides a module parameter
  (`amd_pmc.disable_workarounds=1`) for users who might experience
  regressions

### 5. **Addresses Known Hardware/Firmware Limitation**
The commit acknowledges a hardware/firmware limitation where:
- A fix exists in SMU firmware 64.66.0+
- But it requires SBIOS activation that Linux cannot detect
- This is a defensive approach to ensure all affected systems get the
  workaround

### 6. **Provides User Control**
The commit message mentions that users who experience keyboard wakeup
regression can use `amd_pmc.disable_workarounds=1` to disable the
workaround and provide DMI data for future quirking. This gives users an
escape hatch if needed.

### 7. **Follows Stable Kernel Criteria**
This commit meets the stable kernel backport criteria:
- **Fixes a real bug**: Spurious IRQ1 wakeups affecting suspend/resume
- **Already tested**: Has a "Tested-by" tag from the bug reporter
- **Small and contained**: Changes are limited to the AMD PMC driver
- **No new features**: Only adjusts existing workaround logic
- **Clear impact**: Users experience unwanted system wakeups

### Code Analysis Details:
The key change in `drivers/platform/x86/amd/pmc/pmc.c` removes the SMU
version check:
```c
- /* cezanne platform firmware has a fix in 64.66.0 */
- if (pdev->cpu_id == AMD_CPU_ID_CZN) {
- if (!pdev->major) {
- rc = amd_pmc_get_smu_version(pdev);
- if (rc)
- return rc;
- }
- if (pdev->major > 64 || (pdev->major == 64 && pdev->minor > 65))
- return 0;
- }
```

This ensures the workaround is always applied for affected CPUs,
regardless of SMU firmware version.

The quirks restructuring in `pmc-quirks.c` creates a combined quirk
(`quirk_s2idle_spurious_8042`) that applies both fixes where needed,
showing careful consideration of the various affected systems.

 drivers/platform/x86/amd/pmc/pmc-quirks.c | 54 ++++++++++++++---------
 drivers/platform/x86/amd/pmc/pmc.c        | 13 ------
 2 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index ded4c84f5ed1..7ffc659b2794 100644
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
index 0b9b23eb7c2c..bd318fd02ccf 100644
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

