Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7468801;
	Tue, 30 Apr 2024 11:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475973; cv=none; b=gAVhbAsaAdL86kMhYjusup0zhtW5l9Ac0IvSWtf35nq84GCchOMGWZJYXTAxIgIjx2hEz3oa/FWxfBA9kLBTTurU0nWicfstVt2kSiNdEQoJJ8FTycxtqoWKh1TPP3F5zHOHapyaCg1d2vRTvXwr3BKGJY1fYCdWKkjTZUfz+sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475973; c=relaxed/simple;
	bh=2BpX3oZ2ZU9Ki34jjnt6xK51XSlGWcfGnpP2pec22nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrR3NEzx+SBI4g0ruJ3TWt3bzuKPjKXx/4xY6pdDD0/DzOy467aCbd23oRO/vMxb8juwz0Mhn0bsEdDTtEkkXwN58fqVIcgQxJYUmYiQHQ1J3/aSnGX+VckASFBb1f65nr5ZPbTJh/t4Heb1f9JyOi13rvU3OwAfq2ibmyvL9v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kttyAIzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kttyAIzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29BBC2BBFC;
	Tue, 30 Apr 2024 11:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475973;
	bh=2BpX3oZ2ZU9Ki34jjnt6xK51XSlGWcfGnpP2pec22nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kttyAIztQrGB4kZY0wWAT7ZOYlDU5lavhyY4g2AKka1ZFW2ZZfPbR5M3NK07DBsu3
	 D9Oa2iSMfYwdDsy/RTtp8rqAjtUSUlhrgpE3M3AejA7TiNCH4TRLoHQw1d7C9XpPaW
	 Ks70+HF8NmrHwHuRICjbNM3FK0FuiwDgCt9Tgr94=
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
Subject: [PATCH 5.15 36/80] mlxsw: spectrum_acl_tcam: Fix incorrect list API usage
Date: Tue, 30 Apr 2024 12:40:08 +0200
Message-ID: <20240430103044.483372728@linuxfoundation.org>
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

[ Upstream commit b377add0f0117409c418ddd6504bd682ebe0bf79 ]

Both the function that migrates all the chunks within a region and the
function that migrates all the entries within a chunk call
list_first_entry() on the respective lists without checking that the
lists are not empty. This is incorrect usage of the API, which leads to
the following warning [1].

Fix by returning if the lists are empty as there is nothing to migrate
in this case.

[1]
WARNING: CPU: 0 PID: 6437 at drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c:1266 mlxsw_sp_acl_tcam_vchunk_migrate_all+0x1f1/0>
Modules linked in:
CPU: 0 PID: 6437 Comm: kworker/0:37 Not tainted 6.9.0-rc3-custom-00883-g94a65f079ef6 #39
Hardware name: Mellanox Technologies Ltd. MSN3700/VMOD0005, BIOS 5.11 01/06/2019
Workqueue: mlxsw_core mlxsw_sp_acl_tcam_vregion_rehash_work
RIP: 0010:mlxsw_sp_acl_tcam_vchunk_migrate_all+0x1f1/0x2c0
[...]
Call Trace:
 <TASK>
 mlxsw_sp_acl_tcam_vregion_rehash_work+0x6c/0x4a0
 process_one_work+0x151/0x370
 worker_thread+0x2cb/0x3e0
 kthread+0xd0/0x100
 ret_from_fork+0x34/0x50
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Fixes: 6f9579d4e302 ("mlxsw: spectrum_acl: Remember where to continue rehash migration")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Alexander Zubkov <green@qrator.net>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/4628e9a22d1d84818e28310abbbc498e7bc31bc9.1713797103.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 8c1e97d463eb7..e0e7f630801a9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -1284,6 +1284,9 @@ mlxsw_sp_acl_tcam_vchunk_migrate_one(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	}
 
+	if (list_empty(&vchunk->ventry_list))
+		goto out;
+
 	/* If the migration got interrupted, we have the ventry to start from
 	 * stored in context.
 	 */
@@ -1335,6 +1338,7 @@ mlxsw_sp_acl_tcam_vchunk_migrate_one(struct mlxsw_sp *mlxsw_sp,
 		}
 	}
 
+out:
 	mlxsw_sp_acl_tcam_vchunk_migrate_end(mlxsw_sp, vchunk, ctx);
 	return 0;
 }
@@ -1348,6 +1352,9 @@ mlxsw_sp_acl_tcam_vchunk_migrate_all(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_acl_tcam_vchunk *vchunk;
 	int err;
 
+	if (list_empty(&vregion->vchunk_list))
+		return 0;
+
 	/* If the migration got interrupted, we have the vchunk
 	 * we are working on stored in context.
 	 */
-- 
2.43.0



