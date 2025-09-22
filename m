Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E7827B320;
	Mon, 22 Sep 2025 19:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569785; cv=none; b=BQb4M2JBXRZZWHWPvQ+lCSbr4OHCuAOh0nilIok7/z1BpHAWE0o8UqvVknPINNamTIHbZgpfit/SHau8EOuHBIipPDsAl7mlha3y7KV/UnD3WYlmDL8fyaA/dLyoKHZEJEnZq5yMe6/8jO1hLRZS8GUPwrcV4KvbsqJtyW3q1O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569785; c=relaxed/simple;
	bh=aoyLESXHLG9nwBtnOkSnNqKxAJV1qwNio6hguJb5zcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxlb9o4xamY/n9QoS0cjYkSOU4Wxy1q0InKvMIHmL0He18Ao3b8TcG/ldqy8VuyFpOKBvYlL/ezEvNJOYpKHmgXImO6Ww/X0i+1VkCEnmgCBOynL8MN5Ej/l8Ox4O5o6HjUlQNoN3hXdMMoILjptSxZHLIeBbgBP6ioN3MLO2s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8nkaA3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8nkaA3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937DBC4CEF5;
	Mon, 22 Sep 2025 19:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569784;
	bh=aoyLESXHLG9nwBtnOkSnNqKxAJV1qwNio6hguJb5zcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8nkaA3yHJfQVJtypny/0VjOl1vHFaq2TPSD+wwZgKaBS7CDJwGlmhngHwIhwR8D/
	 rv0htWU6Ma2ot5aJLJh4+17nHfKdypAuXNMOHNeeUabxGED/5vxf5VATdK+c0XuPFX
	 gu955P3aX1IR5ec8jBF5LG0wlJ7RzSmBLAnX7kCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <David.Laight@aculab.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 6.6 68/70] minmax: simplify and clarify min_t()/max_t() implementation
Date: Mon, 22 Sep 2025 21:30:08 +0200
Message-ID: <20250922192406.437051177@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]

This simplifies the min_t() and max_t() macros by no longer making them
work in the context of a C constant expression.

That means that you can no longer use them for static initializers or
for array sizes in type definitions, but there were only a couple of
such uses, and all of them were converted (famous last words) to use
MIN_T/MAX_T instead.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -45,17 +45,20 @@
 
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
-#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-	typeof(x) unique_x = (x);			\
-	typeof(y) unique_y = (y);			\
+#define __cmp_once_unique(op, type, x, y, ux, uy) \
+	({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
+
+#define __cmp_once(op, type, x, y) \
+	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
+
+#define __careful_cmp_once(op, x, y) ({			\
 	static_assert(__types_ok(x, y),			\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp(op, unique_x, unique_y); })
+	__cmp_once(op, __auto_type, x, y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y),				\
-		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
+		__cmp(op, x, y), __careful_cmp_once(op, x, y))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -158,7 +161,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -166,7 +169,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
 
 /*
  * Do not check the array parameter using __must_be_array().


