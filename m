Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5132D1F40;
	Wed, 25 Feb 2026 06:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002615; cv=none; b=aL2EIyfMTR3vrST+SfdmFy3FJm9lZ7kCHeLLADzMqOMyIoS+36VP7Z2VWzVzAAH41zgUJ5xy389GpQ1CpgJVRZk8zqayY1NB6XJGa5/yO+fo898ol2rcEV2ciQzho0yO20Vss7/hZGvptW70VYtxt/cbuVqsV9o3wXOhAC6xoWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002615; c=relaxed/simple;
	bh=0Pfqev4kUzHVppD6ULVAbNEo/F51y2/cGqAhqbSrUBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2miXKkwXmnDZ34UEUickx8RIwmHHss74nMOcXRVPQ4Ily2zVfoe3wMiu3qpmNsVUuPhQDIOTXvYuW80wbYlMsTqdu/UuS6UVeLV8xo21d8gbGNsOE2Skzno714tSDm09x+pXoK5TsDXNA9DkfAwXh4L6dBI6rXygBNCLQwBv+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bP60CAuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bP60CAuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7A5C19425;
	Wed, 25 Feb 2026 06:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002615;
	bh=0Pfqev4kUzHVppD6ULVAbNEo/F51y2/cGqAhqbSrUBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bP60CAuzhr86NYGbNS592Wr2Y4bdlTrJ05F1+szdSMCpk9zR9TKvzsbQ/PL+LdiZx
	 F1R06S9vTipLYN4o4DSJos7oAo0zR961VKvltfMKs0jWiG5pnbxBqpjatX5ZKi6TzJ
	 O4X59UYidJHdROQK3GzStH06E6OLbhuzT6wxd6r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars Francke <lars.francke@gmail.com>,
	Yijun Shen <Yijun.Shen@Dell.com>,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 367/641] platform/x86/amd/pmf: Prevent TEE errors after hibernate
Date: Tue, 24 Feb 2026 17:21:33 -0800
Message-ID: <20260225012357.502098176@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index bc544a4a5266e..e787480f4df26 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -314,6 +314,61 @@ int amd_pmf_init_metrics_table(struct amd_pmf_dev *dev)
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
@@ -347,7 +402,12 @@ static int amd_pmf_resume_handler(struct device *dev)
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
index bd19f2a6bc786..2da1885d87915 100644
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -122,6 +122,12 @@ struct cookie_header {
 
 typedef void (*apmf_event_handler_t)(acpi_handle handle, u32 event, void *data);
 
+static const uuid_t amd_pmf_ta_uuid[] __used = { UUID_INIT(0xd9b39bf2, 0x66bd, 0x4154, 0xaf, 0xb8,
+							   0x8a, 0xcc, 0x2b, 0x2b, 0x60, 0xd6),
+						 UUID_INIT(0x6fd93b77, 0x3fb8, 0x524d, 0xb1, 0x2d,
+							   0xc5, 0x29, 0xb1, 0x3d, 0x85, 0x43),
+					       };
+
 /* APTS PMF BIOS Interface */
 struct amd_pmf_apts_output {
 	u16 table_version;
@@ -888,4 +894,8 @@ void amd_pmf_populate_ta_inputs(struct amd_pmf_dev *dev, struct ta_pmf_enact_tab
 void amd_pmf_dump_ta_inputs(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in);
 int amd_pmf_invoke_cmd_enact(struct amd_pmf_dev *dev);
 
+int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid);
+void amd_pmf_tee_deinit(struct amd_pmf_dev *dev);
+int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev);
+
 #endif /* PMF_H */
diff --git a/drivers/platform/x86/amd/pmf/tee-if.c b/drivers/platform/x86/amd/pmf/tee-if.c
index 6e8116bef4f6a..9030459352375 100644
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
@@ -312,7 +306,7 @@ static void amd_pmf_invoke_cmd(struct work_struct *work)
 	schedule_delayed_work(&dev->pb_work, msecs_to_jiffies(pb_actions_ms));
 }
 
-static int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev)
+int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev)
 {
 	struct cookie_header *header;
 	int res;
@@ -468,7 +462,7 @@ static int amd_pmf_register_input_device(struct amd_pmf_dev *dev)
 	return 0;
 }
 
-static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
+int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 {
 	u32 size;
 	int ret;
@@ -516,7 +510,7 @@ static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 	return ret;
 }
 
-static void amd_pmf_tee_deinit(struct amd_pmf_dev *dev)
+void amd_pmf_tee_deinit(struct amd_pmf_dev *dev)
 {
 	if (!dev->tee_ctx)
 		return;
-- 
2.51.0



