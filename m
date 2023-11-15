Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2532F28369
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gpe8WMCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAACC4E779;
	Wed, 15 Nov 2023 20:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081607;
	bh=RCFZMXBoVSRi5Qhe0W7pfd6YPlBmw9pCa9aDpbTbL8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gpe8WMCqpE1nzdelkxGp5sjGn5z0Eie1YL4uSG8R3QNJ45y5AUYppDL+bU+Y659Lj
	 8pEdZS2ZXOp0aKZlUuzBwNMSI97sVNcX0D55qnXt/NZHVgHXwNTJPd2iVzv/k6jVGg
	 w55UKkpfCLpTlgf4LQxZZCUyn7YqQiBaceXepHyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Len Baker <len.baker@gmx.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/191] overflow: Implement size_t saturating arithmetic helpers
Date: Wed, 15 Nov 2023 15:44:48 -0500
Message-ID: <20231115204645.306955467@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit e1be43d9b5d0d1310dbd90185a8e5c7145dde40f ]

In order to perform more open-coded replacements of common allocation
size arithmetic, the kernel needs saturating (SIZE_MAX) helpers for
multiplication, addition, and subtraction. For example, it is common in
allocators, especially on realloc, to add to an existing size:

    p = krealloc(map->patch,
                 sizeof(struct reg_sequence) * (map->patch_regs + num_regs),
                 GFP_KERNEL);

There is no existing saturating replacement for this calculation, and
just leaving the addition open coded inside array_size() could
potentially overflow as well. For example, an overflow in an expression
for a size_t argument might wrap to zero:

    array_size(anything, something_at_size_max + 1) == 0

Introduce size_mul(), size_add(), and size_sub() helpers that
implicitly promote arguments to size_t and saturated calculations for
use in allocations. With these helpers it is also possible to redefine
array_size(), array3_size(), flex_array_size(), and struct_size() in
terms of the new helpers.

As with the check_*_overflow() helpers, the new helpers use __must_check,
though what is really desired is a way to make sure that assignment is
only to a size_t lvalue. Without this, it's still possible to introduce
overflow/underflow via type conversion (i.e. from size_t to int).
Enforcing this will currently need to be left to static analysis or
future use of -Wconversion.

Additionally update the overflow unit tests to force runtime evaluation
for the pathological cases.

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Len Baker <len.baker@gmx.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: d692873cbe86 ("gve: Use size_add() in call to struct_size()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/process/deprecated.rst |  20 ++++-
 include/linux/overflow.h             | 110 +++++++++++++++++----------
 lib/test_overflow.c                  |  98 ++++++++++++++++++++++++
 3 files changed, 184 insertions(+), 44 deletions(-)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index 9d83b8db88740..86ea327b7e3a7 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -70,6 +70,9 @@ Instead, the 2-factor form of the allocator should be used::
 
 	foo = kmalloc_array(count, size, GFP_KERNEL);
 
+Specifically, kmalloc() can be replaced with kmalloc_array(), and
+kzalloc() can be replaced with kcalloc().
+
 If no 2-factor form is available, the saturate-on-overflow helpers should
 be used::
 
@@ -90,9 +93,20 @@ Instead, use the helper::
         array usage and switch to a `flexible array member
         <#zero-length-and-one-element-arrays>`_ instead.
 
-See array_size(), array3_size(), and struct_size(),
-for more details as well as the related check_add_overflow() and
-check_mul_overflow() family of functions.
+For other calculations, please compose the use of the size_mul(),
+size_add(), and size_sub() helpers. For example, in the case of::
+
+	foo = krealloc(current_size + chunk_size * (count - 3), GFP_KERNEL);
+
+Instead, use the helpers::
+
+	foo = krealloc(size_add(current_size,
+				size_mul(chunk_size,
+					 size_sub(count, 3))), GFP_KERNEL);
+
+For more details, also see array3_size() and flex_array_size(),
+as well as the related check_mul_overflow(), check_add_overflow(),
+check_sub_overflow(), and check_shl_overflow() family of functions.
 
 simple_strtol(), simple_strtoll(), simple_strtoul(), simple_strtoull()
 ----------------------------------------------------------------------
diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index ef74051d5cfed..35af574d006f5 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -250,81 +250,94 @@ static inline bool __must_check __must_check_overflow(bool overflow)
 }))
 
 /**
- * array_size() - Calculate size of 2-dimensional array.
- *
- * @a: dimension one
- * @b: dimension two
+ * size_mul() - Calculate size_t multiplication with saturation at SIZE_MAX
  *
- * Calculates size of 2-dimensional array: @a * @b.
+ * @factor1: first factor
+ * @factor2: second factor
  *
- * Returns: number of bytes needed to represent the array or SIZE_MAX on
- * overflow.
+ * Returns: calculate @factor1 * @factor2, both promoted to size_t,
+ * with any overflow causing the return value to be SIZE_MAX. The
+ * lvalue must be size_t to avoid implicit type conversion.
  */
-static inline __must_check size_t array_size(size_t a, size_t b)
+static inline size_t __must_check size_mul(size_t factor1, size_t factor2)
 {
 	size_t bytes;
 
-	if (check_mul_overflow(a, b, &bytes))
+	if (check_mul_overflow(factor1, factor2, &bytes))
 		return SIZE_MAX;
 
 	return bytes;
 }
 
 /**
- * array3_size() - Calculate size of 3-dimensional array.
+ * size_add() - Calculate size_t addition with saturation at SIZE_MAX
  *
- * @a: dimension one
- * @b: dimension two
- * @c: dimension three
- *
- * Calculates size of 3-dimensional array: @a * @b * @c.
+ * @addend1: first addend
+ * @addend2: second addend
  *
- * Returns: number of bytes needed to represent the array or SIZE_MAX on
- * overflow.
+ * Returns: calculate @addend1 + @addend2, both promoted to size_t,
+ * with any overflow causing the return value to be SIZE_MAX. The
+ * lvalue must be size_t to avoid implicit type conversion.
  */
-static inline __must_check size_t array3_size(size_t a, size_t b, size_t c)
+static inline size_t __must_check size_add(size_t addend1, size_t addend2)
 {
 	size_t bytes;
 
-	if (check_mul_overflow(a, b, &bytes))
-		return SIZE_MAX;
-	if (check_mul_overflow(bytes, c, &bytes))
+	if (check_add_overflow(addend1, addend2, &bytes))
 		return SIZE_MAX;
 
 	return bytes;
 }
 
-/*
- * Compute a*b+c, returning SIZE_MAX on overflow. Internal helper for
- * struct_size() below.
+/**
+ * size_sub() - Calculate size_t subtraction with saturation at SIZE_MAX
+ *
+ * @minuend: value to subtract from
+ * @subtrahend: value to subtract from @minuend
+ *
+ * Returns: calculate @minuend - @subtrahend, both promoted to size_t,
+ * with any overflow causing the return value to be SIZE_MAX. For
+ * composition with the size_add() and size_mul() helpers, neither
+ * argument may be SIZE_MAX (or the result with be forced to SIZE_MAX).
+ * The lvalue must be size_t to avoid implicit type conversion.
  */
-static inline __must_check size_t __ab_c_size(size_t a, size_t b, size_t c)
+static inline size_t __must_check size_sub(size_t minuend, size_t subtrahend)
 {
 	size_t bytes;
 
-	if (check_mul_overflow(a, b, &bytes))
-		return SIZE_MAX;
-	if (check_add_overflow(bytes, c, &bytes))
+	if (minuend == SIZE_MAX || subtrahend == SIZE_MAX ||
+	    check_sub_overflow(minuend, subtrahend, &bytes))
 		return SIZE_MAX;
 
 	return bytes;
 }
 
 /**
- * struct_size() - Calculate size of structure with trailing array.
- * @p: Pointer to the structure.
- * @member: Name of the array member.
- * @count: Number of elements in the array.
+ * array_size() - Calculate size of 2-dimensional array.
  *
- * Calculates size of memory needed for structure @p followed by an
- * array of @count number of @member elements.
+ * @a: dimension one
+ * @b: dimension two
  *
- * Return: number of bytes needed or SIZE_MAX on overflow.
+ * Calculates size of 2-dimensional array: @a * @b.
+ *
+ * Returns: number of bytes needed to represent the array or SIZE_MAX on
+ * overflow.
  */
-#define struct_size(p, member, count)					\
-	__ab_c_size(count,						\
-		    sizeof(*(p)->member) + __must_be_array((p)->member),\
-		    sizeof(*(p)))
+#define array_size(a, b)	size_mul(a, b)
+
+/**
+ * array3_size() - Calculate size of 3-dimensional array.
+ *
+ * @a: dimension one
+ * @b: dimension two
+ * @c: dimension three
+ *
+ * Calculates size of 3-dimensional array: @a * @b * @c.
+ *
+ * Returns: number of bytes needed to represent the array or SIZE_MAX on
+ * overflow.
+ */
+#define array3_size(a, b, c)	size_mul(size_mul(a, b), c)
 
 /**
  * flex_array_size() - Calculate size of a flexible array member
@@ -340,7 +353,22 @@ static inline __must_check size_t __ab_c_size(size_t a, size_t b, size_t c)
  * Return: number of bytes needed or SIZE_MAX on overflow.
  */
 #define flex_array_size(p, member, count)				\
-	array_size(count,						\
-		    sizeof(*(p)->member) + __must_be_array((p)->member))
+	size_mul(count,							\
+		 sizeof(*(p)->member) + __must_be_array((p)->member))
+
+/**
+ * struct_size() - Calculate size of structure with trailing flexible array.
+ *
+ * @p: Pointer to the structure.
+ * @member: Name of the array member.
+ * @count: Number of elements in the array.
+ *
+ * Calculates size of memory needed for structure @p followed by an
+ * array of @count number of @member elements.
+ *
+ * Return: number of bytes needed or SIZE_MAX on overflow.
+ */
+#define struct_size(p, member, count)					\
+	size_add(sizeof(*(p)), flex_array_size(p, member, count))
 
 #endif /* __LINUX_OVERFLOW_H */
diff --git a/lib/test_overflow.c b/lib/test_overflow.c
index 7a4b6f6c5473c..7a5a5738d2d21 100644
--- a/lib/test_overflow.c
+++ b/lib/test_overflow.c
@@ -588,12 +588,110 @@ static int __init test_overflow_allocation(void)
 	return err;
 }
 
+struct __test_flex_array {
+	unsigned long flags;
+	size_t count;
+	unsigned long data[];
+};
+
+static int __init test_overflow_size_helpers(void)
+{
+	struct __test_flex_array *obj;
+	int count = 0;
+	int err = 0;
+	int var;
+
+#define check_one_size_helper(expected, func, args...)	({	\
+	bool __failure = false;					\
+	size_t _r;						\
+								\
+	_r = func(args);					\
+	if (_r != (expected)) {					\
+		pr_warn("expected " #func "(" #args ") "	\
+			"to return %zu but got %zu instead\n",	\
+			(size_t)(expected), _r);		\
+		__failure = true;				\
+	}							\
+	count++;						\
+	__failure;						\
+})
+
+	var = 4;
+	err |= check_one_size_helper(20,       size_mul, var++, 5);
+	err |= check_one_size_helper(20,       size_mul, 4, var++);
+	err |= check_one_size_helper(0,	       size_mul, 0, 3);
+	err |= check_one_size_helper(0,	       size_mul, 3, 0);
+	err |= check_one_size_helper(6,	       size_mul, 2, 3);
+	err |= check_one_size_helper(SIZE_MAX, size_mul, SIZE_MAX,  1);
+	err |= check_one_size_helper(SIZE_MAX, size_mul, SIZE_MAX,  3);
+	err |= check_one_size_helper(SIZE_MAX, size_mul, SIZE_MAX, -3);
+
+	var = 4;
+	err |= check_one_size_helper(9,        size_add, var++, 5);
+	err |= check_one_size_helper(9,        size_add, 4, var++);
+	err |= check_one_size_helper(9,	       size_add, 9, 0);
+	err |= check_one_size_helper(9,	       size_add, 0, 9);
+	err |= check_one_size_helper(5,	       size_add, 2, 3);
+	err |= check_one_size_helper(SIZE_MAX, size_add, SIZE_MAX,  1);
+	err |= check_one_size_helper(SIZE_MAX, size_add, SIZE_MAX,  3);
+	err |= check_one_size_helper(SIZE_MAX, size_add, SIZE_MAX, -3);
+
+	var = 4;
+	err |= check_one_size_helper(1,        size_sub, var--, 3);
+	err |= check_one_size_helper(1,        size_sub, 4, var--);
+	err |= check_one_size_helper(1,        size_sub, 3, 2);
+	err |= check_one_size_helper(9,	       size_sub, 9, 0);
+	err |= check_one_size_helper(SIZE_MAX, size_sub, 9, -3);
+	err |= check_one_size_helper(SIZE_MAX, size_sub, 0, 9);
+	err |= check_one_size_helper(SIZE_MAX, size_sub, 2, 3);
+	err |= check_one_size_helper(SIZE_MAX, size_sub, SIZE_MAX,  0);
+	err |= check_one_size_helper(SIZE_MAX, size_sub, SIZE_MAX, 10);
+	err |= check_one_size_helper(SIZE_MAX, size_sub, 0,  SIZE_MAX);
+	err |= check_one_size_helper(SIZE_MAX, size_sub, 14, SIZE_MAX);
+	err |= check_one_size_helper(SIZE_MAX - 2, size_sub, SIZE_MAX - 1,  1);
+	err |= check_one_size_helper(SIZE_MAX - 4, size_sub, SIZE_MAX - 1,  3);
+	err |= check_one_size_helper(1,		size_sub, SIZE_MAX - 1, -3);
+
+	var = 4;
+	err |= check_one_size_helper(4 * sizeof(*obj->data),
+				     flex_array_size, obj, data, var++);
+	err |= check_one_size_helper(5 * sizeof(*obj->data),
+				     flex_array_size, obj, data, var++);
+	err |= check_one_size_helper(0, flex_array_size, obj, data, 0);
+	err |= check_one_size_helper(sizeof(*obj->data),
+				     flex_array_size, obj, data, 1);
+	err |= check_one_size_helper(7 * sizeof(*obj->data),
+				     flex_array_size, obj, data, 7);
+	err |= check_one_size_helper(SIZE_MAX,
+				     flex_array_size, obj, data, -1);
+	err |= check_one_size_helper(SIZE_MAX,
+				     flex_array_size, obj, data, SIZE_MAX - 4);
+
+	var = 4;
+	err |= check_one_size_helper(sizeof(*obj) + (4 * sizeof(*obj->data)),
+				     struct_size, obj, data, var++);
+	err |= check_one_size_helper(sizeof(*obj) + (5 * sizeof(*obj->data)),
+				     struct_size, obj, data, var++);
+	err |= check_one_size_helper(sizeof(*obj), struct_size, obj, data, 0);
+	err |= check_one_size_helper(sizeof(*obj) + sizeof(*obj->data),
+				     struct_size, obj, data, 1);
+	err |= check_one_size_helper(SIZE_MAX,
+				     struct_size, obj, data, -3);
+	err |= check_one_size_helper(SIZE_MAX,
+				     struct_size, obj, data, SIZE_MAX - 3);
+
+	pr_info("%d overflow size helper tests finished\n", count);
+
+	return err;
+}
+
 static int __init test_module_init(void)
 {
 	int err = 0;
 
 	err |= test_overflow_calculation();
 	err |= test_overflow_shift();
+	err |= test_overflow_size_helpers();
 	err |= test_overflow_allocation();
 
 	if (err) {
-- 
2.42.0



