Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6CF37A4AE;
	Mon,  9 Feb 2026 14:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647726; cv=none; b=lsTuQOAR+IkoId8qy80eJ5HGDRzvo+qB2ltOrI1NnNlS04+VQHrJr1HgMw32MQUx+z3SbBDoiTOS6WK29mle8HQfB+LbwHzrVYfBnxHf7AQt2228MibnPzyccIjLypQ0oTgMmK+pjFL6V5Z98926kH6rdYoz+Tg+EBm0+ikRBM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647726; c=relaxed/simple;
	bh=Dx8Mq5D1p5V9nRH/92a4xaRAfoD1NJX0kM4iapHlkwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1IdyhfnIwxVZ0tTY07TiFyOnzdJ7EPoNGNBrpdi+6pdyhoAALsNqNXlDCoHTA+c7v2UmPKxA0vtyr3FPu2T5N79eFPGT+wVeOWza1e1qLM/8FRucIT+eRr8TRUpox6IY0ZBmMkQANFXcHtKcZ/Lu7esfjw5H7DDjhtBiYQFOb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAx9ozs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAx9ozs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC83C116C6;
	Mon,  9 Feb 2026 14:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647726;
	bh=Dx8Mq5D1p5V9nRH/92a4xaRAfoD1NJX0kM4iapHlkwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAx9ozs/b9kfKtP8THXKd7o3ZGG+cvBqCilj8NbLGipa7G1mzNXaTCg5RYlXm0kxt
	 tjONETbzyNPZtfqDssdmk3pUiF3cebXBfZS7k9wPc5kyTf3Oip+DqEIEOjj5n2WDPP
	 bHMJxenSBOTF1T1U7LCzc7XSw6dZmXqIeFjVzYfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Li <hao.li@linux.dev>,
	Hao Ge <hao.ge@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 011/113] mm/slab: Add alloc_tagging_slab_free_hook for memcg_alloc_abort_single
Date: Mon,  9 Feb 2026 15:22:40 +0100
Message-ID: <20260209142310.618266453@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <hao.ge@linux.dev>

commit e6c53ead2d8fa73206e0a63e9cd9aea6bc929837 upstream.

When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warning
may be noticed:

[ 3959.023862] ------------[ cut here ]------------
[ 3959.023891] alloc_tag was not cleared (got tag for lib/xarray.c:378)
[ 3959.023947] WARNING: ./include/linux/alloc_tag.h:155 at alloc_tag_add+0x128/0x178, CPU#6: mkfs.ntfs/113998
[ 3959.023978] Modules linked in: dns_resolver tun brd overlay exfat btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse nfnetlink sr_mod virtio_gpu cdrom drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms_helper ghash_ce drm sm4 backlight virtio_net net_failover virtio_scsi failover virtio_console virtio_blk virtio_mmio dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
[ 3959.024170] CPU: 6 UID: 0 PID: 113998 Comm: mkfs.ntfs Kdump: loaded Tainted: G        W           6.19.0-rc7+ #7 PREEMPT(voluntary)
[ 3959.024182] Tainted: [W]=WARN
[ 3959.024186] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
[ 3959.024192] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 3959.024199] pc : alloc_tag_add+0x128/0x178
[ 3959.024207] lr : alloc_tag_add+0x128/0x178
[ 3959.024214] sp : ffff80008b696d60
[ 3959.024219] x29: ffff80008b696d60 x28: 0000000000000000 x27: 0000000000000240
[ 3959.024232] x26: 0000000000000000 x25: 0000000000000240 x24: ffff800085d17860
[ 3959.024245] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 00000000000002d0
[ 3959.024257] x20: ffff0000e6ef3318 x19: ffff800085ae0410 x18: 0000000000000000
[ 3959.024269] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[ 3959.024281] x14: 0000000000000000 x13: 0000000000000001 x12: ffff600064101293
[ 3959.024292] x11: 1fffe00064101292 x10: ffff600064101292 x9 : dfff800000000000
[ 3959.024305] x8 : 00009fff9befed6e x7 : ffff000320809493 x6 : 0000000000000001
[ 3959.024316] x5 : ffff000320809490 x4 : ffff600064101293 x3 : ffff800080691838
[ 3959.024328] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000d5bcd640
[ 3959.024340] Call trace:
[ 3959.024346]  alloc_tag_add+0x128/0x178 (P)
[ 3959.024355]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
[ 3959.024362]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
[ 3959.024369]  xas_alloc+0x304/0x4f0
[ 3959.024381]  xas_create+0x1e0/0x4a0
[ 3959.024388]  xas_store+0x68/0xda8
[ 3959.024395]  __filemap_add_folio+0x5b0/0xbd8
[ 3959.024409]  filemap_add_folio+0x16c/0x7e0
[ 3959.024416]  __filemap_get_folio_mpol+0x2dc/0x9e8
[ 3959.024424]  iomap_get_folio+0xfc/0x180
[ 3959.024435]  __iomap_get_folio+0x2f8/0x4b8
[ 3959.024441]  iomap_write_begin+0x198/0xc18
[ 3959.024448]  iomap_write_iter+0x2ec/0x8f8
[ 3959.024454]  iomap_file_buffered_write+0x19c/0x290
[ 3959.024461]  blkdev_write_iter+0x38c/0x978
[ 3959.024470]  vfs_write+0x4d4/0x928
[ 3959.024482]  ksys_write+0xfc/0x1f8
[ 3959.024489]  __arm64_sys_write+0x74/0xb0
[ 3959.024496]  invoke_syscall+0xd4/0x258
[ 3959.024507]  el0_svc_common.constprop.0+0xb4/0x240
[ 3959.024514]  do_el0_svc+0x48/0x68
[ 3959.024520]  el0_svc+0x40/0xf8
[ 3959.024526]  el0t_64_sync_handler+0xa0/0xe8
[ 3959.024533]  el0t_64_sync+0x1ac/0x1b0
[ 3959.024540] ---[ end trace 0000000000000000 ]---

When __memcg_slab_post_alloc_hook() fails, there are two different
free paths depending on whether size == 1 or size != 1. In the
kmem_cache_free_bulk() path, we do call alloc_tagging_slab_free_hook().
However, in memcg_alloc_abort_single() we don't, the above warning will be
triggered on the next allocation.

Therefore, add alloc_tagging_slab_free_hook() to the
memcg_alloc_abort_single() path.

Fixes: 9f9796b413d3 ("mm, slab: move memcg charging to post-alloc hook")
Cc: stable@vger.kernel.org
Suggested-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Link: https://patch.msgid.link/20260204101401.202762-1-hao.ge@linux.dev
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4657,8 +4657,12 @@ void slab_free(struct kmem_cache *s, str
 static noinline
 void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
 {
+	struct slab *slab = virt_to_slab(object);
+
+	alloc_tagging_slab_free_hook(s, slab, &object, 1);
+
 	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
-		do_slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
+		do_slab_free(s, slab, object, object, 1, _RET_IP_);
 }
 #endif
 


