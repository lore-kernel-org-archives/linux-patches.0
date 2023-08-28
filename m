Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E828440C
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A71C433C8;
	Mon, 28 Aug 2023 10:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217700;
	bh=mrtihyyCC2FxzznDSL4NV40Hu5AMwS1bK1eL4WX1aoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpoDa/p3mfIYpxSt5H5QmEfnvv4iHziuXFqB0bNq7Q0lEqUHbxUzuKSM/KXtB1yh3
	 XeiEUKvPAO4Ta4BMADWzJwlLN9EIHnO48/BSnpP+wXcy4xgStdpnEDQyVddQBwOmtd
	 FjY3byzRCgahyARWF03f4s8ckqCe4PpXgg/9/gLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <natechancellor@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 01/57] lib/mpi: Eliminate unused umul_ppmm definitions for MIPS
Date: Mon, 28 Aug 2023 12:12:21 +0200
Message-ID: <20230828101144.277050199@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101144.231099710@linuxfoundation.org>
References: <20230828101144.231099710@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <natechancellor@gmail.com>

commit b0c091ae04f6746f541b9be91809e1f4f43e9a65 upstream.

Clang errors out when building this macro:

lib/mpi/generic_mpih-mul1.c:37:24: error: invalid use of a cast in a
inline asm context requiring an l-value: remove the cast or build with
-fheinous-gnu-extensions
                umul_ppmm(prod_high, prod_low, s1_ptr[j], s2_limb);
                ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/mpi/longlong.h:652:20: note: expanded from macro 'umul_ppmm'
        : "=l" ((USItype)(w0)), \
                ~~~~~~~~~~^~~
lib/mpi/generic_mpih-mul1.c:37:3: error: invalid output constraint '=h'
in asm
                umul_ppmm(prod_high, prod_low, s1_ptr[j], s2_limb);
                ^
lib/mpi/longlong.h:653:7: note: expanded from macro 'umul_ppmm'
             "=h" ((USItype)(w1)) \
             ^
2 errors generated.

The C version that is used for GCC 4.4 and up works well with clang;
however, it is not currently being used because Clang masks itself
as GCC 4.2.1 for compatibility reasons. As Nick points out, we require
GCC 4.6 and newer in the kernel so we can eliminate all of the
versioning checks and just use the C version of umul_ppmm for all
supported compilers.

Link: https://github.com/ClangBuiltLinux/linux/issues/605
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/mpi/longlong.h |   36 +-----------------------------------
 1 file changed, 1 insertion(+), 35 deletions(-)

--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -639,30 +639,12 @@ do { \
 	**************  MIPS  *****************
 	***************************************/
 #if defined(__mips__) && W_TYPE_SIZE == 32
-#if (__GNUC__ >= 5) || (__GNUC__ >= 4 && __GNUC_MINOR__ >= 4)
 #define umul_ppmm(w1, w0, u, v)			\
 do {						\
 	UDItype __ll = (UDItype)(u) * (v);	\
 	w1 = __ll >> 32;			\
 	w0 = __ll;				\
 } while (0)
-#elif __GNUC__ > 2 || __GNUC_MINOR__ >= 7
-#define umul_ppmm(w1, w0, u, v) \
-	__asm__ ("multu %2,%3" \
-	: "=l" ((USItype)(w0)), \
-	     "=h" ((USItype)(w1)) \
-	: "d" ((USItype)(u)), \
-	     "d" ((USItype)(v)))
-#else
-#define umul_ppmm(w1, w0, u, v) \
-	__asm__ ("multu %2,%3\n" \
-	   "mflo %0\n" \
-	   "mfhi %1" \
-	: "=d" ((USItype)(w0)), \
-	     "=d" ((USItype)(w1)) \
-	: "d" ((USItype)(u)), \
-	     "d" ((USItype)(v)))
-#endif
 #define UMUL_TIME 10
 #define UDIV_TIME 100
 #endif /* __mips__ */
@@ -687,7 +669,7 @@ do {									\
 		 : "d" ((UDItype)(u)),					\
 		   "d" ((UDItype)(v)));					\
 } while (0)
-#elif (__GNUC__ >= 5) || (__GNUC__ >= 4 && __GNUC_MINOR__ >= 4)
+#else
 #define umul_ppmm(w1, w0, u, v) \
 do {									\
 	typedef unsigned int __ll_UTItype __attribute__((mode(TI)));	\
@@ -695,22 +677,6 @@ do {									\
 	w1 = __ll >> 64;						\
 	w0 = __ll;							\
 } while (0)
-#elif __GNUC__ > 2 || __GNUC_MINOR__ >= 7
-#define umul_ppmm(w1, w0, u, v) \
-	__asm__ ("dmultu %2,%3" \
-	: "=l" ((UDItype)(w0)), \
-	     "=h" ((UDItype)(w1)) \
-	: "d" ((UDItype)(u)), \
-	     "d" ((UDItype)(v)))
-#else
-#define umul_ppmm(w1, w0, u, v) \
-	__asm__ ("dmultu %2,%3\n" \
-	   "mflo %0\n" \
-	   "mfhi %1" \
-	: "=d" ((UDItype)(w0)), \
-	     "=d" ((UDItype)(w1)) \
-	: "d" ((UDItype)(u)), \
-	     "d" ((UDItype)(v)))
 #endif
 #define UMUL_TIME 20
 #define UDIV_TIME 140


