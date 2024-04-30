Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9D48801;
	Tue, 30 Apr 2024 11:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475970; cv=none; b=t3zHktB88U8t8gWoYhG6Fa/+9bdEYyqym4X5CahEB2rVr9uJy1773SLLFA041zmAFhyX80PWaGeWi9KCLUdPNiIrfQl/R4AA0jsYgkmuTDxQOEsrvOpp/zBnkea+E1yc6WYPZt+ZOdOC0CYYHyJ7DS1niguqa0zXJCDTaZrPAio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475970; c=relaxed/simple;
	bh=/DZuc+mf/p6b1qWN0ecZJ11ZE21Bvci8W1alxCg19Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLXpl9rEp0QuOFj2bdTS/NkqVeqq9yBf8vFHp89bhzIt7wPvNEd4CtRS8JcOot8B9HDtML3qdJVhtNutVogvvu0X9ZO8aY51Ecd6V91b5HsPunTldu/hVELHb5eDMErGxur42O43xBX8MZmxA4KS725yJpShMKcN/WX1f2Bkk3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBrrA+XA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBrrA+XA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9EAC2BBFC;
	Tue, 30 Apr 2024 11:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475970;
	bh=/DZuc+mf/p6b1qWN0ecZJ11ZE21Bvci8W1alxCg19Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBrrA+XAUVahYVAySMW6jk39YdacF9DPWLZdRykFhP0mSUbVdiB3wRkuwOqcTXVil
	 Hj/05ovAj/XfMEEppTUjxSmEzOhvgVh1qqQ9iWFoopWk7EFs2CwARfBGGfSXUKQWFr
	 xzfSsjle9ysw9Ylhtk/G1PFKfxcbP0SDW5uVRHhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Alexander Zubkov <green@qrator.net>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/80] mlxsw: spectrum_acl_tcam: Fix warning during rehash
Date: Tue, 30 Apr 2024 12:40:07 +0200
Message-ID: <20240430103044.454243919@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 743edc8547a92b6192aa1f1b6bb78233fa21dc9b ]

As previously explained, the rehash delayed work migrates filters from
one region to another. This is done by iterating over all chunks (all
the filters with the same priority) in the region and in each chunk
iterating over all the filters.

When the work runs out of credits it stores the current chunk and entry
as markers in the per-work context so that it would know where to resume
the migration from the next time the work is scheduled.

Upon error, the chunk marker is reset to NULL, but without resetting the
entry markers despite being relative to it. This can result in migration
being resumed from an entry that does not belong to the chunk being
migrated. In turn, this will eventually lead to a chunk being iterated
over as if it is an entry. Because of how the two structures happen to
be defined, this does not lead to KASAN splats, but to warnings such as
[1].

Fix by creating a helper that resets all the markers and call it from
all the places the currently only reset the chunk marker. For good
measures also call it when starting a completely new rehash. Add a
warning to avoid future cases.

[1]
WARNING: CPU: 7 PID: 1076 at drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c:407 mlxsw_afk_encode+0x242/0x2f0
Modules linked in:
CPU: 7 PID: 1076 Comm: kworker/7:24 Tainted: G        W          6.9.0-rc3-custom-00880-g29e61d91b77b #29
Hardware name: Mellanox Technologies Ltd. MSN3700/VMOD0005, BIOS 5.11 01/06/2019
Workqueue: mlxsw_core mlxsw_sp_acl_tcam_vregion_rehash_work
RIP: 0010:mlxsw_afk_encode+0x242/0x2f0
[...]
Call Trace:
 <TASK>
 mlxsw_sp_acl_atcam_entry_add+0xd9/0x3c0
 mlxsw_sp_acl_tcam_entry_create+0x5e/0xa0
 mlxsw_sp_acl_tcam_vchunk_migrate_all+0x109/0x290
 mlxsw_sp_acl_tcam_vregion_rehash_work+0x6c/0x470
 process_one_work+0x151/0x370
 worker_thread+0x2cb/0x3e0
 kthread+0xd0/0x100
 ret_from_fork+0x34/0x50
 </TASK>

Fixes: 6f9579d4e302 ("mlxsw: spectrum_acl: Remember where to continue rehash migration")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Alexander Zubkov <green@qrator.net>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/cc17eed86b41dd829d39b07906fec074a9ce580e.1713797103.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlxsw/spectrum_acl_tcam.c        | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index b63b4a3ee7c42..8c1e97d463eb7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -725,6 +725,17 @@ static void mlxsw_sp_acl_tcam_vregion_rehash_work(struct work_struct *work)
 		mlxsw_sp_acl_tcam_vregion_rehash_work_schedule(vregion);
 }
 
+static void
+mlxsw_sp_acl_tcam_rehash_ctx_vchunk_reset(struct mlxsw_sp_acl_tcam_rehash_ctx *ctx)
+{
+	/* The entry markers are relative to the current chunk and therefore
+	 * needs to be reset together with the chunk marker.
+	 */
+	ctx->current_vchunk = NULL;
+	ctx->start_ventry = NULL;
+	ctx->stop_ventry = NULL;
+}
+
 static void
 mlxsw_sp_acl_tcam_rehash_ctx_vchunk_changed(struct mlxsw_sp_acl_tcam_vchunk *vchunk)
 {
@@ -747,7 +758,7 @@ mlxsw_sp_acl_tcam_rehash_ctx_vregion_changed(struct mlxsw_sp_acl_tcam_vregion *v
 	 * the current chunk pointer to make sure all chunks
 	 * are properly migrated.
 	 */
-	vregion->rehash.ctx.current_vchunk = NULL;
+	mlxsw_sp_acl_tcam_rehash_ctx_vchunk_reset(&vregion->rehash.ctx);
 }
 
 static struct mlxsw_sp_acl_tcam_vregion *
@@ -1250,7 +1261,7 @@ mlxsw_sp_acl_tcam_vchunk_migrate_end(struct mlxsw_sp *mlxsw_sp,
 {
 	mlxsw_sp_acl_tcam_chunk_destroy(mlxsw_sp, vchunk->chunk2);
 	vchunk->chunk2 = NULL;
-	ctx->current_vchunk = NULL;
+	mlxsw_sp_acl_tcam_rehash_ctx_vchunk_reset(ctx);
 }
 
 static int
@@ -1282,6 +1293,8 @@ mlxsw_sp_acl_tcam_vchunk_migrate_one(struct mlxsw_sp *mlxsw_sp,
 		ventry = list_first_entry(&vchunk->ventry_list,
 					  typeof(*ventry), list);
 
+	WARN_ON(ventry->vchunk != vchunk);
+
 	list_for_each_entry_from(ventry, &vchunk->ventry_list, list) {
 		/* During rollback, once we reach the ventry that failed
 		 * to migrate, we are done.
@@ -1373,7 +1386,7 @@ mlxsw_sp_acl_tcam_vregion_migrate(struct mlxsw_sp *mlxsw_sp,
 		 * to vregion->region.
 		 */
 		swap(vregion->region, vregion->region2);
-		ctx->current_vchunk = NULL;
+		mlxsw_sp_acl_tcam_rehash_ctx_vchunk_reset(ctx);
 		ctx->this_is_rollback = true;
 		err2 = mlxsw_sp_acl_tcam_vchunk_migrate_all(mlxsw_sp, vregion,
 							    ctx, credits);
@@ -1432,6 +1445,7 @@ mlxsw_sp_acl_tcam_vregion_rehash_start(struct mlxsw_sp *mlxsw_sp,
 
 	ctx->hints_priv = hints_priv;
 	ctx->this_is_rollback = false;
+	mlxsw_sp_acl_tcam_rehash_ctx_vchunk_reset(ctx);
 
 	return 0;
 
-- 
2.43.0



