Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2772376BED;
	Tue, 16 Dec 2025 12:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888079; cv=none; b=Z0AjXRrS+Bvsa3m7utRybXvfWXtUZPrRAWMboWfEEa+xNZ9Pue1RupW0EKS6+0JZErnbls1cHX4SKYe6jUXB3ZSPFx7kRpIlWmQ/RCy7oXySagBszLXr4qcMOrwJvdVTvZF8U7uI0K7SQUQexd7F7Ayv02NVhbTPArCvby6OiOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888079; c=relaxed/simple;
	bh=IdXzn8bKlIuguWxm9BPV1E0OFixLfhWRt3tV2jrqLRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qo/PhRRTjkgcWicbIPLG+NzWsFYga9xyZqbiKtuDhmKIxvi7oYZHYnrNEy/DlGtTrMz/dZSReVC/DOhscKifsg0Qd6NLH3BuL792cH60a+ng+xICrbqso0tsPV6jlnED3LCg1uRzpMotRxT3PiK7dv88oUk7pChyKZjCsdGzXKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztf/wX8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztf/wX8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C936C4CEF1;
	Tue, 16 Dec 2025 12:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888078;
	bh=IdXzn8bKlIuguWxm9BPV1E0OFixLfhWRt3tV2jrqLRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztf/wX8IADtdQSoWifQ4eFyi7mczeE9UlACeNzhci4EqKvHj2cE87qNPbSf26qTWY
	 Hc//TjpjFG7FBfXZga5V8JHc2sHZaF0LVsESvJ6fS2qz3hYfZLCwZs0H6/Q3CBht9D
	 AbX1vDKhC45uE8avi8qd75ip21M2nuoTyFOZNXl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 426/614] RDMA/irdma: Do not directly rely on IB_PD_UNSAFE_GLOBAL_RKEY
Date: Tue, 16 Dec 2025 12:13:13 +0100
Message-ID: <20251216111416.807099808@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 71d3bdae5eab21cf8991a6f3cd914caa31d5a51f ]

The HW disables bounds checking for MRs with a length of zero, so
the driver will only allow a zero length MR if the "all_memory"
flag is set, and this flag is only set if IB_PD_UNSAFE_GLOBAL_RKEY
is set for the PD.

This means that the "get_dma_mr" method will currently fail unless
the IB_PD_UNSAFE_GLOBAL_RKEY flag is set. This has not been an issue
because the "get_dma_mr" method is only ever invoked if the device
does not support the local DMA key or if IB_PD_UNSAFE_GLOBAL_RKEY
is set, and so far, all IRDMA HW supports the local DMA lkey.

However, some new HW does not support the local DMA lkey, so the
"get_dma_mr" method needs to work without IB_PD_UNSAFE_GLOBAL_RKEY
being set.

To support HW that does not allow the local DMA lkey, the logic has
been changed to pass an explicit flag to indicate when a dma_mr is
being created so that the zero length will be allowed.

Also, the "all_memory" flag has been forced to false for normal MR
allocation since these MRs are never supposed to provide global
unsafe rkey semantics anyway; only the MR created with "get_dma_mr"
should support this.

Fixes: bb6d73d9add6 ("RDMA/irdma: Prevent zero-length STAG registration")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Link: https://patch.msgid.link/20251125025350.180-7-tatyana.e.nikolova@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c    |  2 +-
 drivers/infiniband/hw/irdma/main.h  |  2 +-
 drivers/infiniband/hw/irdma/verbs.c | 15 ++++++++-------
 drivers/infiniband/hw/irdma/verbs.h |  3 ++-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index c6a0a661d6e7e..f4f4f92ba63ac 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3710,7 +3710,7 @@ int irdma_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	iwpd = iwqp->iwpd;
 	tagged_offset = (uintptr_t)iwqp->ietf_mem.va;
 	ibmr = irdma_reg_phys_mr(&iwpd->ibpd, iwqp->ietf_mem.pa, buf_len,
-				 IB_ACCESS_LOCAL_WRITE, &tagged_offset);
+				 IB_ACCESS_LOCAL_WRITE, &tagged_offset, false);
 	if (IS_ERR(ibmr)) {
 		ret = -ENOMEM;
 		goto error;
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index 886b30da188ae..65ce4924dbfa6 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -556,7 +556,7 @@ void irdma_copy_ip_htonl(__be32 *dst, u32 *src);
 u16 irdma_get_vlan_ipv4(u32 *addr);
 void irdma_get_vlan_mac_ipv6(u32 *addr, u16 *vlan_id, u8 *mac);
 struct ib_mr *irdma_reg_phys_mr(struct ib_pd *ib_pd, u64 addr, u64 size,
-				int acc, u64 *iova_start);
+				int acc, u64 *iova_start, bool dma_mr);
 int irdma_upload_qp_context(struct irdma_qp *iwqp, bool freeze, bool raw);
 void irdma_cqp_ce_handler(struct irdma_pci_f *rf, struct irdma_sc_cq *cq);
 int irdma_ah_cqp_op(struct irdma_pci_f *rf, struct irdma_sc_ah *sc_ah, u8 cmd,
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c884f2ce282f9..8c44c3fcf9731 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3108,7 +3108,6 @@ static int irdma_hw_alloc_stag(struct irdma_device *iwdev,
 	info->stag_idx = iwmr->stag >> IRDMA_CQPSQ_STAG_IDX_S;
 	info->pd_id = iwpd->sc_pd.pd_id;
 	info->total_len = iwmr->len;
-	info->all_memory = pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY;
 	info->remote_access = true;
 	cqp_info->cqp_cmd = IRDMA_OP_ALLOC_STAG;
 	cqp_info->post_sq = 1;
@@ -3119,7 +3118,7 @@ static int irdma_hw_alloc_stag(struct irdma_device *iwdev,
 	if (status)
 		return status;
 
-	iwmr->is_hwreg = 1;
+	iwmr->is_hwreg = true;
 	return 0;
 }
 
@@ -3263,7 +3262,7 @@ static int irdma_hwreg_mr(struct irdma_device *iwdev, struct irdma_mr *iwmr,
 	if (iwdev->rf->sc_dev.hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_ATOMIC_OPS)
 		stag_info->remote_atomics_en = (access & IB_ACCESS_REMOTE_ATOMIC) ? 1 : 0;
 	stag_info->pd_id = iwpd->sc_pd.pd_id;
-	stag_info->all_memory = pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY;
+	stag_info->all_memory = iwmr->dma_mr;
 	if (stag_info->access_rights & IRDMA_ACCESS_FLAGS_ZERO_BASED)
 		stag_info->addr_type = IRDMA_ADDR_TYPE_ZERO_BASED;
 	else
@@ -3290,7 +3289,7 @@ static int irdma_hwreg_mr(struct irdma_device *iwdev, struct irdma_mr *iwmr,
 	irdma_put_cqp_request(&iwdev->rf->cqp, cqp_request);
 
 	if (!ret)
-		iwmr->is_hwreg = 1;
+		iwmr->is_hwreg = true;
 
 	return ret;
 }
@@ -3663,7 +3662,7 @@ static int irdma_hwdereg_mr(struct ib_mr *ib_mr)
 	if (status)
 		return status;
 
-	iwmr->is_hwreg = 0;
+	iwmr->is_hwreg = false;
 	return 0;
 }
 
@@ -3786,9 +3785,10 @@ static struct ib_mr *irdma_rereg_user_mr(struct ib_mr *ib_mr, int flags,
  * @size: size of memory to register
  * @access: Access rights
  * @iova_start: start of virtual address for physical buffers
+ * @dma_mr: Flag indicating whether this region is a PD DMA MR
  */
 struct ib_mr *irdma_reg_phys_mr(struct ib_pd *pd, u64 addr, u64 size, int access,
-				u64 *iova_start)
+				u64 *iova_start, bool dma_mr)
 {
 	struct irdma_device *iwdev = to_iwdev(pd->device);
 	struct irdma_pbl *iwpbl;
@@ -3805,6 +3805,7 @@ struct ib_mr *irdma_reg_phys_mr(struct ib_pd *pd, u64 addr, u64 size, int access
 	iwpbl = &iwmr->iwpbl;
 	iwpbl->iwmr = iwmr;
 	iwmr->type = IRDMA_MEMREG_TYPE_MEM;
+	iwmr->dma_mr = dma_mr;
 	iwpbl->user_base = *iova_start;
 	stag = irdma_create_stag(iwdev);
 	if (!stag) {
@@ -3843,7 +3844,7 @@ static struct ib_mr *irdma_get_dma_mr(struct ib_pd *pd, int acc)
 {
 	u64 kva = 0;
 
-	return irdma_reg_phys_mr(pd, 0, 0, acc, &kva);
+	return irdma_reg_phys_mr(pd, 0, 0, acc, &kva, true);
 }
 
 /**
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index ac8b387018350..aabbb3442098b 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -111,7 +111,8 @@ struct irdma_mr {
 	};
 	struct ib_umem *region;
 	int access;
-	u8 is_hwreg;
+	bool is_hwreg:1;
+	bool dma_mr:1;
 	u16 type;
 	u32 page_cnt;
 	u64 page_size;
-- 
2.51.0



