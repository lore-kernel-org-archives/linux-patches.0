Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF832ECEAA;
	Tue, 17 Jun 2025 16:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178207; cv=none; b=bzZeVG/G5/ghn1Os79/MAF0rMyfrYgygmvqNplXPjcdQNzXk1xZjEb65GFvcVb0bvxXF0FmjbKy6fO2+tUb9Dl+L9/phj8EM5s+TZunTQonMt2FtXehJm2I5gQJf6/yBWSrSyB+NJuN/GZigOH70KpwKlmG1QZ+oqwYEQ0Yojtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178207; c=relaxed/simple;
	bh=AgrlHYfMaz7AfsgNN5sySumFfiHJ2S83C+JedbmcRoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsrU1E0QU5jTDNu7OHdEc1Vy2nbNbeuLgP9UY8U6u+FhCuxlOglO8EbwACH7JukQkzlE+mH8am0yzOnypSiuj7/Ki7C7VN3saPxTlkIx1cLdCvq33uFKYT5dFw5YKl+L8k6h6UxRJdeeZUiNqZiSy5kEv3oMPB57l2wiSIEemtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsHNwT7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsHNwT7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3386CC4CEE3;
	Tue, 17 Jun 2025 16:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178207;
	bh=AgrlHYfMaz7AfsgNN5sySumFfiHJ2S83C+JedbmcRoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsHNwT7s++Ivf8CMP5dRA5cwMoUXDGI1uqvI1Od+sfRm3o+dLXK7IoCGqBUKizZqg
	 wD5htmzyrqoRrSw0mGan/qiSycWrCzLa9N3EcZ04YAAlYtMmCYMqhjCtSq4zAtuXDt
	 PPeesREF7o00On77Um6pXwrbrtwa6StDRcxXbb/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Amir Tzin <amirtz@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 461/512] net/mlx5: Fix ECVF vports unload on shutdown flow
Date: Tue, 17 Jun 2025 17:27:07 +0200
Message-ID: <20250617152438.248023402@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Amir Tzin <amirtz@nvidia.com>

[ Upstream commit 687560d8a9a2d654829ad0da1ec24242f1de711d ]

Fix shutdown flow UAF when a virtual function is created on the embedded
chip (ECVF) of a BlueField device. In such case the vport acl ingress
table is not properly destroyed.

ECVF functionality is independent of ecpf_vport_exists capability and
thus functions mlx5_eswitch_(enable|disable)_pf_vf_vports() should not
test it when enabling/disabling ECVF vports.

kernel log:
[] refcount_t: underflow; use-after-free.
[] WARNING: CPU: 3 PID: 1 at lib/refcount.c:28
   refcount_warn_saturate+0x124/0x220
----------------
[] Call trace:
[] refcount_warn_saturate+0x124/0x220
[] tree_put_node+0x164/0x1e0 [mlx5_core]
[] mlx5_destroy_flow_table+0x98/0x2c0 [mlx5_core]
[] esw_acl_ingress_table_destroy+0x28/0x40 [mlx5_core]
[] esw_acl_ingress_lgcy_cleanup+0x80/0xf4 [mlx5_core]
[] esw_legacy_vport_acl_cleanup+0x44/0x60 [mlx5_core]
[] esw_vport_cleanup+0x64/0x90 [mlx5_core]
[] mlx5_esw_vport_disable+0xc0/0x1d0 [mlx5_core]
[] mlx5_eswitch_unload_ec_vf_vports+0xcc/0x150 [mlx5_core]
[] mlx5_eswitch_disable_sriov+0x198/0x2a0 [mlx5_core]
[] mlx5_device_disable_sriov+0xb8/0x1e0 [mlx5_core]
[] mlx5_sriov_detach+0x40/0x50 [mlx5_core]
[] mlx5_unload+0x40/0xc4 [mlx5_core]
[] mlx5_unload_one_devl_locked+0x6c/0xe4 [mlx5_core]
[] mlx5_unload_one+0x3c/0x60 [mlx5_core]
[] shutdown+0x7c/0xa4 [mlx5_core]
[] pci_device_shutdown+0x3c/0xa0
[] device_shutdown+0x170/0x340
[] __do_sys_reboot+0x1f4/0x2a0
[] __arm64_sys_reboot+0x2c/0x40
[] invoke_syscall+0x78/0x100
[] el0_svc_common.constprop.0+0x54/0x184
[] do_el0_svc+0x30/0xac
[] el0_svc+0x48/0x160
[] el0t_64_sync_handler+0xa4/0x12c
[] el0t_64_sync+0x1a4/0x1a8
[] --[ end trace 9c4601d68c70030e ]---

Fixes: a7719b29a821 ("net/mlx5: Add management of EC VF vports")
Reviewed-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250610151514.1094735-3-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 7aef30dbd82d6..6544546a1153f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1295,12 +1295,15 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 		ret = mlx5_eswitch_load_pf_vf_vport(esw, MLX5_VPORT_ECPF, enabled_events);
 		if (ret)
 			goto ecpf_err;
-		if (mlx5_core_ec_sriov_enabled(esw->dev)) {
-			ret = mlx5_eswitch_load_ec_vf_vports(esw, esw->esw_funcs.num_ec_vfs,
-							     enabled_events);
-			if (ret)
-				goto ec_vf_err;
-		}
+	}
+
+	/* Enable ECVF vports */
+	if (mlx5_core_ec_sriov_enabled(esw->dev)) {
+		ret = mlx5_eswitch_load_ec_vf_vports(esw,
+						     esw->esw_funcs.num_ec_vfs,
+						     enabled_events);
+		if (ret)
+			goto ec_vf_err;
 	}
 
 	/* Enable VF vports */
@@ -1331,9 +1334,11 @@ void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw)
 {
 	mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
 
+	if (mlx5_core_ec_sriov_enabled(esw->dev))
+		mlx5_eswitch_unload_ec_vf_vports(esw,
+						 esw->esw_funcs.num_ec_vfs);
+
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
-		if (mlx5_core_ec_sriov_enabled(esw->dev))
-			mlx5_eswitch_unload_ec_vf_vports(esw, esw->esw_funcs.num_vfs);
 		mlx5_eswitch_unload_pf_vf_vport(esw, MLX5_VPORT_ECPF);
 	}
 
-- 
2.39.5



