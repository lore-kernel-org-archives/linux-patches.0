Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483573090E8;
	Sat, 25 Oct 2025 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409124; cv=none; b=cYidC0Q9Rg5ppZ1cCuvkupEZzzNRwwrBSKtvmpBhVbJdyaZomdcKhSHdcXU1xAu18aHJK7RMW5JD5ti00f2y2Cgxxo/4ZgU8X5dukHoQI3lhDA/T1tAz7DkS+Xd05m5WvzXNCtT6+872gbsMOdpjKVJYICpi6pPFRHq9xWv/wdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409124; c=relaxed/simple;
	bh=/mfqZDXaS19Zt1/yfga/qqLhBhNpk2jGueT690aABBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TakTZj0xUkIy4bQaS+QVwRetj9F3xSYMitq+sk+2hHlTJI99rYSglXciE6gly/HyGbuYb8kGh8AhnZ3Ig7mKKKKnNpq1sYRw7ML7Qq78FrhNMyc4/h5ooWlF3a0BtQY4XrAaKxDBTdiS6U9F3MSk1iz9OZe0U92pFatknztYJy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZFADb+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZFADb+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390E1C4CEFB;
	Sat, 25 Oct 2025 16:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409124;
	bh=/mfqZDXaS19Zt1/yfga/qqLhBhNpk2jGueT690aABBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZFADb+bW8P8XVzATTCp+WBNBvIFZ/Ey4ucEnjJtZu98wTst6RxD+ADHtBciUNccr
	 YReaxlr8na2rv4mlYsTf+e7/deLkFKheA2ZDdP33ZEl1EA/1FO7hkjoII0i5ZuZSyT
	 XSrGFTeJ+GA3BJmWXsq8DO7puKH2tHTJJpkxUswFd4iGy6Bha6FBoSIiOrw2TzbFyK
	 7UeoDuTvl2BQAxa2uCamERzoWCaeXGOiOgurICOOuokQA+BvK9iiZW3AqIAGwZgMZV
	 iiQ5NRczhYQZpCc3imwiZmUnKmXt9Lja6zPvOw3Q27pRBM5b3OgkGsjdFlIZYYaQSd
	 X/IlI/24arAWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Yijun Shen <Yijun.Shen@Dell.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] platform/x86/amd/pmf: Fix the custom bios input handling mechanism
Date: Sat, 25 Oct 2025 11:57:19 -0400
Message-ID: <20251025160905.3857885-208-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit d82e3d2dd0ba019ac6cdd81e47bf4c8ac895cfa0 ]

Originally, the 'amd_pmf_get_custom_bios_inputs()' function was written
under the assumption that the BIOS would only send a single pending
request for the driver to process. However, following OEM enablement, it
became clear that multiple pending requests for custom BIOS inputs might
be sent at the same time, a scenario that the current code logic does not
support when it comes to handling multiple custom BIOS inputs.

To address this, the code logic needs to be improved to not only manage
multiple simultaneous custom BIOS inputs but also to ensure it is scalable
for future additional inputs.

Co-developed-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://patch.msgid.link/20250901110140.2519072-3-Shyam-sundar.S-k@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Bug fixed: The original code assumed only one pending bit would ever
  be set for custom BIOS inputs, so multiple simultaneous notifications
  from firmware were mishandled or ignored. This is a real-world OEM-
  triggered bug that affects policy evaluation and thus system behavior
  (performance/thermal) for users.
  - Before: A single-bit switch on `pending_req` handled only exactly
    one notification and treated others as “invalid.”
  - After: Iterates over a bitmask and applies all pending custom BIOS
    inputs, addressing concurrent notifications.

- Scope and risk: Small, localized to AMD PMF Smart PC input plumbing,
  no UAPI changes, and no architectural rework. It mainly:
  - Introduces a small static mapping of notification bits to input
    indices.
  - Switches to a loop over the bitmask to set multiple inputs.
  - Renames the TA input fields to an array to make handling scalable.

- Concrete code changes
  - Introduces a bitmask table and removes rigid enums:
    - Added per-input bit mapping:
      `drivers/platform/x86/amd/pmf/pmf.h:660`
      - `static const struct amd_pmf_pb_bitmap custom_bios_inputs[]
        __used = { {"NOTIFY_CUSTOM_BIOS_INPUT1", BIT(5)},
        {"NOTIFY_CUSTOM_BIOS_INPUT2", BIT(6)}, ... }`
    - Defines the simple bitmap struct:
      `drivers/platform/x86/amd/pmf/pmf.h:655`
      - `struct amd_pmf_pb_bitmap { const char *name; u32 bit_mask; };`
    - This replaces fixed enum dispatch and makes the logic extensible
      and correct for multiple bits.
  - Makes TA inputs scalable but layout-compatible:
    - Replaces two discrete fields with an array of two:
      `drivers/platform/x86/amd/pmf/pmf.h:743`
      - `u32 bios_input_1[2];`
    - This preserves total size/ordering for the two inputs currently
      used and enables indexing (scalable, no user-visible ABI).
  - Correctly handles multiple pending requests:
    - New helper to set the proper field by index (handles non-
      contiguous layout): `drivers/platform/x86/amd/pmf/spc.c:121`
      - `amd_pmf_set_ta_custom_bios_input(in, index, value);`
    - Iterates all pending bits and applies each matching custom BIOS
      input: `drivers/platform/x86/amd/pmf/spc.c:150`
      - Loops over `custom_bios_inputs`, checks `pdev->req.pending_req &
        bit_mask`, and assigns from `pdev->req.custom_policy[i]`.
    - Debug dump now iterates all defined custom inputs instead of only
      two hardcoded fields: `drivers/platform/x86/amd/pmf/spc.c:107`

- Stable backport criteria
  - Fixes a real bug that affects end users (policy decisions based on
    multiple BIOS flags).
  - Small and self-contained to AMD PMF Smart PC path (files: `pmf.h`,
    `spc.c`).
  - Minimal regression risk: logic simply adds proper handling for
    multiple bits; if only one bit is set, behavior remains as before.
    The field change is internal to the driver/TA IPC and not a kernel
    ABI.
  - No architectural overhaul; it’s a straightforward correctness and
    scalability improvement.
  - The commit message clearly explains the OEM-found issue; the patch
    is tested and reviewed.

- Notes
  - Backport where AMD PMF custom BIOS input handling exists. On
    branches without that feature, this patch is not applicable.
  - Later mainline commits add support for more inputs and versions, but
    this change alone fixes the core bug (multiple simultaneous inputs)
    without pulling in larger reworks.

 drivers/platform/x86/amd/pmf/pmf.h | 15 +++++-----
 drivers/platform/x86/amd/pmf/spc.c | 48 +++++++++++++++++++++++-------
 2 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/pmf.h b/drivers/platform/x86/amd/pmf/pmf.h
index 45b60238d5277..df1b4a4f9586b 100644
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -621,14 +621,14 @@ enum ta_slider {
 	TA_MAX,
 };
 
-enum apmf_smartpc_custom_bios_inputs {
-	APMF_SMARTPC_CUSTOM_BIOS_INPUT1,
-	APMF_SMARTPC_CUSTOM_BIOS_INPUT2,
+struct amd_pmf_pb_bitmap {
+	const char *name;
+	u32 bit_mask;
 };
 
-enum apmf_preq_smartpc {
-	NOTIFY_CUSTOM_BIOS_INPUT1 = 5,
-	NOTIFY_CUSTOM_BIOS_INPUT2,
+static const struct amd_pmf_pb_bitmap custom_bios_inputs[] __used = {
+	{"NOTIFY_CUSTOM_BIOS_INPUT1",     BIT(5)},
+	{"NOTIFY_CUSTOM_BIOS_INPUT2",     BIT(6)},
 };
 
 enum platform_type {
@@ -686,8 +686,7 @@ struct ta_pmf_condition_info {
 	u32 power_slider;
 	u32 lid_state;
 	bool user_present;
-	u32 bios_input1;
-	u32 bios_input2;
+	u32 bios_input_1[2];
 	u32 monitor_count;
 	u32 rsvd2[2];
 	u32 bat_design;
diff --git a/drivers/platform/x86/amd/pmf/spc.c b/drivers/platform/x86/amd/pmf/spc.c
index 1d90f9382024b..869b4134513f3 100644
--- a/drivers/platform/x86/amd/pmf/spc.c
+++ b/drivers/platform/x86/amd/pmf/spc.c
@@ -70,8 +70,20 @@ static const char *ta_slider_as_str(unsigned int state)
 	}
 }
 
+static u32 amd_pmf_get_ta_custom_bios_inputs(struct ta_pmf_enact_table *in, int index)
+{
+	switch (index) {
+	case 0 ... 1:
+		return in->ev_info.bios_input_1[index];
+	default:
+		return 0;
+	}
+}
+
 void amd_pmf_dump_ta_inputs(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in)
 {
+	int i;
+
 	dev_dbg(dev->dev, "==== TA inputs START ====\n");
 	dev_dbg(dev->dev, "Slider State: %s\n", ta_slider_as_str(in->ev_info.power_slider));
 	dev_dbg(dev->dev, "Power Source: %s\n", amd_pmf_source_as_str(in->ev_info.power_source));
@@ -90,29 +102,43 @@ void amd_pmf_dump_ta_inputs(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *
 	dev_dbg(dev->dev, "Platform type: %s\n", platform_type_as_str(in->ev_info.platform_type));
 	dev_dbg(dev->dev, "Laptop placement: %s\n",
 		laptop_placement_as_str(in->ev_info.device_state));
-	dev_dbg(dev->dev, "Custom BIOS input1: %u\n", in->ev_info.bios_input1);
-	dev_dbg(dev->dev, "Custom BIOS input2: %u\n", in->ev_info.bios_input2);
+	for (i = 0; i < ARRAY_SIZE(custom_bios_inputs); i++)
+		dev_dbg(dev->dev, "Custom BIOS input%d: %u\n", i + 1,
+			amd_pmf_get_ta_custom_bios_inputs(in, i));
 	dev_dbg(dev->dev, "==== TA inputs END ====\n");
 }
 #else
 void amd_pmf_dump_ta_inputs(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in) {}
 #endif
 
+/*
+ * This helper function sets the appropriate BIOS input value in the TA enact
+ * table based on the provided index. We need this approach because the custom
+ * BIOS input array is not continuous, due to the existing TA structure layout.
+ */
+static void amd_pmf_set_ta_custom_bios_input(struct ta_pmf_enact_table *in, int index, u32 value)
+{
+	switch (index) {
+	case 0 ... 1:
+		in->ev_info.bios_input_1[index] = value;
+		break;
+	default:
+		return;
+	}
+}
+
 static void amd_pmf_get_custom_bios_inputs(struct amd_pmf_dev *pdev,
 					   struct ta_pmf_enact_table *in)
 {
+	unsigned int i;
+
 	if (!pdev->req.pending_req)
 		return;
 
-	switch (pdev->req.pending_req) {
-	case BIT(NOTIFY_CUSTOM_BIOS_INPUT1):
-		in->ev_info.bios_input1 = pdev->req.custom_policy[APMF_SMARTPC_CUSTOM_BIOS_INPUT1];
-		break;
-	case BIT(NOTIFY_CUSTOM_BIOS_INPUT2):
-		in->ev_info.bios_input2 = pdev->req.custom_policy[APMF_SMARTPC_CUSTOM_BIOS_INPUT2];
-		break;
-	default:
-		dev_dbg(pdev->dev, "Invalid preq for BIOS input: 0x%x\n", pdev->req.pending_req);
+	for (i = 0; i < ARRAY_SIZE(custom_bios_inputs); i++) {
+		if (!(pdev->req.pending_req & custom_bios_inputs[i].bit_mask))
+			continue;
+		amd_pmf_set_ta_custom_bios_input(in, i, pdev->req.custom_policy[i]);
 	}
 
 	/* Clear pending requests after handling */
-- 
2.51.0

