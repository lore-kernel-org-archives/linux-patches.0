Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7751B36C0C9;
	Tue,  6 Jan 2026 17:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722298; cv=none; b=E4KcW2BxdftHJsNltNBX8NKm5Tt6smJ1OyTFelWt/SehJwiaoBgalYYWoX8UlUSXxGS+38Yw1wfGYhu1qT1h1DH31FeHLI2u0s86RtqcukePWznU+lKLx5dBPakoPg1LrFUMMFyNWqvFmhI5u4Ep+2yB4+/rWMA5872332jv2QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722298; c=relaxed/simple;
	bh=Ko7sdh2fqb4SMVP9qNgXfCrrLFZ5KAGG4opbts4wpEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syyoMNTqvxhglT0pSxxzNCAKEFRd/BpozqPmjQgcc8cA8xjzreQwZCAGqdjOpM8bX1UtSmIq3RPCzGyERAzBykhgU65zhkmGOv0VCvGNjvTGRc7KBXK8pD5nPwJTMjodc5hySHz+VJbwrI/oEH96ZjgJ6o5zwSi3B0/8+FfSgE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVAHeiRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVAHeiRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81D3C116C6;
	Tue,  6 Jan 2026 17:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722298;
	bh=Ko7sdh2fqb4SMVP9qNgXfCrrLFZ5KAGG4opbts4wpEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVAHeiRP6De5jmGTRqQxMymoehHU5ohLLMVxQUsv2RRO+b7K9ALZKxiCJvKrVywrm
	 ZQzxvhCxfcrUw1HNBmNWIj9QUQtXYGDy/gx0jJqnwxE0g8ReriRKAR3OhuR1YJLxcQ
	 BsNDQxOt405GGOS3udFf51lKgnTvblmBPqLyRhpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 222/312] mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN
Date: Tue,  6 Jan 2026 18:04:56 +0100
Message-ID: <20260106170555.874187592@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

commit 007f5da43b3d0ecff972e2616062b8da1f862f5e upstream.

Patch series "kasan: vmalloc: Fixes for the percpu allocator and
vrealloc", v3.

Patches fix two issues related to KASAN and vmalloc.

The first one, a KASAN tag mismatch, possibly resulting in a kernel panic,
can be observed on systems with a tag-based KASAN enabled and with
multiple NUMA nodes.  Initially it was only noticed on x86 [1] but later a
similar issue was also reported on arm64 [2].

Specifically the problem is related to how vm_structs interact with
pcpu_chunks - both when they are allocated, assigned and when pcpu_chunk
addresses are derived.

When vm_structs are allocated they are unpoisoned, each with a different
random tag, if vmalloc support is enabled along the KASAN mode.  Later
when first pcpu chunk is allocated it gets its 'base_addr' field set to
the first allocated vm_struct.  With that it inherits that vm_struct's
tag.

When pcpu_chunk addresses are later derived (by pcpu_chunk_addr(), for
example in pcpu_alloc_noprof()) the base_addr field is used and offsets
are added to it.  If the initial conditions are satisfied then some of the
offsets will point into memory allocated with a different vm_struct.  So
while the lower bits will get accurately derived the tag bits in the top
of the pointer won't match the shadow memory contents.

The solution (proposed at v2 of the x86 KASAN series [3]) is to unpoison
the vm_structs with the same tag when allocating them for the per cpu
allocator (in pcpu_get_vm_areas()).

The second one reported by syzkaller [4] is related to vrealloc and
happens because of random tag generation when unpoisoning memory without
allocating new pages.  This breaks shadow memory tracking and needs to
reuse the existing tag instead of generating a new one.  At the same time
an inconsistency in used flags is corrected.


This patch (of 3):

Syzkaller reported a memory out-of-bounds bug [4].  This patch fixes two
issues:

1. In vrealloc the KASAN_VMALLOC_VM_ALLOC flag is missing when
   unpoisoning the extended region. This flag is required to correctly
   associate the allocation with KASAN's vmalloc tracking.

   Note: In contrast, vzalloc (via __vmalloc_node_range_noprof)
   explicitly sets KASAN_VMALLOC_VM_ALLOC and calls
   kasan_unpoison_vmalloc() with it.  vrealloc must behave consistently --
   especially when reusing existing vmalloc regions -- to ensure KASAN can
   track allocations correctly.

2. When vrealloc reuses an existing vmalloc region (without allocating
   new pages) KASAN generates a new tag, which breaks tag-based memory
   access tracking.

Introduce KASAN_VMALLOC_KEEP_TAG, a new KASAN flag that allows reusing the
tag already attached to the pointer, ensuring consistent tag behavior
during reallocation.

Pass KASAN_VMALLOC_KEEP_TAG and KASAN_VMALLOC_VM_ALLOC to the
kasan_unpoison_vmalloc inside vrealloc_node_align_noprof().

Link: https://lkml.kernel.org/r/cover.1765978969.git.m.wieczorretman@pm.me
Link: https://lkml.kernel.org/r/38dece0a4074c43e48150d1e242f8242c73bf1a5.1764874575.git.m.wieczorretman@pm.me
Link: https://lore.kernel.org/all/e7e04692866d02e6d3b32bb43b998e5d17092ba4.1738686764.git.maciej.wieczor-retman@intel.com/ [1]
Link: https://lore.kernel.org/all/aMUrW1Znp1GEj7St@MiWiFi-R3L-srv/ [2]
Link: https://lore.kernel.org/all/CAPAsAGxDRv_uFeMYu9TwhBVWHCCtkSxoWY4xmFB_vowMbi8raw@mail.gmail.com/ [3]
Link: https://syzkaller.appspot.com/bug?extid=997752115a851cb0cf36 [4]
Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reported-by: syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68e243a2.050a0220.1696c6.007d.GAE@google.com/T/
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kasan.h |    1 +
 mm/kasan/hw_tags.c    |    2 +-
 mm/kasan/shadow.c     |    4 +++-
 mm/vmalloc.c          |    4 +++-
 4 files changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -28,6 +28,7 @@ typedef unsigned int __bitwise kasan_vma
 #define KASAN_VMALLOC_INIT		((__force kasan_vmalloc_flags_t)0x01u)
 #define KASAN_VMALLOC_VM_ALLOC		((__force kasan_vmalloc_flags_t)0x02u)
 #define KASAN_VMALLOC_PROT_NORMAL	((__force kasan_vmalloc_flags_t)0x04u)
+#define KASAN_VMALLOC_KEEP_TAG		((__force kasan_vmalloc_flags_t)0x08u)
 
 #define KASAN_VMALLOC_PAGE_RANGE 0x1 /* Apply exsiting page range */
 #define KASAN_VMALLOC_TLB_FLUSH  0x2 /* TLB flush */
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -361,7 +361,7 @@ void *__kasan_unpoison_vmalloc(const voi
 		return (void *)start;
 	}
 
-	tag = kasan_random_tag();
+	tag = (flags & KASAN_VMALLOC_KEEP_TAG) ? get_tag(start) : kasan_random_tag();
 	start = set_tag(start, tag);
 
 	/* Unpoison and initialize memory up to size. */
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -648,7 +648,9 @@ void *__kasan_unpoison_vmalloc(const voi
 	    !(flags & KASAN_VMALLOC_PROT_NORMAL))
 		return (void *)start;
 
-	start = set_tag(start, kasan_random_tag());
+	if (unlikely(!(flags & KASAN_VMALLOC_KEEP_TAG)))
+		start = set_tag(start, kasan_random_tag());
+
 	kasan_unpoison(start, size, false);
 	return (void *)start;
 }
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4176,7 +4176,9 @@ void *vrealloc_node_align_noprof(const v
 	 */
 	if (size <= alloced_size) {
 		kasan_unpoison_vmalloc(p + old_size, size - old_size,
-				       KASAN_VMALLOC_PROT_NORMAL);
+				       KASAN_VMALLOC_PROT_NORMAL |
+				       KASAN_VMALLOC_VM_ALLOC |
+				       KASAN_VMALLOC_KEEP_TAG);
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during


