Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F481CA8F;
	Mon,  1 Apr 2024 16:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987435; cv=none; b=a7KDWdn+FMtgzEjDj/lTLTsjZBKgEG5cqblTH8KxtylPL+fHW9FI/YHyiYGJ/Saw/u4Vh2FrrxFngupnXP1p8i9MHvQ2JDNCpvCpdV0EuT0s0FINiTHJ2WlC5VhvIBOiDsAVRDWacJnuQzw29T44B7jWJFWn5aba9Bl+k3Q1qrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987435; c=relaxed/simple;
	bh=XR1UShcNlkTQP+HX1VqaAmEKooNdDTm0cr4Kl3+1CAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OHYHPeFiOQx/DApvH4LxV2uKEKzOC958Hc9k3W39QWRW1rokdwd31QvapsS1aWyXK0Uyehyn7ITET7sDE9CxilMBDMRilurPGBZQlFu/y3KsrysZs1KMSYqqg6hQ6Bdokp54sXqjuKYZGyV9sQJViQFB14lal3E9gsUYNJpXOKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQJYb+8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQJYb+8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF970C433C7;
	Mon,  1 Apr 2024 16:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987435;
	bh=XR1UShcNlkTQP+HX1VqaAmEKooNdDTm0cr4Kl3+1CAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQJYb+8A3czPc19bCNfj+ULnCdRQLykGFYJQiIezCiX908ZfkQUqbKkawFYjQKxWH
	 oUIPlmEJJmkT4kcdkvVllu2NqVttOcDyNKbZkmXTDk7I5fbm4fI0N4aAMa6Y4LyPrx
	 YD/SWgU5X/VkM0fnLhce0pD+yiy+bInrBKDYvOm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Yosry Ahmed <yosryahmed@google.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Poulin?= <jeromepoulin@gmail.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 286/399] mm: zswap: fix writeback shinker GFP_NOIO/GFP_NOFS recursion
Date: Mon,  1 Apr 2024 17:44:12 +0200
Message-ID: <20240401152557.717859948@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 30fb6a8d9e3378919f378f9bf561142b4a6d2637 upstream.

Kent forwards this bug report of zswap re-entering the block layer
from an IO request allocation and locking up:

[10264.128242] sysrq: Show Blocked State
[10264.128268] task:kworker/20:0H   state:D stack:0     pid:143   tgid:143   ppid:2      flags:0x00004000
[10264.128271] Workqueue: bcachefs_io btree_write_submit [bcachefs]
[10264.128295] Call Trace:
[10264.128295]  <TASK>
[10264.128297]  __schedule+0x3e6/0x1520
[10264.128303]  schedule+0x32/0xd0
[10264.128304]  schedule_timeout+0x98/0x160
[10264.128308]  io_schedule_timeout+0x50/0x80
[10264.128309]  wait_for_completion_io_timeout+0x7f/0x180
[10264.128310]  submit_bio_wait+0x78/0xb0
[10264.128313]  swap_writepage_bdev_sync+0xf6/0x150
[10264.128317]  zswap_writeback_entry+0xf2/0x180
[10264.128319]  shrink_memcg_cb+0xe7/0x2f0
[10264.128322]  __list_lru_walk_one+0xb9/0x1d0
[10264.128325]  list_lru_walk_one+0x5d/0x90
[10264.128326]  zswap_shrinker_scan+0xc4/0x130
[10264.128327]  do_shrink_slab+0x13f/0x360
[10264.128328]  shrink_slab+0x28e/0x3c0
[10264.128329]  shrink_one+0x123/0x1b0
[10264.128331]  shrink_node+0x97e/0xbc0
[10264.128332]  do_try_to_free_pages+0xe7/0x5b0
[10264.128333]  try_to_free_pages+0xe1/0x200
[10264.128334]  __alloc_pages_slowpath.constprop.0+0x343/0xde0
[10264.128337]  __alloc_pages+0x32d/0x350
[10264.128338]  allocate_slab+0x400/0x460
[10264.128339]  ___slab_alloc+0x40d/0xa40
[10264.128345]  kmem_cache_alloc+0x2e7/0x330
[10264.128348]  mempool_alloc+0x86/0x1b0
[10264.128349]  bio_alloc_bioset+0x200/0x4f0
[10264.128352]  bio_alloc_clone+0x23/0x60
[10264.128354]  alloc_io+0x26/0xf0 [dm_mod 7e9e6b44df4927f93fb3e4b5c782767396f58382]
[10264.128361]  dm_submit_bio+0xb8/0x580 [dm_mod 7e9e6b44df4927f93fb3e4b5c782767396f58382]
[10264.128366]  __submit_bio+0xb0/0x170
[10264.128367]  submit_bio_noacct_nocheck+0x159/0x370
[10264.128368]  bch2_submit_wbio_replicas+0x21c/0x3a0 [bcachefs 85f1b9a7a824f272eff794653a06dde1a94439f2]
[10264.128391]  btree_write_submit+0x1cf/0x220 [bcachefs 85f1b9a7a824f272eff794653a06dde1a94439f2]
[10264.128406]  process_one_work+0x178/0x350
[10264.128408]  worker_thread+0x30f/0x450
[10264.128409]  kthread+0xe5/0x120

The zswap shrinker resumes the swap_writepage()s that were intercepted
by the zswap store. This will enter the block layer, and may even
enter the filesystem depending on the swap backing file.

Make it respect GFP_NOIO and GFP_NOFS.

Link: https://lore.kernel.org/linux-mm/rc4pk2r42oyvjo4dc62z6sovquyllq56i5cdgcaqbd7wy3hfzr@n4nbxido3fme/
Link: https://lkml.kernel.org/r/20240321182532.60000-1-hannes@cmpxchg.org
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reported-by: Jérôme Poulin <jeromepoulin@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: stable@vger.kernel.org	[v6.8]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -645,6 +645,14 @@ static unsigned long zswap_shrinker_coun
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
+	/*
+	 * The shrinker resumes swap writeback, which will enter block
+	 * and may enter fs. XXX: Harmonize with vmscan.c __GFP_FS
+	 * rules (may_enter_fs()), which apply on a per-folio basis.
+	 */
+	if (!gfp_has_io_fs(sc->gfp_mask))
+		return 0;
+
 #ifdef CONFIG_MEMCG_KMEM
 	mem_cgroup_flush_stats(memcg);
 	nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;


