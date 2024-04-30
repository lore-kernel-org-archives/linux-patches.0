Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65118801;
	Tue, 30 Apr 2024 11:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475950; cv=none; b=nQMHRoFF764Pi1ahjgjfyncZKSNRJkwRUxHjEHxGyQ503NuQKWTilyjT/2nrAwJPSuxCNFl//jc+T00RNpButoVHo2Vl7qZ+yt2DNS8OWb56WJr8g82JIyLv+DqKWxcfD7e1f3rpWcO3K9D5aD/ay+2ZTZXiVFWj+qeztnutgBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475950; c=relaxed/simple;
	bh=lxXAPNBcm+IpNnsOfck79ax2Q2VeOtpx8GHbIZ+8Pt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2RM/W+zx4R2ex7r2+/gd1lcjEjkkXc1iUMnV3kHschhInnwmHtjW3ZO+lKcT/ZAj70r92celvGAJUUAs28k1QHMLszvE7MWlJzdk8HLrFp9FAf3XgOcyi7z+vhJ2ktJe7UGC5GkHUl9rRprq/BbFZp8OhRRHZDiciU7XECdY3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GD5UdTay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GD5UdTay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25883C2BBFC;
	Tue, 30 Apr 2024 11:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475950;
	bh=lxXAPNBcm+IpNnsOfck79ax2Q2VeOtpx8GHbIZ+8Pt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GD5UdTayczMJkEvWatk270hlA90UYe2B7yBcpjWN4xR0SzS4ey7CY+l4P3MVWZsn0
	 OSA/rrU7gBWiQLEUDJrCYb/oHfjnHIyEsLCU3wiX+G4ZWRjPcgSjE1ML/bqZO3R4hj
	 /gr+HiC8DGi+WsaIyXgkpcZyxub4TKY4Em79GhgQ=
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
Subject: [PATCH 5.15 31/80] mlxsw: spectrum_acl_tcam: Fix possible use-after-free during activity update
Date: Tue, 30 Apr 2024 12:40:03 +0200
Message-ID: <20240430103044.335561990@linuxfoundation.org>
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

[ Upstream commit 79b5b4b18bc85b19d3a518483f9abbbe6d7b3ba4 ]

The rule activity update delayed work periodically traverses the list of
configured rules and queries their activity from the device.

As part of this task it accesses the entry pointed by 'ventry->entry',
but this entry can be changed concurrently by the rehash delayed work,
leading to a use-after-free [1].

Fix by closing the race and perform the activity query under the
'vregion->lock' mutex.

[1]
BUG: KASAN: slab-use-after-free in mlxsw_sp_acl_tcam_flower_rule_activity_get+0x121/0x140
Read of size 8 at addr ffff8881054ed808 by task kworker/0:18/181

CPU: 0 PID: 181 Comm: kworker/0:18 Not tainted 6.9.0-rc2-custom-00781-gd5ab772d32f7 #2
Hardware name: Mellanox Technologies Ltd. MSN3700/VMOD0005, BIOS 5.11 01/06/2019
Workqueue: mlxsw_core mlxsw_sp_acl_rule_activity_update_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xc6/0x120
 print_report+0xce/0x670
 kasan_report+0xd7/0x110
 mlxsw_sp_acl_tcam_flower_rule_activity_get+0x121/0x140
 mlxsw_sp_acl_rule_activity_update_work+0x219/0x400
 process_one_work+0x8eb/0x19b0
 worker_thread+0x6c9/0xf70
 kthread+0x2c9/0x3b0
 ret_from_fork+0x4d/0x80
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 1039:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0x8f/0xa0
 __kmalloc+0x19c/0x360
 mlxsw_sp_acl_tcam_entry_create+0x7b/0x1f0
 mlxsw_sp_acl_tcam_vchunk_migrate_all+0x30d/0xb50
 mlxsw_sp_acl_tcam_vregion_rehash_work+0x157/0x1300
 process_one_work+0x8eb/0x19b0
 worker_thread+0x6c9/0xf70
 kthread+0x2c9/0x3b0
 ret_from_fork+0x4d/0x80
 ret_from_fork_asm+0x1a/0x30

Freed by task 1039:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 poison_slab_object+0x102/0x170
 __kasan_slab_free+0x14/0x30
 kfree+0xc1/0x290
 mlxsw_sp_acl_tcam_vchunk_migrate_all+0x3d7/0xb50
 mlxsw_sp_acl_tcam_vregion_rehash_work+0x157/0x1300
 process_one_work+0x8eb/0x19b0
 worker_thread+0x6c9/0xf70
 kthread+0x2c9/0x3b0
 ret_from_fork+0x4d/0x80
 ret_from_fork_asm+0x1a/0x30

Fixes: 2bffc5322fd8 ("mlxsw: spectrum_acl: Don't take mutex in mlxsw_sp_acl_tcam_vregion_rehash_work()")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Alexander Zubkov <green@qrator.net>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/1fcce0a60b231ebeb2515d91022284ba7b4ffe7a.1713797103.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c    | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 1dce4e9958c90..f663cb0fd19a3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -1189,8 +1189,14 @@ mlxsw_sp_acl_tcam_ventry_activity_get(struct mlxsw_sp *mlxsw_sp,
 				      struct mlxsw_sp_acl_tcam_ventry *ventry,
 				      bool *activity)
 {
-	return mlxsw_sp_acl_tcam_entry_activity_get(mlxsw_sp,
-						    ventry->entry, activity);
+	struct mlxsw_sp_acl_tcam_vregion *vregion = ventry->vchunk->vregion;
+	int err;
+
+	mutex_lock(&vregion->lock);
+	err = mlxsw_sp_acl_tcam_entry_activity_get(mlxsw_sp, ventry->entry,
+						   activity);
+	mutex_unlock(&vregion->lock);
+	return err;
 }
 
 static int
-- 
2.43.0



