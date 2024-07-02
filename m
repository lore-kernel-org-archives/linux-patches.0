Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853891BD51A;
	Tue,  2 Jul 2024 17:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940043; cv=none; b=gQgZuG+pQQybIPJ379Ct+D0TMfq2EhvJKtfBHzzuiT3w04Tze1eHctK7m+Bso9XpbDXWABiTFxxOWnSM0AK6MVAEL2DUWILPePmawLQceREX4y+k5GY4oD5ONNGpcf4557Krz9iSXUWTAfnedxn1B66ZbC+jQUR7Jlucuhv0wVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940043; c=relaxed/simple;
	bh=fzvXHKH4Lb40xnY/QsYFQ/5TNt8EvcXpZPPkXyJCsi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iw9En0ZdiktcvmOh+rhQgmQs5EnH+uy3jX1T3RfvZcy+lE1pWmF49T3agKYLk8ToOhoux/kCK4HcsSQXrfMtXpJs+8Lfb8f95vyWTUmaEGzxfddAn//SdRVvNRA7wK1kct1+0f/E7ROLvIYIQVwmf1b2nFRAtw4RRPZ9TGjcRgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkEUu8jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkEUu8jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDD6C4AF0C;
	Tue,  2 Jul 2024 17:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940043;
	bh=fzvXHKH4Lb40xnY/QsYFQ/5TNt8EvcXpZPPkXyJCsi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkEUu8jT9EX9AYdNqvDlXn0TZ6Yz7CtQ7TCvyVo/NXDrNjpgtMiZCgGZcvooFVDOy
	 nhBeI+QrbLdldkcXpPqfNLSSfL8DQDjCZ3yi7vhlmxBV8FxDlflkaSFb6zBqCXhxvG
	 pbCZlnkysdhJtniABmpb8xNeNeQ9mY+xNU+TYpUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 035/222] mlxsw: spectrum_buffers: Fix memory corruptions on Spectrum-4 systems
Date: Tue,  2 Jul 2024 19:01:13 +0200
Message-ID: <20240702170245.318845803@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit c28947de2bed40217cf256c5d0d16880054fcf13 ]

The following two shared buffer operations make use of the Shared Buffer
Status Register (SBSR):

 # devlink sb occupancy snapshot pci/0000:01:00.0
 # devlink sb occupancy clearmax pci/0000:01:00.0

The register has two masks of 256 bits to denote on which ingress /
egress ports the register should operate on. Spectrum-4 has more than
256 ports, so the register was extended by cited commit with a new
'port_page' field.

However, when filling the register's payload, the driver specifies the
ports as absolute numbers and not relative to the first port of the port
page, resulting in memory corruptions [1].

Fix by specifying the ports relative to the first port of the port page.

[1]
BUG: KASAN: slab-use-after-free in mlxsw_sp_sb_occ_snapshot+0xb6d/0xbc0
Read of size 1 at addr ffff8881068cb00f by task devlink/1566
[...]
Call Trace:
 <TASK>
 dump_stack_lvl+0xc6/0x120
 print_report+0xce/0x670
 kasan_report+0xd7/0x110
 mlxsw_sp_sb_occ_snapshot+0xb6d/0xbc0
 mlxsw_devlink_sb_occ_snapshot+0x75/0xb0
 devlink_nl_sb_occ_snapshot_doit+0x1f9/0x2a0
 genl_family_rcv_msg_doit+0x20c/0x300
 genl_rcv_msg+0x567/0x800
 netlink_rcv_skb+0x170/0x450
 genl_rcv+0x2d/0x40
 netlink_unicast+0x547/0x830
 netlink_sendmsg+0x8d4/0xdb0
 __sys_sendto+0x49b/0x510
 __x64_sys_sendto+0xe5/0x1c0
 do_syscall_64+0xc1/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
[...]
Allocated by task 1:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0x8f/0xa0
 copy_verifier_state+0xbc2/0xfb0
 do_check_common+0x2c51/0xc7e0
 bpf_check+0x5107/0x9960
 bpf_prog_load+0xf0e/0x2690
 __sys_bpf+0x1a61/0x49d0
 __x64_sys_bpf+0x7d/0xc0
 do_syscall_64+0xc1/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 1:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 poison_slab_object+0x109/0x170
 __kasan_slab_free+0x14/0x30
 kfree+0xca/0x2b0
 free_verifier_state+0xce/0x270
 do_check_common+0x4828/0xc7e0
 bpf_check+0x5107/0x9960
 bpf_prog_load+0xf0e/0x2690
 __sys_bpf+0x1a61/0x49d0
 __x64_sys_bpf+0x7d/0xc0
 do_syscall_64+0xc1/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: f8538aec88b4 ("mlxsw: Add support for more than 256 ports in SBSR register")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlxsw/spectrum_buffers.c         | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index c9f1c79f3f9d0..ba090262e27ef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -1607,8 +1607,8 @@ static void mlxsw_sp_sb_sr_occ_query_cb(struct mlxsw_core *mlxsw_core,
 int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 			     unsigned int sb_index)
 {
+	u16 local_port, local_port_1, first_local_port, last_local_port;
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-	u16 local_port, local_port_1, last_local_port;
 	struct mlxsw_sp_sb_sr_occ_query_cb_ctx cb_ctx;
 	u8 masked_count, current_page = 0;
 	unsigned long cb_priv = 0;
@@ -1628,6 +1628,7 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 	masked_count = 0;
 	mlxsw_reg_sbsr_pack(sbsr_pl, false);
 	mlxsw_reg_sbsr_port_page_set(sbsr_pl, current_page);
+	first_local_port = current_page * MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE;
 	last_local_port = current_page * MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE +
 			  MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE - 1;
 
@@ -1645,9 +1646,12 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 		if (local_port != MLXSW_PORT_CPU_PORT) {
 			/* Ingress quotas are not supported for the CPU port */
 			mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl,
-							     local_port, 1);
+							     local_port - first_local_port,
+							     1);
 		}
-		mlxsw_reg_sbsr_egress_port_mask_set(sbsr_pl, local_port, 1);
+		mlxsw_reg_sbsr_egress_port_mask_set(sbsr_pl,
+						    local_port - first_local_port,
+						    1);
 		for (i = 0; i < mlxsw_sp->sb_vals->pool_count; i++) {
 			err = mlxsw_sp_sb_pm_occ_query(mlxsw_sp, local_port, i,
 						       &bulk_list);
@@ -1684,7 +1688,7 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 			      unsigned int sb_index)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-	u16 local_port, last_local_port;
+	u16 local_port, first_local_port, last_local_port;
 	LIST_HEAD(bulk_list);
 	unsigned int masked_count;
 	u8 current_page = 0;
@@ -1702,6 +1706,7 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 	masked_count = 0;
 	mlxsw_reg_sbsr_pack(sbsr_pl, true);
 	mlxsw_reg_sbsr_port_page_set(sbsr_pl, current_page);
+	first_local_port = current_page * MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE;
 	last_local_port = current_page * MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE +
 			  MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE - 1;
 
@@ -1719,9 +1724,12 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 		if (local_port != MLXSW_PORT_CPU_PORT) {
 			/* Ingress quotas are not supported for the CPU port */
 			mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl,
-							     local_port, 1);
+							     local_port - first_local_port,
+							     1);
 		}
-		mlxsw_reg_sbsr_egress_port_mask_set(sbsr_pl, local_port, 1);
+		mlxsw_reg_sbsr_egress_port_mask_set(sbsr_pl,
+						    local_port - first_local_port,
+						    1);
 		for (i = 0; i < mlxsw_sp->sb_vals->pool_count; i++) {
 			err = mlxsw_sp_sb_pm_occ_clear(mlxsw_sp, local_port, i,
 						       &bulk_list);
-- 
2.43.0



