Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4633E8801;
	Tue, 30 Apr 2024 11:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476232; cv=none; b=KOVOdYklu9FD+IzGa48QRDlB8ZFaSpXMoZCkDUmvfjDyyzc27gvxbh5/dgy/vImRqIvXe9qgEZcSejVzpAzl9XQniA2WrhtAwpMpQ24iMy4Loezj93C9ztX0mmBsyN8rfDK84Ze0fpVErmCiHpcMhI+JO91HouzgscztaStzYAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476232; c=relaxed/simple;
	bh=et/evpRVxLl3KeVrgIEWZTsxizSPvD1LzqxTZwXJC0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhm6BebmPbubvtBMVhdIypHHgDtPRJT0Oyq9ZTYYMrw0AA2HN87lzE9X4Io3Zgi1pzqx/vJeNfovdBWtEFA6Fo9L3jFFKEI+DDHK1m+RXWgiZ48FzpF3sh5POnjGLTs5AzSpQtCyE1KrCRi7GKIWkI+fxNvWnDxNTwPGog/Kep4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XevwZyQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XevwZyQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95F3C4AF1A;
	Tue, 30 Apr 2024 11:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476232;
	bh=et/evpRVxLl3KeVrgIEWZTsxizSPvD1LzqxTZwXJC0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XevwZyQl8bd/owcj8wIC6pW7NP2hWWtsMHeLsERAHfwdWd4mNpLB3ChJySiBhR7WG
	 qSOZqTvPJEU0d2w2Br4gK5doH3mz0iDNlWPHAlITVjw9BQbKGOOOh19ZGWIUDNcCSo
	 MXndxohhmienJx14ZxF7OtsDBu6H27bk08wgsD5M=
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
Subject: [PATCH 5.4 074/107] mlxsw: spectrum_acl_tcam: Fix incorrect list API usage
Date: Tue, 30 Apr 2024 12:40:34 +0200
Message-ID: <20240430103046.839839701@linuxfoundation.org>
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
index 26042c859cf68..89ce9b1233bd9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -1325,6 +1325,9 @@ mlxsw_sp_acl_tcam_vchunk_migrate_one(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	}
 
+	if (list_empty(&vchunk->ventry_list))
+		goto out;
+
 	/* If the migration got interrupted, we have the ventry to start from
 	 * stored in context.
 	 */
@@ -1376,6 +1379,7 @@ mlxsw_sp_acl_tcam_vchunk_migrate_one(struct mlxsw_sp *mlxsw_sp,
 		}
 	}
 
+out:
 	mlxsw_sp_acl_tcam_vchunk_migrate_end(mlxsw_sp, vchunk, ctx);
 	return 0;
 }
@@ -1389,6 +1393,9 @@ mlxsw_sp_acl_tcam_vchunk_migrate_all(struct mlxsw_sp *mlxsw_sp,
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



