Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECA043BDCB;
	Thu, 30 Jul 2026 14:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422466; cv=none; b=j8fetoVTOzw5+JXo0JOix0u9DUPdEWsvMmBBJ26cGfkcayYKhiUM3bvKESYgs5hGmqqWXdj92wke1R52VLSv3C4/X8pTtQc1AOlFu5q0WjbKU62io57nJ6TMmrKRLS7HFVl2Az5AdJFjMGcQnasb9TXar5s9LzQtGsD2jyl9Btk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422466; c=relaxed/simple;
	bh=OkEbC8Vk1Bc/RRTS9ElrNGn6fgfAqnqETeAGobLgwFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DjWUe+/ahQaxuFCaYmQltFdOHfKFTjtyI1tolIFnHdP9bued8WUiYJHKsmCn6fxBjgDcNELqEw0x3cP/rNOxlAgeVxKvPZJOMFVvwgwDKvX+oEYCtsEoYzZiiEQMsijMOT9n/n9vsei+G+xJ6wjnKaB7dycGUgV5LDa/amOK4vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEw3y0hB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEw3y0hB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987391F000E9;
	Thu, 30 Jul 2026 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422465;
	bh=szNRjv698gOdSzOCXph11S00PDL+SOQ6E3uaVhhux0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEw3y0hB7uVF8d5onp9GW0WnTBOMoHS47mm0rC6dHkgpbQ7P1fjEU4zvizL21tjfn
	 qAzl5Mm9MobwBOXoFRj2DvGSyb2Ct81qB+DAGPSDEnnujAkPqJI0CMd04QmlunsHX4
	 SwgdGai4/YV3gRmBXvMmNgx8nwgM/cXHZ3SFK9wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7.1 447/744] drm/ttm: Account for NULL and handle pages in ttm_pool_backup
Date: Thu, 30 Jul 2026 16:12:00 +0200
Message-ID: <20260730141453.798380717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 5b7b3b6595ee77d01c7463757baed114786094dd upstream.

Pages in ttm_pool_backup can be NULL or backup handles
(ttm_backup_page_ptr_is_handle()), neither of which can be passed to
set_pages_array_wb() or freed. Add a dedicated WB pass before the
dma/purge loop that walks allocations using the same i += num_pages
stride, skipping NULL and handle entries, and calls set_pages_array_wb()
once per contiguous run of real pages. Apply the same NULL/handle guard
to the dma/purge loop.

Fixes the following oops:

Oops: general protection fault, kernel NULL pointer dereference 0x0: 0000 [#1] SMP NOPTI
RIP: 0010:__cpa_process_fault+0xf8/0x770
RSP: 0018:ffffc90000a87718 EFLAGS: 00010287
RAX: 0000000000000000 RBX: ffffc90000a87868 RCX: 0000000000000000
RDX: 0000000000001000 RSI: 0005088000000000 RDI: ffffffff827c5f34
RBP: 0005088000000000 R08: ffffc90000a877cb R09: ffffc90000a877d0
R10: 0000000000000000 R11: 000000000000001b R12: 000ffffffffff000
R13: ffffc90000a87868 R14: ffffc90000a87868 R15: ffff88815b882ae0
FS:  0000000000000000(0000) GS:ffff8884ec840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f930b844000 CR3: 000000000262e003 CR4: 0000000008f70ef0
PKRU: 55555554
Call Trace:
 <TASK>
 __change_page_attr_set_clr+0x989/0xe90
 ? __purge_vmap_area_lazy+0x6c/0x3a0
 ? _vm_unmap_aliases+0x250/0x2a0
 set_pages_array_wb+0x7f/0x120
 ttm_pool_backup+0x4c9/0x5b0 [ttm]
 ? dma_resv_wait_timeout+0x3b/0xf0
 ttm_tt_backup+0x32/0x60 [ttm]
 ttm_bo_shrink+0x66/0x110 [ttm]
 xe_bo_shrink_purge+0x12b/0x1b0 [xe]
 xe_bo_shrink+0xbb/0x270 [xe]
 __xe_shrinker_walk+0xf7/0x160 [xe]
 xe_shrinker_walk+0x9d/0xc0 [xe]
 xe_shrinker_scan+0x11f/0x210 [xe]
 do_shrink_slab+0x13b/0x270
 shrink_slab+0xf1/0x400
 shrink_node+0x352/0x8a0
 balance_pgdat+0x32c/0x700
 kswapd+0x205/0x2f0
 ? __pfx_autoremove_wake_function+0x10/0x10
 ? __pfx_kswapd+0x10/0x10
 kthread+0xd1/0x110
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x1b1/0x200
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: b63d715b8090 ("drm/ttm/pool, drm/ttm/tt: Provide a helper to shrink pages")
Cc: stable@vger.kernel.org
Assisted-by: GitHub_Copilot:claude-opus-4.8
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20260702214815.4009271-1-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_pool.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -1051,9 +1051,31 @@ long ttm_pool_backup(struct ttm_pool *po
 		return -EBUSY;
 
 #ifdef CONFIG_X86
-	/* Anything returned to the system needs to be cached. */
-	if (tt->caching != ttm_cached)
-		set_pages_array_wb(tt->pages, tt->num_pages);
+	/* Anything returned to the system needs to be cached. Walk allocations
+	 * skipping NULL pages and issue set_pages_array_wb() per contiguous run.
+	 */
+	if (tt->caching != ttm_cached) {
+		pgoff_t run_start = 0, run_count = 0;
+
+		for (i = 0; i < tt->num_pages; i += num_pages) {
+			page = tt->pages[i];
+			if (unlikely(!page || ttm_backup_page_ptr_is_handle(page))) {
+				if (run_count) {
+					set_pages_array_wb(&tt->pages[run_start],
+							   run_count);
+					run_count = 0;
+				}
+				num_pages = 1;
+				continue;
+			}
+			num_pages = 1UL << ttm_pool_page_order(pool, page);
+			if (!run_count)
+				run_start = i;
+			run_count += num_pages;
+		}
+		if (run_count)
+			set_pages_array_wb(&tt->pages[run_start], run_count);
+	}
 #endif
 
 	if (tt->dma_address || flags->purge) {
@@ -1061,7 +1083,7 @@ long ttm_pool_backup(struct ttm_pool *po
 			unsigned int order;
 
 			page = tt->pages[i];
-			if (unlikely(!page)) {
+			if (unlikely(!page || ttm_backup_page_ptr_is_handle(page))) {
 				num_pages = 1;
 				continue;
 			}
@@ -1104,6 +1126,10 @@ long ttm_pool_backup(struct ttm_pool *po
 		if (unlikely(!page))
 			continue;
 
+		/* Already-handled entry from a previous attempt. */
+		if (unlikely(ttm_backup_page_ptr_is_handle(page)))
+			continue;
+
 		ttm_pool_split_for_swap(pool, page);
 
 		shandle = ttm_backup_backup_page(backup, page, flags->writeback, i,


