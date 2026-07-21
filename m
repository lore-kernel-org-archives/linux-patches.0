Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E89471268;
	Tue, 21 Jul 2026 20:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664534; cv=none; b=VY4qtddoX7+oL9B4ywD+BOKln3zVYZuO5RY7UUj4MtcReueMjouNwPcJHXQF2ZaWcy2EY1wiH8QKQlkW/kohuzuJgnwnGQcDYQb36a8I92IqD9qtxhX2AUE1FG0w85/I2mcJ/kn7thtDKCQSGKCq2MPdr1yFnXFJc2c9Pwql4O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664534; c=relaxed/simple;
	bh=jALdpwUyarZiwVxCZrr/4StgL4Gu+l/j2pwqL7fynAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYDj52H/oK5t1KI36K646m9cr6TwkncOpY1kIzvIhX1CwneYxjXspjZkTfqkblGk+JY+4/g5dJG4XWiEnwNRwkKxBHEJRhRVyuDurASubK4vSyj2w+a0Q2kljXLDth9Rz+2Zy/L2DI32zz+3EymMkO3dCoGCKyyJdHI9MotSrkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOP3vSJW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOP3vSJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8616A1F000E9;
	Tue, 21 Jul 2026 20:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664533;
	bh=aA94nzVBivnCCrH4TWBGlOgITXAKZYS+Wuu/JpLrfho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOP3vSJW9WsQ2lxEUmEzpvZ2lFv6wE+u3t4IjjfuCCaYFNVXrsFE+4x8REB9WUt8v
	 78XayJ0aSy77NBIhTIwTpgAdcSMY+400BPlUEf2FN4A3NNRV17jWUaXdiqzsJVNFeM
	 QM136faRXsVPk7VJbIjYhV8RbsGnP/XlmCNa1BQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 1235/1276] slab: Introduce kmalloc_flex() and family
Date: Tue, 21 Jul 2026 17:27:58 +0200
Message-ID: <20260721152513.726931907@linuxfoundation.org>
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

commit e4c8b46b924eb8de66c6f0accc9cdd0c2e8fa23b upstream.

As done for kmalloc_obj*(), introduce a type-aware allocator for flexible
arrays, which may also have "counted_by" annotations:

	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);

becomes:

	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);

The internal use of __flex_counter() allows for automatically setting
the counter member of a struct's flexible array member when it has
been annotated with __counted_by(), avoiding any missed early size
initializations while __counted_by() annotations are added to the
kernel. Additionally, this also checks for "too large" allocations based
on the type size of the counter variable. For example:

	if (count > type_max(ptr->flex_counter))
		fail...;
	size = struct_size(ptr, flex_member, count);
	ptr = kmalloc(size, gfp);
	if (!ptr)
		fail...;
	ptr->flex_counter = count;

becomes (n.b. unchanged from earlier example):

	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
	if (!ptr)
		fail...;
	ptr->flex_counter = count;

Note that manual initialization of the flexible array counter is still
required (at some point) after allocation as not all compiler versions
support the __counted_by annotation yet. But doing it internally makes
sure they cannot be missed when __counted_by _is_ available, meaning
that the bounds checker will not trip due to the lack of "early enough"
initializations that used to work before enabling the stricter bounds
checking. For example:

	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
	fill(ptr->flex, count);
	ptr->flex_count = count;

This works correctly before adding a __counted_by annotation (since
nothing is checking ptr->flex accesses against ptr->flex_count). After
adding the annotation, the bounds sanitizer would trip during fill()
because ptr->flex_count wasn't set yet. But with kmalloc_flex() setting
ptr->flex_count internally at allocation time, the existing code works
without needing to move the ptr->flex_count assignment before the call
to fill(). (This has been a stumbling block for __counted_by adoption.)

Link: https://patch.msgid.link/20251203233036.3212363-4-kees@kernel.org
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Kees Cook <kees@kernel.org>
[Backport-notes: Removed the actual flex counter handling.  That's a new
 feature, which isn't necessary for just adding the new allocation APIs
 to get backports to apply cleanly.  Also, the allocation-time overflow
 check in the upstream commit was reverted upstream.]
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/deprecated.rst |    7 +++++
 include/linux/slab.h                 |   42 +++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -387,6 +387,7 @@ allocations. For example, these open cod
 	ptr = kzalloc(sizeof(*ptr), gfp);
 	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
 	ptr = kcalloc(count, sizeof(*ptr), gfp);
+	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
 	ptr = kmalloc(sizeof(struct foo, gfp);
 
 become, respectively::
@@ -395,4 +396,10 @@ become, respectively::
 	ptr = kzalloc_obj(*ptr, gfp);
 	ptr = kmalloc_objs(*ptr, count, gfp);
 	ptr = kzalloc_objs(*ptr, count, gfp);
+	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
 	__auto_type ptr = kmalloc_obj(struct foo, gfp);
+
+If `ptr->flex_member` is annotated with __counted_by(), the allocation
+will automatically fail if `count` is larger than the maximum
+representable value that can be stored in the counter member associated
+with `flex_member`.
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -901,6 +901,27 @@ static __always_inline __alloc_size(1) v
 })
 
 /**
+ * __alloc_flex - Allocate an object that has a trailing flexible array
+ * @KMALLOC: kmalloc wrapper function to use for allocation.
+ * @GFP: GFP flags for the allocation.
+ * @TYPE: type of structure to allocate space for.
+ * @FAM: The name of the flexible array member of @TYPE structure.
+ * @COUNT: how many @FAM elements to allocate space for.
+ *
+ * Returns: Newly allocated pointer to @TYPE with @COUNT-many trailing
+ * @FAM elements, or NULL on failure or if @COUNT cannot be represented
+ * by the member of @TYPE that counts the @FAM elements (annotated via
+ * __counted_by()).
+ */
+#define __alloc_flex(KMALLOC, GFP, TYPE, FAM, COUNT)			\
+({									\
+	const size_t __count = (COUNT);					\
+	const size_t __obj_size = struct_size_t(TYPE, FAM, __count);	\
+	TYPE *__obj_ptr = KMALLOC(__obj_size, GFP);			\
+	__obj_ptr;							\
+})
+
+/**
  * kmalloc_obj - Allocate a single instance of the given type
  * @VAR_OR_TYPE: Variable or type to allocate.
  * @GFP: GFP flags for the allocation.
@@ -923,23 +944,44 @@ static __always_inline __alloc_size(1) v
 #define kmalloc_objs(VAR_OR_TYPE, COUNT, GFP)		\
 	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), COUNT)
 
+/**
+ * kmalloc_flex - Allocate a single instance of the given flexible structure
+ * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
+ * @FAM: The name of the flexible array member of the structure.
+ * @COUNT: How many flexible array member elements are desired.
+ * @GFP: GFP flags for the allocation.
+ *
+ * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
+ * failure. If @FAM has been annotated with __counted_by(), the allocation
+ * will immediately fail if @COUNT is larger than what the type of the
+ * struct's counter variable can represent.
+ */
+#define kmalloc_flex(VAR_OR_TYPE, FAM, COUNT, GFP)	\
+	__alloc_flex(kmalloc, GFP, typeof(VAR_OR_TYPE),	FAM, COUNT)
+
 /* All kzalloc aliases for kmalloc_(obj|objs|flex). */
 #define kzalloc_obj(P, GFP)				\
 	__alloc_objs(kzalloc, GFP, typeof(P), 1)
 #define kzalloc_objs(P, COUNT, GFP)			\
 	__alloc_objs(kzalloc, GFP, typeof(P), COUNT)
+#define kzalloc_flex(P, FAM, COUNT, GFP)		\
+	__alloc_flex(kzalloc, GFP, typeof(P), FAM, COUNT)
 
 /* All kvmalloc aliases for kmalloc_(obj|objs|flex). */
 #define kvmalloc_obj(P, GFP)				\
 	__alloc_objs(kvmalloc, GFP, typeof(P), 1)
 #define kvmalloc_objs(P, COUNT, GFP)			\
 	__alloc_objs(kvmalloc, GFP, typeof(P), COUNT)
+#define kvmalloc_flex(P, FAM, COUNT, GFP)		\
+	__alloc_flex(kvmalloc, GFP, typeof(P), FAM, COUNT)
 
 /* All kvzalloc aliases for kmalloc_(obj|objs|flex). */
 #define kvzalloc_obj(P, GFP)				\
 	__alloc_objs(kvzalloc, GFP, typeof(P), 1)
 #define kvzalloc_objs(P, COUNT, GFP)			\
 	__alloc_objs(kvzalloc, GFP, typeof(P), COUNT)
+#define kvzalloc_flex(P, FAM, COUNT, GFP)		\
+	__alloc_flex(kvzalloc, GFP, typeof(P), FAM, COUNT)
 
 #define kmem_buckets_alloc(_b, _size, _flags)	\
 	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))


