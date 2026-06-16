Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC9147A0DA;
	Tue, 16 Jun 2026 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631169; cv=none; b=MGpcsHwWDtnMSkJh4YWDeJqueSiwxhAOK48jaONa3BcvuEX+TCvEdGuVBqG1Q8CEJ7qz58qwTYAL5ZowQ1ft0uRTCdviU4Klkj9oxgPg3FRvwuH1YsEEFUEX+hS6WCj9xC49tKqayMqlcoMRyj8NZLouqw68xt3uf4quKE0BGyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631169; c=relaxed/simple;
	bh=9FcfJ9LXOYGpn6rPUPhh3mRcCS7u6/zLgNl1W7nxMTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C7rLIxLk/X0hKkKlZc30b1LShnRlb/BO+M8BRFtAmO8YMbOAo0+tBF98p0UUh6rrm1YWeIZWMribYqGPKyWzUCzpOLRivwZOdhdgNBYO6DoRybrieU7rrYVj4elAdxnatUICDmlfINk1SIEkbWtYKDkutOfJVroaatZESvf3i+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZcnjuUK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZcnjuUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2218E1F000E9;
	Tue, 16 Jun 2026 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631168;
	bh=cUXF4imZLBZ9LMBR5sogd3r4nGk19e2SaioXwwdDQEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZcnjuUKo29UFSbIEx7s9ig6iika2mPjCBp6MTGcJipVKEdbe4H//UCXW5BFugMFe
	 ZGWmT5Ei38efjAzBOeO+bvdkA6GxHV8Vy+Cg97DSEGJyyjnK3ez9HF3siR4+W/UqVL
	 /w8w5OfX4jUePXW7VbrthcR9PiEDWuTSc58NyOn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.1 168/522] drm/i915: Fix potential UAF in TTM object purge
Date: Tue, 16 Jun 2026 20:25:15 +0530
Message-ID: <20260616145134.019841262@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>

commit 5c4063c87a619e4df954c179d24628636f5db15f upstream.

TLDR: The bo->ttm object might be changed by calling ttm_bo_validate(),
      move casting it to an i915_tt object later to actually get the right
      pointer.

A user reported hitting the following bug under heavy use on DG2:

[26620.095550] Oops: general protection fault, probably for non-canonical address 0xa56b6b6b6b6b6b8b: 0000 1 SMP NOPTI
[26620.095556] CPU: 2 UID: 0 PID: 631 Comm: Xorg Not tainted 6.18.8 #1 PREEMPT(lazy)
[26620.095558] Hardware name: ASRock B850M Steel Legend WiFi/B850M Steel Legend WiFi, BIOS 3.50 09/18/2025
[26620.095559] RIP: 0010:i915_ttm_purge+0x84/0x100 [i915]
[26620.095604] Code: 00 00 00 48 8d 54 24 10 48 89 e6 48 89 fb e8 83 aa ae ff 85 c0 75 6f 48 83 bb a8 01 00 00 00 74 2c 48 8b 45 78 48 85 c0 74 23 <48> 8b 78 20 48 c7 c2 ff ff ff ff 31 f6 e8 7a 73 e3 e0 48 8b 7d 78
[26620.095605] RSP: 0018:ffffc90005fd7430 EFLAGS: 00010282
[26620.095607] RAX: a56b6b6b6b6b6b6b RBX: ffff8881f46c3dc0 RCX: 0000000000000000
[26620.095608] RDX: 0000000000000000 RSI: 0000000000000246 RDI: 00000000ffffffff
[26620.095609] RBP: ffff888289610f00 R08: 0000000000000001 R09: ffff88823b022000
[26620.095609] R10: ffff888103029b28 R11: ffff8881fc7f3800 R12: ffff88810b6150d0
[26620.095609] R13: ffff888289610f00 R14: 0000000000000000 R15: ffff8881f46c3dc0
[26620.095610] FS: 00007f1004d86900(0000) GS:ffff88901c858000(0000) knlGS:0000000000000000
[26620.095611] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[26620.095611] CR2: 00007f0fdf489000 CR3: 000000035b0c1000 CR4: 0000000000750ef0
[26620.095612] PKRU: 55555554
[26620.095612] Call Trace:
[26620.095615] <TASK>
[26620.095615] i915_ttm_move+0x2b9/0x420 [i915]
[26620.095642] ? ttm_tt_init+0x65/0x80 [ttm]
[26620.095644] ? i915_ttm_tt_create+0xc6/0x150 [i915]
[26620.095667] ttm_bo_handle_move_mem+0xb6/0x160 [ttm]
[26620.095669] ttm_bo_evict+0x100/0x150 [ttm]
[26620.095671] ? preempt_count_add+0x64/0xa0
[26620.095673] ? _raw_spin_lock+0xe/0x30
[26620.095675] ? _raw_spin_unlock+0xd/0x30
[26620.095675] ? i915_gem_object_evictable+0xb7/0xd0 [i915]
[26620.095704] ttm_bo_evict_cb+0x6e/0xd0 [ttm]
[26620.095705] ttm_lru_walk_for_evict+0xa6/0x200 [ttm]
[26620.095708] ttm_bo_alloc_resource+0x185/0x4f0 [ttm]
[26620.095709] ? init_object+0x62/0xd0
[26620.095712] ttm_bo_validate+0x7a/0x180 [ttm]
[26620.095713] ? _raw_spin_unlock_irqrestore+0x16/0x30
[26620.095714] __i915_ttm_get_pages+0xb0/0x170 [i915]
[26620.095737] i915_ttm_get_pages+0x9f/0x150 [i915]
[26620.095759] ? i915_gem_do_execbuffer+0xedc/0x2b40 [i915]
[26620.095786] ? alloc_debug_processing+0xd0/0x100
[26620.095787] ? _raw_spin_unlock_irqrestore+0x16/0x30
[26620.095788] ? i915_vma_instance+0xa0/0x4e0 [i915]
[26620.095822] __i915_gem_object_get_pages+0x2f/0x40 [i915]
[26620.095848] i915_vma_pin_ww+0x706/0x980 [i915]
[26620.095875] ? i915_gem_do_execbuffer+0xedc/0x2b40 [i915]
[26620.095904] eb_validate_vmas+0x170/0xa00 [i915]
[26620.095930] i915_gem_do_execbuffer+0x1201/0x2b40 [i915]
[26620.095953] ? alloc_debug_processing+0xd0/0x100
[26620.095954] ? _raw_spin_unlock_irqrestore+0x16/0x30
[26620.095955] ? i915_gem_execbuffer2_ioctl+0xc9/0x240 [i915]
[26620.095977] ? __wake_up_sync_key+0x32/0x50
[26620.095979] ? i915_gem_execbuffer2_ioctl+0xc9/0x240 [i915]
[26620.096001] ? __slab_alloc.isra.0+0x67/0xc0
[26620.096003] i915_gem_execbuffer2_ioctl+0x11a/0x240 [i915]

Results from decode_stacktrace.sh pointed to dereference of a file pointer
field of a i915 TTM page vector container associated with an object being
purged on eviction.  That path is taken when the object is marked as no
longer needed.

Code analysis revealed a possibility of the i915 TTM page vector container
being replaced with a new instance inside a function that purges content
of the object, should it be still busy.  That function is called,
indirectly via a more general function that changes the object's placement
and caching policy, before the problematic dereference, but still after
a pointer to the container is captured, rendering the pointer no longer
valid.

Fix the issue by capturing the pointer to the container only after its
potential replacement.

v2: Move the container_of() inside the if block (Sebastian),
  - a simplified version of the commit description that explains briefly
    why the change is necessary (Christian).

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/14882
Fixes: 7ae034590ceae ("drm/i915/ttm: add tt shmem backend")
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc: stable@vger.kernel.org # v5.17+
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Sebastian Brzezinka <sebastian.brzezinka@intel.com>
Cc: Christian König <christian.koenig@amd.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://lore.kernel.org/r/20260508122612.469227-2-janusz.krzysztofik@linux.intel.com
(cherry picked from commit 4462966a93eb185849b7f174f0d0de53476d00a4)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -422,8 +422,6 @@ void i915_ttm_free_cached_io_rsgt(struct
 int i915_ttm_purge(struct drm_i915_gem_object *obj)
 {
 	struct ttm_buffer_object *bo = i915_gem_to_ttm(obj);
-	struct i915_ttm_tt *i915_tt =
-		container_of(bo->ttm, typeof(*i915_tt), ttm);
 	struct ttm_operation_ctx ctx = {
 		.interruptible = true,
 		.no_wait_gpu = false,
@@ -438,16 +436,22 @@ int i915_ttm_purge(struct drm_i915_gem_o
 	if (ret)
 		return ret;
 
-	if (bo->ttm && i915_tt->filp) {
-		/*
-		 * The below fput(which eventually calls shmem_truncate) might
-		 * be delayed by worker, so when directly called to purge the
-		 * pages(like by the shrinker) we should try to be more
-		 * aggressive and release the pages immediately.
-		 */
-		shmem_truncate_range(file_inode(i915_tt->filp),
-				     0, (loff_t)-1);
-		fput(fetch_and_zero(&i915_tt->filp));
+	if (bo->ttm) {
+		struct i915_ttm_tt *i915_tt =
+			container_of(bo->ttm, typeof(*i915_tt), ttm);
+
+		if (i915_tt->filp) {
+			/*
+			 * The below fput(which eventually calls shmem_truncate)
+			 * might be delayed by worker, so when directly called
+			 * to purge the pages(like by the shrinker) we should
+			 * try to be more aggressive and release the pages
+			 * immediately.
+			 */
+			shmem_truncate_range(file_inode(i915_tt->filp),
+					     0, (loff_t)-1);
+			fput(fetch_and_zero(&i915_tt->filp));
+		}
 	}
 
 	obj->write_domain = 0;


