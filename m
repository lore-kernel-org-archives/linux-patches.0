Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696AF2E40E;
	Fri, 24 Nov 2023 18:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGF4C/9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC85AC433C8;
	Fri, 24 Nov 2023 18:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851873;
	bh=yBMgT48CpPInHKHxLExHUO2V5gsAyNAcgbbSkwRGGmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGF4C/9/43ZRZQcYeP93PKOAhcqNzvBOKVwgK8lDapc8jFSuAUWCXOo6Rh5lr35Qh
	 WrWGpTRbHu2SM1HIRCJooUR5FVZtHrX4z4yTJMUUdp8qPb3wSnUoWHwTI6GACOuuLJ
	 s3p9G3way6VvqlqNNoVkX6IBY81x7GFeeIxMOX/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/372] net: hns3: fix add VLAN fail issue
Date: Fri, 24 Nov 2023 17:48:36 +0000
Message-ID: <20231124172014.780487819@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 472a2ff63efb30234cbf6b2cdaf8117f21b4f8bc ]

The hclge_sync_vlan_filter is called in periodic task,
trying to remove VLAN from vlan_del_fail_bmap. It can
be concurrence with VLAN adding operation from user.
So once user failed to delete a VLAN id, and add it
again soon, it may be removed by the periodic task,
which may cause the software configuration being
inconsistent with hardware. So add mutex handling
to avoid this.

     user                        hns3 driver

                                           periodic task
                                                │
  add vlan 10 ───── hns3_vlan_rx_add_vid        │
       │             (suppose success)          │
       │                                        │
  del vlan 10 ─────  hns3_vlan_rx_kill_vid      │
       │           (suppose fail,add to         │
       │             vlan_del_fail_bmap)        │
       │                                        │
  add vlan 10 ───── hns3_vlan_rx_add_vid        │
                     (suppose success)          │
                                       foreach vlan_del_fail_bmp
                                            del vlan 10

Fixes: fe4144d47eef ("net: hns3: sync VLAN filter entries when kill VLAN ID failed")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 28 +++++++++++++------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 11 ++++++--
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3e1d202d60ce1..51998a4d732d3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10132,8 +10132,6 @@ static void hclge_rm_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
 	struct hclge_dev *hdev = vport->back;
 
-	mutex_lock(&hdev->vport_lock);
-
 	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 		if (vlan->vlan_id == vlan_id) {
 			if (is_write_tbl && vlan->hd_tbl_status)
@@ -10148,8 +10146,6 @@ static void hclge_rm_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 			break;
 		}
 	}
-
-	mutex_unlock(&hdev->vport_lock);
 }
 
 void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
@@ -10558,11 +10554,16 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 	 * handle mailbox. Just record the vlan id, and remove it after
 	 * reset finished.
 	 */
+	mutex_lock(&hdev->vport_lock);
 	if ((test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) ||
 	     test_bit(HCLGE_STATE_RST_FAIL, &hdev->state)) && is_kill) {
 		set_bit(vlan_id, vport->vlan_del_fail_bmap);
+		mutex_unlock(&hdev->vport_lock);
 		return -EBUSY;
+	} else if (!is_kill && test_bit(vlan_id, vport->vlan_del_fail_bmap)) {
+		clear_bit(vlan_id, vport->vlan_del_fail_bmap);
 	}
+	mutex_unlock(&hdev->vport_lock);
 
 	/* when port base vlan enabled, we use port base vlan as the vlan
 	 * filter entry. In this case, we don't update vlan filter table
@@ -10577,17 +10578,22 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 	}
 
 	if (!ret) {
-		if (!is_kill)
+		if (!is_kill) {
 			hclge_add_vport_vlan_table(vport, vlan_id,
 						   writen_to_tbl);
-		else if (is_kill && vlan_id != 0)
+		} else if (is_kill && vlan_id != 0) {
+			mutex_lock(&hdev->vport_lock);
 			hclge_rm_vport_vlan_table(vport, vlan_id, false);
+			mutex_unlock(&hdev->vport_lock);
+		}
 	} else if (is_kill) {
 		/* when remove hw vlan filter failed, record the vlan id,
 		 * and try to remove it from hw later, to be consistence
 		 * with stack
 		 */
+		mutex_lock(&hdev->vport_lock);
 		set_bit(vlan_id, vport->vlan_del_fail_bmap);
+		mutex_unlock(&hdev->vport_lock);
 	}
 
 	hclge_set_vport_vlan_fltr_change(vport);
@@ -10627,6 +10633,7 @@ static void hclge_sync_vlan_filter(struct hclge_dev *hdev)
 	int i, ret, sync_cnt = 0;
 	u16 vlan_id;
 
+	mutex_lock(&hdev->vport_lock);
 	/* start from vport 1 for PF is always alive */
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		struct hclge_vport *vport = &hdev->vport[i];
@@ -10637,21 +10644,26 @@ static void hclge_sync_vlan_filter(struct hclge_dev *hdev)
 			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
 						       vport->vport_id, vlan_id,
 						       true);
-			if (ret && ret != -EINVAL)
+			if (ret && ret != -EINVAL) {
+				mutex_unlock(&hdev->vport_lock);
 				return;
+			}
 
 			clear_bit(vlan_id, vport->vlan_del_fail_bmap);
 			hclge_rm_vport_vlan_table(vport, vlan_id, false);
 			hclge_set_vport_vlan_fltr_change(vport);
 
 			sync_cnt++;
-			if (sync_cnt >= HCLGE_MAX_SYNC_COUNT)
+			if (sync_cnt >= HCLGE_MAX_SYNC_COUNT) {
+				mutex_unlock(&hdev->vport_lock);
 				return;
+			}
 
 			vlan_id = find_first_bit(vport->vlan_del_fail_bmap,
 						 VLAN_N_VID);
 		}
 	}
+	mutex_unlock(&hdev->vport_lock);
 
 	hclge_sync_vlan_fltr_state(hdev);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 72cf5145e15a2..90ceec730d5bd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1258,6 +1258,8 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 	     test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state)) && is_kill) {
 		set_bit(vlan_id, hdev->vlan_del_fail_bmap);
 		return -EBUSY;
+	} else if (!is_kill && test_bit(vlan_id, hdev->vlan_del_fail_bmap)) {
+		clear_bit(vlan_id, hdev->vlan_del_fail_bmap);
 	}
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
@@ -1285,20 +1287,25 @@ static void hclgevf_sync_vlan_filter(struct hclgevf_dev *hdev)
 	int ret, sync_cnt = 0;
 	u16 vlan_id;
 
+	if (bitmap_empty(hdev->vlan_del_fail_bmap, VLAN_N_VID))
+		return;
+
+	rtnl_lock();
 	vlan_id = find_first_bit(hdev->vlan_del_fail_bmap, VLAN_N_VID);
 	while (vlan_id != VLAN_N_VID) {
 		ret = hclgevf_set_vlan_filter(handle, htons(ETH_P_8021Q),
 					      vlan_id, true);
 		if (ret)
-			return;
+			break;
 
 		clear_bit(vlan_id, hdev->vlan_del_fail_bmap);
 		sync_cnt++;
 		if (sync_cnt >= HCLGEVF_MAX_SYNC_COUNT)
-			return;
+			break;
 
 		vlan_id = find_first_bit(hdev->vlan_del_fail_bmap, VLAN_N_VID);
 	}
+	rtnl_unlock();
 }
 
 static int hclgevf_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
-- 
2.42.0



