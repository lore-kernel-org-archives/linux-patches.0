Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00195A79B;
	Thu, 16 Jul 2026 13:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210383; cv=none; b=UE2o7j49jGPCM1xi4zkHFaJv/IEvhAvoyWrisOfT47zFHXMu6XLVtfYH2uuOqo9X2T5aneSg+HfMjM/FA7nqg/zNnIXMdgDTR0BdnvMfMRJeuzTZYGKk8eAG9qm5ueoFmiD34G75ljhsRbGpZyDz2rl8hHrzIJScKizGlgU+xgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210383; c=relaxed/simple;
	bh=/sMDQi5ECu565Iik1KISjAmEAUAguK2K78jmA5RX6G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNUxI0cdKK0YxzqLzX5NeMWrOupZnEXWU9K977ZJaP4eYWNkm/OQgHQTmp3HNDSGXxuhhNHjVBZkjBQRG3un4NDIv3XNLd5LHisBYP3wPc7aYnFpC22Jfpbs7UbAWv6z4FOLtIE1EidbAD4HkoGE1CUl6S83gG+i05CVD7OgaUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L94DSzP7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L94DSzP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516001F000E9;
	Thu, 16 Jul 2026 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210381;
	bh=zY6ei28TOLY/xRnpMa5XREzAAqJRbg/aftUw0BjwPhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L94DSzP7tLXu21J1DqiwlpP4gQjZEAahtZhSNN69SrHHE9fiQPqNGc4IBcLX18plJ
	 mfYkUCfejXlnf6/YQJuISxBbRuelBQRL/oOIEkxzizU/ZEqxSqJVgSkHU6wMno/wk7
	 qsKJ6Jd8Km5Gfj/cju7s2cVSrmH4pMTTyEqTWcZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 026/480] add default_gfp() helper macro and use it in the new *alloc_obj() helpers
Date: Thu, 16 Jul 2026 15:26:13 +0200
Message-ID: <20260716133045.260759401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e19e1b480ac73c3e62ffebbca1174f0f511f43e7 upstream.

Most simple allocations use GFP_KERNEL, and with the new allocation
helpers being introduced, let's just take advantage of that to simplify
that default case.

It's a numbers game:

    git grep 'alloc_obj(' |
	sed 's/.*\(GFP_[_A-Z]*\).*/\1/' |
	sort | uniq -c | sort -n | tail

shows that about 90% of all those new allocator instances just use that
standard GFP_KERNEL.

Those helpers are already macros, and we can easily just make it be the
default case when the gfp argument is missing.

And yes, we could do that for all the legacy interfaces too, but let's
keep it to just the new ones at least for now, since those all got
converted recently anyway, so this is not any "extra" noise outside of
that limited conversion.

And, in fact, I want to do this before doing the -rc1 release, exactly
so that we don't get extra merge conflicts.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/gfp.h  |    4 ++++
 include/linux/slab.h |   48 ++++++++++++++++++++++++------------------------
 2 files changed, 28 insertions(+), 24 deletions(-)

--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -13,6 +13,10 @@
 struct vm_area_struct;
 struct mempolicy;
 
+/* Helper macro to avoid gfp flags if they are the default one */
+#define __default_gfp(a,...) a
+#define default_gfp(...) __default_gfp(__VA_ARGS__ __VA_OPT__(,) GFP_KERNEL)
+
 /* Convert GFP flags to their corresponding migrate type */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
 #define GFP_MOVABLE_SHIFT 3
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1011,8 +1011,8 @@ void *kmalloc_nolock_noprof(size_t size,
  * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
  * on failure.
  */
-#define kmalloc_obj(VAR_OR_TYPE, GFP)			\
-	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), 1)
+#define kmalloc_obj(VAR_OR_TYPE, ...) \
+	__alloc_objs(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), 1)
 
 /**
  * kmalloc_objs - Allocate an array of the given type
@@ -1023,8 +1023,8 @@ void *kmalloc_nolock_noprof(size_t size,
  * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
  * or NULL on failure.
  */
-#define kmalloc_objs(VAR_OR_TYPE, COUNT, GFP)		\
-	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), COUNT)
+#define kmalloc_objs(VAR_OR_TYPE, COUNT, ...) \
+	__alloc_objs(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), COUNT)
 
 /**
  * kmalloc_flex - Allocate a single instance of the given flexible structure
@@ -1038,32 +1038,32 @@ void *kmalloc_nolock_noprof(size_t size,
  * will immediately fail if @COUNT is larger than what the type of the
  * struct's counter variable can represent.
  */
-#define kmalloc_flex(VAR_OR_TYPE, FAM, COUNT, GFP)	\
-	__alloc_flex(kmalloc, GFP, typeof(VAR_OR_TYPE),	FAM, COUNT)
+#define kmalloc_flex(VAR_OR_TYPE, FAM, COUNT, ...) \
+	__alloc_flex(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), FAM, COUNT)
 
 /* All kzalloc aliases for kmalloc_(obj|objs|flex). */
-#define kzalloc_obj(P, GFP)				\
-	__alloc_objs(kzalloc, GFP, typeof(P), 1)
-#define kzalloc_objs(P, COUNT, GFP)			\
-	__alloc_objs(kzalloc, GFP, typeof(P), COUNT)
-#define kzalloc_flex(P, FAM, COUNT, GFP)		\
-	__alloc_flex(kzalloc, GFP, typeof(P), FAM, COUNT)
+#define kzalloc_obj(P, ...) \
+	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
+#define kzalloc_objs(P, COUNT, ...) \
+	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), COUNT)
+#define kzalloc_flex(P, FAM, COUNT, ...)		\
+	__alloc_flex(kzalloc, default_gfp(__VA_ARGS__), typeof(P), FAM, COUNT)
 
 /* All kvmalloc aliases for kmalloc_(obj|objs|flex). */
-#define kvmalloc_obj(P, GFP)				\
-	__alloc_objs(kvmalloc, GFP, typeof(P), 1)
-#define kvmalloc_objs(P, COUNT, GFP)			\
-	__alloc_objs(kvmalloc, GFP, typeof(P), COUNT)
-#define kvmalloc_flex(P, FAM, COUNT, GFP)		\
-	__alloc_flex(kvmalloc, GFP, typeof(P), FAM, COUNT)
+#define kvmalloc_obj(P, ...) \
+	__alloc_objs(kvmalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
+#define kvmalloc_objs(P, COUNT, ...) \
+	__alloc_objs(kvmalloc, default_gfp(__VA_ARGS__), typeof(P), COUNT)
+#define kvmalloc_flex(P, FAM, COUNT, ...) \
+	__alloc_flex(kvmalloc, default_gfp(__VA_ARGS__), typeof(P), FAM, COUNT)
 
 /* All kvzalloc aliases for kmalloc_(obj|objs|flex). */
-#define kvzalloc_obj(P, GFP)				\
-	__alloc_objs(kvzalloc, GFP, typeof(P), 1)
-#define kvzalloc_objs(P, COUNT, GFP)			\
-	__alloc_objs(kvzalloc, GFP, typeof(P), COUNT)
-#define kvzalloc_flex(P, FAM, COUNT, GFP)		\
-	__alloc_flex(kvzalloc, GFP, typeof(P), FAM, COUNT)
+#define kvzalloc_obj(P, ...) \
+	__alloc_objs(kvzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
+#define kvzalloc_objs(P, COUNT, ...) \
+	__alloc_objs(kvzalloc, default_gfp(__VA_ARGS__), typeof(P), COUNT)
+#define kvzalloc_flex(P, FAM, COUNT, ...) \
+	__alloc_flex(kvzalloc, default_gfp(__VA_ARGS__), typeof(P), FAM, COUNT)
 
 #define kmem_buckets_alloc(_b, _size, _flags)	\
 	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))


