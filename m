Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515AB3C17;
	Fri, 31 Oct 2025 14:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919404; cv=none; b=Z4playlJJSQyK5wPPAtjeK945XMZGuDtKL80lpcHI5WfTPrhgtJemJMMW+TipU4y9oRfsuHSdlYufrhjf7KLvyddj03/8+6WRKu9zR4o1RTVIowQkgNQhCVodhoR8jU2rBt1AG0+4F6OpSxb/4YTU1O6QXMAeLwhNvWVVLNe1VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919404; c=relaxed/simple;
	bh=cnC0ZgFqPwBJ+vQaKuFKHT9m0exukPeRvmx6yyIZ49Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJddnPDDdfLuJDVdZ2zUpH9im361psyseG3ZcLJR//yQTLVeZn8osjXH67TME6sJ+nVlHzanGHhFk5AuPAyD67kym49FLdjk12VAkiMNEXrsoz6kkwAdz66V6kScuo4HEFvv/B3VKYUqwZUw5GPhKD0+xZfJJgRmQZpECJFZkFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJHW13IM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJHW13IM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8FBC4CEFD;
	Fri, 31 Oct 2025 14:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919404;
	bh=cnC0ZgFqPwBJ+vQaKuFKHT9m0exukPeRvmx6yyIZ49Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJHW13IMQ6Jw7bcTiJhw9Vct+HfiwfFVPs4VyCe99kGsFMIahMa8rkksHUbTyoZU1
	 d6IFQD4jfcxVXvkqSyhyFfQ1UgmBKtk5Cy27Svs6UkVdsTuS59/kz2mRe0yD49KGy5
	 wxl1MyPRMU+7Ya77cWtvIGMpdw3fKSUd41c68pIA=
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
Subject: [PATCH 6.6 29/32] bits: introduce fixed-type GENMASK_U*()
Date: Fri, 31 Oct 2025 15:01:23 +0100
Message-ID: <20251031140043.154280085@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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
@@ -15,7 +15,6 @@
 #  define aligned_byte_mask(n) (~0xffUL << (BITS_PER_LONG - 8 - 8*(n)))
 #endif
 
-#define BITS_PER_TYPE(type)	(sizeof(type) * BITS_PER_BYTE)
 #define BITS_TO_LONGS(nr)	__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
 #define BITS_TO_U64(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u64))
 #define BITS_TO_U32(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u32))
--- a/include/linux/bits.h
+++ b/include/linux/bits.h
@@ -11,6 +11,7 @@
 #define BIT_ULL_MASK(nr)	(ULL(1) << ((nr) % BITS_PER_LONG_LONG))
 #define BIT_ULL_WORD(nr)	((nr) / BITS_PER_LONG_LONG)
 #define BITS_PER_BYTE		8
+#define BITS_PER_TYPE(type)	(sizeof(type) * BITS_PER_BYTE)
 
 /*
  * Create a contiguous bitmask starting at bit position @l and ending at
@@ -19,11 +20,40 @@
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


