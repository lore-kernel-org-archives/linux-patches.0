Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB55B12CDA5;
	Tue, 30 Apr 2024 11:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476226; cv=none; b=Fz35cZFr2r6pA1VI9CzhNhRf8y+pxWPMSKIBh+R5A0g6ac0NF6OG/1fdmfEzT90S7AJ9AYX+IPDGUxFRSsVJNhE+Gwu/q7KZ9xrLXn6XM2zng83Mf76PUbY984eBqdg7CTdSk2W1Zlk+kzUscs1HuL1MB1bSh3HEMscZABIfZ28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476226; c=relaxed/simple;
	bh=dtx1fRgxwYmFX8GgpIdmZiNpNyRJfqUYa/yG+PowUHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hR0fErGFIA5BnFWRf6exD0ESxagpD6lSwnwL1fpTpmjsGviPsq1Gjby5PJRlJyrwYQSVixX+uJBJQug6oE0rblc4pMEN6S8rzwg4W3ne5Uer9khNKDLy0JXlMHo+Rv5Qh2w2VpwWN3tE0adcLBHJ5QM4LMUwDg0bnEWFzne+aEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZkwn1Tm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZkwn1Tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47476C2BBFC;
	Tue, 30 Apr 2024 11:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476225;
	bh=dtx1fRgxwYmFX8GgpIdmZiNpNyRJfqUYa/yG+PowUHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZkwn1TmR/MSuATJoTnD1APOK+b8pe1L6VXVTRY2Qo6ZtD4OmCYXUktt2rRVaLRaS
	 L2m8mVFwSYnmDHpIxKYr1oOuAtxOxhV3ZFA5wObQD5nMvGnSM/qkvE70p1Wnv7ksEc
	 a8lZh0V4xrwzI6+dHXsioLOYjmoeaSMb26vS5lO4=
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
Subject: [PATCH 5.4 072/107] mlxsw: spectrum_acl_tcam: Fix memory leak during rehash
Date: Tue, 30 Apr 2024 12:40:32 +0200
Message-ID: <20240430103046.781038178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 8ca3f7a7b61393804c46f170743c3b839df13977 ]

The rehash delayed work migrates filters from one region to another.
This is done by iterating over all chunks (all the filters with the same
priority) in the region and in each chunk iterating over all the
filters.

If the migration fails, the code tries to migrate the filters back to
the old region. However, the rollback itself can also fail in which case
another migration will be erroneously performed. Besides the fact that
this ping pong is not a very good idea, it also creates a problem.

Each virtual chunk references two chunks: The currently used one
('vchunk->chunk') and a backup ('vchunk->chunk2'). During migration the
first holds the chunk we want to migrate filters to and the second holds
the chunk we are migrating filters from.

The code currently assumes - but does not verify - that the backup chunk
does not exist (NULL) if the currently used chunk does not reference the
target region. This assumption breaks when we are trying to rollback a
rollback, resulting in the backup chunk being overwritten and leaked
[1].

Fix by not rolling back a failed rollback and add a warning to avoid
future cases.

[1]
WARNING: CPU: 5 PID: 1063 at lib/parman.c:291 parman_destroy+0x17/0x20
Modules linked in:
CPU: 5 PID: 1063 Comm: kworker/5:11 Tainted: G        W          6.9.0-rc2-custom-00784-gc6a05c468a0b #14
Hardware name: Mellanox Technologies Ltd. MSN3700/VMOD0005, BIOS 5.11 01/06/2019
Workqueue: mlxsw_core mlxsw_sp_acl_tcam_vregion_rehash_work
RIP: 0010:parman_destroy+0x17/0x20
[...]
Call Trace:
 <TASK>
 mlxsw_sp_acl_atcam_region_fini+0x19/0x60
 mlxsw_sp_acl_tcam_region_destroy+0x49/0xf0
 mlxsw_sp_acl_tcam_vregion_rehash_work+0x1f1/0x470
 process_one_work+0x151/0x370
 worker_thread+0x2cb/0x3e0
 kthread+0xd0/0x100
 ret_from_fork+0x34/0x50
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Fixes: 843500518509 ("mlxsw: spectrum_acl: Do rollback as another call to mlxsw_sp_acl_tcam_vchunk_migrate_all()")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Alexander Zubkov <green@qrator.net>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/d5edd4f4503934186ae5cfe268503b16345b4e0f.1713797103.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 5175ed6cdae08..abfa4b44f468d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -1271,6 +1271,8 @@ mlxsw_sp_acl_tcam_vchunk_migrate_start(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_acl_tcam_chunk *new_chunk;
 
+	WARN_ON(vchunk->chunk2);
+
 	new_chunk = mlxsw_sp_acl_tcam_chunk_create(mlxsw_sp, vchunk, region);
 	if (IS_ERR(new_chunk))
 		return PTR_ERR(new_chunk);
@@ -1405,6 +1407,8 @@ mlxsw_sp_acl_tcam_vregion_migrate(struct mlxsw_sp *mlxsw_sp,
 	err = mlxsw_sp_acl_tcam_vchunk_migrate_all(mlxsw_sp, vregion,
 						   ctx, credits);
 	if (err) {
+		if (ctx->this_is_rollback)
+			return err;
 		/* In case migration was not successful, we need to swap
 		 * so the original region pointer is assigned again
 		 * to vregion->region.
-- 
2.43.0



