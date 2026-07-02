Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F083093DD;
	Thu,  2 Jul 2026 16:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011584; cv=none; b=CbKSdULCOTdSGVPHFTxJG2hjU7Ab/A9zDOmfQC/mgqs87Uv0eCssORrTPxEJX0xiyBqkIldV9FYw326sY/rff048yIXKwGjGqlY9NPKF+RuaELt8RIHXQUMbfy4zmv60WZKrOBYeybDCeNpHtynjCoXERRqV+x1VmHeoDb2BjD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011584; c=relaxed/simple;
	bh=80WQnAQnVRbZjTW1oMZfEyeW+ZAoL4J4IJc1Q3Un53E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1p3VDVPPm4Zymwa7XFHbZ4FMG4F4C9KWleuhXkgY2BbauU8rKoDvnxVcaJsrjmPqOXT8c2M2j7yfKa8LKEfhcS+YL2XMEtbARliSm8keWDeGPS+sRf2NGan8wP6sPBHYonmwE7lMoNWiawKy6Zb1y9bqXtUH4evvkN443IE/0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=to6MKoaU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="to6MKoaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D421F00A3D;
	Thu,  2 Jul 2026 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011582;
	bh=I1vuSd1VuKqDg13rRFzlJfxe/UyUuWBBKCgoChwt9Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=to6MKoaUIH0m1n6oml3h30KmyHSuNO7pdnuz2V1crzraod6GTVdfQM4lnXWZVTqvV
	 mcSZTtBNO/xQvklgjnQHu1a0/5/q5r0p6GXf/UEoOj39HekRFLaP9MVTBjMDNE7jPw
	 6dmv4DSOAHk2qa5e0z2U1zhbaKW2xKuWrBnXNJ5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 048/120] userfaultfd: build __VMA_UFFD_FLAGS from config-gated masks
Date: Thu,  2 Jul 2026 18:20:44 +0200
Message-ID: <20260702155113.958927002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit cc7a9f6e57c4f71e8e1fee3274b1ae8770f2a743 upstream.

The VMA flags bitmap is a single word today: NUM_VMA_FLAG_BITS is
BITS_PER_LONG, so on 32-bit vma_flags_t holds only 32 bits.  (The bitmap
type exists so this can grow past BITS_PER_LONG later; until it does,
anything declared above the first word is out of range on 32-bit.) The bit
enum nevertheless declares some bits unconditionally above BITS_PER_LONG
-- VMA_UFFD_MINOR_BIT is 41, with VM_UFFD_MINOR == VM_NONE on 32-bit so no
VMA actually carries the bit.

__VMA_UFFD_FLAGS feeds VMA_UFFD_MINOR_BIT to mk_vma_flags()
unconditionally.  On 32-bit that becomes __set_bit(41, &one_long), a write
one word past the end of the single-word bitmap.  The compiler folds the
out-of-bounds store with wraparound (1UL << (41 % 32) == bit 9) into the
first word; bit 9 is already in __VMA_UFFD_FLAGS so the mask happens to
come out right today, but it is an out-of-bounds write all the same, and
any high-numbered bit whose mod-BITS_PER_LONG position is otherwise unused
would silently OR an extra bit into the mask.

Rather than feed bit numbers that may not exist on the current build to
mk_vma_flags(), build the mask from whole per-mode masks that collapse to
EMPTY_VMA_FLAGS when their feature is unavailable.  Add
mk_vma_flags_from_masks() for that, and define VMA_UFFD_MISSING / _WP /
_MINOR alongside the VM_UFFD_* flags, gating VMA_UFFD_MINOR on the same
config as VM_UFFD_MINOR (which implies 64BIT, where bit 41 fits).  An
out-of-range bit is then never materialised, on any arch, and the in-range
fast path stays a compile-time constant.

Link: https://lore.kernel.org/20260529172331.356655-7-kas@kernel.org
Fixes: 9ea35a25d51b ("mm: introduce VMA flags bitmap type")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h            |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/userfaultfd_k.h |    4 ++--
 2 files changed, 41 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -496,6 +496,21 @@ enum {
 #else
 #define VM_UFFD_MINOR	VM_NONE
 #endif
+
+/*
+ * vma_flags_t masks for the userfaultfd VMA flags. VMA_UFFD_MINOR is gated on
+ * the same config as VM_UFFD_MINOR -- which implies 64BIT, where the bit fits
+ * -- so an out-of-range bit is never fed to mk_vma_flags() on a build whose
+ * bitmap cannot hold it.
+ */
+#define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
+#define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
+#define VMA_UFFD_MINOR		mk_vma_flags(VMA_UFFD_MINOR_BIT)
+#else
+#define VMA_UFFD_MINOR		EMPTY_VMA_FLAGS
+#endif
+
 #ifdef CONFIG_64BIT
 #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
 #define VM_SEALED		INIT_VM_FLAG(SEALED)
@@ -1238,6 +1253,30 @@ static __always_inline void vma_flags_se
 #define vma_flags_set(flags, ...) \
 	vma_flags_set_mask(flags, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline vma_flags_t __mk_vma_flags_from_masks(size_t count,
+		const vma_flags_t *masks)
+{
+	vma_flags_t flags = EMPTY_VMA_FLAGS;
+	size_t i;
+
+	for (i = 0; i < count; i++)
+		vma_flags_set_mask(&flags, masks[i]);
+	return flags;
+}
+
+/*
+ * Combine pre-computed vma_flags_t masks into one value, e.g.:
+ *
+ * vma_flags_t flags = mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR);
+ *
+ * Unlike mk_vma_flags(), which takes bit numbers, this takes whole masks --
+ * each of which may be EMPTY_VMA_FLAGS when its feature is unavailable -- so a
+ * bit that does not exist on the current build is never materialised.
+ */
+#define mk_vma_flags_from_masks(...)					\
+	__mk_vma_flags_from_masks(COUNT_ARGS(__VA_ARGS__),		\
+		(const vma_flags_t []){__VA_ARGS__})
+
 /* Clear all of the to-clear flags in flags, non-atomically. */
 static __always_inline void vma_flags_clear_mask(vma_flags_t *flags,
 		vma_flags_t to_clear)
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -23,8 +23,8 @@
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
 
-#define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
-				      VMA_UFFD_MINOR_BIT)
+#define __VMA_UFFD_FLAGS mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP, \
+						 VMA_UFFD_MINOR)
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining


