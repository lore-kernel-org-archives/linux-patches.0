Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492B053E16;
	Tue, 23 Jan 2024 00:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970358; cv=none; b=oSSwORXIXCebdiAChLUa6Asppy1StXDKecn8UIJYRjYtllH5B2oYG2ceM7EWOv/YAvieIecWrwPsu0XnTFRDT98ZFfWQpEFT2xW1glnOP8kShqIbsEt9B7Eh1Y5FADz40YpAk0qc2KXo00ViCeg6aVD/QW+Chg82xe2vckMPVSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970358; c=relaxed/simple;
	bh=XY2K4NPXoPZUh8LPI8rlzrVIJb5lLviO+6GbJpdmMuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9LliPhEUGlZneduxa7dwzpegmNaQs2zXS0OWF7zKGC2xzao6oGi6B6u3jjsWoOn9EfzXiYaCXkGA50dcaIkTk2Yj34EXPdGfjSmAhVtPJLKa85ETpdywRgFmJw9Sp5NBx3ajZNyLKtzksCY0rd/GA/dU5Yup4Fw14l3JTmJ9g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xz+LM/4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xz+LM/4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB540C433F1;
	Tue, 23 Jan 2024 00:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970358;
	bh=XY2K4NPXoPZUh8LPI8rlzrVIJb5lLviO+6GbJpdmMuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xz+LM/4hrfC3RohHyyLL8sGK0d94izqTFnezND5S7ZvIIwvON/0L/2Fb70HStHCij
	 yFqf1bWXgwQZ6I1h6FMMF/LvJ3hiwkLiL1C3XkCclhi6D42dxqLLf6KSuc+WEOzzJE
	 nP4puPTKaJMt/zpBoka1kOa7BGG56aDLazdQWBAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 635/641] mlxsw: spectrum_acl_tcam: Fix NULL pointer dereference in error path
Date: Mon, 22 Jan 2024 15:58:59 -0800
Message-ID: <20240122235838.140684257@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit efeb7dfea8ee10cdec11b6b6ba4e405edbe75809 ]

When calling mlxsw_sp_acl_tcam_region_destroy() from an error path after
failing to attach the region to an ACL group, we hit a NULL pointer
dereference upon 'region->group->tcam' [1].

Fix by retrieving the 'tcam' pointer using mlxsw_sp_acl_to_tcam().

[1]
BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
RIP: 0010:mlxsw_sp_acl_tcam_region_destroy+0xa0/0xd0
[...]
Call Trace:
 mlxsw_sp_acl_tcam_vchunk_get+0x88b/0xa20
 mlxsw_sp_acl_tcam_ventry_add+0x25/0xe0
 mlxsw_sp_acl_rule_add+0x47/0x240
 mlxsw_sp_flower_replace+0x1a9/0x1d0
 tc_setup_cb_add+0xdc/0x1c0
 fl_hw_replace_filter+0x146/0x1f0
 fl_change+0xc17/0x1360
 tc_new_tfilter+0x472/0xb90
 rtnetlink_rcv_msg+0x313/0x3b0
 netlink_rcv_skb+0x58/0x100
 netlink_unicast+0x244/0x390
 netlink_sendmsg+0x1e4/0x440
 ____sys_sendmsg+0x164/0x260
 ___sys_sendmsg+0x9a/0xe0
 __sys_sendmsg+0x7a/0xc0
 do_syscall_64+0x40/0xe0
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Fixes: 22a677661f56 ("mlxsw: spectrum: Introduce ACL core with simple TCAM implementation")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/fb6a4542bbc9fcab5a523802d97059bffbca7126.1705502064.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index d50786b0a6ce..7d1e91196e94 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -681,13 +681,13 @@ static void
 mlxsw_sp_acl_tcam_region_destroy(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_tcam_region *region)
 {
+	struct mlxsw_sp_acl_tcam *tcam = mlxsw_sp_acl_to_tcam(mlxsw_sp->acl);
 	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
 
 	ops->region_fini(mlxsw_sp, region->priv);
 	mlxsw_sp_acl_tcam_region_disable(mlxsw_sp, region);
 	mlxsw_sp_acl_tcam_region_free(mlxsw_sp, region);
-	mlxsw_sp_acl_tcam_region_id_put(region->group->tcam,
-					region->id);
+	mlxsw_sp_acl_tcam_region_id_put(tcam, region->id);
 	kfree(region);
 }
 
-- 
2.43.0



