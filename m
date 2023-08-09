Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE9315AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA82C433C8;
	Wed,  9 Aug 2023 10:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577987;
	bh=EwcuVHPAYhXUGh94BAoHXF69v3+qx/4dT04EswxdCVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHBZv/Lclz6nEy3wBDOALlEaK+WOnltftdyQwfdR0uD5UkGviyGjlwAVtTNE7xe9w
	 eZjpxgvcXT6Vil6U5kfoJTdo1cHfIvv6FApTp4fxHxDbYTofVDKhT2jSQio29qHGHh
	 zsdX5ZmQlsTH7ATbPgrVcePVj4CZ+djcOL7xZEc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 036/165] net/mlx5e: xsk: Fix invalid buffer access for legacy rq
Date: Wed,  9 Aug 2023 12:39:27 +0200
Message-ID: <20230809103643.993671236@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit e0f52298fee449fec37e3e3c32df60008b509b16 ]

The below crash can be encountered when using xdpsock in rx mode for
legacy rq: the buffer gets released in the XDP_REDIRECT path, and then
once again in the driver. This fix sets the flag to avoid releasing on
the driver side.

XSK handling of buffers for legacy rq was relying on the caller to set
the skip release flag. But the referenced fix started using fragment
counts for pages instead of the skip flag.

Crash log:
 general protection fault, probably for non-canonical address 0xffff8881217e3a: 0000 [#1] SMP
 CPU: 0 PID: 14 Comm: ksoftirqd/0 Not tainted 6.5.0-rc1+ #31
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 RIP: 0010:bpf_prog_03b13f331978c78c+0xf/0x28
 Code:  ...
 RSP: 0018:ffff88810082fc98 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff888138404901 RCX: c0ffffc900027cbc
 RDX: ffffffffa000b514 RSI: 00ffff8881217e32 RDI: ffff888138404901
 RBP: ffff88810082fc98 R08: 0000000000091100 R09: 0000000000000006
 R10: 0000000000000800 R11: 0000000000000800 R12: ffffc9000027a000
 R13: ffff8881217e2dc0 R14: ffff8881217e2910 R15: ffff8881217e2f00
 FS:  0000000000000000(0000) GS:ffff88852c800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000564cb2e2cde0 CR3: 000000010e603004 CR4: 0000000000370eb0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  ? die_addr+0x32/0x80
  ? exc_general_protection+0x192/0x390
  ? asm_exc_general_protection+0x22/0x30
  ? 0xffffffffa000b514
  ? bpf_prog_03b13f331978c78c+0xf/0x28
  mlx5e_xdp_handle+0x48/0x670 [mlx5_core]
  ? dev_gro_receive+0x3b5/0x6e0
  mlx5e_xsk_skb_from_cqe_linear+0x6e/0x90 [mlx5_core]
  mlx5e_handle_rx_cqe+0x55/0x100 [mlx5_core]
  mlx5e_poll_rx_cq+0x87/0x6e0 [mlx5_core]
  mlx5e_napi_poll+0x45e/0x6b0 [mlx5_core]
  __napi_poll+0x25/0x1a0
  net_rx_action+0x28a/0x300
  __do_softirq+0xcd/0x279
  ? sort_range+0x20/0x20
  run_ksoftirqd+0x1a/0x20
  smpboot_thread_fn+0xa2/0x130
  kthread+0xc9/0xf0
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>
 Modules linked in: mlx5_ib mlx5_core rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm ib_uverbs ib_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter overlay zram zsmalloc fuse [last unloaded: mlx5_core]
 ---[ end trace 0000000000000000 ]---

Fixes: 7abd955a58fb ("net/mlx5e: RX, Fix page_pool page fragment tracking for XDP")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index d97e6df66f454..b8dd744536553 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -323,8 +323,11 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	net_prefetch(mxbuf->xdp.data);
 
 	prog = rcu_dereference(rq->xdp_prog);
-	if (likely(prog && mlx5e_xdp_handle(rq, prog, mxbuf)))
+	if (likely(prog && mlx5e_xdp_handle(rq, prog, mxbuf))) {
+		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
+			wi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
 		return NULL; /* page/packet was consumed by XDP */
+	}
 
 	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
 	 * will be handled by mlx5e_free_rx_wqe.
-- 
2.40.1



