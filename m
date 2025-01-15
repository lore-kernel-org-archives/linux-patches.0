Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8A41E98FC;
	Wed, 15 Jan 2025 10:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937971; cv=none; b=HXeE8iqjvMDSQWlnlouoRCvpwQ7XqMBWsWgqg88dCIGNqLks1c8T/lLobi9enQbGdsMM6jt95A+iXj9dbKXviVVCftVgIYjvlzDWPAySvcAmzaDyM75iI9KC/XpcDsXtG+O5w4UaVuY6aRTSNc475bp8N2b1puixez8buOWgA5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937971; c=relaxed/simple;
	bh=IHXylc2TCycl0RM4adsMqwhg+KGlrMpxY0aU8a/B01c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRSthKZlc9offZ+qsxZM5d1rCdw+e+nd65qO1tZRKGXoQ7nOCZOflRnwCqaaSARfV0rTdtT+mHEBAeOMsVbYRGeY7yhs/piCJhZGfFPAaA7ppjuKVKbPo4pCwzHgpk4ld7SUWKc7HYUv2xcFDk9TGxyrc27HoKn28xccqOv/PaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSNFm+1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSNFm+1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5349DC4CEDF;
	Wed, 15 Jan 2025 10:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937971;
	bh=IHXylc2TCycl0RM4adsMqwhg+KGlrMpxY0aU8a/B01c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSNFm+1SqqPRKlPmVUixxMcIXwNmk2CcdiVNLoS3uCEN/BSkFv8/wuWcZIH+fnobi
	 GBEZO8qEHaJMMJjAcNWEG0viW3Z9neaIHGlw3/wTeA1xcmnx7AwamGN4HQBXuf27m2
	 c9wwvl0q+KVkWKrmZv2mG/DUh65BTTc36OZNrfJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Lan <lanhao@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/189] net: hns3: fixed reset failure issues caused by the incorrect reset type
Date: Wed, 15 Jan 2025 11:35:42 +0100
Message-ID: <20250115103608.198154942@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Lan <lanhao@huawei.com>

[ Upstream commit 5a4b584c67699a69981f0740618a144965a63237 ]

When a reset type that is not supported by the driver is input, a reset
pending flag bit of the HNAE3_NONE_RESET type is generated in
reset_pending. The driver does not have a mechanism to clear this type
of error. As a result, the driver considers that the reset is not
complete. This patch provides a mechanism to clear the
HNAE3_NONE_RESET flag and the parameter of
hnae3_ae_ops.set_default_reset_request is verified.

The error message:
hns3 0000:39:01.0: cmd failed -16
hns3 0000:39:01.0: hclge device re-init failed, VF is disabled!
hns3 0000:39:01.0: failed to reset VF stack
hns3 0000:39:01.0: failed to reset VF(4)
hns3 0000:39:01.0: prepare reset(2) wait done
hns3 0000:39:01.0 eth4: already uninitialized

Use the crash tool to view struct hclgevf_dev:
struct hclgevf_dev {
...
	default_reset_request = 0x20,
	reset_level = HNAE3_NONE_RESET,
	reset_pending = 0x100,
	reset_type = HNAE3_NONE_RESET,
...
};

Fixes: 720bd5837e37 ("net: hns3: add set_default_reset_request in the hnae3_ae_ops")
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20250106143642.539698-2-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 33 ++++++++++++++--
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 38 ++++++++++++++++---
 2 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bd86efd92a5a..35c618c794be 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3584,6 +3584,17 @@ static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
 	return ret;
 }
 
+static void hclge_set_reset_pending(struct hclge_dev *hdev,
+				    enum hnae3_reset_type reset_type)
+{
+	/* When an incorrect reset type is executed, the get_reset_level
+	 * function generates the HNAE3_NONE_RESET flag. As a result, this
+	 * type do not need to pending.
+	 */
+	if (reset_type != HNAE3_NONE_RESET)
+		set_bit(reset_type, &hdev->reset_pending);
+}
+
 static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 {
 	u32 cmdq_src_reg, msix_src_reg, hw_err_src_reg;
@@ -3604,7 +3615,7 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 	 */
 	if (BIT(HCLGE_VECTOR0_IMPRESET_INT_B) & msix_src_reg) {
 		dev_info(&hdev->pdev->dev, "IMP reset interrupt\n");
-		set_bit(HNAE3_IMP_RESET, &hdev->reset_pending);
+		hclge_set_reset_pending(hdev, HNAE3_IMP_RESET);
 		set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
 		*clearval = BIT(HCLGE_VECTOR0_IMPRESET_INT_B);
 		hdev->rst_stats.imp_rst_cnt++;
@@ -3614,7 +3625,7 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 	if (BIT(HCLGE_VECTOR0_GLOBALRESET_INT_B) & msix_src_reg) {
 		dev_info(&hdev->pdev->dev, "global reset interrupt\n");
 		set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
-		set_bit(HNAE3_GLOBAL_RESET, &hdev->reset_pending);
+		hclge_set_reset_pending(hdev, HNAE3_GLOBAL_RESET);
 		*clearval = BIT(HCLGE_VECTOR0_GLOBALRESET_INT_B);
 		hdev->rst_stats.global_rst_cnt++;
 		return HCLGE_VECTOR0_EVENT_RST;
@@ -4062,7 +4073,7 @@ static void hclge_do_reset(struct hclge_dev *hdev)
 	case HNAE3_FUNC_RESET:
 		dev_info(&pdev->dev, "PF reset requested\n");
 		/* schedule again to check later */
-		set_bit(HNAE3_FUNC_RESET, &hdev->reset_pending);
+		hclge_set_reset_pending(hdev, HNAE3_FUNC_RESET);
 		hclge_reset_task_schedule(hdev);
 		break;
 	default:
@@ -4096,6 +4107,8 @@ static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
 		clear_bit(HNAE3_FLR_RESET, addr);
 	}
 
+	clear_bit(HNAE3_NONE_RESET, addr);
+
 	if (hdev->reset_type != HNAE3_NONE_RESET &&
 	    rst_level < hdev->reset_type)
 		return HNAE3_NONE_RESET;
@@ -4237,7 +4250,7 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 		return false;
 	} else if (hdev->rst_stats.reset_fail_cnt < MAX_RESET_FAIL_CNT) {
 		hdev->rst_stats.reset_fail_cnt++;
-		set_bit(hdev->reset_type, &hdev->reset_pending);
+		hclge_set_reset_pending(hdev, hdev->reset_type);
 		dev_info(&hdev->pdev->dev,
 			 "re-schedule reset task(%u)\n",
 			 hdev->rst_stats.reset_fail_cnt);
@@ -4480,8 +4493,20 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 static void hclge_set_def_reset_request(struct hnae3_ae_dev *ae_dev,
 					enum hnae3_reset_type rst_type)
 {
+#define HCLGE_SUPPORT_RESET_TYPE \
+	(BIT(HNAE3_FLR_RESET) | BIT(HNAE3_FUNC_RESET) | \
+	BIT(HNAE3_GLOBAL_RESET) | BIT(HNAE3_IMP_RESET))
+
 	struct hclge_dev *hdev = ae_dev->priv;
 
+	if (!(BIT(rst_type) & HCLGE_SUPPORT_RESET_TYPE)) {
+		/* To prevent reset triggered by hclge_reset_event */
+		set_bit(HNAE3_NONE_RESET, &hdev->default_reset_request);
+		dev_warn(&hdev->pdev->dev, "unsupported reset type %d\n",
+			 rst_type);
+		return;
+	}
+
 	set_bit(rst_type, &hdev->default_reset_request);
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 094a7c7b5592..ab54e6155e93 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1395,6 +1395,17 @@ static int hclgevf_notify_roce_client(struct hclgevf_dev *hdev,
 	return ret;
 }
 
+static void hclgevf_set_reset_pending(struct hclgevf_dev *hdev,
+				      enum hnae3_reset_type reset_type)
+{
+	/* When an incorrect reset type is executed, the get_reset_level
+	 * function generates the HNAE3_NONE_RESET flag. As a result, this
+	 * type do not need to pending.
+	 */
+	if (reset_type != HNAE3_NONE_RESET)
+		set_bit(reset_type, &hdev->reset_pending);
+}
+
 static int hclgevf_reset_wait(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_RESET_WAIT_US	20000
@@ -1544,7 +1555,7 @@ static void hclgevf_reset_err_handle(struct hclgevf_dev *hdev)
 		hdev->rst_stats.rst_fail_cnt);
 
 	if (hdev->rst_stats.rst_fail_cnt < HCLGEVF_RESET_MAX_FAIL_CNT)
-		set_bit(hdev->reset_type, &hdev->reset_pending);
+		hclgevf_set_reset_pending(hdev, hdev->reset_type);
 
 	if (hclgevf_is_reset_pending(hdev)) {
 		set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
@@ -1664,6 +1675,8 @@ static enum hnae3_reset_type hclgevf_get_reset_level(unsigned long *addr)
 		clear_bit(HNAE3_FLR_RESET, addr);
 	}
 
+	clear_bit(HNAE3_NONE_RESET, addr);
+
 	return rst_level;
 }
 
@@ -1673,14 +1686,15 @@ static void hclgevf_reset_event(struct pci_dev *pdev,
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 	struct hclgevf_dev *hdev = ae_dev->priv;
 
-	dev_info(&hdev->pdev->dev, "received reset request from VF enet\n");
-
 	if (hdev->default_reset_request)
 		hdev->reset_level =
 			hclgevf_get_reset_level(&hdev->default_reset_request);
 	else
 		hdev->reset_level = HNAE3_VF_FUNC_RESET;
 
+	dev_info(&hdev->pdev->dev, "received reset request from VF enet, reset level is %d\n",
+		 hdev->reset_level);
+
 	/* reset of this VF requested */
 	set_bit(HCLGEVF_RESET_REQUESTED, &hdev->reset_state);
 	hclgevf_reset_task_schedule(hdev);
@@ -1691,8 +1705,20 @@ static void hclgevf_reset_event(struct pci_dev *pdev,
 static void hclgevf_set_def_reset_request(struct hnae3_ae_dev *ae_dev,
 					  enum hnae3_reset_type rst_type)
 {
+#define HCLGEVF_SUPPORT_RESET_TYPE \
+	(BIT(HNAE3_VF_RESET) | BIT(HNAE3_VF_FUNC_RESET) | \
+	BIT(HNAE3_VF_PF_FUNC_RESET) | BIT(HNAE3_VF_FULL_RESET) | \
+	BIT(HNAE3_FLR_RESET) | BIT(HNAE3_VF_EXP_RESET))
+
 	struct hclgevf_dev *hdev = ae_dev->priv;
 
+	if (!(BIT(rst_type) & HCLGEVF_SUPPORT_RESET_TYPE)) {
+		/* To prevent reset triggered by hclge_reset_event */
+		set_bit(HNAE3_NONE_RESET, &hdev->default_reset_request);
+		dev_info(&hdev->pdev->dev, "unsupported reset type %d\n",
+			 rst_type);
+		return;
+	}
 	set_bit(rst_type, &hdev->default_reset_request);
 }
 
@@ -1849,14 +1875,14 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 		 */
 		if (hdev->reset_attempts > HCLGEVF_MAX_RESET_ATTEMPTS_CNT) {
 			/* prepare for full reset of stack + pcie interface */
-			set_bit(HNAE3_VF_FULL_RESET, &hdev->reset_pending);
+			hclgevf_set_reset_pending(hdev, HNAE3_VF_FULL_RESET);
 
 			/* "defer" schedule the reset task again */
 			set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
 		} else {
 			hdev->reset_attempts++;
 
-			set_bit(hdev->reset_level, &hdev->reset_pending);
+			hclgevf_set_reset_pending(hdev, hdev->reset_level);
 			set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
 		}
 		hclgevf_reset_task_schedule(hdev);
@@ -1979,7 +2005,7 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 		rst_ing_reg = hclgevf_read_dev(&hdev->hw, HCLGEVF_RST_ING);
 		dev_info(&hdev->pdev->dev,
 			 "receive reset interrupt 0x%x!\n", rst_ing_reg);
-		set_bit(HNAE3_VF_RESET, &hdev->reset_pending);
+		hclgevf_set_reset_pending(hdev, HNAE3_VF_RESET);
 		set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
 		set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
 		*clearval = ~(1U << HCLGEVF_VECTOR0_RST_INT_B);
-- 
2.39.5



