Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214080;
	b=jTs13TGMzMZDa7Ap/mwYVtR8bTlrjA0R4hk9vAeAgCRZj+AlXov0+SiGZ6JQzwRlUR5w
	 EOq8dr1fNkh7jhFLltyA5Hdyw7JhzUSxQLDXHh0XxLCLX7ACPCiW/ibsezLdQG9qGBu9t
	 mde/pdpY90AIL+eFVXWrDUxRcF9HrThF2VXJ3pxq4z6/hbMkGA22JjM90/fSlLwmR1YfE
	 mFqjug6wk4UpGwK+67icsh11QlOUZqCtvtlxjQUUv89ps0TdEyh+LaS3v6PHPuz2ssbGD
	 WreiwH5VkLmtn9/MWTu8zzm9u5879rdV4BcKYyA2IX192lxnFV+30X9es88BW9HQmPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x56ixJhdezGoz7ejNMiiDeyUeCUg8J3vsjuTyFw8kYQ=;
	b=vpy1aX67fzpFJes6kiVE/e7sO1M1iS77X4wzidJN3GykpwgHjOvyVMRhpuCINWh0fxRM
	 pIs6G91p0a6ApmTUUIS1pyWPjrqexYuKK1ROxxwFTldb+HSbg3KDamdoNP4gk2a+G2vrh
	 UA5rZMbtuItqyIH9mQodhm9p05EqYdxKQTgiEI+5WukubTGLaRQo1WB5eQd7BFjkCqmYY
	 EcDiCIVCykNI9bAAn2m7CSw9z3fBUiqBOzkSiocPnXtBbqVKKAnMIzrzQdqdp6/qbN2Wy
	 deA+pqpMLz2D605/nJn715GbGJb1lVhvq5ie3/rSqQgZ5G/Hl6rm9s0ybXQANgvW8iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+LviwYz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDB2606A322;
	Wed, 28 Oct 2026 19:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+LviwYz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8941F01825;
	Wed, 28 Oct 2026 19:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214079;
	bh=x56ixJhdezGoz7ejNMiiDeyUeCUg8J3vsjuTyFw8kYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+LviwYz8TjHwUE3JHtohLwAGu80Igahb+9IEzTymYiJr6wX0WTjHGdueSBq92DAZ
	 wKlK9UD666vCjhPYG/mmBNHNbdaLwK6393FzoNVQfdAJfH9784JNmlYjRsbn0r4z6t
	 UA4duX9+hiPEc13Ne8dB3TPTKJTVbv9CWGjo5DjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0733/1887] RDMA/mlx5: Fix implicit ODP use after free
Date: Wed, 28 Oct 2026 17:47:09 +0100
Message-ID: <20261028170516.129749581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit d3d930411ce390e532470194296658a960887773 ]

Prevent double queueing of implicit ODP mr destroy work by using
__xa_cmpxchg() to make sure this is the only time we are destroying this
specific mr.

Without this change, we could try to invalidate this mr twice, which in
turn could result in queuing a MR work destroy twice, and eventually the
second work could execute after the MR was freed due to the first work,
causing a user after free and trace below.

   refcount_t: underflow; use-after-free.
   WARNING: CPU: 2 PID: 12178 at lib/refcount.c:28 refcount_warn_saturate+0x12b/0x130
   Modules linked in: bonding ib_ipoib vfio_pci ip_gre geneve nf_tables ip6_gre gre ip6_tunnel tunnel6 ipip tunnel4 ib_umad rdma_ucm mlx5_vfio_pci vfio_pci_core vfio_iommu_type1 mlx5_ib vfio ib_uverbs mlx5_core iptable_raw openvswitch nsh rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcsec_gss_krb5 auth_rpcgss oid_registry overlay zram zsmalloc fuse [last unloaded: ib_uverbs]
   CPU: 2 PID: 12178 Comm: kworker/u20:5 Not tainted 6.5.0-rc1_net_next_mlx5_58c644e #1
   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
   Workqueue: events_unbound free_implicit_child_mr_work [mlx5_ib]
   RIP: 0010:refcount_warn_saturate+0x12b/0x130
   Code: 48 c7 c7 38 95 2a 82 c6 05 bc c6 fe 00 01 e8 0c 66 aa ff 0f 0b 5b c3 48 c7 c7 e0 94 2a 82 c6 05 a7 c6 fe 00 01 e8 f5 65 aa ff <0f> 0b 5b c3 90 8b 07 3d 00 00 00 c0 74 12 83 f8 01 74 13 8d 50 ff
   RSP: 0018:ffff8881008e3e40 EFLAGS: 00010286
   RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000027
   RDX: ffff88852c91b5c8 RSI: 0000000000000001 RDI: ffff88852c91b5c0
   RBP: ffff8881dacd4e00 R08: 00000000ffffffff R09: 0000000000000019
   R10: 000000000000072e R11: 0000000063666572 R12: ffff88812bfd9e00
   R13: ffff8881c792d200 R14: ffff88810011c005 R15: ffff8881002099c0
   FS:  0000000000000000(0000) GS:ffff88852c900000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 00007f5694b5e000 CR3: 00000001153f6003 CR4: 0000000000370ea0
   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
   Call Trace:
    <TASK>
    ? refcount_warn_saturate+0x12b/0x130
    free_implicit_child_mr_work+0x180/0x1b0 [mlx5_ib]
    process_one_work+0x1cc/0x3c0
    worker_thread+0x218/0x3c0
    kthread+0xc6/0xf0
    ret_from_fork+0x1f/0x30
    </TASK>

Fixes: 5256edcb98a1 ("RDMA/mlx5: Rework implicit ODP destroy")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/r/c96b8645a81085abff739e6b06e286a350d1283d.1737274283.git.leon@kernel.org
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 89682fe0747ff..1b5492b75b7d8 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -213,10 +213,24 @@ static void destroy_unused_implicit_child_mr(struct mlx5_ib_mr *mr)
 	unsigned long idx = ib_umem_start(odp) >> MLX5_IMR_MTT_SHIFT;
 	struct mlx5_ib_mr *imr = mr->parent;
 
+	/*
+	 * If userspace is racing freeing the parent implicit ODP MR then we can
+	 * loose the race with parent destruction. In this case
+	 * mlx5_ib_free_odp_mr() will free everything in the implicit_children
+	 * xarray so NOP is fine. This child MR cannot be destroyed here because
+	 * we are under its umem_mutex.
+	 */
 	if (!refcount_inc_not_zero(&imr->mmkey.usecount))
 		return;
 
-	xa_erase(&imr->implicit_children, idx);
+	xa_lock(&imr->implicit_children);
+	if (__xa_cmpxchg(&imr->implicit_children, idx, mr, NULL, GFP_KERNEL) !=
+	    mr) {
+		xa_unlock(&imr->implicit_children);
+		return;
+	}
+
+	xa_unlock(&imr->implicit_children);
 
 	/* Freeing a MR is a sleeping operation, so bounce to a work queue */
 	INIT_WORK(&mr->odp_destroy.work, free_implicit_child_mr_work);
-- 
2.53.0



