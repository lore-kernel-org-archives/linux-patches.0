Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812F31AC884;
	Mon, 14 Oct 2024 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919783; cv=none; b=jphEIavUheYDKjRzoxdcV+5owxCPukSWff6uS3Iyj1aET07rwuAlbfpnsjcpxPOkqnhg4y/F8vflzsvDFIhzybxPTUK964q8NH8B76wT2Mx7DpIZoRUQfCtJJ3bWJbNh6q9FKQItOXOcDuOAUkBow5i9ZvpYHTmoX3MM0te7X9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919783; c=relaxed/simple;
	bh=8FL6jkXHP4w/YOPYHkr2jLoIyFZEzZUn7yUTh7tEA1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDzlcpxA6jbDb0WxOVA4qre81d512GtElO1RN81LGgZ2isLxuPd09iDnAv7oeoC/Mlwy13Y4QMn+bwhBMN0mujSxUtnD1D94DgvxiM1yR0e7tUqHWGGN5M61zvqu/tLazcmvUT/qbUy+Ykhsdzbr8jvbsD2msKl7Tbv+P/SWMAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxDGtyKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxDGtyKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E5BC4CEC3;
	Mon, 14 Oct 2024 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919783;
	bh=8FL6jkXHP4w/YOPYHkr2jLoIyFZEzZUn7yUTh7tEA1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxDGtyKYxglqpxhECpBZzzeesXR4Wg/Dxfhu44ViJkyXMyiXNrP3AFjxZVWSqwnWX
	 VMQstSO8uWH9ozcRM4vPjscqPdOdI2t6hngcxuJmaIXyVfQs9YU5ZcLpeZEYmeb9HH
	 s1MWCmihMCwbEk1lNo34TY+Eq3r9l9+M69oGwyE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 706/798] RDMA/mlx5: Enforce umem boundaries for explicit ODP page faults
Date: Mon, 14 Oct 2024 16:21:00 +0200
Message-ID: <20241014141245.804656302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 8c6d097d830f779fc1725fbaa1314f20a7a07b4b ]

The new memory scheme page faults are requesting the driver to fetch
additinal pages to the faulted memory access.
This is done in order to prefetch pages before and after the area that
got the page fault, assuming this will reduce the total amount of page
faults.

The driver should ensure it handles only the pages that are within the
umem range.

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/20240909100504.29797-5-michaelgur@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index af73c5ebe6ac5..d3cada2ae5a5b 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -734,24 +734,31 @@ static int pagefault_dmabuf_mr(struct mlx5_ib_mr *mr, size_t bcnt,
  *  >0: Number of pages mapped
  */
 static int pagefault_mr(struct mlx5_ib_mr *mr, u64 io_virt, size_t bcnt,
-			u32 *bytes_mapped, u32 flags)
+			u32 *bytes_mapped, u32 flags, bool permissive_fault)
 {
 	struct ib_umem_odp *odp = to_ib_umem_odp(mr->umem);
 
-	if (unlikely(io_virt < mr->ibmr.iova))
+	if (unlikely(io_virt < mr->ibmr.iova) && !permissive_fault)
 		return -EFAULT;
 
 	if (mr->umem->is_dmabuf)
 		return pagefault_dmabuf_mr(mr, bcnt, bytes_mapped, flags);
 
 	if (!odp->is_implicit_odp) {
+		u64 offset = io_virt < mr->ibmr.iova ? 0 : io_virt - mr->ibmr.iova;
 		u64 user_va;
 
-		if (check_add_overflow(io_virt - mr->ibmr.iova,
-				       (u64)odp->umem.address, &user_va))
+		if (check_add_overflow(offset, (u64)odp->umem.address,
+				       &user_va))
 			return -EFAULT;
-		if (unlikely(user_va >= ib_umem_end(odp) ||
-			     ib_umem_end(odp) - user_va < bcnt))
+
+		if (permissive_fault) {
+			if (user_va < ib_umem_start(odp))
+				user_va = ib_umem_start(odp);
+			if ((user_va + bcnt) > ib_umem_end(odp))
+				bcnt = ib_umem_end(odp) - user_va;
+		} else if (unlikely(user_va >= ib_umem_end(odp) ||
+				    ib_umem_end(odp) - user_va < bcnt))
 			return -EFAULT;
 		return pagefault_real_mr(mr, odp, user_va, bcnt, bytes_mapped,
 					 flags);
@@ -858,7 +865,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 	case MLX5_MKEY_MR:
 		mr = container_of(mmkey, struct mlx5_ib_mr, mmkey);
 
-		ret = pagefault_mr(mr, io_virt, bcnt, bytes_mapped, 0);
+		ret = pagefault_mr(mr, io_virt, bcnt, bytes_mapped, 0, false);
 		if (ret < 0)
 			goto end;
 
@@ -1724,7 +1731,7 @@ static void mlx5_ib_prefetch_mr_work(struct work_struct *w)
 	for (i = 0; i < work->num_sge; ++i) {
 		ret = pagefault_mr(work->frags[i].mr, work->frags[i].io_virt,
 				   work->frags[i].length, &bytes_mapped,
-				   work->pf_flags);
+				   work->pf_flags, false);
 		if (ret <= 0)
 			continue;
 		mlx5_update_odp_stats(work->frags[i].mr, prefetch, ret);
@@ -1775,7 +1782,7 @@ static int mlx5_ib_prefetch_sg_list(struct ib_pd *pd,
 		if (IS_ERR(mr))
 			return PTR_ERR(mr);
 		ret = pagefault_mr(mr, sg_list[i].addr, sg_list[i].length,
-				   &bytes_mapped, pf_flags);
+				   &bytes_mapped, pf_flags, false);
 		if (ret < 0) {
 			mlx5r_deref_odp_mkey(&mr->mmkey);
 			return ret;
-- 
2.43.0



