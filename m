Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EB21C5F2C;
	Wed,  5 Mar 2025 17:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197300; cv=none; b=K6B7J7EpEj0AWnXlNAWraVs24OsUT9pJrJCmwNaIBZlOV1zfqpO1wr5f2F9sA2V0/jnq9AElXX09Eu+v/DUZUz35i1fD/RqgmcLIvf5GbJda4Hu1q1pHR99EkVn9KvS9mCNNrW/RWKXlGHcOZAv31o1/U55MnXdQhiCkpkG+5vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197300; c=relaxed/simple;
	bh=NN57pOU6/B7DtChFcJM2Uva/2Zbkk3uGn+ra4EIksdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oegvhjunVtxVIrIfHgqruuztR9sIxiPNFDxm6JOzYHYw8Q61QZqQabmDsHoTvwuSKiLYr0eOd2gnq6pI1W0BP/uRVolQ7d44a8lWNfitS4JBNQm1JyWAZVQkOa/lOiFd2Wp3qrXGYE9vA9JNj70dd5qKKe5Nu/z15WsSPcTPYws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2iicfaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2iicfaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A812FC4CED1;
	Wed,  5 Mar 2025 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197300;
	bh=NN57pOU6/B7DtChFcJM2Uva/2Zbkk3uGn+ra4EIksdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2iicfaAQ+9QkSHpVElDDG19AUOZFjXqRduzmebNmM+k93wfnR8jr776ytnGIarhH
	 SUgYTLOnJLTVoMCDaR2nZBhXv9GXg5pLcqmtqREaj08bDBymWSt7x7LEpWzUNcv+6C
	 4vtIvK3VRKa9h5LPLEqxH1u7XQZZWYDiRlpiVVIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/176] RDMA/mlx5: Cache all user cacheable mkeys on dereg MR flow
Date: Wed,  5 Mar 2025 18:47:50 +0100
Message-ID: <20250305174509.519454849@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit dd1b913fb0d0e3e6d55e92d2319d954474dd66ac ]

Currently, when dereging an MR, if the mkey doesn't belong to a cache
entry, it will be destroyed.  As a result, the restart of applications
with many non-cached mkeys is not efficient since all the mkeys are
destroyed and then recreated.  This process takes a long time (for 100,000
MRs, it is ~20 seconds for dereg and ~28 seconds for re-reg).

To shorten the restart runtime, insert all cacheable mkeys to the cache.
If there is no fitting entry to the mkey properties, create a temporary
entry that fits it.

After a predetermined timeout, the cache entries will shrink to the
initial high limit.

The mkeys will still be in the cache when consuming them again after an
application restart. Therefore, the registration will be much faster
(for 100,000 MRs, it is ~4 seconds for dereg and ~5 seconds for re-reg).

The temporary cache entries created to store the non-cache mkeys are not
exposed through sysfs like the default cache entries.

Link: https://lore.kernel.org/r/20230125222807.6921-6-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: d97505baea64 ("RDMA/mlx5: Fix the recovery flow of the UMR QP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +
 drivers/infiniband/hw/mlx5/mr.c      | 55 +++++++++++++++++++++-------
 2 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7c9d5648947e9..f345e2ae394d2 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -650,6 +650,8 @@ struct mlx5_ib_mkey {
 	unsigned int ndescs;
 	struct wait_queue_head wait;
 	refcount_t usecount;
+	/* User Mkey must hold either a rb_key or a cache_ent. */
+	struct mlx5r_cache_rb_key rb_key;
 	struct mlx5_cache_ent *cache_ent;
 };
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1060b30a837a0..bf1ca7565be67 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1110,15 +1110,14 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 	rb_key.access_flags = get_unchangeable_access_flags(dev, access_flags);
 	ent = mkey_cache_ent_from_rb_key(dev, rb_key);
 	/*
-	 * Matches access in alloc_cache_mr(). If the MR can't come from the
-	 * cache then synchronously create an uncached one.
+	 * If the MR can't come from the cache then synchronously create an uncached
+	 * one.
 	 */
-	if (!ent || ent->limit == 0 ||
-	    !mlx5r_umr_can_reconfig(dev, 0, access_flags) ||
-	    mlx5_umem_needs_ats(dev, umem, access_flags)) {
+	if (!ent) {
 		mutex_lock(&dev->slow_path_mutex);
 		mr = reg_create(pd, umem, iova, access_flags, page_size, false);
 		mutex_unlock(&dev->slow_path_mutex);
+		mr->mmkey.rb_key = rb_key;
 		return mr;
 	}
 
@@ -1209,6 +1208,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 		goto err_2;
 	}
 	mr->mmkey.type = MLX5_MKEY_MR;
+	mr->mmkey.ndescs = get_octo_len(iova, umem->length, mr->page_shift);
 	mr->umem = umem;
 	set_mr_fields(dev, mr, umem->length, access_flags, iova);
 	kvfree(in);
@@ -1747,6 +1747,40 @@ mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 	}
 }
 
+static int cache_ent_find_and_store(struct mlx5_ib_dev *dev,
+				    struct mlx5_ib_mr *mr)
+{
+	struct mlx5_mkey_cache *cache = &dev->cache;
+	struct mlx5_cache_ent *ent;
+
+	if (mr->mmkey.cache_ent) {
+		xa_lock_irq(&mr->mmkey.cache_ent->mkeys);
+		mr->mmkey.cache_ent->in_use--;
+		xa_unlock_irq(&mr->mmkey.cache_ent->mkeys);
+		goto end;
+	}
+
+	mutex_lock(&cache->rb_lock);
+	ent = mkey_cache_ent_from_rb_key(dev, mr->mmkey.rb_key);
+	mutex_unlock(&cache->rb_lock);
+	if (ent) {
+		if (ent->rb_key.ndescs == mr->mmkey.rb_key.ndescs) {
+			mr->mmkey.cache_ent = ent;
+			goto end;
+		}
+	}
+
+	ent = mlx5r_cache_create_ent(dev, mr->mmkey.rb_key, false);
+	if (IS_ERR(ent))
+		return PTR_ERR(ent);
+
+	mr->mmkey.cache_ent = ent;
+
+end:
+	return push_mkey(mr->mmkey.cache_ent, false,
+			 xa_mk_value(mr->mmkey.key));
+}
+
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
@@ -1792,16 +1826,11 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	}
 
 	/* Stop DMA */
-	if (mr->mmkey.cache_ent) {
-		xa_lock_irq(&mr->mmkey.cache_ent->mkeys);
-		mr->mmkey.cache_ent->in_use--;
-		xa_unlock_irq(&mr->mmkey.cache_ent->mkeys);
-
+	if (mr->umem && mlx5r_umr_can_load_pas(dev, mr->umem->length))
 		if (mlx5r_umr_revoke_mr(mr) ||
-		    push_mkey(mr->mmkey.cache_ent, false,
-			      xa_mk_value(mr->mmkey.key)))
+		    cache_ent_find_and_store(dev, mr))
 			mr->mmkey.cache_ent = NULL;
-	}
+
 	if (!mr->mmkey.cache_ent) {
 		rc = destroy_mkey(to_mdev(mr->ibmr.device), mr);
 		if (rc)
-- 
2.39.5



