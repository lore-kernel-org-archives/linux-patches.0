Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A94375F99;
	Tue, 17 Mar 2026 16:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765596; cv=none; b=nLANoDjYfYHt5T1HYbCj7JdcldUp3icwmZpxeWNbZxHZve6cdeMjDYCkSaMu4zbxtWfGyLmfs7dG6F7WlXYCKOp4FT9DDCk2T2vn9QS1mvI+ricIpLf4xeKpExqHt1JvoQGjZTqIiC9eAcq/3TIy3sJQdaqKl4SZu9jhx0Sz9P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765596; c=relaxed/simple;
	bh=GVjrClLuh9y0kg7GkavF2lIE6tA5qR3xOrFt5ei0t28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1+bBZdrgxBGYJyVtT4psOajfOQVb3Tj3G2pcxXXqc7krwBGzKYvLJfYo6s8napaEin3cnxHfbxxF5QNLHmtfZ9iSSdA6nlezAyalT5lYasS8zaKp+83Iq+wGsI1GiAw38gdVXFKrvwWXQYZAWRIiGSMAEh/BHNrVVQDAojtQP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmtqdJfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmtqdJfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C121BC4CEF7;
	Tue, 17 Mar 2026 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765596;
	bh=GVjrClLuh9y0kg7GkavF2lIE6tA5qR3xOrFt5ei0t28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmtqdJfi3gG2/TPZzhN54op76MJMmVPSYZ/VLXbbNpHGq/T63KyBiA6jTCxoglVxm
	 m/LKUsU/U1tOfzHWI51Q1paNlTdMDcDtgdDV19+oMhyJZIwszEA8gM07YE0Q8pd7KI
	 Lc+4d4ohpltib/LGaDP/ItaQaWp/rcbsfWUsaKBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 046/378] net/mlx5e: Fix DMA FIFO desync on error CQE SQ recovery
Date: Tue, 17 Mar 2026 17:30:03 +0100
Message-ID: <20260317163008.681639981@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 1633111d69053512d099658d4a05fc736fab36b0 ]

In case of a TX error CQE, a recovery flow is triggered,
mlx5e_reset_txqsq_cc_pc() resets dma_fifo_cc to 0 but not dma_fifo_pc,
desyncing the DMA FIFO producer and consumer.

After recovery, the producer pushes new DMA entries at the old
dma_fifo_pc, while the consumer reads from position 0.
This causes us to unmap stale DMA addresses from before the recovery.

The DMA FIFO is a purely software construct with no HW counterpart.
At the point of reset, all WQEs have been flushed so dma_fifo_cc is
already equal to dma_fifo_pc. There is no need to reset either counter,
similar to how skb_fifo pc/cc are untouched.

Remove the 'dma_fifo_cc = 0' reset.

This fixes the following WARNING:
    WARNING: CPU: 0 PID: 0 at drivers/iommu/dma-iommu.c:1240 iommu_dma_unmap_page+0x79/0x90
    Modules linked in: mlx5_vdpa vringh vdpa bonding mlx5_ib mlx5_vfio_pci ipip mlx5_fwctl tunnel4 mlx5_core ib_ipoib geneve ip6_gre ip_gre gre nf_tables ip6_tunnel rdma_ucm ib_uverbs ib_umad vfio_pci vfio_pci_core act_mirred act_skbedit act_vlan vhost_net vhost tap ip6table_mangle ip6table_nat ip6table_filter ip6_tables iptable_mangle cls_matchall nfnetlink_cttimeout act_gact cls_flower sch_ingress vhost_iotlb iptable_raw tunnel6 vfio_iommu_type1 vfio openvswitch nsh rpcsec_gss_krb5 auth_rpcgss oid_registry xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink iptable_nat nf_nat xt_addrtype br_netfilter overlay zram zsmalloc rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core fuse [last unloaded: nf_tables]
    CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.13.0-rc5_for_upstream_min_debug_2024_12_30_21_33 #1
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
    RIP: 0010:iommu_dma_unmap_page+0x79/0x90
    Code: 2b 4d 3b 21 72 26 4d 3b 61 08 73 20 49 89 d8 44 89 f9 5b 4c 89 f2 4c 89 e6 48 89 ef 5d 41 5c 41 5d 41 5e 41 5f e9 c7 ae 9e ff <0f> 0b 5b 5d 41 5c 41 5d 41 5e 41 5f c3 66 2e 0f 1f 84 00 00 00 00
    Call Trace:
     <IRQ>
     ? __warn+0x7d/0x110
     ? iommu_dma_unmap_page+0x79/0x90
     ? report_bug+0x16d/0x180
     ? handle_bug+0x4f/0x90
     ? exc_invalid_op+0x14/0x70
     ? asm_exc_invalid_op+0x16/0x20
     ? iommu_dma_unmap_page+0x79/0x90
     ? iommu_dma_unmap_page+0x2e/0x90
     dma_unmap_page_attrs+0x10d/0x1b0
     mlx5e_tx_wi_dma_unmap+0xbe/0x120 [mlx5_core]
     mlx5e_poll_tx_cq+0x16d/0x690 [mlx5_core]
     mlx5e_napi_poll+0x8b/0xac0 [mlx5_core]
     __napi_poll+0x24/0x190
     net_rx_action+0x32a/0x3b0
     ? mlx5_eq_comp_int+0x7e/0x270 [mlx5_core]
     ? notifier_call_chain+0x35/0xa0
     handle_softirqs+0xc9/0x270
     irq_exit_rcu+0x71/0xd0
     common_interrupt+0x7f/0xa0
     </IRQ>
     <TASK>
     asm_common_interrupt+0x22/0x40

Fixes: db75373c91b0 ("net/mlx5e: Recover Send Queue (SQ) from error state")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260305142634.1813208-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 9f6454102cf79..d6ace2b6fc1df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -46,7 +46,6 @@ static void mlx5e_reset_txqsq_cc_pc(struct mlx5e_txqsq *sq)
 		  "SQ 0x%x: cc (0x%x) != pc (0x%x)\n",
 		  sq->sqn, sq->cc, sq->pc);
 	sq->cc = 0;
-	sq->dma_fifo_cc = 0;
 	sq->pc = 0;
 }
 
-- 
2.51.0



