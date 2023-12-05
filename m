Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B7F611E;
	Tue,  5 Dec 2023 03:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URT5lPTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26669C433C7;
	Tue,  5 Dec 2023 03:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746302;
	bh=EDLpVzRrIf7boNLR1qFEoA3mSBPRxpxy69vbbdjWzrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URT5lPTU3ljBZXxADH2mVJTa3MlmsglG8PO1gDgBNjFbFy1O+fTOMON4P7l4Vqjoq
	 vovDslzXd84gZI2UL6b7KTGLKCjtgqhn3XDPkLujKrvXuVsSq2DgXqUcbREV5E9taX
	 vLv80/taaDbmBl66hMgqEHz1WhHey8avmX3FRQHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Bednarz <christopher.n.bednarz@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 4.14 01/30] RDMA/irdma: Prevent zero-length STAG registration
Date: Tue,  5 Dec 2023 12:16:08 +0900
Message-ID: <20231205031511.571552355@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031511.476698159@linuxfoundation.org>
References: <20231205031511.476698159@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Bednarz <christopher.n.bednarz@intel.com>

commit bb6d73d9add68ad270888db327514384dfa44958 upstream.

Currently irdma allows zero-length STAGs to be programmed in HW during
the kernel mode fast register flow. Zero-length MR or STAG registration
disable HW memory length checks.

Improve gaps in bounds checking in irdma by preventing zero-length STAG or
MR registrations except if the IB_PD_UNSAFE_GLOBAL_RKEY is set.

This addresses the disclosure CVE-2023-25775.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Christopher Bednarz <christopher.n.bednarz@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230818144838.1758-1-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  |    6 ++++++
 drivers/infiniband/hw/i40iw/i40iw_type.h  |    2 ++
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |   10 ++++++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -2853,6 +2853,9 @@ static enum i40iw_status_code i40iw_sc_a
 	u64 header;
 	enum i40iw_page_size page_size;
 
+	if (!info->total_len && !info->all_memory)
+		return -EINVAL;
+
 	page_size = (info->page_size == 0x200000) ? I40IW_PAGE_SIZE_2M : I40IW_PAGE_SIZE_4K;
 	cqp = dev->cqp;
 	wqe = i40iw_sc_cqp_get_next_send_wqe(cqp, scratch);
@@ -2911,6 +2914,9 @@ static enum i40iw_status_code i40iw_sc_m
 	u8 addr_type;
 	enum i40iw_page_size page_size;
 
+	if (!info->total_len && !info->all_memory)
+		return -EINVAL;
+
 	page_size = (info->page_size == 0x200000) ? I40IW_PAGE_SIZE_2M : I40IW_PAGE_SIZE_4K;
 	if (info->access_rights & (I40IW_ACCESS_FLAGS_REMOTEREAD_ONLY |
 				   I40IW_ACCESS_FLAGS_REMOTEWRITE_ONLY))
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -780,6 +780,7 @@ struct i40iw_allocate_stag_info {
 	bool use_hmc_fcn_index;
 	u8 hmc_fcn_index;
 	bool use_pf_rid;
+	bool all_memory;
 };
 
 struct i40iw_reg_ns_stag_info {
@@ -798,6 +799,7 @@ struct i40iw_reg_ns_stag_info {
 	bool use_hmc_fcn_index;
 	u8 hmc_fcn_index;
 	bool use_pf_rid;
+	bool all_memory;
 };
 
 struct i40iw_fast_reg_stag_info {
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1579,7 +1579,8 @@ static int i40iw_handle_q_mem(struct i40
 static int i40iw_hw_alloc_stag(struct i40iw_device *iwdev, struct i40iw_mr *iwmr)
 {
 	struct i40iw_allocate_stag_info *info;
-	struct i40iw_pd *iwpd = to_iwpd(iwmr->ibmr.pd);
+	struct ib_pd *pd = iwmr->ibmr.pd;
+	struct i40iw_pd *iwpd = to_iwpd(pd);
 	enum i40iw_status_code status;
 	int err = 0;
 	struct i40iw_cqp_request *cqp_request;
@@ -1596,6 +1597,7 @@ static int i40iw_hw_alloc_stag(struct i4
 	info->stag_idx = iwmr->stag >> I40IW_CQPSQ_STAG_IDX_SHIFT;
 	info->pd_id = iwpd->sc_pd.pd_id;
 	info->total_len = iwmr->length;
+	info->all_memory = pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY;
 	info->remote_access = true;
 	cqp_info->cqp_cmd = OP_ALLOC_STAG;
 	cqp_info->post_sq = 1;
@@ -1649,6 +1651,8 @@ static struct ib_mr *i40iw_alloc_mr(stru
 	iwmr->type = IW_MEMREG_TYPE_MEM;
 	palloc = &iwpbl->pble_alloc;
 	iwmr->page_cnt = max_num_sg;
+	/* Use system PAGE_SIZE as the sg page sizes are unknown at this point */
+	iwmr->length = max_num_sg * PAGE_SIZE;
 	mutex_lock(&iwdev->pbl_mutex);
 	status = i40iw_get_pble(&iwdev->sc_dev, iwdev->pble_rsrc, palloc, iwmr->page_cnt);
 	mutex_unlock(&iwdev->pbl_mutex);
@@ -1745,7 +1749,8 @@ static int i40iw_hwreg_mr(struct i40iw_d
 {
 	struct i40iw_pbl *iwpbl = &iwmr->iwpbl;
 	struct i40iw_reg_ns_stag_info *stag_info;
-	struct i40iw_pd *iwpd = to_iwpd(iwmr->ibmr.pd);
+	struct ib_pd *pd = iwmr->ibmr.pd;
+	struct i40iw_pd *iwpd = to_iwpd(pd);
 	struct i40iw_pble_alloc *palloc = &iwpbl->pble_alloc;
 	enum i40iw_status_code status;
 	int err = 0;
@@ -1765,6 +1770,7 @@ static int i40iw_hwreg_mr(struct i40iw_d
 	stag_info->total_len = iwmr->length;
 	stag_info->access_rights = access;
 	stag_info->pd_id = iwpd->sc_pd.pd_id;
+	stag_info->all_memory = pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY;
 	stag_info->addr_type = I40IW_ADDR_TYPE_VA_BASED;
 	stag_info->page_size = iwmr->page_size;
 


