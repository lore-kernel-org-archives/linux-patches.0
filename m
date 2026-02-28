Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE686333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301850; cv=none; b=cjoj+8lN5JFHBnjXSHnLSmwS8zthdslZElsWcpnn40khR8bCzzH7kzUJwkRUdHrygjpTRgCow8dpYC6dfWIgn8NT9U8n1iEsROpLbNwKCyZ91lE5jQ2jxdnaLjjYc9whKJX/QbXCl3XK4LKYk2PBD3t8WfNsETbmyQ3C7MItJmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301850; c=relaxed/simple;
	bh=AJV2aFA7jHMUaghNBvHoNBZ7SZAQYUgdIFZv7e2OxJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZYQSB+GzzcuT9IpHhOqfsISc3L2T0Ri4Lkphh9Nc2yqrh48cHR5H7j4grefQ2fkmCdiT4Z4UXSP2CETY6PGQfd4dR77QXTctv5X/EaESxEN2E5Kzkr5NU+H3mjpt+wlJe5hv5AHge27Eytki4J5JdMHRdsgUvS18T5rHzl1OMgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHeywJ50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHeywJ50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC14C116D0;
	Sat, 28 Feb 2026 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301850;
	bh=AJV2aFA7jHMUaghNBvHoNBZ7SZAQYUgdIFZv7e2OxJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHeywJ502tP96LCNLumvLHHblskRCNhIi5K2Ig/P2TGAH9Ywh2cpV7vKb14muh3iY
	 xNYjgv+g+2FDqUfcdmAcsPrNraPd0309TWtlPkDfDVfR4yfOESxuG+3DQ/0cx8BzIQ
	 5HWsjn7P6ai8wqs9lExLC9+lTIZXyroCU/KlhlntO7G6/weewRODw90XWSwFImKL1Y
	 C5aKzlw2OMOHlQjwhbx1NOSUznApTRclayrqP+33HI+MvuUjSdQsAbfBjuVxBUHCYp
	 MELYLBn9EQQ2IlqqvXkuA7qnwQlfE3sraBVSPEOFuikVq2bW9hoKgs8EM7OROuYl+R
	 n+M7yvMd9TzaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Lars Francke <lars.francke@gmail.com>,
	Yijun Shen <Yijun.Shen@Dell.com>,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 271/385] platform/x86/amd/pmf: Prevent TEE errors after hibernate
Date: Sat, 28 Feb 2026 12:58:13 -0500
Message-ID: <20260228180011.1568201-271-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 48d229c7047128dd52eaf863881bb3e62b5896e5 ]

After resuming from hibernate, TEE commands can time out and cause PSP
disables. Fix this by reinitializing the Trusted Application (TA) and
cancelling the pb workqueue in the hibernate callbacks to avoid these
errors.

ccp 0000:c4:00.2: tee: command 0x5 timed out, disabling PSP
amd-pmf AMDI0107:00: TEE enact cmd failed. err: ffff000e, ret:0
amd-pmf AMDI0107:00: TEE enact cmd failed. err: ffff000e, ret:0
amd-pmf AMDI0107:00: TEE enact cmd failed. err: ffff000e, ret:0

Fixes: ae82cef7d9c5 ("platform/x86/amd/pmf: Add support for PMF-TA interaction")
Reported-by: Lars Francke <lars.francke@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Co-developed-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
[ML: Add more tags]
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260116041132.153674-2-superm1@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
 drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
 drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
 3 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index 8a1e2268d301a..2e352e475b562 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -316,6 +316,61 @@ int amd_pmf_init_metrics_table(struct amd_pmf_dev *dev)
 	return 0;
 }
 
+static int amd_pmf_reinit_ta(struct amd_pmf_dev *pdev)
+{
+	bool status;
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(amd_pmf_ta_uuid); i++) {
+		ret = amd_pmf_tee_init(pdev, &amd_pmf_ta_uuid[i]);
+		if (ret) {
+			dev_err(pdev->dev, "TEE init failed for UUID[%d] ret: %d\n", i, ret);
+			return ret;
+		}
+
+		ret = amd_pmf_start_policy_engine(pdev);
+		dev_dbg(pdev->dev, "start policy engine ret: %d (UUID idx: %d)\n", ret, i);
+		status = ret == TA_PMF_TYPE_SUCCESS;
+		if (status)
+			break;
+		amd_pmf_tee_deinit(pdev);
+	}
+
+	return 0;
+}
+
+static int amd_pmf_restore_handler(struct device *dev)
+{
+	struct amd_pmf_dev *pdev = dev_get_drvdata(dev);
+	int ret;
+
+	if (pdev->buf) {
+		ret = amd_pmf_set_dram_addr(pdev, false);
+		if (ret)
+			return ret;
+	}
+
+	if (pdev->smart_pc_enabled)
+		amd_pmf_reinit_ta(pdev);
+
+	return 0;
+}
+
+static int amd_pmf_freeze_handler(struct device *dev)
+{
+	struct amd_pmf_dev *pdev = dev_get_drvdata(dev);
+
+	if (!pdev->smart_pc_enabled)
+		return 0;
+
+	cancel_delayed_work_sync(&pdev->pb_work);
+	/* Clear all TEE resources */
+	amd_pmf_tee_deinit(pdev);
+	pdev->session_id = 0;
+
+	return 0;
+}
+
 static int amd_pmf_suspend_handler(struct device *dev)
 {
 	struct amd_pmf_dev *pdev = dev_get_drvdata(dev);
@@ -349,7 +404,12 @@ static int amd_pmf_resume_handler(struct device *dev)
 	return 0;
 }
 
-static DEFINE_SIMPLE_DEV_PM_OPS(amd_pmf_pm, amd_pmf_suspend_handler, amd_pmf_resume_handler);
+static const struct dev_pm_ops amd_pmf_pm = {
+	.suspend = amd_pmf_suspend_handler,
+	.resume = amd_pmf_resume_handler,
+	.freeze = amd_pmf_freeze_handler,
+	.restore = amd_pmf_restore_handler,
+};
 
 static void amd_pmf_init_features(struct amd_pmf_dev *dev)
 {
diff --git a/drivers/platform/x86/amd/pmf/pmf.h b/drivers/platform/x86/amd/pmf/pmf.h
index 34ba0309a33a2..b857ef4498903 100644
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -116,6 +116,12 @@ struct cookie_header {
 
 #define APTS_MAX_STATES		16
 
+static const uuid_t amd_pmf_ta_uuid[] __used = { UUID_INIT(0xd9b39bf2, 0x66bd, 0x4154, 0xaf, 0xb8,
+							   0x8a, 0xcc, 0x2b, 0x2b, 0x60, 0xd6),
+						 UUID_INIT(0x6fd93b77, 0x3fb8, 0x524d, 0xb1, 0x2d,
+							   0xc5, 0x29, 0xb1, 0x3d, 0x85, 0x43),
+					       };
+
 /* APTS PMF BIOS Interface */
 struct amd_pmf_apts_output {
 	u16 table_version;
@@ -802,4 +808,8 @@ void amd_pmf_dump_ta_inputs(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *
 /* Quirk infrastructure */
 void amd_pmf_quirks_init(struct amd_pmf_dev *dev);
 
+int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid);
+void amd_pmf_tee_deinit(struct amd_pmf_dev *dev);
+int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev);
+
 #endif /* PMF_H */
diff --git a/drivers/platform/x86/amd/pmf/tee-if.c b/drivers/platform/x86/amd/pmf/tee-if.c
index a9b195ec6f33f..6254423d05b06 100644
--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -27,12 +27,6 @@ module_param(pb_side_load, bool, 0444);
 MODULE_PARM_DESC(pb_side_load, "Sideload policy binaries debug policy failures");
 #endif
 
-static const uuid_t amd_pmf_ta_uuid[] = { UUID_INIT(0xd9b39bf2, 0x66bd, 0x4154, 0xaf, 0xb8, 0x8a,
-						    0xcc, 0x2b, 0x2b, 0x60, 0xd6),
-					  UUID_INIT(0x6fd93b77, 0x3fb8, 0x524d, 0xb1, 0x2d, 0xc5,
-						    0x29, 0xb1, 0x3d, 0x85, 0x43),
-					};
-
 static const char *amd_pmf_uevent_as_str(unsigned int state)
 {
 	switch (state) {
@@ -296,7 +290,7 @@ static void amd_pmf_invoke_cmd(struct work_struct *work)
 	schedule_delayed_work(&dev->pb_work, msecs_to_jiffies(pb_actions_ms));
 }
 
-static int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev)
+int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev)
 {
 	struct cookie_header *header;
 	int res;
@@ -454,7 +448,7 @@ static int amd_pmf_register_input_device(struct amd_pmf_dev *dev)
 	return 0;
 }
 
-static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
+int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 {
 	u32 size;
 	int ret;
@@ -502,7 +496,7 @@ static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 	return ret;
 }
 
-static void amd_pmf_tee_deinit(struct amd_pmf_dev *dev)
+void amd_pmf_tee_deinit(struct amd_pmf_dev *dev)
 {
 	if (!dev->tee_ctx)
 		return;
-- 
2.51.0

