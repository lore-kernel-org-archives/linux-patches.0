Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566DB27FD72;
	Tue, 11 Nov 2025 01:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824499; cv=none; b=AqLeV42K7AjApFyuly9r3TAYlxsPVp+5L5bLf4OLJzpANZoa+daEG4FofLGsxfYrrFWuy1Be0BHVkESN5oSoG9xve8DPq/Vvjgi4SOcnNKgI+MGpmkSICGkwpK/MkgwuNh2vYeSHi3f3nWF6dk6BCQ9ueP7BtDZNisQrhnrBBQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824499; c=relaxed/simple;
	bh=/t0rQEmCOrBqhsF9zLFOZrC7OkqjHpKBAH0iw8qiHRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8+TxhyjqP1zJ/MbO+qBpwaJTE12+ebPo1JPT8e3oq8J+A6W2urmIT0HKq7Dm21sG9JWgqdsGFcA6X/yrFY2XEzYKl6hahDCHSwmCSmB0QWuLKZfEquIndMqePgHO+mAcoO5Y8pCZxY17q7iTVQ6LwaTqCPGQlqgRBQcP04j6+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRrTkMte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRrTkMte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A79C116D0;
	Tue, 11 Nov 2025 01:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824499;
	bh=/t0rQEmCOrBqhsF9zLFOZrC7OkqjHpKBAH0iw8qiHRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRrTkMteILK+DRMgBlRm7+F8Ry+c8xZg5X+RqnQGqjvbVsi+QEzTZwI/2xvG2Jpc8
	 g3QABm41gahAUwrVFLuiFZNAnH/EXb+UzPHLQEpxdZuDCJaE3ichxwTKpcx5LITyLb
	 k5UM2ICKvJVrdSift7xe+86FN5oWWtIxYWePpZWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Yijun Shen <Yijun.Shen@Dell.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 512/849] platform/x86/amd/pmf: Fix the custom bios input handling mechanism
Date: Tue, 11 Nov 2025 09:41:22 +0900
Message-ID: <20251111004548.809078779@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



