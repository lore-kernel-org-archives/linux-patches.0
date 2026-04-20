Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720AB2853F3;
	Mon, 20 Apr 2026 16:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701506; cv=none; b=HolNLs9viDUZCHWM6geQhGNfnvlDa2JdsC2mjIvYVExga+FwBnRPefGqW2GLma0av1gpvhKIKYorUZDhEPr3xN/CQgf1MbRB9Dn+6CXybZUVJTpjEVc6gP6EtjgQV20c8aJjCt07wRVcb0O1WcbE7Ee/dW+TXi/rVOVNJpW9MDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701506; c=relaxed/simple;
	bh=GXLHl44sfjyfbiiV3ic/scVPPNH4NAe7AgA6yE+g8kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApVkXJVr3dfCxUHZTTKFnzbFrpgUyuRQSWr0tln2rvvWLpl3kh7EbxHE8KTBDYM5ta3rGMp8sxCuWNqxGY64zUYIBZ6ImtXMR/Astkq6FyN5jrNZT4SaGnJTMFQLbCXtW3XDRuMMkj4CzXHdH16JRlujm8dqT//OmMLFm4TIoTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VH9E5gyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VH9E5gyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B21C2BCB4;
	Mon, 20 Apr 2026 16:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701506;
	bh=GXLHl44sfjyfbiiV3ic/scVPPNH4NAe7AgA6yE+g8kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VH9E5gyr5UmoQTmNAWDygMHIjKVWxp4mliCEGWmbTywgfYfJzYlSaDRtOamn1Pc/7
	 p+ebFdwUs6cyRIZMRyfc7Tbx4pe44u+0pHX3DzyiJp3gtmHOQJ/2+CFPTrCUrWBgVL
	 0zlKH9NYxWreRebvW7O1oGPWZeOkbhLduQZddORw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 140/162] x86: rename and clean up __copy_from_user_inatomic_nocache()
Date: Mon, 20 Apr 2026 17:42:52 +0200
Message-ID: <20260420153932.117331806@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5de7bcaadf160c1716b20a263cf8f5b06f658959 upstream.

Similarly to the previous commit, this renames the somewhat confusingly
named function.  But in this case, it was at least less confusing: the
__copy_from_user_inatomic_nocache is indeed copying from user memory,
and it is indeed ok to be used in an atomic context, so it will not warn
about it.

But the previous commit also removed the NTB mis-use of the
__copy_from_user_inatomic_nocache() function, and as a result every
call-site is now _actually_ doing a real user copy.  That means that we
can now do the proper user pointer verification too.

End result: add proper address checking, remove the double underscores,
and change the "nocache" to "nontemporal" to more accurately describe
what this x86-only function actually does.  It might be worth noting
that only the target is non-temporal: the actual user accesses are
normal memory accesses.

Also worth noting is that non-x86 targets (and on older 32-bit x86 CPU's
before XMM2 in the Pentium III) we end up just falling back on a regular
user copy, so nothing can actually depend on the non-temporal semantics,
but that has always been true.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/uaccess.h    |    2 +-
 arch/x86/include/asm/uaccess_32.h |    8 +-------
 arch/x86/include/asm/uaccess_64.h |    3 ++-
 arch/x86/lib/usercopy_32.c        |    9 +++++----
 drivers/gpu/drm/i915/i915_gem.c   |    2 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c   |    2 +-
 include/linux/uaccess.h           |   11 ++++++++---
 lib/iov_iter.c                    |    2 +-
 8 files changed, 20 insertions(+), 19 deletions(-)

--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -508,7 +508,7 @@ extern struct movsl_mask {
 } ____cacheline_aligned_in_smp movsl_mask;
 #endif
 
-#define ARCH_HAS_NOCACHE_UACCESS 1
+#define ARCH_HAS_NONTEMPORAL_UACCESS 1
 
 /*
  * The "unsafe" user accesses aren't really "unsafe", but the naming
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -26,13 +26,7 @@ raw_copy_from_user(void *to, const void
 	return __copy_user_ll(to, (__force const void *)from, n);
 }
 
-static __always_inline unsigned long
-__copy_from_user_inatomic_nocache(void *to, const void __user *from,
-				  unsigned long n)
-{
-       return __copy_from_user_ll_nocache_nozero(to, from, n);
-}
-
+unsigned long __must_check copy_from_user_inatomic_nontemporal(void *, const void __user *, unsigned long n);
 unsigned long __must_check clear_user(void __user *mem, unsigned long len);
 unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
 
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -152,11 +152,12 @@ extern size_t copy_to_nontemporal(void *
 extern long __copy_user_flushcache(void *dst, const void __user *src, unsigned size);
 
 static inline int
-__copy_from_user_inatomic_nocache(void *dst, const void __user *src,
+copy_from_user_inatomic_nontemporal(void *dst, const void __user *src,
 				  unsigned size)
 {
 	long ret;
 	kasan_check_write(dst, size);
+	src = mask_user_address(src);
 	stac();
 	ret = copy_to_nontemporal(dst, (__force const void *)src, size);
 	clac();
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -322,10 +322,11 @@ unsigned long __copy_user_ll(void *to, c
 }
 EXPORT_SYMBOL(__copy_user_ll);
 
-unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *from,
+unsigned long copy_from_user_inatomic_nontemporal(void *to, const void __user *from,
 					unsigned long n)
 {
-	__uaccess_begin_nospec();
+	if (!user_access_begin(from, n))
+		return n;
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if (n > 64 && static_cpu_has(X86_FEATURE_XMM2))
 		n = __copy_user_intel_nocache(to, from, n);
@@ -334,7 +335,7 @@ unsigned long __copy_from_user_ll_nocach
 #else
 	__copy_user(to, from, n);
 #endif
-	__uaccess_end();
+	user_access_end();
 	return n;
 }
-EXPORT_SYMBOL(__copy_from_user_ll_nocache_nozero);
+EXPORT_SYMBOL(copy_from_user_inatomic_nontemporal);
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -519,7 +519,7 @@ ggtt_write(struct io_mapping *mapping,
 
 	/* We can use the cpu mem copy function because this is X86. */
 	vaddr = io_mapping_map_atomic_wc(mapping, base);
-	unwritten = __copy_from_user_inatomic_nocache((void __force *)vaddr + offset,
+	unwritten = copy_from_user_inatomic_nontemporal((void __force *)vaddr + offset,
 						      user_data, length);
 	io_mapping_unmap_atomic(vaddr);
 	if (unwritten) {
--- a/drivers/gpu/drm/qxl/qxl_ioctl.c
+++ b/drivers/gpu/drm/qxl/qxl_ioctl.c
@@ -182,7 +182,7 @@ static int qxl_process_single_command(st
 
 	/* TODO copy slow path code from i915 */
 	fb_cmd = qxl_bo_kmap_atomic_page(qdev, cmd_bo, (release->release_offset & PAGE_MASK));
-	unwritten = __copy_from_user_inatomic_nocache
+	unwritten = copy_from_user_inatomic_nontemporal
 		(fb_cmd + sizeof(union qxl_release_info) + (release->release_offset & ~PAGE_MASK),
 		 u64_to_user_ptr(cmd->command), cmd->command_size);
 
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -318,16 +318,21 @@ static inline size_t probe_subpage_write
 
 #endif /* CONFIG_ARCH_HAS_SUBPAGE_FAULTS */
 
-#ifndef ARCH_HAS_NOCACHE_UACCESS
+#ifndef ARCH_HAS_NONTEMPORAL_UACCESS
 
 static inline __must_check unsigned long
-__copy_from_user_inatomic_nocache(void *to, const void __user *from,
+copy_from_user_inatomic_nontemporal(void *to, const void __user *from,
 				  unsigned long n)
 {
+	if (can_do_masked_user_access())
+		from = mask_user_address(from);
+	else
+		if (!access_ok(from, n))
+			return n;
 	return __copy_from_user_inatomic(to, from, n);
 }
 
-#endif		/* ARCH_HAS_NOCACHE_UACCESS */
+#endif		/* ARCH_HAS_NONTEMPORAL_UACCESS */
 
 extern __must_check int check_zeroed_user(const void __user *from, size_t size);
 
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -265,7 +265,7 @@ static __always_inline
 size_t copy_from_user_iter_nocache(void __user *iter_from, size_t progress,
 				   size_t len, void *to, void *priv2)
 {
-	return __copy_from_user_inatomic_nocache(to + progress, iter_from, len);
+	return copy_from_user_inatomic_nontemporal(to + progress, iter_from, len);
 }
 
 size_t _copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)


