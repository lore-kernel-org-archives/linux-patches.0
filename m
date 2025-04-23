Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0986263F2D;
	Wed, 23 Apr 2025 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420421; cv=none; b=R83XNRXZ25geVfhhY88Z2Bf8+qlHW7UsTbCBYPV6I7QoqMup7Iv+xQokMJprn/odKMSlXOm/JkdPjZQeOLLYF/RKbJ6j/OZWLFO90K9SRU3LalKJN9sl0FnXoU8zTGfZQEKpdaFaueN5WGTLB9fjrxFQgZtD/V9GFvvig/mwgIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420421; c=relaxed/simple;
	bh=adZ99xPpveAcmKdAPD+OER8z/piY5qiHou8p71JoFOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQZOEWTlyKEwKWmlfCrG8gfQjoy4FHAzPaoc5gZINbyT2zWXKH9jKHENdkAU0RY/ma9YRWx/3AU422WBsvZ63HsNgx4Jl8gPACnyFR7HlqgiRBDt/bSj2XcLXEGVQyFnp1eMENW/9rpGv72x3eM/EE9MN/EBQuuGVDk5SPsJEFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eitub8ki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eitub8ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33728C4CEE3;
	Wed, 23 Apr 2025 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420421;
	bh=adZ99xPpveAcmKdAPD+OER8z/piY5qiHou8p71JoFOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eitub8kieisMvhNgEcXqugPamxFHEW6DAMzt/g2SnS06HFWBrcl8jmX9Lsg7Ewts5
	 ciWpjHAOp1TS79PkAT3eVVux7d8CjYadNFDv9Qqc1vdofP9I0V84NICLdvjoI5xZyN
	 gFrh1RHb53mvZ5kmBk4ykY5Qf+9+PoP2/7AZgfqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 130/223] slab: ensure slab->obj_exts is clear in a newly allocated slab page
Date: Wed, 23 Apr 2025 16:43:22 +0200
Message-ID: <20250423142622.391545125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Suren Baghdasaryan <surenb@google.com>

commit d2f5819b6ed357c0c350c0616b6b9f38be59adf6 upstream.

ktest recently reported crashes while running several buffered io tests
with __alloc_tagging_slab_alloc_hook() at the top of the crash call stack.
The signature indicates an invalid address dereference with low bits of
slab->obj_exts being set. The bits were outside of the range used by
page_memcg_data_flags and objext_flags and hence were not masked out
by slab_obj_exts() when obtaining the pointer stored in slab->obj_exts.
The typical crash log looks like this:

00510 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
00510 Mem abort info:
00510   ESR = 0x0000000096000045
00510   EC = 0x25: DABT (current EL), IL = 32 bits
00510   SET = 0, FnV = 0
00510   EA = 0, S1PTW = 0
00510   FSC = 0x05: level 1 translation fault
00510 Data abort info:
00510   ISV = 0, ISS = 0x00000045, ISS2 = 0x00000000
00510   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
00510   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
00510 user pgtable: 4k pages, 39-bit VAs, pgdp=0000000104175000
00510 [0000000000000010] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
00510 Internal error: Oops: 0000000096000045 [#1]  SMP
00510 Modules linked in:
00510 CPU: 10 UID: 0 PID: 7692 Comm: cat Not tainted 6.15.0-rc1-ktest-g189e17946605 #19327 NONE
00510 Hardware name: linux,dummy-virt (DT)
00510 pstate: 20001005 (nzCv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
00510 pc : __alloc_tagging_slab_alloc_hook+0xe0/0x190
00510 lr : __kmalloc_noprof+0x150/0x310
00510 sp : ffffff80c87df6c0
00510 x29: ffffff80c87df6c0 x28: 000000000013d1ff x27: 000000000013d200
00510 x26: ffffff80c87df9e0 x25: 0000000000000000 x24: 0000000000000001
00510 x23: ffffffc08041953c x22: 000000000000004c x21: ffffff80c0002180
00510 x20: fffffffec3120840 x19: ffffff80c4821000 x18: 0000000000000000
00510 x17: fffffffec3d02f00 x16: fffffffec3d02e00 x15: fffffffec3d00700
00510 x14: fffffffec3d00600 x13: 0000000000000200 x12: 0000000000000006
00510 x11: ffffffc080bb86c0 x10: 0000000000000000 x9 : ffffffc080201e58
00510 x8 : ffffff80c4821060 x7 : 0000000000000000 x6 : 0000000055555556
00510 x5 : 0000000000000001 x4 : 0000000000000010 x3 : 0000000000000060
00510 x2 : 0000000000000000 x1 : ffffffc080f50cf8 x0 : ffffff80d801d000
00510 Call trace:
00510  __alloc_tagging_slab_alloc_hook+0xe0/0x190 (P)
00510  __kmalloc_noprof+0x150/0x310
00510  __bch2_folio_create+0x5c/0xf8
00510  bch2_folio_create+0x2c/0x40
00510  bch2_readahead+0xc0/0x460
00510  read_pages+0x7c/0x230
00510  page_cache_ra_order+0x244/0x3a8
00510  page_cache_async_ra+0x124/0x170
00510  filemap_readahead.isra.0+0x58/0xa0
00510  filemap_get_pages+0x454/0x7b0
00510  filemap_read+0xdc/0x418
00510  bch2_read_iter+0x100/0x1b0
00510  vfs_read+0x214/0x300
00510  ksys_read+0x6c/0x108
00510  __arm64_sys_read+0x20/0x30
00510  invoke_syscall.constprop.0+0x54/0xe8
00510  do_el0_svc+0x44/0xc8
00510  el0_svc+0x18/0x58
00510  el0t_64_sync_handler+0x104/0x130
00510  el0t_64_sync+0x154/0x158
00510 Code: d5384100 f9401c01 b9401aa3 b40002e1 (f8227881)
00510 ---[ end trace 0000000000000000 ]---
00510 Kernel panic - not syncing: Oops: Fatal exception
00510 SMP: stopping secondary CPUs
00510 Kernel Offset: disabled
00510 CPU features: 0x0000,000000e0,00000410,8240500b
00510 Memory Limit: none

Investigation indicates that these bits are already set when we allocate
slab page and are not zeroed out after allocation. We are not yet sure
why these crashes start happening only recently but regardless of the
reason, not initializing a field that gets used later is wrong. Fix it
by initializing slab->obj_exts during slab page allocation.

Fixes: 21c690a349ba ("mm: introduce slabobj_ext to support slab object extensions")
Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
Tested-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250411155737.1360746-1-surenb@google.com
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1960,6 +1960,11 @@ static inline void handle_failed_objexts
 #define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | \
 				__GFP_ACCOUNT | __GFP_NOFAIL)
 
+static inline void init_slab_obj_exts(struct slab *slab)
+{
+	slab->obj_exts = 0;
+}
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		        gfp_t gfp, bool new_slab)
 {
@@ -2044,6 +2049,10 @@ static inline bool need_slab_obj_ext(voi
 
 #else /* CONFIG_SLAB_OBJ_EXT */
 
+static inline void init_slab_obj_exts(struct slab *slab)
+{
+}
+
 static int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			       gfp_t gfp, bool new_slab)
 {
@@ -2613,6 +2622,7 @@ static struct slab *allocate_slab(struct
 	slab->objects = oo_objects(oo);
 	slab->inuse = 0;
 	slab->frozen = 0;
+	init_slab_obj_exts(slab);
 
 	account_slab(slab, oo_order(oo), s, flags);
 


