Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB49481DD;
	Wed,  5 Mar 2025 17:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197272; cv=none; b=PX+gDUB5hLdE6Z64He7/qTClo4Vk0P3g221U5R7qrfriXgWVtzMAjsK2TcrNGLZae123F8NPsPOGtbS4DnZxTFzPQbovy3XkZHIGCOkksepZHnD7UIHGkuK7utXBsT+ipo7MRTpX9p5J+iNPc8uZTX4cxJqWZ4ssgQHTGWI2qjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197272; c=relaxed/simple;
	bh=6E3g8mB46wZwMn+JQmr/PWGy7+cDg+bWe6Jcj6MqK7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaI3Be3O2sD+FkpHIl2SabfuFl0ReWMkCoXMwsEbKmMSi6dtqbTQzaq0PA+lrffd54H/2S4I2sUV5yBJNiVsqor8UuxikIB+uve5hHwLJ6xz2ke4el6OPXaJ733oHIryvlQTlyimJZ++M3L9JHAQtXMTeBZXUS3NMBJbpGn9i0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJ5JFbJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJ5JFbJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DD9C4CED1;
	Wed,  5 Mar 2025 17:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197271;
	bh=6E3g8mB46wZwMn+JQmr/PWGy7+cDg+bWe6Jcj6MqK7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJ5JFbJCIdosO2kzDMh94Y1Y8uEV31/l1CAc2FlbRZQaid7SFG9k6mFOaxLgBZtUg
	 J3f/2E7O5McUy8Bdv5gOZRZij00Ff2VSufzGf9UggHBc2mwlRbdkow+0aLr1EsuF/E
	 o1A9t9yQtRNK98im9AyN21T3BHCdrsmtYkSKFGvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aharon Landau <aharonl@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/176] RDMA/mlx5: Dont keep umrable page_shift in cache entries
Date: Wed,  5 Mar 2025 18:47:46 +0100
Message-ID: <20250305174509.358007400@linuxfoundation.org>
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

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit a2a88b8e22d1b202225d0e40b02ad068afab2ccb ]

mkc.log_page_size can be changed using UMR. Therefore, don't treat it as a
cache entry property.

Removing it from struct mlx5_cache_ent.

All cache mkeys will be created with default PAGE_SHIFT, and updated with
the needed page_shift using UMR when passing them to a user.

Link: https://lore.kernel.org/r/20230125222807.6921-2-michaelgur@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: d97505baea64 ("RDMA/mlx5: Fix the recovery flow of the UMR QP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 -
 drivers/infiniband/hw/mlx5/mr.c      | 3 +--
 drivers/infiniband/hw/mlx5/odp.c     | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 0ef347e91ffeb..10c87901da27c 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -759,7 +759,6 @@ struct mlx5_cache_ent {
 	char                    name[4];
 	u32                     order;
 	u32			access_mode;
-	u32			page;
 	unsigned int		ndescs;
 
 	u8 disabled:1;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index b81b03aa2a629..53fadd6edb68d 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -297,7 +297,7 @@ static void set_cache_mkc(struct mlx5_cache_ent *ent, void *mkc)
 
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 get_mkc_octo_size(ent->access_mode, ent->ndescs));
-	MLX5_SET(mkc, mkc, log_page_size, ent->page);
+	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
 }
 
 /* Asynchronously schedule new MRs to be populated in the cache. */
@@ -765,7 +765,6 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 		if (ent->order > mkey_cache_max_order(dev))
 			continue;
 
-		ent->page = PAGE_SHIFT;
 		ent->ndescs = 1 << ent->order;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
 		if ((dev->mdev->profile.mask & MLX5_PROF_MASK_MR_CACHE) &&
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 87fbee8061003..a5c9baec8be85 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1598,14 +1598,12 @@ void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent)
 
 	switch (ent->order - 2) {
 	case MLX5_IMR_MTT_CACHE_ENTRY:
-		ent->page = PAGE_SHIFT;
 		ent->ndescs = MLX5_IMR_MTT_ENTRIES;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
 		ent->limit = 0;
 		break;
 
 	case MLX5_IMR_KSM_CACHE_ENTRY:
-		ent->page = MLX5_KSM_PAGE_SHIFT;
 		ent->ndescs = mlx5_imr_ksm_entries;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_KSM;
 		ent->limit = 0;
-- 
2.39.5



