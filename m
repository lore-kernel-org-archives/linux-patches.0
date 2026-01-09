Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5002737EE;
	Fri,  9 Jan 2026 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961056; cv=none; b=M3bPagOXDwVe76GOHy8TVeSHevMq3ILfKK9kETR4HUn/em0JGOpiu6sg6KoiuOtcxjvRiVAurBGaPhB4aEBDq1yzqZa/wLH/lMCD9/Exzphgb56IsV8lpXACQ+JppBMZ2DipjiuPNGh08kFIHH5rCHKt+SdFFOFZZ8wBbV3uWig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961056; c=relaxed/simple;
	bh=NN9++4CKKlSS/30E/SVUv/J68cvf2IRXzQ3ksfi5PPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnxHWZ3JYKsM93AeNL3r0ez39ZfN4Kv5TcfNUcanIJJUghnDft2hSPYi98XgKd5iTjIGotImsgx40nSQikkF50hphkREp/Z34ymHQcNG3WoWP4EhslmG4N5OwxEH2afF71EaaqYF2ff804loK2JB3HRSHRkQkLgr3NlGd6Yqa8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mv6IVEx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mv6IVEx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D56C4CEF1;
	Fri,  9 Jan 2026 12:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961056;
	bh=NN9++4CKKlSS/30E/SVUv/J68cvf2IRXzQ3ksfi5PPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mv6IVEx6cjtjK3V7tdyXvl/SRffxpSNMbO2U3hlk7b8jzWvmwK0mAKqBOPQc9PLsr
	 AQsIor2rqzp1dtfVnNpa92k61+11q3JMDhe98dLRoRjxsbcIDIIDOJcjcbsS3x3rCq
	 U4bC+i7OVk+TFO5b6mxqJCWw2/GNiO7kITLDRVQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 602/737] kasan: refactor pcpu kasan vmalloc unpoison
Date: Fri,  9 Jan 2026 12:42:21 +0100
Message-ID: <20260109112156.653607346@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

commit 6f13db031e27e88213381039032a9cc061578ea6 upstream.

A KASAN tag mismatch, possibly causing a kernel panic, can be observed
on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
It was reported on arm64 and reproduced on x86. It can be explained in
the following points:

1. There can be more than one virtual memory chunk.
2. Chunk's base address has a tag.
3. The base address points at the first chunk and thus inherits
   the tag of the first chunk.
4. The subsequent chunks will be accessed with the tag from the
   first chunk.
5. Thus, the subsequent chunks need to have their tag set to
   match that of the first chunk.

Refactor code by reusing __kasan_unpoison_vmalloc in a new helper in
preparation for the actual fix.

Link: https://lkml.kernel.org/r/eb61d93b907e262eefcaa130261a08bcb6c5ce51.1764874575.git.m.wieczorretman@pm.me
Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kasan.h |   15 +++++++++++++++
 mm/kasan/common.c     |   17 +++++++++++++++++
 mm/vmalloc.c          |    4 +---
 3 files changed, 33 insertions(+), 3 deletions(-)

--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -423,6 +423,16 @@ static __always_inline void kasan_poison
 		__kasan_poison_vmalloc(start, size);
 }
 
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+				 kasan_vmalloc_flags_t flags);
+static __always_inline void
+kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+			  kasan_vmalloc_flags_t flags)
+{
+	if (kasan_enabled())
+		__kasan_unpoison_vmap_areas(vms, nr_vms, flags);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline void kasan_populate_early_vm_area_shadow(void *start,
@@ -446,6 +456,11 @@ static inline void *kasan_unpoison_vmall
 static inline void kasan_poison_vmalloc(const void *start, unsigned long size)
 { }
 
+static __always_inline void
+kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+			  kasan_vmalloc_flags_t flags)
+{ }
+
 #endif /* CONFIG_KASAN_VMALLOC */
 
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -26,6 +26,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/bug.h>
+#include <linux/vmalloc.h>
 
 #include "kasan.h"
 #include "../slab.h"
@@ -450,3 +451,19 @@ bool __kasan_check_byte(const void *addr
 	}
 	return true;
 }
+
+#ifdef CONFIG_KASAN_VMALLOC
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+				 kasan_vmalloc_flags_t flags)
+{
+	unsigned long size;
+	void *addr;
+	int area;
+
+	for (area = 0 ; area < nr_vms ; area++) {
+		size = vms[area]->size;
+		addr = vms[area]->addr;
+		vms[area]->addr = __kasan_unpoison_vmalloc(addr, size, flags);
+	}
+}
+#endif
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4196,9 +4196,7 @@ retry:
 	 * With hardware tag-based KASAN, marking is skipped for
 	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
 	 */
-	for (area = 0; area < nr_vms; area++)
-		vms[area]->addr = kasan_unpoison_vmalloc(vms[area]->addr,
-				vms[area]->size, KASAN_VMALLOC_PROT_NORMAL);
+	kasan_unpoison_vmap_areas(vms, nr_vms, KASAN_VMALLOC_PROT_NORMAL);
 
 	kfree(vas);
 	return vms;


