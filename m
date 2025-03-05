Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78DD17B505;
	Wed,  5 Mar 2025 18:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197945; cv=none; b=pwVHO3KUohjVV5i1uIpoeROHQtvnh6fiEDVzk7gdjDZeiDw6V4DYlgwIP/KRg+cSVG/D/i6tKRlOypUVXHaOxuO8nsndBA2O9CNo6AAzQsVZVxXHztEAR2OTAMCWD3iRIwpP/XzGxeeiBCGw18snImZsjDOnV83ypwKUNwS/Mt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197945; c=relaxed/simple;
	bh=Zfh2BXeQiZcgfqF1f/t7pwOAhkT7yIycc4QBqDsGiNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kReHX50ldExjKICJoaAJG6ch0OW5PZEYn46jSJBA1zGBV0C/t8pnvGMpUjbNCd3zq4kgebm7AByXZcNSg9rgaBnLugRKCYIX0xmUImGbmH9D1lFRgqQOC2DfNDoX6rDRYubx7AkBy3kokk6MwwuIdUrZeTpbj8FV9l+iP7iKz8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfch5CUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfch5CUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C31FC4CEEB;
	Wed,  5 Mar 2025 18:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197945;
	bh=Zfh2BXeQiZcgfqF1f/t7pwOAhkT7yIycc4QBqDsGiNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfch5CUWiME/ryGGEUARsFAIW7WtzABzMF4sE0gYl4Tt/1SpSEs5yYndViKzgdaSu
	 yoUsUxB6QFqBM2zG4dgMUG6RxBO2PW/gg6wbHE1zwO0tfD6IJ0o5PD1AUpytDpNq4A
	 WtVbnT5Q54+xaneQzVDXVh5ueurBeEcQaXSovyvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/150] RDMA/mlx5: Fix a WARN during dereg_mr for DM type
Date: Wed,  5 Mar 2025 18:47:13 +0100
Message-ID: <20250305174503.982486685@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit abc7b3f1f056d69a8f11d6dceecc0c9549ace770 ]

Memory regions (MR) of type DM (device memory) do not have an associated
umem.

In the __mlx5_ib_dereg_mr() -> mlx5_free_priv_descs() flow, the code
incorrectly takes the wrong branch, attempting to call
dma_unmap_single() on a DMA address that is not mapped.

This results in a WARN [1], as shown below.

The issue is resolved by properly accounting for the DM type and
ensuring the correct branch is selected in mlx5_free_priv_descs().

[1]
WARNING: CPU: 12 PID: 1346 at drivers/iommu/dma-iommu.c:1230 iommu_dma_unmap_page+0x79/0x90
Modules linked in: ip6table_mangle ip6table_nat ip6table_filter ip6_tables iptable_mangle xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcsec_gss_krb5 auth_rpcgss oid_registry ovelay rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core fuse mlx5_core
CPU: 12 UID: 0 PID: 1346 Comm: ibv_rc_pingpong Not tainted 6.12.0-rc7+ #1631
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:iommu_dma_unmap_page+0x79/0x90
Code: 2b 49 3b 29 72 26 49 3b 69 08 73 20 4d 89 f0 44 89 e9 4c 89 e2 48 89 ee 48 89 df 5b 5d 41 5c 41 5d 41 5e 41 5f e9 07 b8 88 ff <0f> 0b 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 66 0f 1f 44 00
RSP: 0018:ffffc90001913a10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88810194b0a8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88810194b0a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f537abdd740(0000) GS:ffff88885fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f537aeb8000 CR3: 000000010c248001 CR4: 0000000000372eb0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
? __warn+0x84/0x190
? iommu_dma_unmap_page+0x79/0x90
? report_bug+0xf8/0x1c0
? handle_bug+0x55/0x90
? exc_invalid_op+0x13/0x60
? asm_exc_invalid_op+0x16/0x20
? iommu_dma_unmap_page+0x79/0x90
dma_unmap_page_attrs+0xe6/0x290
mlx5_free_priv_descs+0xb0/0xe0 [mlx5_ib]
__mlx5_ib_dereg_mr+0x37e/0x520 [mlx5_ib]
? _raw_spin_unlock_irq+0x24/0x40
? wait_for_completion+0xfe/0x130
? rdma_restrack_put+0x63/0xe0 [ib_core]
ib_dereg_mr_user+0x5f/0x120 [ib_core]
? lock_release+0xc6/0x280
destroy_hw_idr_uobject+0x1d/0x60 [ib_uverbs]
uverbs_destroy_uobject+0x58/0x1d0 [ib_uverbs]
uobj_destroy+0x3f/0x70 [ib_uverbs]
ib_uverbs_cmd_verbs+0x3e4/0xbb0 [ib_uverbs]
? __pfx_uverbs_destroy_def_handler+0x10/0x10 [ib_uverbs]
? lock_acquire+0xc1/0x2f0
? ib_uverbs_ioctl+0xcb/0x170 [ib_uverbs]
? ib_uverbs_ioctl+0x116/0x170 [ib_uverbs]
? lock_release+0xc6/0x280
ib_uverbs_ioctl+0xe7/0x170 [ib_uverbs]
? ib_uverbs_ioctl+0xcb/0x170 [ib_uverbs]
__x64_sys_ioctl+0x1b0/0xa70
do_syscall_64+0x6b/0x140
entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f537adaf17b
Code: 0f 1e fa 48 8b 05 1d ad 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed ac 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffff218f0b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffff218f1d8 RCX: 00007f537adaf17b
RDX: 00007ffff218f1c0 RSI: 00000000c0181b01 RDI: 0000000000000003
RBP: 00007ffff218f1a0 R08: 00007f537aa8d010 R09: 0000561ee2e4f270
R10: 00007f537aace3a8 R11: 0000000000000246 R12: 00007ffff218f190
R13: 000000000000001c R14: 0000561ee2e4d7c0 R15: 00007ffff218f450
</TASK>

Fixes: f18ec4223117 ("RDMA/mlx5: Use a union inside mlx5_ib_mr")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/2039c22cfc3df02378747ba4d623a558b53fc263.1738587076.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 0a3cbb14e1839..753faa9ad06a8 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1935,7 +1935,8 @@ mlx5_alloc_priv_descs(struct ib_device *device,
 static void
 mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 {
-	if (!mr->umem && !mr->data_direct && mr->descs) {
+	if (!mr->umem && !mr->data_direct &&
+	    mr->ibmr.type != IB_MR_TYPE_DM && mr->descs) {
 		struct ib_device *device = mr->ibmr.device;
 		int size = mr->max_descs * mr->desc_size;
 		struct mlx5_ib_dev *dev = to_mdev(device);
-- 
2.39.5



