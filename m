Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E5D46D56D;
	Tue, 21 Jul 2026 20:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664531; cv=none; b=oBySk7aCvCxpDVBl5Maqh/K1ddP4dv5H7DKHEP/+HJonqus7rhgn4blcVugGYVIeyJ7LWHBc9+4KmCv7d9vJfCVoEXW/BcEmLhObmOGOscjKiXlnGDrmcRNymSsyqPaYgGIFl04qE6AckWxQpcEDSip2M12NUdVinmPpHFVNNb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664531; c=relaxed/simple;
	bh=I2p7m7dMwbGrWWcT8O26Iq+tYtaxW3Yx6Ez7CsKyWsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLySjryh1PIAZV1s0FfAY/IC+f9T+fAs9hFevGhkS8lg+5pIGxwhV1xjjwMSp9Z7wO4kRqZWKMkLZRpXKx4Y/32Yl0EmCBkfIF/RhXaFERjy38FSe/3NdP0iqesf7+ztTRTq6c6z5PcIYmafuanMbLARBuWKOq3OQ2JrIxzItfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvRPRCVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvRPRCVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6FA1F000E9;
	Tue, 21 Jul 2026 20:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664530;
	bh=UA5zugDUlendp10Px4VCU11AJm9DWrMXiz/5xsLkUPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvRPRCVX1hjzZHDTwUxwllgL74dDVdElHEWxTchLu7OCoLAcoCDyI6beMb8WFpwxW
	 2mwrUKD0/KPMywu2B/25nUR6qmHTYxC7l5hsSmsACuUSJdhAGqX3ue/ER8hW2Dzp1+
	 F2glPymLfB3HyJg53cY0bMQeMqYfAjK9MH44CUT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 1234/1276] slab: Introduce kmalloc_obj() and family
Date: Tue, 21 Jul 2026 17:27:57 +0200
Message-ID: <20260721152513.704490796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

commit 2932ba8d9c99875b98c951d9d3fd6d651d35df3a upstream.

Introduce type-aware kmalloc-family helpers to replace the common
idioms for single object and arrays of objects allocation:

	ptr = kmalloc(sizeof(*ptr), gfp);
	ptr = kmalloc(sizeof(struct some_obj_name), gfp);
	ptr = kzalloc(sizeof(*ptr), gfp);
	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
	ptr = kcalloc(count, sizeof(*ptr), gfp);

These become, respectively:

	ptr = kmalloc_obj(*ptr, gfp);
	ptr = kmalloc_obj(*ptr, gfp);
	ptr = kzalloc_obj(*ptr, gfp);
	ptr = kmalloc_objs(*ptr, count, gfp);
	ptr = kzalloc_objs(*ptr, count, gfp);

Beyond the other benefits outlined below, the primary ergonomic benefit
is the elimination of needing "sizeof" nor the type name, and the
enforcement of assignment types (they do not return "void *", but rather
a pointer to the type of the first argument). The type name _can_ be
used, though, in the case where an assignment is indirect (e.g. via
"return"). This additionally allows[1] variables to be declared via
__auto_type:

	__auto_type ptr = kmalloc_obj(struct foo, gfp);

Internal introspection of the allocated type now becomes possible,
allowing for future alignment-aware choices to be made by the allocator
and future hardening work that can be type sensitive. For example,
adding __alignof(*ptr) as an argument to the internal allocators so that
appropriate/efficient alignment choices can be made, or being able to
correctly choose per-allocation offset randomization within a bucket
that does not break alignment requirements.

Link: https://lore.kernel.org/all/CAHk-=wiCOTW5UftUrAnvJkr6769D29tF7Of79gUjdQHS_TkF5A@mail.gmail.com/ [1]
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://patch.msgid.link/20251203233036.3212363-1-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/deprecated.rst |   24 ++++++++++++++
 include/linux/slab.h                 |   58 +++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -372,3 +372,27 @@ The helper must be used::
 			DECLARE_FLEX_ARRAY(struct type2, two);
 		};
 	};
+
+Open-coded kmalloc assignments for struct objects
+-------------------------------------------------
+Performing open-coded kmalloc()-family allocation assignments prevents
+the kernel (and compiler) from being able to examine the type of the
+variable being assigned, which limits any related introspection that
+may help with alignment, wrap-around, or additional hardening. The
+kmalloc_obj()-family of macros provide this introspection, which can be
+used for the common code patterns for single, array, and flexible object
+allocations. For example, these open coded assignments::
+
+	ptr = kmalloc(sizeof(*ptr), gfp);
+	ptr = kzalloc(sizeof(*ptr), gfp);
+	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
+	ptr = kcalloc(count, sizeof(*ptr), gfp);
+	ptr = kmalloc(sizeof(struct foo, gfp);
+
+become, respectively::
+
+	ptr = kmalloc_obj(*ptr, gfp);
+	ptr = kzalloc_obj(*ptr, gfp);
+	ptr = kmalloc_objs(*ptr, count, gfp);
+	ptr = kzalloc_objs(*ptr, count, gfp);
+	__auto_type ptr = kmalloc_obj(struct foo, gfp);
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_SLAB_H
 #define	_LINUX_SLAB_H
 
+#include <linux/bug.h>
 #include <linux/cache.h>
 #include <linux/gfp.h>
 #include <linux/overflow.h>
@@ -883,6 +884,63 @@ static __always_inline __alloc_size(1) v
 }
 #define kmalloc(...)				alloc_hooks(kmalloc_noprof(__VA_ARGS__))
 
+/**
+ * __alloc_objs - Allocate objects of a given type using
+ * @KMALLOC: which size-based kmalloc wrapper to allocate with.
+ * @GFP: GFP flags for the allocation.
+ * @TYPE: type to allocate space for.
+ * @COUNT: how many @TYPE objects to allocate.
+ *
+ * Returns: Newly allocated pointer to (first) @TYPE of @COUNT-many
+ * allocated @TYPE objects, or NULL on failure.
+ */
+#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
+({									\
+	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
+	(TYPE *)KMALLOC(__obj_size, GFP);				\
+})
+
+/**
+ * kmalloc_obj - Allocate a single instance of the given type
+ * @VAR_OR_TYPE: Variable or type to allocate.
+ * @GFP: GFP flags for the allocation.
+ *
+ * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
+ * on failure.
+ */
+#define kmalloc_obj(VAR_OR_TYPE, GFP)			\
+	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), 1)
+
+/**
+ * kmalloc_objs - Allocate an array of the given type
+ * @VAR_OR_TYPE: Variable or type to allocate an array of.
+ * @COUNT: How many elements in the array.
+ * @GFP: GFP flags for the allocation.
+ *
+ * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
+ * or NULL on failure.
+ */
+#define kmalloc_objs(VAR_OR_TYPE, COUNT, GFP)		\
+	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), COUNT)
+
+/* All kzalloc aliases for kmalloc_(obj|objs|flex). */
+#define kzalloc_obj(P, GFP)				\
+	__alloc_objs(kzalloc, GFP, typeof(P), 1)
+#define kzalloc_objs(P, COUNT, GFP)			\
+	__alloc_objs(kzalloc, GFP, typeof(P), COUNT)
+
+/* All kvmalloc aliases for kmalloc_(obj|objs|flex). */
+#define kvmalloc_obj(P, GFP)				\
+	__alloc_objs(kvmalloc, GFP, typeof(P), 1)
+#define kvmalloc_objs(P, COUNT, GFP)			\
+	__alloc_objs(kvmalloc, GFP, typeof(P), COUNT)
+
+/* All kvzalloc aliases for kmalloc_(obj|objs|flex). */
+#define kvzalloc_obj(P, GFP)				\
+	__alloc_objs(kvzalloc, GFP, typeof(P), 1)
+#define kvzalloc_objs(P, COUNT, GFP)			\
+	__alloc_objs(kvzalloc, GFP, typeof(P), COUNT)
+
 #define kmem_buckets_alloc(_b, _size, _flags)	\
 	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))
 


