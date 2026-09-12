Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818C22BDC0E;
	Sat, 12 Sep 2026 11:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212289; cv=none; b=ZW9Uc1Of0kGivHAwt4ar2xCxwks47EHizHlLmzpzW8phrxGM4tT0weZK4X/UejRQhfrEx/c3twWlx3MMwFsN1wAA9vXs2lEMOXnD/nIGOIzOkzcunSBZtP5R4LfK+O7Kay97fEweokWesFjAe+fhxQ+vSbrcRdwaiFhi0utr+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212289; c=relaxed/simple;
	bh=S9BdFdixuyoGMesahmEjeWcMydhfbJDNJu8YrsEU88c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cP9gFRz676f+/ktNt/WjO20rB5NoTK/aJVJx61eWkAOVqF1ozeM1BhaiGKYER4W2mxEE8iScpmtG0swrnr29j7T7sl6N0F6rLdnhoDyXZPfxnWF10NEDBXmSX0WNrh9o3VO33i2tQsXI/gS3V+0PdE+YfQXYKVlRnHw0ed5WwO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snmtNcib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snmtNcib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066641F000FF;
	Sat, 12 Sep 2026 11:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212288;
	bh=aEbyt3GrYKnUuy5QB0SFd9/64zUJTApp01l++x1Lx6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=snmtNcibz2MxaGA9Xx2eS+4jkxzEg1eKdNuxvNzxmGVdxzVGdYMeJ9hvPZX/w/Gb2
	 6XZr1xIX8MzCHh/V7bcS8lUgMGRmNKQRnEqydpKOLybtlTo3HqSDorNW9BmoO1C6rh
	 VVBp2L+7XrZT5HmRtCXRMqzoASdRyXUqo+Cke9jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1379/1518] net: page_pool: Remove zone/policy GFP flags when allocating XArray entries
Date: Sat, 12 Sep 2026 08:59:08 +0200
Message-ID: <20260912065654.739679428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

[ Upstream commit 039f248a6cc1f4dec895c001de2c600842022e58 ]

Net drivers request GFP flags according to both the current context and
the device constraints, but the XArray entry itself is by no mean used
by the device. Passing though device constraints to XArray allocation is
a bug and will be warned and fixed up by slab, e.g.:

    Unexpected gfp: 0x4 (GFP_DMA32). Fixing up to gfp: 0x82820 (GFP_ATOMIC|__GFP_NOWARN|__GFP_NOMEMALLOC). Fix your code!
    CPU: 2 UID: 0 PID: 1071629 Comm: kworker/u80:1 Not tainted 7.2.0-rc7+ #1 PREEMPT(lazy)
    Hardware name: LENOVO 21Q4/LNVNB161216, BIOS PXCN27WW 10/20/2025
    Workqueue: mt76 mt792x_pm_wake_work [mt792x_lib]
    Call Trace:
     <TASK>
     dump_stack_lvl+0x6e/0x90
     kmalloc_fix_flags+0x4d/0x6a
     refill_objects+0x10a/0x330
     __pcs_replace_empty_main+0x292/0x5c0
     kmem_cache_alloc_lru_noprof+0x4c2/0x680
     ? __xas_nomem+0x3a/0x120
     __xas_nomem+0x3a/0x120
     __xa_alloc+0xd4/0x190
     page_pool_dma_map+0xef/0x400
     __page_pool_alloc_netmems_slow+0xed/0x480
     ? lock_release+0x280/0x490
     page_pool_alloc_frag_netmem+0xe0/0x3a0
     page_pool_alloc_frag+0xe/0x20
     mt76_dma_rx_fill_buf+0x1f6/0x580 [mt76]
     mt76_dma_rx_reset+0x1cf/0x230 [mt76]
     mt792x_wpdma_reset+0x183/0x1b0 [mt792x_lib]
     mt792x_wpdma_reinit_cond+0x5e/0xa0 [mt792x_lib]
     mt792xe_mcu_drv_pmctrl+0x28/0x60 [mt792x_lib]
     mt792x_mcu_drv_pmctrl+0x3e/0x90 [mt792x_lib]
     mt792x_pm_wake_work+0x2d/0x1d0 [mt792x_lib]
     ? process_one_work+0x20e/0x600
     process_one_work+0x230/0x600
     ? process_one_work+0x256/0x600
     worker_thread+0x1ec/0x3c0
     ? rescuer_thread+0x610/0x610
     kthread+0xf2/0x130
     ? kthread_affine_node+0x140/0x140
     ret_from_fork+0x2a5/0x380
     ? kthread_affine_node+0x140/0x140
     ret_from_fork_asm+0x11/0x20
     </TASK>

Currently mt76 and stmmac may allocate page pool pages with GFP_DMA32.

Fix it by removing zone/policy GFP flags when allocating XArray entries.
This is inspired by commit 96d578088085 ("iommu/dma: Use the gfp
parameter in __iommu_dma_alloc_noncontiguous()").

Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
Signed-off-by: Rong Zhang <i@rong.moe>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20260821-page-pool-xa-drop-dma32-v1-1-6eab295c3478@rong.moe
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index d89affe84c783..d1fa5640a9128 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -482,6 +482,13 @@ static int page_pool_register_dma_index(struct page_pool *pool,
 	if (unlikely(!PP_DMA_INDEX_BITS))
 		goto out;
 
+	/*
+	 * Drivers request GFP flags according to both the current context and
+	 * the device constraints, but the XArray entry itself is by no mean
+	 * used by the device, so remove zone/policy flags.
+	 */
+	gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM | __GFP_COMP);
+
 	if (in_softirq())
 		err = xa_alloc(&pool->dma_mapped, &id, netmem_to_page(netmem),
 			       PP_DMA_INDEX_LIMIT, gfp);
-- 
2.53.0



