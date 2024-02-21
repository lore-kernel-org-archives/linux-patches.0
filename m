Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91FB69D2E;
	Wed, 21 Feb 2024 13:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522037; cv=none; b=ma0cXd9jozPxIA3eu05zLO9kP9844axbt2I1pZZ1kCSw2jv4XcSpLj/KdtiwndkJ56sztIrqOCkPuUqxuvLpll0gga8YMeOTQ7ZfewzPO7TyRGWFCqRwzRGCOXPvgP/tikv24l0lA+vCJJ6uFT3svzPuYBnBsMLraqxnVWNXA30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522037; c=relaxed/simple;
	bh=/iH7i1U4+nbrRg70LOYZSDuVVBn9sifEjT3gouJ1jLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PY0oT6A+5Rl/PzK102O0taCbbSt9kRqm/DYFoJjxS1miS58tjLkfhn9lSzT1YSJCTY+kDatBBjQ+3K0WkSZqt1MKmj4Gck+VUD15ANLyTuUb01/D+LFuiXmPBVLpmkk+V1juB8W4gZ05R4+BGmaGsQWRwgy1+rXWYpu4T1DpulY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dqNcgyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dqNcgyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3980AC433C7;
	Wed, 21 Feb 2024 13:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522037;
	bh=/iH7i1U4+nbrRg70LOYZSDuVVBn9sifEjT3gouJ1jLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dqNcgyXa0mZ2HlqJ7JTe9YdP6XKbnye78XtIWYCrcliy891yp7/M7Nn3Nle8/eYH
	 Df4mwREW+iNwON+rVzUw5RorTvN64MmRlfZBd2DzqJGzzPlX7oCNkVOyzaRuryIv2F
	 QLrCtits1H6At/XSFWCxd8A1/tPOnfcPonGlzICs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	linux-hardening@vger.kernel.org,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 063/476] overflow: Allow mixed type arguments
Date: Wed, 21 Feb 2024 14:01:54 +0100
Message-ID: <20240221130010.264862772@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit d219d2a9a92e39aa92799efe8f2aa21259b6dd82 upstream.

When the check_[op]_overflow() helpers were introduced, all arguments
were required to be the same type to make the fallback macros simpler.
However, now that the fallback macros have been removed[1], it is fine
to allow mixed types, which makes using the helpers much more useful,
as they can be used to test for type-based overflows (e.g. adding two
large ints but storing into a u8), as would be handy in the drm core[2].

Remove the restriction, and add additional self-tests that exercise
some of the mixed-type overflow cases, and double-check for accidental
macro side-effects.

[1] https://git.kernel.org/linus/4eb6bd55cfb22ffc20652732340c4962f3ac9a91
[2] https://lore.kernel.org/lkml/20220824084514.2261614-2-gwan-gyeong.mun@intel.com

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: linux-hardening@vger.kernel.org
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Tested-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
[ dropped the test portion of the commit as that doesn't apply to
  5.15.y - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/overflow.h |   72 ++++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 31 deletions(-)

--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -51,40 +51,50 @@ static inline bool __must_check __must_c
 	return unlikely(overflow);
 }
 
-/*
- * For simplicity and code hygiene, the fallback code below insists on
- * a, b and *d having the same type (similar to the min() and max()
- * macros), whereas gcc's type-generic overflow checkers accept
- * different types. Hence we don't just make check_add_overflow an
- * alias for __builtin_add_overflow, but add type checks similar to
- * below.
+/** check_add_overflow() - Calculate addition with overflow checking
+ *
+ * @a: first addend
+ * @b: second addend
+ * @d: pointer to store sum
+ *
+ * Returns 0 on success.
+ *
+ * *@d holds the results of the attempted addition, but is not considered
+ * "safe for use" on a non-zero return value, which indicates that the
+ * sum has overflowed or been truncated.
  */
-#define check_add_overflow(a, b, d) __must_check_overflow(({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	__builtin_add_overflow(__a, __b, __d);	\
-}))
+#define check_add_overflow(a, b, d)	\
+	__must_check_overflow(__builtin_add_overflow(a, b, d))
 
-#define check_sub_overflow(a, b, d) __must_check_overflow(({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	__builtin_sub_overflow(__a, __b, __d);	\
-}))
+/** check_sub_overflow() - Calculate subtraction with overflow checking
+ *
+ * @a: minuend; value to subtract from
+ * @b: subtrahend; value to subtract from @a
+ * @d: pointer to store difference
+ *
+ * Returns 0 on success.
+ *
+ * *@d holds the results of the attempted subtraction, but is not considered
+ * "safe for use" on a non-zero return value, which indicates that the
+ * difference has underflowed or been truncated.
+ */
+#define check_sub_overflow(a, b, d)	\
+	__must_check_overflow(__builtin_sub_overflow(a, b, d))
 
-#define check_mul_overflow(a, b, d) __must_check_overflow(({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	__builtin_mul_overflow(__a, __b, __d);	\
-}))
+/** check_mul_overflow() - Calculate multiplication with overflow checking
+ *
+ * @a: first factor
+ * @b: second factor
+ * @d: pointer to store product
+ *
+ * Returns 0 on success.
+ *
+ * *@d holds the results of the attempted multiplication, but is not
+ * considered "safe for use" on a non-zero return value, which indicates
+ * that the product has overflowed or been truncated.
+ */
+#define check_mul_overflow(a, b, d)	\
+	__must_check_overflow(__builtin_mul_overflow(a, b, d))
 
 /** check_shl_overflow() - Calculate a left-shifted value and check overflow
  *


