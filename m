Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E19189B9C;
	Tue, 10 Sep 2024 09:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961406; cv=none; b=fWI0tRJRfH9dZ/9wx5pNMVyldLDs7+HC7VwLpDK5a+rUqGnP9XrNZ7XgC6uRSAnUnuZS8E5/eWoe+7vv7jcE2XB74Vjaz0qFzpaXl6+0FTgm2Fn25/ULYIOE90H/C5r+UJ2wYz7rAIltla71gPwjHg8/k3CNRkf21NujJ7SW6HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961406; c=relaxed/simple;
	bh=84mqLbCEQ2/Q5EhiK3E1j5tLULVjRSUH6GNORWe8dmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7rPE9a85LNsaSia5UTL7Kvp6VrmkRkaVVeVvth+PWG+obVW2PRE4y7Yfjzbz6Jj02zn5M/ocWWatcyd0Z07vY8NRLhj8n9wySQ/E1oqFhCRzLkIzKR0vkbezOQPlrFDWDKcV9STAqssi1rNcezoGOVt6R1WtHRzkNEP3L60rr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVXJVNHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVXJVNHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55474C4CEC3;
	Tue, 10 Sep 2024 09:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961405;
	bh=84mqLbCEQ2/Q5EhiK3E1j5tLULVjRSUH6GNORWe8dmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVXJVNHu8x5UTjUmpXDwoxz/rilZT9b5EAb+DdkT1+lrPRododmCDkuMIveStAGl2
	 XlDQWcA9MC568/89bCZGhjpWfVEGu1ErVRTCyP+ntWkh43dz6dHHsmBh2qUyr6uYGH
	 1GHsWNrTZ3N/HV/KvBwB82THZTLlXo0PWYJ2N+F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <gehao@kylinos.cn>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Kees Cook <kees@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 059/375] mm/slub: add check for s->flags in the alloc_tagging_slab_free_hook
Date: Tue, 10 Sep 2024 11:27:36 +0200
Message-ID: <20240910092624.211868189@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <gehao@kylinos.cn>

commit ab7ca09520e9c41c219a4427fe0dae24024bfe7f upstream.

When enable CONFIG_MEMCG & CONFIG_KFENCE & CONFIG_KMEMLEAK, the following
warning always occurs,This is because the following call stack occurred:
mem_pool_alloc
    kmem_cache_alloc_noprof
        slab_alloc_node
            kfence_alloc

Once the kfence allocation is successful,slab->obj_exts will not be empty,
because it has already been assigned a value in kfence_init_pool.

Since in the prepare_slab_obj_exts_hook function,we perform a check for
s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE),the alloc_tag_add function
will not be called as a result.Therefore,ref->ct remains NULL.

However,when we call mem_pool_free,since obj_ext is not empty, it
eventually leads to the alloc_tag_sub scenario being invoked.  This is
where the warning occurs.

So we should add corresponding checks in the alloc_tagging_slab_free_hook.
For __GFP_NO_OBJ_EXT case,I didn't see the specific case where it's using
kfence,so I won't add the corresponding check in
alloc_tagging_slab_free_hook for now.

[    3.734349] ------------[ cut here ]------------
[    3.734807] alloc_tag was not set
[    3.735129] WARNING: CPU: 4 PID: 40 at ./include/linux/alloc_tag.h:130 kmem_cache_free+0x444/0x574
[    3.735866] Modules linked in: autofs4
[    3.736211] CPU: 4 UID: 0 PID: 40 Comm: ksoftirqd/4 Tainted: G        W          6.11.0-rc3-dirty #1
[    3.736969] Tainted: [W]=WARN
[    3.737258] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
[    3.737875] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    3.738501] pc : kmem_cache_free+0x444/0x574
[    3.738951] lr : kmem_cache_free+0x444/0x574
[    3.739361] sp : ffff80008357bb60
[    3.739693] x29: ffff80008357bb70 x28: 0000000000000000 x27: 0000000000000000
[    3.740338] x26: ffff80008207f000 x25: ffff000b2eb2fd60 x24: ffff0000c0005700
[    3.740982] x23: ffff8000804229e4 x22: ffff800082080000 x21: ffff800081756000
[    3.741630] x20: fffffd7ff8253360 x19: 00000000000000a8 x18: ffffffffffffffff
[    3.742274] x17: ffff800ab327f000 x16: ffff800083398000 x15: ffff800081756df0
[    3.742919] x14: 0000000000000000 x13: 205d344320202020 x12: 5b5d373038343337
[    3.743560] x11: ffff80008357b650 x10: 000000000000005d x9 : 00000000ffffffd0
[    3.744231] x8 : 7f7f7f7f7f7f7f7f x7 : ffff80008237bad0 x6 : c0000000ffff7fff
[    3.744907] x5 : ffff80008237ba78 x4 : ffff8000820bbad0 x3 : 0000000000000001
[    3.745580] x2 : 68d66547c09f7800 x1 : 68d66547c09f7800 x0 : 0000000000000000
[    3.746255] Call trace:
[    3.746530]  kmem_cache_free+0x444/0x574
[    3.746931]  mem_pool_free+0x44/0xf4
[    3.747306]  free_object_rcu+0xc8/0xdc
[    3.747693]  rcu_do_batch+0x234/0x8a4
[    3.748075]  rcu_core+0x230/0x3e4
[    3.748424]  rcu_core_si+0x14/0x1c
[    3.748780]  handle_softirqs+0x134/0x378
[    3.749189]  run_ksoftirqd+0x70/0x9c
[    3.749560]  smpboot_thread_fn+0x148/0x22c
[    3.749978]  kthread+0x10c/0x118
[    3.750323]  ret_from_fork+0x10/0x20
[    3.750696] ---[ end trace 0000000000000000 ]---

Link: https://lkml.kernel.org/r/20240816013336.17505-1-hao.ge@linux.dev
Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2044,6 +2044,10 @@ alloc_tagging_slab_free_hook(struct kmem
 	if (!mem_alloc_profiling_enabled())
 		return;
 
+	/* slab->obj_exts might not be NULL if it was created for MEMCG accounting. */
+	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
+		return;
+
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
 		return;


