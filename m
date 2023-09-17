Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99986FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264F1C433C9;
	Sun, 17 Sep 2023 20:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981499;
	bh=KoRGFtKAHV7RcqLMWUdprxAQ0nprA+K5PC9IMuK9/Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKguA8dsZrTCA7d2YQjBH8Go2mkrg8TMvhdGLZbVe3tt4mwDGxMvKvbcaFlIXnllO
	 Iyb5v/aWPgeVQB154C5JGItrckt7pwKZaGJG7PicGtkXTZ623rD1DmI6ponfezNIyz
	 /4yGKVW/5S262yuydeV/pmgvBlZ+TfbZVDjqFJ9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/219] net: hns3: fix invalid mutex between tc qdisc and dcb ets command issue
Date: Sun, 17 Sep 2023 21:14:19 +0200
Message-ID: <20230917191045.759493622@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit fa5564945f7d15ae2390b00c08b6abaef0165cda ]

We hope that tc qdisc and dcb ets commands can not be used crosswise.
If we want to use any of the commands to configure tc,
We must use the other command to clear the existing configuration.

However, when we configure a single tc with tc qdisc,
we can still configure it with dcb ets.
Because we use mqprio_active as the tag of tc qdisc configuration,
but with dcb ets, we do not check mqprio_active.

This patch fix this issue by check mqprio_active before
executing the dcb ets command. and add dcb_ets_active to
replace HCLGE_FLAG_DCB_ENABLE and HCLGE_FLAG_MQPRIO_ENABLE
at the hclge layer,

Fixes: cacde272dd00 ("net: hns3: Add hclge_dcb module for the support of DCB feature")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         | 20 +++++--------------
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  5 +++--
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  2 --
 4 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index fcb8b6dc5ab92..c693bb701ba3e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -797,6 +797,7 @@ struct hnae3_tc_info {
 	u8 max_tc; /* Total number of TCs */
 	u8 num_tc; /* Total number of enabled TCs */
 	bool mqprio_active;
+	bool dcb_ets_active;
 };
 
 #define HNAE3_MAX_DSCP			64
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 09362823140d5..2740f0d703e4f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -251,7 +251,7 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 	int ret;
 
 	if (!(hdev->dcbx_cap & DCB_CAP_DCBX_VER_IEEE) ||
-	    hdev->flag & HCLGE_FLAG_MQPRIO_ENABLE)
+	    h->kinfo.tc_info.mqprio_active)
 		return -EINVAL;
 
 	ret = hclge_ets_validate(hdev, ets, &num_tc, &map_changed);
@@ -267,10 +267,7 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 	}
 
 	hclge_tm_schd_info_update(hdev, num_tc);
-	if (num_tc > 1)
-		hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
-	else
-		hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
+	h->kinfo.tc_info.dcb_ets_active = num_tc > 1;
 
 	ret = hclge_ieee_ets_to_tm_info(hdev, ets);
 	if (ret)
@@ -463,7 +460,7 @@ static u8 hclge_getdcbx(struct hnae3_handle *h)
 	struct hclge_vport *vport = hclge_get_vport(h);
 	struct hclge_dev *hdev = vport->back;
 
-	if (hdev->flag & HCLGE_FLAG_MQPRIO_ENABLE)
+	if (h->kinfo.tc_info.mqprio_active)
 		return 0;
 
 	return hdev->dcbx_cap;
@@ -587,7 +584,8 @@ static int hclge_setup_tc(struct hnae3_handle *h,
 	if (!test_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state))
 		return -EBUSY;
 
-	if (hdev->flag & HCLGE_FLAG_DCB_ENABLE)
+	kinfo = &vport->nic.kinfo;
+	if (kinfo->tc_info.dcb_ets_active)
 		return -EINVAL;
 
 	ret = hclge_mqprio_qopt_check(hdev, mqprio_qopt);
@@ -601,7 +599,6 @@ static int hclge_setup_tc(struct hnae3_handle *h,
 	if (ret)
 		return ret;
 
-	kinfo = &vport->nic.kinfo;
 	memcpy(&old_tc_info, &kinfo->tc_info, sizeof(old_tc_info));
 	hclge_sync_mqprio_qopt(&kinfo->tc_info, mqprio_qopt);
 	kinfo->tc_info.mqprio_active = tc > 0;
@@ -610,13 +607,6 @@ static int hclge_setup_tc(struct hnae3_handle *h,
 	if (ret)
 		goto err_out;
 
-	hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
-
-	if (tc > 1)
-		hdev->flag |= HCLGE_FLAG_MQPRIO_ENABLE;
-	else
-		hdev->flag &= ~HCLGE_FLAG_MQPRIO_ENABLE;
-
 	return hclge_notify_init_up(hdev);
 
 err_out:
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 84ecd8b9be48c..884e45fb6b72e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11132,6 +11132,7 @@ static void hclge_get_mdix_mode(struct hnae3_handle *handle,
 
 static void hclge_info_show(struct hclge_dev *hdev)
 {
+	struct hnae3_handle *handle = &hdev->vport->nic;
 	struct device *dev = &hdev->pdev->dev;
 
 	dev_info(dev, "PF info begin:\n");
@@ -11148,9 +11149,9 @@ static void hclge_info_show(struct hclge_dev *hdev)
 	dev_info(dev, "This is %s PF\n",
 		 hdev->flag & HCLGE_FLAG_MAIN ? "main" : "not main");
 	dev_info(dev, "DCB %s\n",
-		 hdev->flag & HCLGE_FLAG_DCB_ENABLE ? "enable" : "disable");
+		 handle->kinfo.tc_info.dcb_ets_active ? "enable" : "disable");
 	dev_info(dev, "MQPRIO %s\n",
-		 hdev->flag & HCLGE_FLAG_MQPRIO_ENABLE ? "enable" : "disable");
+		 handle->kinfo.tc_info.mqprio_active ? "enable" : "disable");
 	dev_info(dev, "Default tx spare buffer size: %u\n",
 		 hdev->tx_spare_buf_size);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 13f23d606e77b..f6fef790e16c1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -916,8 +916,6 @@ struct hclge_dev {
 
 #define HCLGE_FLAG_MAIN			BIT(0)
 #define HCLGE_FLAG_DCB_CAPABLE		BIT(1)
-#define HCLGE_FLAG_DCB_ENABLE		BIT(2)
-#define HCLGE_FLAG_MQPRIO_ENABLE	BIT(3)
 	u32 flag;
 
 	u32 pkt_buf_size; /* Total pf buf size for tx/rx */
-- 
2.40.1



