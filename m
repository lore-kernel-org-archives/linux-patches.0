Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA201C860D;
	Wed,  5 Mar 2025 18:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197943; cv=none; b=ntHMabe4xo/CdNeQk8P9pqsfNuezQb32mETQrl6bO5IsYIjdiBmo4z4Bp8U3/8fE/OMJqosaXi376WYGLYOvJIX6DDaCqQBeII4LPyqSLodr+grVtWc4AgD0iwtiVBbogHPCgn3YlQCu0bI1S4sL2RwQrT9hMeXmYDuSgyjJaNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197943; c=relaxed/simple;
	bh=Qu1b39enMVBcjAuqU+BXY14c8GzTUuh0rF2qx8v/pvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2K0aAunWYpfxJmTrOikHD9uepz+HZbN0OLN52hB91Zz3Ofbx9SH4HWi0j8dalrcWyQAq/YvGBm5Yp5qR2knDf1d11zlOE+DOSEgVt3eLHErJad+mS2GlY7+FeLGILTxd+o2jFfPl+/EIY2YdeYBTfriTQ+qt8+XkbvjMNGSjA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLALPwAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLALPwAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646EBC4CED1;
	Wed,  5 Mar 2025 18:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197942;
	bh=Qu1b39enMVBcjAuqU+BXY14c8GzTUuh0rF2qx8v/pvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLALPwAzkjsZK1MFCfBfrGuvhjnyev11M7rkcZ4dl0/ZqXPA5HxaDkriAgxpazAFp
	 nshsPdBA5zz0NFQk6EGexi1IKnWVdZGcvHHf45PTZuizZGI7blY0ESoxUpF6lIAK5w
	 U5mO/0H9AJh6WZp5neHL9ugA1zinnehKaSm4GFQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Artemy Kovalyov <artemyko@mnvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/150] RDMA/mlx5: Fix a race for DMABUF MR which can lead to CQE with error
Date: Wed,  5 Mar 2025 18:47:12 +0100
Message-ID: <20250305174503.942620589@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit cc668a11e6ac8adb0e016711080d3f314722cc91 ]

This patch addresses a potential race condition for a DMABUF MR that can
result in a CQE with an error on the UMR QP.

During the __mlx5_ib_dereg_mr() flow, the following sequence of calls
occurs:
mlx5_revoke_mr()
mlx5r_umr_revoke_mr()
mlx5r_umr_post_send_wait()
At this point, the lkey is freed from the hardware's perspective.

However, concurrently, mlx5_ib_dmabuf_invalidate_cb() might be triggered
by another task attempting to invalidate the MR having that freed lkey.

Since the lkey has already been freed, this can lead to a CQE error,
causing the UMR QP to enter an error state.

To resolve this race condition, the dma_resv_lock() which was hold as
part of the mlx5_ib_dmabuf_invalidate_cb() is now also acquired as part
of the mlx5_revoke_mr() scope.

Upon a successful revoke, we set umem_dmabuf->private which points to
that MR to NULL, preventing any further invalidation attempts on its
lkey.

Fixes: e6fb246ccafb ("RDMA/mlx5: Consolidate MR destruction to mlx5_ib_dereg_mr()")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Artemy Kovalyov <artemyko@mnvidia.com>
Link: https://patch.msgid.link/70617067abbfaa0c816a2544c922e7f4346def58.1738587016.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index bb02b6adbf2c2..0a3cbb14e1839 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1550,7 +1550,7 @@ static void mlx5_ib_dmabuf_invalidate_cb(struct dma_buf_attachment *attach)
 
 	dma_resv_assert_held(umem_dmabuf->attach->dmabuf->resv);
 
-	if (!umem_dmabuf->sgt)
+	if (!umem_dmabuf->sgt || !mr)
 		return;
 
 	mlx5r_umr_update_mr_pas(mr, MLX5_IB_UPD_XLT_ZAP);
@@ -2022,11 +2022,16 @@ static int mlx5_revoke_mr(struct mlx5_ib_mr *mr)
 	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
 	struct mlx5_cache_ent *ent = mr->mmkey.cache_ent;
 	bool is_odp = is_odp_mr(mr);
+	bool is_odp_dma_buf = is_dmabuf_mr(mr) &&
+			!to_ib_umem_dmabuf(mr->umem)->pinned;
 	int ret = 0;
 
 	if (is_odp)
 		mutex_lock(&to_ib_umem_odp(mr->umem)->umem_mutex);
 
+	if (is_odp_dma_buf)
+		dma_resv_lock(to_ib_umem_dmabuf(mr->umem)->attach->dmabuf->resv, NULL);
+
 	if (mr->mmkey.cacheable && !mlx5r_umr_revoke_mr(mr) && !cache_ent_find_and_store(dev, mr)) {
 		ent = mr->mmkey.cache_ent;
 		/* upon storing to a clean temp entry - schedule its cleanup */
@@ -2054,6 +2059,12 @@ static int mlx5_revoke_mr(struct mlx5_ib_mr *mr)
 		mutex_unlock(&to_ib_umem_odp(mr->umem)->umem_mutex);
 	}
 
+	if (is_odp_dma_buf) {
+		if (!ret)
+			to_ib_umem_dmabuf(mr->umem)->private = NULL;
+		dma_resv_unlock(to_ib_umem_dmabuf(mr->umem)->attach->dmabuf->resv);
+	}
+
 	return ret;
 }
 
-- 
2.39.5



