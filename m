Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BF7317711;
	Mon, 27 Oct 2025 18:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591451; cv=none; b=EP0jFfCdqDkxJwtA26oqsdxiNTo5DrcgPkqetc31BLL0oxflK9eqv7DAUT7jSk0ctzDqJh2LY8Gw0o4Noi6zEoO1Y1l4fX/WnVi4NBjf8MrYTm/WhTkWpuLl3E3pJoEFWGLGuoCn/bE2rwCxN/Yx/FYW6NEoxPQGmISzFrOvWJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591451; c=relaxed/simple;
	bh=nXmvYXBIQ7zaGdiQiWGLvjsIRCowZZjfHaVloVPjLKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBUhAtOHJlodiTm1OSmXlmVXuhdzp4XXsFFeOGHLQsaFwNV5azrFDwmGPNxdGUBL92KOs0yI0JoYN/HOMX+R52X07AxAO2hEn5tYYfzLPjduyn8XFLpMjRI2JC1qAtuVJj8iztszdq2HjGmFCQAuT3Fg4sQ9oUP5TZa7uNAeSto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nxv48pql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nxv48pql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B8BC4CEF1;
	Mon, 27 Oct 2025 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591451;
	bh=nXmvYXBIQ7zaGdiQiWGLvjsIRCowZZjfHaVloVPjLKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nxv48pqlx2oNOef5ZhGwMve4OGZTSONkoDonwzmc8qrY2Ehtp8rsqJUtcHbvFBnxI
	 sYZCtQJJUyTFEpFTYO/d0NbF5zOJkUy+IECYg7zl1OB0IiHrj3OwC9I3Fwwvb5HKH7
	 k8CrAp949oL2JQ9U6LyEq84w/p8L/bzV2ULoUxuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 202/332] minmax: allow min()/max()/clamp() if the arguments have the same signedness.
Date: Mon, 27 Oct 2025 19:34:15 +0100
Message-ID: <20251027183530.049257434@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit d03eba99f5bf7cbc6e2fdde3b6fa36954ad58e09 ]

The type-check in min()/max() is there to stop unexpected results if a
negative value gets converted to a large unsigned value.  However it also
rejects 'unsigned int' v 'unsigned long' compares which are common and
never problematc.

Replace the 'same type' check with a 'same signedness' check.

The new test isn't itself a compile time error, so use static_assert() to
report the error and give a meaningful error message.

Due to the way builtin_choose_expr() works detecting the error in the
'non-constant' side (where static_assert() can be used) also detects
errors when the arguments are constant.

Link: https://lkml.kernel.org/r/fe7e6c542e094bfca655abcd323c1c98@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   62 ++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -12,9 +12,8 @@
  *
  * - avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - perform strict type-checking (to generate warnings instead of
- *   nasty runtime surprises). See the "unnecessary" pointer comparison
- *   in __typecheck().
+ * - perform signed v unsigned type-checking (to generate compile
+ *   errors instead of nasty runtime surprises).
  * - retain result as a constant expressions when called with only
  *   constant expressions (to avoid tripping VLA warnings in stack
  *   allocation usage).
@@ -22,23 +21,30 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-#define __no_side_effects(x, y) \
-		(__is_constexpr(x) && __is_constexpr(y))
+/* is_signed_type() isn't a constexpr for pointer types */
+#define __is_signed(x) 								\
+	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
+		is_signed_type(typeof(x)), 0)
 
-#define __safe_cmp(x, y) \
-		(__typecheck(x, y) && __no_side_effects(x, y))
+#define __types_ok(x, y) \
+	(__is_signed(x) == __is_signed(y))
 
-#define __cmp(x, y, op)	((x) op (y) ? (x) : (y))
+#define __cmp_op_min <
+#define __cmp_op_max >
 
-#define __cmp_once(x, y, unique_x, unique_y, op) ({	\
+#define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
+
+#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
 		typeof(x) unique_x = (x);		\
 		typeof(y) unique_y = (y);		\
-		__cmp(unique_x, unique_y, op); })
-
-#define __careful_cmp(x, y, op) \
-	__builtin_choose_expr(__safe_cmp(x, y), \
-		__cmp(x, y, op), \
-		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
+		static_assert(__types_ok(x, y),		\
+			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+		__cmp(op, unique_x, unique_y); })
+
+#define __careful_cmp(op, x, y)					\
+	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
+		__cmp(op, x, y),				\
+		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -47,17 +53,15 @@
 		typeof(val) unique_val = (val);				\
 		typeof(lo) unique_lo = (lo);				\
 		typeof(hi) unique_hi = (hi);				\
+		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+				(lo) <= (hi), true),					\
+			"clamp() low limit " #lo " greater than high limit " #hi);	\
+		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
 		__clamp(unique_val, unique_lo, unique_hi); })
 
-#define __clamp_input_check(lo, hi)					\
-        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(			\
-                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))
-
 #define __careful_clamp(val, lo, hi) ({					\
-	__clamp_input_check(lo, hi) +					\
-	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) && \
-			      __typecheck(hi, lo) && __is_constexpr(val) && \
-			      __is_constexpr(lo) && __is_constexpr(hi),	\
+	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
 		__clamp(val, lo, hi),					\
 		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
 			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
@@ -67,14 +71,14 @@
  * @x: first value
  * @y: second value
  */
-#define min(x, y)	__careful_cmp(x, y, <)
+#define min(x, y)	__careful_cmp(min, x, y)
 
 /**
  * max - return maximum of two values of the same or compatible types
  * @x: first value
  * @y: second value
  */
-#define max(x, y)	__careful_cmp(x, y, >)
+#define max(x, y)	__careful_cmp(max, x, y)
 
 /**
  * umin - return minimum of two non-negative values
@@ -83,7 +87,7 @@
  * @y: second value
  */
 #define umin(x, y)	\
-	__careful_cmp((x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull, <)
+	__careful_cmp(min, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
 /**
  * umax - return maximum of two non-negative values
@@ -91,7 +95,7 @@
  * @y: second value
  */
 #define umax(x, y)	\
-	__careful_cmp((x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull, >)
+	__careful_cmp(max, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
 /**
  * min3 - return minimum of three values
@@ -143,7 +147,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp((type)(x), (type)(y), <)
+#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -151,7 +155,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
+#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
 /*
  * Do not check the array parameter using __must_be_array().


