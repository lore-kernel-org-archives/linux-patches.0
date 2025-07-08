Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90FDB672;
	Tue,  8 Jul 2025 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993235; cv=none; b=eQK11Ev2Znnx8LKvpvX3t/PdoUuVc+OMzwOnNy6RVAUK0u57Rw+Vl6REXgokIbXw5ZL3x9uoOha9fzqycAVlRJHGzRpt+FWmsot8JZVJwtDsbzHtjnc6sr3uvuijB9rahf4dv0aGrupmqWcBYAW5jLrM9qrpphysrzKXi9s5yi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993235; c=relaxed/simple;
	bh=rkBmNU6GB9CP5MXzcyQ5GMNpJziN+JiqpJMpoHzvikE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fy7XxYLRq43PGL7a0Z06cxqLvnIS79qwxb4mBddzYUSqVlmbAMo5QediXiVcsUrChDJAe9aQ2A+ylWMxRoq1t9czzYKemDh6m8BQwyH0JJfP7jzkYTdeFNqCXZM9waGJkBhLnq+XARuGzvFsL9u0Ifqu/T4WoZMa6iFDJAv3Acw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2HuGsRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2HuGsRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6F5C4CEED;
	Tue,  8 Jul 2025 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993235;
	bh=rkBmNU6GB9CP5MXzcyQ5GMNpJziN+JiqpJMpoHzvikE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2HuGsRAEXf9qe/1geyXJG2fowRIGXELly3ocmyLQ/L9QqUwcqx7LpBMHdV/OaGrs
	 kKwSbZC8Z5pAEqHv2O55X9GNgTkECo/CQVCJIE3akTpBgvVYOgHq2HHGT+kCBgPYJY
	 42t+c4ZHkF8XyabLvRrt7mJdHwT5XnPMZ4gnUkwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/232] RDMA/mlx5: Fix cache entry update on dereg error
Date: Tue,  8 Jul 2025 18:23:10 +0200
Message-ID: <20250708162246.515474635@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 24d693cf6c89d216a68634d44fa93e4400775d94 ]

Fix double decrement of 'in_use' counter on push_mkey_locked() failure
while deregistering an MR.
If we fail to return an mkey to the cache in cache_ent_find_and_store()
it'll update the 'in_use' counter. Its caller, revoke_mr(), also updates
it, thus having double decrement.

Wrong value of 'in_use' counter will be exposed through debugfs and can
also cause wrong resizing of the cache when users try to set cache
entry size using the 'size' debugfs.

To address this issue, the 'in_use' counter is now decremented within
mlx5_revoke_mr() also after a successful call to
cache_ent_find_and_store() and not within cache_ent_find_and_store().
Other success or failure flows remains unchanged where it was also
decremented.

Fixes: 8c1185fef68c ("RDMA/mlx5: Change check for cacheable mkeys")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/97e979dff636f232ff4c83ce709c17c727da1fdb.1741875692.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 068eac3bdb50b..830a15b66c120 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1968,7 +1968,6 @@ static int cache_ent_find_and_store(struct mlx5_ib_dev *dev,
 
 	if (mr->mmkey.cache_ent) {
 		spin_lock_irq(&mr->mmkey.cache_ent->mkeys_queue.lock);
-		mr->mmkey.cache_ent->in_use--;
 		goto end;
 	}
 
@@ -2036,6 +2035,7 @@ static int mlx5_revoke_mr(struct mlx5_ib_mr *mr)
 	bool is_odp = is_odp_mr(mr);
 	bool is_odp_dma_buf = is_dmabuf_mr(mr) &&
 			!to_ib_umem_dmabuf(mr->umem)->pinned;
+	bool from_cache = !!ent;
 	int ret = 0;
 
 	if (is_odp)
@@ -2048,6 +2048,8 @@ static int mlx5_revoke_mr(struct mlx5_ib_mr *mr)
 		ent = mr->mmkey.cache_ent;
 		/* upon storing to a clean temp entry - schedule its cleanup */
 		spin_lock_irq(&ent->mkeys_queue.lock);
+		if (from_cache)
+			ent->in_use--;
 		if (ent->is_tmp && !ent->tmp_cleanup_scheduled) {
 			mod_delayed_work(ent->dev->cache.wq, &ent->dwork,
 					 msecs_to_jiffies(30 * 1000));
-- 
2.39.5



