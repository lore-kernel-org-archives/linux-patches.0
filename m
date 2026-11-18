Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039337;
	b=f7RtcUBbVsZXihJVXY7g05pnPDQXO+8xtBcOO26C+fBjOxixjXoMLZYFDlDQkec09bpe
	 3nKAZol1vCGb9bwG2A7+Ym6YGMA63hMS6OKeCbAdbhB4ikMdgDqN9PXG0dic35RTo8+9l
	 4dnH686rrtkKpX7VMMpZRLl8PfDkRJ+Lx3HItWQqxTvSOdD0udpRW+jxLh8OuFrozcm+b
	 5EtW4UkwEpk+lmqml4wq+gZHCLe6xIMbakAYBQw2xDjwMO8ONQelqQT7OQh5FCyV/jVo6
	 q1lhgqc1yhDc5dwr001mQoS8QbzypHrhNWTJfywiDCEpKHIqFU7qHVh5l38q3Q3mG/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vn3mQFqosrPND46DyQ6POiH+9MDO+kPSqZsEGKWRc7w=;
	b=om/RbcyvTPP1Ba+vJMdZun+Xy/YG9KrHaajeybZL0HzmhTADehzfPmIbWccOO+BR3xKD
	 hwUJL/QVCgPz+9EiR0h3c6yYnuCQhvgySGem4KYTWlfAW5cOZaezoLS+Ks1aleZCmbvk5
	 k0/0ZMNRs//aAdgbKOhEcjbxoeky4qQ3UtlhuJ4WrJrzzKSLXm/2oR7oY2a+SBiPmY9f+
	 wwZi3JSTratU17Ytxh1VXM2HgW3ZQt0G4TvtOKN2EktdTAEVlddKSe0LRkaNCihtFYq2x
	 H8oqcNyo7edYn9/RN/NqDK8dEYaJKjh8kFjKusLlDJFB8xwM+71G683t1XENfwqqPeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1sZxvOe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7A360A2631;
	Wed, 18 Nov 2026 22:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1sZxvOe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C801F000CA;
	Wed, 18 Nov 2026 22:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039337;
	bh=vn3mQFqosrPND46DyQ6POiH+9MDO+kPSqZsEGKWRc7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1sZxvOeR0Pnia7ebsjDVf49dsy7yJug0lWCRbzl6YkZbGpG5CF5HALdq9kj5Md0c
	 DJB0SKyNLjQGtXFxnw5XTHiGn77o0SaJAn3UrRupCNPGgqRag4mPLXN89oXIrjjdIM
	 KqA3CBrveuzZAchV8+77NbiI1goTd01sFYo3vz4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2065/3318] RDMA/irdma: Preserve fast-registration IOVA on 32-bit
Date: Wed, 18 Nov 2026 15:44:47 +0100
Message-ID: <20261118150424.025651183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit c470050f2a7a7748ce35367e828885a8e658d712 ]

ib_mr::iova is u64, but the fast-registration path passes it through
void * and uintptr_t. These conversions truncate the upper 32 bits on
32-bit kernels before the WQE is built.

Store the IOVA as u64 and write it directly to the WQE. The sole caller
always uses VA-based addressing, so remove the unused FBO selection and
set the VA-based bit unconditionally.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://patch.msgid.link/20260903-64-bit-iova-is-silently-truncated-to-v1-1-96e878ea6873@nvidia.com
Reviewed-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ctrl.c  | 6 ++----
 drivers/infiniband/hw/irdma/type.h  | 4 +---
 drivers/infiniband/hw/irdma/verbs.c | 3 +--
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index ebbece4f09a22..c63772d50cf78 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1320,9 +1320,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 		  info->wr_id, wqe_idx,
 		  &qp->qp_uk.sq_wrtrk_array[wqe_idx].wrid);
 
-	temp = (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED) ?
-		(uintptr_t)info->va : info->fbo;
-	set_64bit_val(wqe, 0, temp);
+	set_64bit_val(wqe, 0, info->va);
 
 	temp = FIELD_GET(IRDMAQPSQ_FIRSTPMPBLIDXHI,
 			 info->first_pm_pbl_index >> 16);
@@ -1339,7 +1337,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 	      FIELD_PREP(IRDMAQPSQ_LPBLSIZE, info->chunk_size) |
 	      FIELD_PREP(IRDMAQPSQ_HPAGESIZE, page_size) |
 	      FIELD_PREP(IRDMAQPSQ_STAGRIGHTS, info->access_rights) |
-	      FIELD_PREP(IRDMAQPSQ_VABASEDTO, info->addr_type) |
+	      IRDMAQPSQ_VABASEDTO |
 	      FIELD_PREP(IRDMAQPSQ_READFENCE, info->read_fence) |
 	      FIELD_PREP(IRDMAQPSQ_LOCALFENCE, info->local_fence) |
 	      FIELD_PREP(IRDMAQPSQ_SIGCOMPL, info->signaled) |
diff --git a/drivers/infiniband/hw/irdma/type.h b/drivers/infiniband/hw/irdma/type.h
index c84ec4dd8536d..d545288c2d1e0 100644
--- a/drivers/infiniband/hw/irdma/type.h
+++ b/drivers/infiniband/hw/irdma/type.h
@@ -1005,13 +1005,11 @@ struct irdma_reg_ns_stag_info {
 struct irdma_fast_reg_stag_info {
 	u64 wr_id;
 	u64 reg_addr_pa;
-	u64 fbo;
-	void *va;
+	u64 va;
 	u64 total_len;
 	u32 page_size;
 	u32 chunk_size;
 	u32 first_pm_pbl_index;
-	enum irdma_addressing_type addr_type;
 	irdma_stag_index stag_idx;
 	u16 access_rights;
 	u32 pd_id;
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index a02c551052dc4..bb4f2e314b8f6 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3564,8 +3564,7 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.stag_idx = reg_wr(ib_wr)->key >> 8;
 			stag_info.page_size = reg_wr(ib_wr)->mr->page_size;
 			stag_info.wr_id = ib_wr->wr_id;
-			stag_info.addr_type = IRDMA_ADDR_TYPE_VA_BASED;
-			stag_info.va = (void *)(uintptr_t)iwmr->ibmr.iova;
+			stag_info.va = iwmr->ibmr.iova;
 			stag_info.total_len = iwmr->ibmr.length;
 			stag_info.reg_addr_pa = *palloc->level1.addr;
 			stag_info.first_pm_pbl_index = palloc->level1.idx;
-- 
2.53.0



