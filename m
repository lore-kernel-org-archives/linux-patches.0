Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A095526AABA;
	Tue,  8 Apr 2025 12:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114583; cv=none; b=rq8mbjUnLimivLd4rkB9YN6NuUfrPpSbjgwQW0vKHsBCCLw4NjSnJvnodgbFzgK54ZdtpPibste3a8EqojjHtq9SAAjeX8W7FfwjPLp7YSJbDQQEvnjaaswxQ8vOfqXeRBM4oZDAOnmMSxCPRF8/1VTaiMUgF88FH1MZPTzhmTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114583; c=relaxed/simple;
	bh=YBZauKEu2qvkjy/radoLDre14g+fLV9WhQKy3vGfI8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwShIn7yBe4Ma0kO2X45drlb3XvEMaVeDVi3KBXSkh+Kxbb2kl0ei0Pu9J2VHzpoChoyzCY4p7PeaubcqeuBI6sAPvW0pSudokaA2BuVOHfJ5XiF8AI8vYuC412PFMfvl54C8QFCV43uDf2dQl+uenNwg1EDH/frtxpgonbcm3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBuOsouU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBuOsouU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C9EC4CEE5;
	Tue,  8 Apr 2025 12:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114583;
	bh=YBZauKEu2qvkjy/radoLDre14g+fLV9WhQKy3vGfI8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBuOsouUpC0csoUK1uHnEuTqZ2p7WDvVfOsjK5RRBDR3BP4uh3al8piUM9SJoIN1v
	 Yf8GZ/8HkiS24wJ2EoX45aaliwwWotdKH/Ub4T0tmteotHG7bKLRHDqlLJol6AXgKH
	 Y+aRNcH624vKCdve6NDJgAxl/liw/mWdyvq8oL1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 159/499] RDMA/mlx5: Fix MR cache initialization error flow
Date: Tue,  8 Apr 2025 12:46:11 +0200
Message-ID: <20250408104855.147563846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit a0130ef84b00c68ba0b79ee974a0f01459741421 ]

Destroy all previously created cache entries and work queue when rolling
back the MR cache initialization upon an error.

Fixes: 73d09b2fe833 ("RDMA/mlx5: Introduce mlx5r_cache_rb_key")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/c41d525fb3c72e28dd38511bf3aaccb5d584063e.1741875692.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index eeb94d1ae60d9..068eac3bdb50b 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -919,6 +919,25 @@ mlx5r_cache_create_ent_locked(struct mlx5_ib_dev *dev,
 	return ERR_PTR(ret);
 }
 
+static void mlx5r_destroy_cache_entries(struct mlx5_ib_dev *dev)
+{
+	struct rb_root *root = &dev->cache.rb_root;
+	struct mlx5_cache_ent *ent;
+	struct rb_node *node;
+
+	mutex_lock(&dev->cache.rb_lock);
+	node = rb_first(root);
+	while (node) {
+		ent = rb_entry(node, struct mlx5_cache_ent, node);
+		node = rb_next(node);
+		clean_keys(dev, ent);
+		rb_erase(&ent->node, root);
+		mlx5r_mkeys_uninit(ent);
+		kfree(ent);
+	}
+	mutex_unlock(&dev->cache.rb_lock);
+}
+
 int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_mkey_cache *cache = &dev->cache;
@@ -970,6 +989,8 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 err:
 	mutex_unlock(&cache->rb_lock);
 	mlx5_mkey_cache_debugfs_cleanup(dev);
+	mlx5r_destroy_cache_entries(dev);
+	destroy_workqueue(cache->wq);
 	mlx5_ib_warn(dev, "failed to create mkey cache entry\n");
 	return ret;
 }
@@ -1003,17 +1024,7 @@ void mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev)
 	mlx5_cmd_cleanup_async_ctx(&dev->async_ctx);
 
 	/* At this point all entries are disabled and have no concurrent work. */
-	mutex_lock(&dev->cache.rb_lock);
-	node = rb_first(root);
-	while (node) {
-		ent = rb_entry(node, struct mlx5_cache_ent, node);
-		node = rb_next(node);
-		clean_keys(dev, ent);
-		rb_erase(&ent->node, root);
-		mlx5r_mkeys_uninit(ent);
-		kfree(ent);
-	}
-	mutex_unlock(&dev->cache.rb_lock);
+	mlx5r_destroy_cache_entries(dev);
 
 	destroy_workqueue(dev->cache.wq);
 	del_timer_sync(&dev->delay_timer);
-- 
2.39.5



