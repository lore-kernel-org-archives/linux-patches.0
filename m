Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBDF303C9B;
	Tue, 30 Sep 2025 14:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244193; cv=none; b=Hv5+0tUE/0EglXg35QcWu3XTNCG67Gq0zLdIh5GCJeJEFm5gKZCzsZgTkFgeEJVipa4iNGQhO3rIwqzDPdvgbywvE6gR4hilCf/tHWArqAaKVIYtdX35Ql5LEiDzXJ/upk+q68yhOLMXKZuAA6zPM9HYjYutmwr6Efuc5JLGrsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244193; c=relaxed/simple;
	bh=s1lYkbb+4CyWmvQY8AvrB88kdw5TrnIzjIYKm0N4Tlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdckguwWFjeyCI+ZQ1oxBmdLHpS89xbprdeTbx04l1EIPFKKnO442c6FaHpZ7lHMj8QKEIvSOeG/Ad6IN6QZqJKbv+edW0S3Ngpv3jZyn09F21DgFPbhp9B76ugnS3IWtf0sGK9XKzJV2Q/p2gUoeosW7gSMBscQQTj25t8uBxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRp74jbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRp74jbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7E0C113D0;
	Tue, 30 Sep 2025 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244193;
	bh=s1lYkbb+4CyWmvQY8AvrB88kdw5TrnIzjIYKm0N4Tlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRp74jbwkfpajSXk9hwd0qLDn7agwdg+CmbLtbLbR1cOWZnHK2CPViw4yBgEAOTiz
	 CAcijJHDtQPlb5RHpNL1GpM9RPX4cnPeGtL4rVV94mctn6FUktQ03oVvX3hL2nUtIe
	 8o46zzE51jTDuVsz61NzzLoIpfCJYu6pc6ggLvt8=
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
	Kees Cook <keescook@chromium.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 014/122] overflow: Allow mixed type arguments
Date: Tue, 30 Sep 2025 16:45:45 +0200
Message-ID: <20250930143823.574238011@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Eliav Farber <farbere@amazon.com>
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


