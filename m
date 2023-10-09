Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA341946D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2D6AZygb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF91C433C8;
	Mon,  9 Oct 2023 13:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857296;
	bh=o4YYDbdsCFB80Cfbl/SLpuJC8oDbvHkypZjXWM46joQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2D6AZygbMTvCpLtBNONo4zRJarq3Go97CcjAy+gJMjitYpu1AqXPVyn8tYnv90qLB
	 o+fzM1M4ZhpSytc0VVDw3q8unUIyUaqTGEWJu6ghV1OeDbrQtw3EdfxWuhbKH6+XyV
	 dj6N2cAQSxq0eh5h2TodMzegOPR5O5SQAigBqMSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH 6.5 163/163] RDMA/mlx5: Remove not-used cache disable flag
Date: Mon,  9 Oct 2023 15:02:07 +0200
Message-ID: <20231009130128.500047722@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

commit c99a7457e5bb873914a74307ba2df85f6799203b upstream.

During execution of mlx5_mkey_cache_cleanup(), there is a guarantee
that MR are not registered and/or destroyed. It means that we don't
need newly introduced cache disable flag.

Fixes: 374012b00457 ("RDMA/mlx5: Fix mkey cache possible deadlock on cleanup")
Link: https://lore.kernel.org/r/c7e9c9f98c8ae4a7413d97d9349b29f5b0a23dbe.1695921626.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    1 -
 drivers/infiniband/hw/mlx5/mr.c      |    5 -----
 2 files changed, 6 deletions(-)

--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -797,7 +797,6 @@ struct mlx5_mkey_cache {
 	struct dentry		*fs_root;
 	unsigned long		last_add;
 	struct delayed_work	remove_ent_dwork;
-	u8			disable: 1;
 };
 
 struct mlx5_ib_port_resources {
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1026,7 +1026,6 @@ void mlx5_mkey_cache_cleanup(struct mlx5
 		return;
 
 	mutex_lock(&dev->cache.rb_lock);
-	dev->cache.disable = true;
 	for (node = rb_first(root); node; node = rb_next(node)) {
 		ent = rb_entry(node, struct mlx5_cache_ent, node);
 		xa_lock_irq(&ent->mkeys);
@@ -1824,10 +1823,6 @@ static int cache_ent_find_and_store(stru
 	}
 
 	mutex_lock(&cache->rb_lock);
-	if (cache->disable) {
-		mutex_unlock(&cache->rb_lock);
-		return 0;
-	}
 	ent = mkey_cache_ent_from_rb_key(dev, mr->mmkey.rb_key);
 	if (ent) {
 		if (ent->rb_key.ndescs == mr->mmkey.rb_key.ndescs) {


