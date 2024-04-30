Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505AF211C;
	Tue, 30 Apr 2024 11:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475523; cv=none; b=nGoeESgUd0qPU1O4fcxfezT3dpyo+cmSXyg0XVzQcpqA6e/iJVHxexs4RB3gQRtRmmKmeVzrdzbM3SX87lRIa9LQvzNyoOy3/UeTR1Sf7kThxGQxOF7zgEgdQFwDvns6ToEnN5VpYQ6+j6YFSjg3SsdP3SJQglJvpRZhghUlBas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475523; c=relaxed/simple;
	bh=NNrkVGR8/11VNJJ7GMiYzsY0uqLtxcn7ymI1qenZVdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHGXOTCdMcVd5Yr0lz7J1iQQ48n47KjzZ+OWVFsj6hB4c6+vipx96PruZr1AL4MpWiBJ5H2EZvpa+oNUz3mIwGlG/V+HlB9jNBZ0VOLnI3wm7YzlsN7XCdXW2VI4lLI9fQNzfnWM/GHR4JA+VtLjJgr6beR+BTA2a6OXyZ7MeDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nu0XJ9sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nu0XJ9sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677CEC2BBFC;
	Tue, 30 Apr 2024 11:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475522;
	bh=NNrkVGR8/11VNJJ7GMiYzsY0uqLtxcn7ymI1qenZVdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nu0XJ9sfKGgfIPr+NZurFSbYuDO8+dur1u2FcJDiUFfLmZldgthRQ5tFdrqLCaaSB
	 2QZRNVQTyWlmtx4SUqehpdn6ZLAW0JuwsmXoVhPiXronavJZ2kqFBK4/ITYmV/4p6X
	 7Vod3sNvw1Vc4Egd6uPFguZM4eNSdPYsi1uQIRhs=
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
Subject: [PATCH 6.6 083/186] mlxsw: spectrum_acl_tcam: Fix memory leak when canceling rehash work
Date: Tue, 30 Apr 2024 12:38:55 +0200
Message-ID: <20240430103100.444802538@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit fb4e2b70a7194b209fc7320bbf33b375f7114bd5 ]

The rehash delayed work is rescheduled with a delay if the number of
credits at end of the work is not negative as supposedly it means that
the migration ended. Otherwise, it is rescheduled immediately.

After "mlxsw: spectrum_acl_tcam: Fix possible use-after-free during
rehash" the above is no longer accurate as a non-negative number of
credits is no longer indicative of the migration being done. It can also
happen if the work encountered an error in which case the migration will
resume the next time the work is scheduled.

The significance of the above is that it is possible for the work to be
pending and associated with hints that were allocated when the migration
started. This leads to the hints being leaked [1] when the work is
canceled while pending as part of ACL region dismantle.

Fix by freeing the hints if hints are associated with a work that was
canceled while pending.

Blame the original commit since the reliance on not having a pending
work associated with hints is fragile.

[1]
unreferenced object 0xffff88810e7c3000 (size 256):
  comm "kworker/0:16", pid 176, jiffies 4295460353
  hex dump (first 32 bytes):
    00 30 95 11 81 88 ff ff 61 00 00 00 00 00 00 80  .0......a.......
    00 00 61 00 40 00 00 00 00 00 00 00 04 00 00 00  ..a.@...........
  backtrace (crc 2544ddb9):
    [<00000000cf8cfab3>] kmalloc_trace+0x23f/0x2a0
    [<000000004d9a1ad9>] objagg_hints_get+0x42/0x390
    [<000000000b143cf3>] mlxsw_sp_acl_erp_rehash_hints_get+0xca/0x400
    [<0000000059bdb60a>] mlxsw_sp_acl_tcam_vregion_rehash_work+0x868/0x1160
    [<00000000e81fd734>] process_one_work+0x59c/0xf20
    [<00000000ceee9e81>] worker_thread+0x799/0x12c0
    [<00000000bda6fe39>] kthread+0x246/0x300
    [<0000000070056d23>] ret_from_fork+0x34/0x70
    [<00000000dea2b93e>] ret_from_fork_asm+0x1a/0x30

Fixes: c9c9af91f1d9 ("mlxsw: spectrum_acl: Allow to interrupt/continue rehash work")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Alexander Zubkov <green@qrator.net>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/0cc12ebb07c4d4c41a1265ee2c28b392ff997a86.1713797103.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 89a5ebc3463ff..92a406f02eae7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -836,10 +836,14 @@ mlxsw_sp_acl_tcam_vregion_destroy(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_acl_tcam *tcam = vregion->tcam;
 
 	if (vgroup->vregion_rehash_enabled && ops->region_rehash_hints_get) {
+		struct mlxsw_sp_acl_tcam_rehash_ctx *ctx = &vregion->rehash.ctx;
+
 		mutex_lock(&tcam->lock);
 		list_del(&vregion->tlist);
 		mutex_unlock(&tcam->lock);
-		cancel_delayed_work_sync(&vregion->rehash.dw);
+		if (cancel_delayed_work_sync(&vregion->rehash.dw) &&
+		    ctx->hints_priv)
+			ops->region_rehash_hints_put(ctx->hints_priv);
 	}
 	mlxsw_sp_acl_tcam_vgroup_vregion_detach(mlxsw_sp, vregion);
 	if (vregion->region2)
-- 
2.43.0



