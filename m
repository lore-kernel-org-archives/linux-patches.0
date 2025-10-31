Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2760834B432;
	Fri, 31 Oct 2025 14:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919483; cv=none; b=j4zQuUyk9MOaauYU149j5fDtnJU4wrRcE8J+p/2JprMjzNukdoGawIlN4v5/LCqHz14zWzUDlEJ6OcPA7iKsrZ9uKrBFY+EHtt9xSAz+r/QOPeAABUM133UMc3NpwF4nlrJ1AucEkaFjOjrNUSaosQ3DpyKOhlxYgTzmy5lw6HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919483; c=relaxed/simple;
	bh=fR7DLU3RGw7g42y6pE3apmPEMnnVTJ55i4MwkwktBTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1uhpl91vEUtUXrOCK0kyo8RZQCAq+p8EpJ0ysBpTkOOWWrkG2vN8iH6JOYkf7SJifYu0XeKj7Zj8Vb8cS6jeePTLjBnfRlN/5jeeyUZ6m/SE0jebHwburm6B8pERjzBm1Kj1MJvGA54XHCljuPPKT59q/maEbJ2cgZxJ0U0IPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9aYy8QA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9aYy8QA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50427C4CEE7;
	Fri, 31 Oct 2025 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919482;
	bh=fR7DLU3RGw7g42y6pE3apmPEMnnVTJ55i4MwkwktBTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9aYy8QAOmslgHkEKEa5e/UcSQUFe3vzyXhmRQPvUexO2U6snu5m8vYxnkHyBmvCi
	 smFl8RxCGtJip9dSGmTdMmtC2Ue8JPJJMxuafwtNgifW+XufBl1qHJuyu0QLom7i48
	 qg5HzHhtLdqteieLr5nU4szKf3hzPBfg7nERxTPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Yury Norov <yury.norov@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.12 33/40] bits: introduce fixed-type GENMASK_U*()
Date: Fri, 31 Oct 2025 15:01:26 +0100
Message-ID: <20251031140044.823398130@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 19408200c094858d952a90bf4977733dc89a4df5 ]

Add GENMASK_TYPE() which generalizes __GENMASK() to support different
types, and implement fixed-types versions of GENMASK() based on it.
The fixed-type version allows more strict checks to the min/max values
accepted, which is useful for defining registers like implemented by
i915 and xe drivers with their REG_GENMASK*() macros.

The strict checks rely on shift-count-overflow compiler check to fail
the build if a number outside of the range allowed is passed.
Example:

  #define FOO_MASK GENMASK_U32(33, 4)

will generate a warning like:

  include/linux/bits.h:51:27: error: right shift count >= width of type [-Werror=shift-count-overflow]
     51 |               type_max(t) >> (BITS_PER_TYPE(t) - 1 - (h)))))
        |                           ^~

The result is casted to the corresponding fixed width type. For
example, GENMASK_U8() returns an u8. Note that because of the C
promotion rules, GENMASK_U8() and GENMASK_U16() will immediately be
promoted to int if used in an expression. Regardless, the main goal is
not to get the correct type, but rather to enforce more checks at
compile time.

While GENMASK_TYPE() is crafted to cover all variants, including the
already existing GENMASK(), GENMASK_ULL() and GENMASK_U128(), for the
moment, only use it for the newly introduced GENMASK_U*(). The
consolidation will be done in a separate change.

Co-developed-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Stable-dep-of: 2ba5772e530f ("gpio: idio-16: Define fixed direction of the GPIO lines")
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bitops.h |    1 -
 include/linux/bits.h   |   30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -8,7 +8,6 @@
 
 #include <uapi/linux/kernel.h>
 
-#define BITS_PER_TYPE(type)	(sizeof(type) * BITS_PER_BYTE)
 #define BITS_TO_LONGS(nr)	__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
 #define BITS_TO_U64(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u64))
 #define BITS_TO_U32(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u32))
--- a/include/linux/bits.h
+++ b/include/linux/bits.h
@@ -12,6 +12,7 @@
 #define BIT_ULL_MASK(nr)	(ULL(1) << ((nr) % BITS_PER_LONG_LONG))
 #define BIT_ULL_WORD(nr)	((nr) / BITS_PER_LONG_LONG)
 #define BITS_PER_BYTE		8
+#define BITS_PER_TYPE(type)	(sizeof(type) * BITS_PER_BYTE)
 
 /*
  * Create a contiguous bitmask starting at bit position @l and ending at
@@ -20,11 +21,40 @@
  */
 #if !defined(__ASSEMBLY__)
 
+/*
+ * Missing asm support
+ *
+ * GENMASK_U*() depend on BITS_PER_TYPE() which relies on sizeof(),
+ * something not available in asm. Nevertheless, fixed width integers is a C
+ * concept. Assembly code can rely on the long and long long versions instead.
+ */
+
 #include <linux/build_bug.h>
+#include <linux/overflow.h>
 #define GENMASK_INPUT_CHECK(h, l) \
 	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
 		__is_constexpr((l) > (h)), (l) > (h), 0)))
 
+/*
+ * Generate a mask for the specified type @t. Additional checks are made to
+ * guarantee the value returned fits in that type, relying on
+ * -Wshift-count-overflow compiler check to detect incompatible arguments.
+ * For example, all these create build errors or warnings:
+ *
+ * - GENMASK(15, 20): wrong argument order
+ * - GENMASK(72, 15): doesn't fit unsigned long
+ * - GENMASK_U32(33, 15): doesn't fit in a u32
+ */
+#define GENMASK_TYPE(t, h, l)					\
+	((t)(GENMASK_INPUT_CHECK(h, l) +			\
+	     (type_max(t) << (l) &				\
+	      type_max(t) >> (BITS_PER_TYPE(t) - 1 - (h)))))
+
+#define GENMASK_U8(h, l)	GENMASK_TYPE(u8, h, l)
+#define GENMASK_U16(h, l)	GENMASK_TYPE(u16, h, l)
+#define GENMASK_U32(h, l)	GENMASK_TYPE(u32, h, l)
+#define GENMASK_U64(h, l)	GENMASK_TYPE(u64, h, l)
+
 #else /* defined(__ASSEMBLY__) */
 
 /*


