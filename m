Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020247;
	b=Ww3zwppkoa5P/oavu4076qTz1R6CaO5XNpZ/2c99BeAR5Bm/wmflUcYOIKu8uKaovkH7
	 NWXYCbIUbN3v0kAbMqeeDtJtefh58Jw6AVaItIMqzDrIkTwikD2SnA0A+U8X2z2muoNnT
	 GDxeaRGScoGwE6xMrrlpyHAHpTTG2LUpORsehWhxP+F8Tkbse/MNwfa+x37yRdc2S807K
	 nIC9d1E8LxQd2otOMNm0xlgxy/1eKNRow/gDKM0T8MGPov8wkpOhQK9L3BW0WNynZGqMk
	 bNfRQMhmJlqNh9kn0pBhDWxFCTPH7MqroAGTU2ENzNyOrxRZ1wbeMtZil60/dwRI4cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/EhKtKwAZce/XvQ412r1dGcgD58HwA5mszP9zZ1y7rA=;
	b=fypQi7BJN6kJ6hJGeknHmwzluebJDXk0CA7Sg/I9hXnijnD5xuNlOsxP/f3yoWPwpC9G
	 nPHRAJ2B1WSfDEWlKSUdbc+UtJHQVhGUi30l0mb602iGYa7T2QJQmQYxNa0hSmE7+jhvF
	 iQU36zDNSbIfsTy6PzhAKLZDw2cW+T219W+hXLA3FX7IVVnI1F4hYJgI1QDyetFYyVp2i
	 88+Hya1DBKiOGgDElfVv2fvdCKMJA33u08O+vxYbukjMbpwZQfuU4tJ0LXu06dDd1bTY2
	 QuGAKDKhhQDSyF/TDT1olcKvPx/H2+wvBA11ndSJ/OhxxJvQZIswqN6/a+HaWzdM2fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCDKmqBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C86606A320;
	Wed, 18 Nov 2026 16:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCDKmqBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7591C1F000C4;
	Wed, 18 Nov 2026 16:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020247;
	bh=/EhKtKwAZce/XvQ412r1dGcgD58HwA5mszP9zZ1y7rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCDKmqBDDYHLkBWDfb1ArSRMvaWyerAkNq72nMqYrOpYChfmPK6+k4f79M4/UNaQl
	 1QnumJzH3wgMpNx/ww3Mv/cuU60cDXm5VcD8cKbyR7KD3gwJoCN4OBVMU81Ph2/jlO
	 96Xq7GyP/vPxlHQ/duNxtQ7xpYQUsK5ig5SaNx+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1841/2651] dma-debug: Skip cacheline tracking for MMIO mappings
Date: Wed, 18 Nov 2026 15:51:21 +0100
Message-ID: <20261118150353.356596034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 4733f2966433b7f926f70c9dc461c33cd5c10835 ]

Mapping one MMIO dma-buf for many RDMA importers overflows dma-debug's
cacheline overlap counter and triggers a warning. DMA_ATTR_MMIO mappings
must never be CPU-cacheable, so CPU cacheline overlap tracking does not
apply to them.

Skip MMIO entries in both cacheline insertion and removal. Keep them in
the DMA entry hash so mapping and unmapping checks still run.

The reported warning was:
 ------------[ cut here ]------------
DMA-API: exceeded 7 overlapping mappings of cacheline 0x000000e040000400
WARNING: kernel/dma/debug.c:465 at add_dma_entry+0x3b5/0x470, CPU#58: dtr/5264
Modules linked in: xt_conntrack xt_MASQUERADE ip6table_nat ip6table_filter ip6_tables iptable_nat nf_nat xt_addrtype rpcsec_gss_krb5 krb5 auth_rpcgss oid_registry overlay rpcrdma rdma_ucm ib_uverbs ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm nvidia(O) mlx5_fwctl nvidia_drm(O) mlx5_ib ib_uverbs_support ib_core zram zsmalloc fuse mlx5_core
CPU: 58 UID: 0 PID: 5264 Comm: dtr Tainted: G           O      J 7.3.0-rc6_for_upstream_debug_2026_10_08_13_46 #1.fc40 PREEMPTLAZY
Tainted: [O]=OOT_MODULE, [J]=FWCTL
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
RIP: 0010:add_dma_entry+0x3bf/0x470
Code: ac e8 f5 89 6e 00 e9 47 fe ff ff 41 f7 c6 00 18 00 00 75 9f 83 fb 07 7e 9a 48 8d 3d eb 02 5f 04 be 07 00 00 00 48 8d 54 24 30 <67> 48 0f b9 3a eb 82 0f 0b 48 c7 c7 80 d3 2a 85 4c 89 e6 e8 a9 1f
RSP: 0018:ff110001bcb7f230 EFLAGS: 00010002
RAX: 0000000000000006 RBX: 0000000000000008 RCX: 0000000000000000
RDX: ff110001bcb7f260 RSI: 0000000000000007 RDI: ffffffff85cfd070
RBP: 000000e040000400 R08: 0000000000000000 R09: ffe21c0044b8abf5
R10: ff11000225c55faf R11: 0000000000000000 R12: 0000000000000246
R13: 1fe220003796fe48 R14: 0000000000000400 R15: 00000000ffffffff
FS:  00007fa8f91e6b80(0000) GS:ff11000eb81cc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa8f5ca80f0 CR3: 0000000164871004 CR4: 0000000000373eb0
Call Trace:
 <TASK>
 ? check_sync+0x2070/0x2070
 ? find_held_lock+0x2b/0x80
 ? debug_dma_map_phys+0x588/0x840
 debug_dma_map_phys+0x267/0x840
 ? dma_debug_add_bus+0xd0/0xd0
 ? __sg_alloc_table+0x2b7/0x4d0
 dma_map_phys+0x10a/0x330
 ? sg_miter_start+0x130/0x130
 dma_buf_phys_vec_to_sgt+0x565/0xed0
 uverbs_dmabuf_map+0x158/0x340 [ib_uverbs]
 ? uverbs_dmabuf_unpin+0x10/0x10 [ib_uverbs]
 dma_buf_map_attachment+0x138/0x690
 ib_umem_dmabuf_map_pages+0x249/0xc90 [ib_core]
 pagefault_dmabuf_mr+0x172/0xf80 [mlx5_ib]
 ? do_raw_spin_unlock+0x54/0x210
 mlx5_ib_init_dmabuf_mr+0x13e/0x200 [mlx5_ib]
[... '?' frames and user-space registers omitted ...]
 reg_user_mr_dmabuf+0x3bf/0x760 [mlx5_ib]
 mlx5_ib_reg_user_mr_dmabuf+0x2dd/0x13b0 [mlx5_ib]
 ib_uverbs_handler_UVERBS_METHOD_REG_MR+0x76d/0xd90 [ib_uverbs]
 ib_uverbs_cmd_verbs+0x2337/0x31c0 [ib_uverbs]
 ib_uverbs_ioctl+0x1c7/0x350 [ib_uverbs]
 __x64_sys_ioctl+0x72c/0x11f0
 do_syscall_64+0xa1/0x4f0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
 </TASK>
 ---[ end trace 0000000000000000 ]---

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Fixes: 3aa31a8bb11e ("dma-buf: provide phys_vec to scatter-gather mapping routine")
Link: https://lore.kernel.org/r/20261013-dma-debug-fixes-v1-1-1ad1f471cc61@nvidia.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 026d50de340e2..36c1f7cbb2ae9 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -489,8 +489,10 @@ static int active_cacheline_insert(struct dma_debug_entry *entry,
 	/* If the device is not writing memory then we don't have any
 	 * concerns about the cpu consuming stale data.  This mitigates
 	 * legitimate usages of overlapping mappings.
+	 * MMIO mappings are never CPU-cacheable and do not need tracking either.
 	 */
-	if (entry->direction == DMA_TO_DEVICE)
+	if (entry->direction == DMA_TO_DEVICE ||
+	    entry->attrs & DMA_ATTR_MMIO)
 		return 0;
 
 	spin_lock_irqsave(&radix_lock, flags);
@@ -519,7 +521,8 @@ static void active_cacheline_remove(struct dma_debug_entry *entry)
 	unsigned long flags;
 
 	/* ...mirror the insert case */
-	if (entry->direction == DMA_TO_DEVICE)
+	if (entry->direction == DMA_TO_DEVICE ||
+	    entry->attrs & DMA_ATTR_MMIO)
 		return;
 
 	spin_lock_irqsave(&radix_lock, flags);
-- 
2.53.0



