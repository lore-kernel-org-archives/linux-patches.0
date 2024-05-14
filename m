Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F33AF9D4;
	Tue, 14 May 2024 11:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687824; cv=none; b=Ld+gACLnEOHfZWacVAYf5HIC1yZomGdMs5Cmdtwy1GN6RDaVrBeulDorR2taldAeKtxjmNUs9D+vwO5MIYstynCtH0Xc76amJiNNaMFgnURv9KV8Hjq2yOVgjpv25iLen2Ahas8mRre0lVGSe4BgsKLva3evYruV8qkKIkiE5V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687824; c=relaxed/simple;
	bh=6NyKHoa2vFzkshhw7LkPOQ5eLHNlbh+h4HuyCxurfKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcZrmaH7XkFMwanJTZ7D9kPolQErKtlwld62Ia8MyxyltVN3OegHolw57jmyR333Ix8ZfLp7GLTaLBWpayyeiXH3MV52GLHogVSAz5FA1dqDcuWZ68hMn0kDTJE6Uh4k9r0IcbUtT0RYNFBklCC44aV4gHMKyQ0PwNWdtXWMMTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzcrWi5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzcrWi5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2231C2BD10;
	Tue, 14 May 2024 11:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687824;
	bh=6NyKHoa2vFzkshhw7LkPOQ5eLHNlbh+h4HuyCxurfKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzcrWi5W6ZOXhdbVifJ7asHd1gywnautjJF5Kh7cj+eAHTR1LTyLVdZjBgMCTmAwD
	 FTd++wVzY9YO3tl5pXLfg8FoHsSFMeFhCPWyg8e8l23Lkt1vLV9E7MufA3G4Z52M8R
	 ebCW4eUihtx0vZ1x60Nxc4A1vb9uu8K7OQqA/X8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yufeng Mo <moyufeng@huawei.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/168] net: hns3: add log for workqueue scheduled late
Date: Tue, 14 May 2024 12:20:16 +0200
Message-ID: <20240514101011.138422036@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit d9069dab207534d9f6f41993ee78a651733becea ]

When the mbx or reset message arrives, the driver is informed
through an interrupt. This task can be processed only after
the workqueue is scheduled. In some cases, this workqueue
scheduling takes a long time. As a result, the mbx or reset
service task cannot be processed in time. So add some warning
message to improve debugging efficiency for this case.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 669554c512d2 ("net: hns3: direct return when receive a unknown mailbox message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  3 +++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 22 +++++++++++++++++--
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  2 ++
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         |  8 +++++++
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 277d6d657c429..e1ba0ae055b02 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -80,6 +80,9 @@ enum hclge_mbx_tbl_cfg_subcode {
 #define HCLGE_MBX_MAX_RESP_DATA_SIZE	8U
 #define HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM	4
 
+#define HCLGE_RESET_SCHED_TIMEOUT	(3 * HZ)
+#define HCLGE_MBX_SCHED_TIMEOUT	(HZ / 2)
+
 struct hclge_ring_chain_param {
 	u8 ring_type;
 	u8 tqp_index;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 71b498aa327bb..93e55c6c4cf5e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2855,16 +2855,20 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
-	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state))
+	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state)) {
+		hdev->last_mbx_scheduled = jiffies;
 		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
+	}
 }
 
 static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    test_bit(HCLGE_STATE_SERVICE_INITED, &hdev->state) &&
-	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
+	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state)) {
+		hdev->last_rst_scheduled = jiffies;
 		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
+	}
 }
 
 static void hclge_errhand_task_schedule(struct hclge_dev *hdev)
@@ -3697,6 +3701,13 @@ static void hclge_mailbox_service_task(struct hclge_dev *hdev)
 	    test_and_set_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state))
 		return;
 
+	if (time_is_before_jiffies(hdev->last_mbx_scheduled +
+				   HCLGE_MBX_SCHED_TIMEOUT))
+		dev_warn(&hdev->pdev->dev,
+			 "mbx service task is scheduled after %ums on cpu%u!\n",
+			 jiffies_to_msecs(jiffies - hdev->last_mbx_scheduled),
+			 smp_processor_id());
+
 	hclge_mbx_handler(hdev);
 
 	clear_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state);
@@ -4346,6 +4357,13 @@ static void hclge_reset_service_task(struct hclge_dev *hdev)
 	if (!test_and_clear_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
 		return;
 
+	if (time_is_before_jiffies(hdev->last_rst_scheduled +
+				   HCLGE_RESET_SCHED_TIMEOUT))
+		dev_warn(&hdev->pdev->dev,
+			 "reset service task is scheduled after %ums on cpu%u!\n",
+			 jiffies_to_msecs(jiffies - hdev->last_rst_scheduled),
+			 smp_processor_id());
+
 	down(&hdev->reset_sem);
 	set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index ba0d41091b1da..6870ccc9d9eac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -928,6 +928,8 @@ struct hclge_dev {
 	u16 hclge_fd_rule_num;
 	unsigned long serv_processed_cnt;
 	unsigned long last_serv_processed;
+	unsigned long last_rst_scheduled;
+	unsigned long last_mbx_scheduled;
 	unsigned long fd_bmap[BITS_TO_LONGS(MAX_FD_FILTER_NUM)];
 	enum HCLGE_FD_ACTIVE_RULE_TYPE fd_active_type;
 	u8 fd_en;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 5182051e5414d..ab6df4c1ea0f6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -855,6 +855,14 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		if (hnae3_get_bit(req->mbx_need_resp, HCLGE_MBX_NEED_RESP_B) &&
 		    req->msg.code < HCLGE_MBX_GET_VF_FLR_STATUS) {
 			resp_msg.status = ret;
+			if (time_is_before_jiffies(hdev->last_mbx_scheduled +
+						   HCLGE_MBX_SCHED_TIMEOUT))
+				dev_warn(&hdev->pdev->dev,
+					 "resp vport%u mbx(%u,%u) late\n",
+					 req->mbx_src_vfid,
+					 req->msg.code,
+					 req->msg.subcode);
+
 			hclge_gen_resp_to_vf(vport, req, &resp_msg);
 		}
 
-- 
2.43.0



