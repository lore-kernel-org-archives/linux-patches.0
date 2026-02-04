Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1295A3D994;
	Wed,  4 Feb 2026 15:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218741; cv=none; b=F/EMg5x3ItQM+kP2/YzZ8z8mZuZ9M+Wbsh3E+80grmKRO73XQJ5X6Z7czoaU7w2IE5ISNmoKhUPHlojmXorkopFdRCQocvzM/V4tw8agmnaRtlPa4V1nzPoqMgoMMXeAmRspNNVH5N+XkaJ+P27DqlvsSF51iQybMlMdonfcBds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218741; c=relaxed/simple;
	bh=OXoCMu3ON9hTMBJcXPwdnsBoTa4GrppF81mVktQFAEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JXfaPj13vUArz5sQUr771UtwXTWqZflXNvq/1Y+3JKMYKv7fOCHJXUNXcNqJu6FI7hzYo9h+Rtt6O08UjOTNiKmeJU6Opdt8cT0d4Y2P7tsX2quMemjaMwPLlND3PTxuNeibwOHxJ5WaAN4gcPcbylGzF1tovRZL7ajCANKtkOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxqKrwr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxqKrwr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F70C4CEF7;
	Wed,  4 Feb 2026 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218741;
	bh=OXoCMu3ON9hTMBJcXPwdnsBoTa4GrppF81mVktQFAEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxqKrwr2mF3m05pWa9uWAuIxePt3rf6aZMuhn0erDcFxLM37aP6TK1ep4gKx+rFmP
	 034zoy7i7QsE8Yh+AHWer7YVcS1+pcovi5/LzirBTBooaIcelS9KkbrQ687S7Nw3/e
	 tuhQhNZ4q7b+RPJkOaKS9E4YWn+URZGCNSAVeGxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	joonki.min@samsung-slsi.corp-partner.google.com,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 46/87] mm/kasan: fix KASAN poisoning in vrealloc()
Date: Wed,  4 Feb 2026 15:40:44 +0100
Message-ID: <20260204143848.572525337@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Ryabinin <ryabinin.a.a@gmail.com>

commit 9b47d4eea3f7c1f620e95bda1d6221660bde7d7b upstream.

A KASAN warning can be triggered when vrealloc() changes the requested
size to a value that is not aligned to KASAN_GRANULE_SIZE.

    ------------[ cut here ]------------
    WARNING: CPU: 2 PID: 1 at mm/kasan/shadow.c:174 kasan_unpoison+0x40/0x48
    ...
    pc : kasan_unpoison+0x40/0x48
    lr : __kasan_unpoison_vmalloc+0x40/0x68
    Call trace:
     kasan_unpoison+0x40/0x48 (P)
     vrealloc_node_align_noprof+0x200/0x320
     bpf_patch_insn_data+0x90/0x2f0
     convert_ctx_accesses+0x8c0/0x1158
     bpf_check+0x1488/0x1900
     bpf_prog_load+0xd20/0x1258
     __sys_bpf+0x96c/0xdf0
     __arm64_sys_bpf+0x50/0xa0
     invoke_syscall+0x90/0x160

Introduce a dedicated kasan_vrealloc() helper that centralizes KASAN
handling for vmalloc reallocations.  The helper accounts for KASAN granule
alignment when growing or shrinking an allocation and ensures that partial
granules are handled correctly.

Use this helper from vrealloc_node_align_noprof() to fix poisoning logic.

[ryabinin.a.a@gmail.com: move kasan_enabled() check, fix build]
  Link: https://lkml.kernel.org/r/20260119144509.32767-1-ryabinin.a.a@gmail.com
Link: https://lkml.kernel.org/r/20260113191516.31015-1-ryabinin.a.a@gmail.com
Fixes: d699440f58ce ("mm: fix vrealloc()'s KASAN poisoning logic")
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reported-by: Maciej Żenczykowski <maze@google.com>
Reported-by: <joonki.min@samsung-slsi.corp-partner.google.com>
Closes: https://lkml.kernel.org/r/CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kasan.h |   14 ++++++++++++++
 mm/kasan/common.c     |   21 +++++++++++++++++++++
 mm/vmalloc.c          |    7 ++-----
 3 files changed, 37 insertions(+), 5 deletions(-)

--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -618,6 +618,17 @@ kasan_unpoison_vmap_areas(struct vm_stru
 		__kasan_unpoison_vmap_areas(vms, nr_vms, flags);
 }
 
+void __kasan_vrealloc(const void *start, unsigned long old_size,
+		unsigned long new_size);
+
+static __always_inline void kasan_vrealloc(const void *start,
+					unsigned long old_size,
+					unsigned long new_size)
+{
+	if (kasan_enabled())
+		__kasan_vrealloc(start, old_size, new_size);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline void kasan_populate_early_vm_area_shadow(void *start,
@@ -647,6 +658,9 @@ kasan_unpoison_vmap_areas(struct vm_stru
 			  kasan_vmalloc_flags_t flags)
 { }
 
+static inline void kasan_vrealloc(const void *start, unsigned long old_size,
+				unsigned long new_size) { }
+
 #endif /* CONFIG_KASAN_VMALLOC */
 
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -590,4 +590,25 @@ void __kasan_unpoison_vmap_areas(struct
 			__kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_TAG);
 	}
 }
+
+void __kasan_vrealloc(const void *addr, unsigned long old_size,
+		unsigned long new_size)
+{
+	if (new_size < old_size) {
+		kasan_poison_last_granule(addr, new_size);
+
+		new_size = round_up(new_size, KASAN_GRANULE_SIZE);
+		old_size = round_up(old_size, KASAN_GRANULE_SIZE);
+		if (new_size < old_size)
+			__kasan_poison_vmalloc(addr + new_size,
+					old_size - new_size);
+	} else if (new_size > old_size) {
+		old_size = round_down(old_size, KASAN_GRANULE_SIZE);
+		__kasan_unpoison_vmalloc(addr + old_size,
+					new_size - old_size,
+					KASAN_VMALLOC_PROT_NORMAL |
+					KASAN_VMALLOC_VM_ALLOC |
+					KASAN_VMALLOC_KEEP_TAG);
+	}
+}
 #endif
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4109,7 +4109,7 @@ void *vrealloc_noprof(const void *p, siz
 		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
 		vm->requested_size = size;
-		kasan_poison_vmalloc(p + size, old_size - size);
+		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
 	}
 
@@ -4117,16 +4117,13 @@ void *vrealloc_noprof(const void *p, siz
 	 * We already have the bytes available in the allocation; use them.
 	 */
 	if (size <= alloced_size) {
-		kasan_unpoison_vmalloc(p + old_size, size - old_size,
-				       KASAN_VMALLOC_PROT_NORMAL |
-				       KASAN_VMALLOC_VM_ALLOC |
-				       KASAN_VMALLOC_KEEP_TAG);
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during
 		 * realloc shrink time.
 		 */
 		vm->requested_size = size;
+		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
 	}
 


