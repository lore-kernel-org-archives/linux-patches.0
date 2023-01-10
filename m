Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92746FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BF9C433D2;
	Tue, 10 Jan 2023 18:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375506;
	bh=9Ognl1MUe3kDd70V7K9Rv+wFLiy4WvKpI2dkbd9sV5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZogcEOqR4R86ORRBE8qYDqW53Ob6SiNy31Ne5F+wy9wy9oRE6npY8k8xgfZvijXkz
	 1ICh6ZLCkA5VZJrYtLaeSsE250155V+jOI2QvGFgAMn8MxQhop8rTopICFg2L/HOOF
	 cwjuAsISQX0uNP3YmWpLotIVeToGs+Jxlzlt5q68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/290] net: hns3: fix VF promisc mode not update when mac table full
Date: Tue, 10 Jan 2023 19:05:04 +0100
Message-Id: <20230110180039.304060163@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 8ee57c7b8406c7aa8ca31e014440c87c6383f429 ]

Currently, it missed set HCLGE_VPORT_STATE_PROMISC_CHANGE
flag for VF when vport->overflow_promisc_flags changed.
So the VF won't check whether to update promisc mode in
this case. So add it.

Fixes: 1e6e76101fd9 ("net: hns3: configure promisc mode for VF asynchronously")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 75 +++++++++++--------
 1 file changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2102b38b9c35..f4d58fcdba27 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12825,60 +12825,71 @@ static int hclge_gro_en(struct hnae3_handle *handle, bool enable)
 	return ret;
 }
 
-static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
+static int hclge_sync_vport_promisc_mode(struct hclge_vport *vport)
 {
-	struct hclge_vport *vport = &hdev->vport[0];
 	struct hnae3_handle *handle = &vport->nic;
+	struct hclge_dev *hdev = vport->back;
+	bool uc_en = false;
+	bool mc_en = false;
 	u8 tmp_flags;
+	bool bc_en;
 	int ret;
-	u16 i;
 
 	if (vport->last_promisc_flags != vport->overflow_promisc_flags) {
 		set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
 		vport->last_promisc_flags = vport->overflow_promisc_flags;
 	}
 
-	if (test_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state)) {
+	if (!test_and_clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+				&vport->state))
+		return 0;
+
+	/* for PF */
+	if (!vport->vport_id) {
 		tmp_flags = handle->netdev_flags | vport->last_promisc_flags;
 		ret = hclge_set_promisc_mode(handle, tmp_flags & HNAE3_UPE,
 					     tmp_flags & HNAE3_MPE);
-		if (!ret) {
-			clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-				  &vport->state);
+		if (!ret)
 			set_bit(HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
 				&vport->state);
-		}
+		else
+			set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+				&vport->state);
+		return ret;
 	}
 
-	for (i = 1; i < hdev->num_alloc_vport; i++) {
-		bool uc_en = false;
-		bool mc_en = false;
-		bool bc_en;
+	/* for VF */
+	if (vport->vf_info.trusted) {
+		uc_en = vport->vf_info.request_uc_en > 0 ||
+			vport->overflow_promisc_flags & HNAE3_OVERFLOW_UPE;
+		mc_en = vport->vf_info.request_mc_en > 0 ||
+			vport->overflow_promisc_flags & HNAE3_OVERFLOW_MPE;
+	}
+	bc_en = vport->vf_info.request_bc_en > 0;
 
-		vport = &hdev->vport[i];
+	ret = hclge_cmd_set_promisc_mode(hdev, vport->vport_id, uc_en,
+					 mc_en, bc_en);
+	if (ret) {
+		set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
+		return ret;
+	}
+	hclge_set_vport_vlan_fltr_change(vport);
 
-		if (!test_and_clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-					&vport->state))
-			continue;
+	return 0;
+}
 
-		if (vport->vf_info.trusted) {
-			uc_en = vport->vf_info.request_uc_en > 0 ||
-				vport->overflow_promisc_flags &
-				HNAE3_OVERFLOW_UPE;
-			mc_en = vport->vf_info.request_mc_en > 0 ||
-				vport->overflow_promisc_flags &
-				HNAE3_OVERFLOW_MPE;
-		}
-		bc_en = vport->vf_info.request_bc_en > 0;
+static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport;
+	int ret;
+	u16 i;
 
-		ret = hclge_cmd_set_promisc_mode(hdev, vport->vport_id, uc_en,
-						 mc_en, bc_en);
-		if (ret) {
-			set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-				&vport->state);
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		vport = &hdev->vport[i];
+
+		ret = hclge_sync_vport_promisc_mode(vport);
+		if (ret)
 			return;
-		}
-		hclge_set_vport_vlan_fltr_change(vport);
 	}
 }
 
-- 
2.35.1



