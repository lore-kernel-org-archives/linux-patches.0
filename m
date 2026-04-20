Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C237A33F5A9;
	Mon, 20 Apr 2026 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701508; cv=none; b=HpOs5ernk0bACg3fe+7hrk7X3RO/+saik/axkcFHciYAbacsUB6rAigxK7v+loeGFimkTHFbenZGooDFfUtdxfeJrrvNbv4byoCzD9QALmmD5x3Nj07kTuVPVTJT4CaGIUtrsAnNjtIpfrzk2ylg2GzYfuxzDXhBu4ZxytFE45A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701508; c=relaxed/simple;
	bh=JLPym1bzU5BHh1TAAJo7cLMWqCCV8yO4TiBDeQz72gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mz1N1NhpIG7l/wPKPB2FOowaK2GqJrS/RyQHPd3V/S5GPydSzUst28xRw4c7fkfRsu1n3uSyqLFa/CealQ6aSE2DuS1/WStMBoranOfgMqqYyT9mVYZDnW03V8wRYpHsTIMnNK8hS2/GKVqN244srqdjl4aNuLmueafHl0sglrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HptBi4LP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HptBi4LP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B9EC19425;
	Mon, 20 Apr 2026 16:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701508;
	bh=JLPym1bzU5BHh1TAAJo7cLMWqCCV8yO4TiBDeQz72gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HptBi4LPQ9niOPSYs6nyb5E2HBXhEdM+8r+t4ggTa+4qgz9H1r8mqFRYfP2kGlgL3
	 f/f7nBqZAvhQgGDHc9yaFoO3zNaIjpKA/e5UrdW0mOPhfDb2sno+zziHzGKrKTYfDI
	 /j75tzCVcJOSa2qNy7FiHjEzLSV8obmIpL88ZKcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 141/162] x86-64/arm64/powerpc: clean up and rename __copy_from_user_flushcache
Date: Mon, 20 Apr 2026 17:42:53 +0200
Message-ID: <20260420153932.153499501@linuxfoundation.org>
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

commit 809b997a5ce945ab470f70c187048fe4f5df20bf upstream.

This finishes the work on these odd functions that were only implemented
by a handful of architectures.

The 'flushcache' function was only used from the iterator code, and
let's make it do the same thing that the nontemporal version does:
remove the two underscores and add the user address checking.

Yes, yes, the user address checking is also done at iovec import time,
but we have long since walked away from the old double-underscore thing
where we try to avoid address checking overhead at access time, and
these functions shouldn't be so special and old-fashioned.

The arm64 version already did the address check, in fact, so there it's
just a matter of renaming it.  For powerpc and x86-64 we now do the
proper user access boilerplate.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/uaccess.h   |    2 +-
 arch/powerpc/include/asm/uaccess.h |    3 +--
 arch/powerpc/lib/pmem.c            |   11 ++++++-----
 arch/x86/include/asm/uaccess_64.h  |    8 ++++----
 arch/x86/lib/usercopy_64.c         |    8 ++++----
 lib/iov_iter.c                     |    2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -480,7 +480,7 @@ extern __must_check long strnlen_user(co
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 extern unsigned long __must_check __copy_user_flushcache(void *to, const void __user *from, unsigned long n);
 
-static inline int __copy_from_user_flushcache(void *dst, const void __user *src, unsigned size)
+static inline size_t copy_from_user_flushcache(void *dst, const void __user *src, size_t size)
 {
 	kasan_check_write(dst, size);
 	return __copy_user_flushcache(dst, __uaccess_mask_ptr(src), size);
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -407,8 +407,7 @@ copy_mc_to_user(void __user *to, const v
 }
 #endif
 
-extern long __copy_from_user_flushcache(void *dst, const void __user *src,
-		unsigned size);
+extern size_t copy_from_user_flushcache(void *dst, const void __user *src, size_t size);
 
 static __must_check __always_inline bool user_access_begin(const void __user *ptr, size_t len)
 {
--- a/arch/powerpc/lib/pmem.c
+++ b/arch/powerpc/lib/pmem.c
@@ -66,15 +66,16 @@ EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
 /*
  * CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE symbols
  */
-long __copy_from_user_flushcache(void *dest, const void __user *src,
-		unsigned size)
+size_t copy_from_user_flushcache(void *dest, const void __user *src,
+				 size_t size)
 {
-	unsigned long copied, start = (unsigned long) dest;
+	unsigned long not_copied, start = (unsigned long) dest;
 
-	copied = __copy_from_user(dest, src, size);
+	src = mask_user_address(src);
+	not_copied = __copy_from_user(dest, src, size);
 	clean_pmem_range(start, start + size);
 
-	return copied;
+	return not_copied;
 }
 
 void memcpy_flushcache(void *dest, const void *src, size_t size)
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -149,7 +149,7 @@ raw_copy_to_user(void __user *dst, const
 
 #define copy_to_nontemporal copy_to_nontemporal
 extern size_t copy_to_nontemporal(void *dst, const void *src, size_t size);
-extern long __copy_user_flushcache(void *dst, const void __user *src, unsigned size);
+extern size_t copy_user_flushcache(void *dst, const void __user *src, size_t size);
 
 static inline int
 copy_from_user_inatomic_nontemporal(void *dst, const void __user *src,
@@ -164,11 +164,11 @@ copy_from_user_inatomic_nontemporal(void
 	return ret;
 }
 
-static inline int
-__copy_from_user_flushcache(void *dst, const void __user *src, unsigned size)
+static inline size_t
+copy_from_user_flushcache(void *dst, const void __user *src, size_t size)
 {
 	kasan_check_write(dst, size);
-	return __copy_user_flushcache(dst, src, size);
+	return copy_user_flushcache(dst, src, size);
 }
 
 /*
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -43,14 +43,14 @@ void arch_wb_cache_pmem(void *addr, size
 }
 EXPORT_SYMBOL_GPL(arch_wb_cache_pmem);
 
-long __copy_user_flushcache(void *dst, const void __user *src, unsigned size)
+size_t copy_user_flushcache(void *dst, const void __user *src, size_t size)
 {
 	unsigned long flushed, dest = (unsigned long) dst;
-	long rc;
+	unsigned long rc;
 
-	stac();
+	src = masked_user_access_begin(src);
 	rc = copy_to_nontemporal(dst, (__force const void *)src, size);
-	clac();
+	user_access_end();
 
 	/*
 	 * copy_to_nontemporal() uses non-temporal stores for the bulk
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -284,7 +284,7 @@ static __always_inline
 size_t copy_from_user_iter_flushcache(void __user *iter_from, size_t progress,
 				      size_t len, void *to, void *priv2)
 {
-	return __copy_from_user_flushcache(to + progress, iter_from, len);
+	return copy_from_user_flushcache(to + progress, iter_from, len);
 }
 
 static __always_inline


