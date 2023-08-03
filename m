Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB9F24161;
	Thu,  3 Aug 2023 18:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3B0C433C8;
	Thu,  3 Aug 2023 18:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691086488;
	bh=DVr3vaTop5aEKN2dLg5oZiV7ia5I3foLhPl+u/44NRs=;
	h=From:Date:Subject:To:Cc:From;
	b=n7hK2tD4MHYvXJVjnymrwlE2xwawPQaiCptAbypypiqVPnACyrbQoRvIXJRyXoo2J
	 93zFUjaqiB1gCCZD1curb8hO3l4qcngmj4Rt2doGTwE1ZzM/4NoRqNK5Er2XggA1mw
	 wd113T5Kc927+S0MFJ6PNBOigste8fF2q85qmoJvPMoAL3fTO4078Tgs21opo+n/P2
	 1EJYW5O1u+ywZrwjQlDsij5UVfx1gkxDCwMAaqY2SABWE5DzgZQVKRc2hEpl/fkSig
	 UFm6ofo89sg47+CRlk+Uu3ZdBRwjDdAdbI18b7B3NVrRyi48Vrc//4uad8vb0wGuLP
	 qp6Bq+BTRh/Mw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 03 Aug 2023 11:14:42 -0700
Subject: [PATCH] lib: test_scanf: Add explicit type cast to result
 initialization in test_number_prefix()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230803-test_scanf-wconstant-conversion-v1-1-74da994dedbc@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJHuy2QC/x2NywqDMBBFf0Vm7UBqKNb+ShHJY1JnM5ZMUEH8d
 1N35yzOvQcoZSaFd3NAppWVF6nyaBsIs5MvIcfq0JnOmpexWEjLpMFJwi0sosVJwQor5X+Lceg
 p+WS9f0aoK79Miff74TOe5wUM3bQecQAAAA==
To: pmladek@suse.com, rostedt@goodmis.org
Cc: senozhatsky@chromium.org, andriy.shevchenko@linux.intel.com, 
 linux@rasmusvillemoes.dk, ndesaulniers@google.com, trix@redhat.com, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2281; i=nathan@kernel.org;
 h=from:subject:message-id; bh=DVr3vaTop5aEKN2dLg5oZiV7ia5I3foLhPl+u/44NRs=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCmn301/wDvtlZH5Zb4DV5+lduXoX/qgX1+y/KOOXdgFP
 rGPbkv1O0pZGMQ4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEPqUzMuyqNjt2tkBUdqFR
 CZugIV/xNsXY1CPqahmpW+eWvLcUfcvI0Hc0Tq1LtjP7+hTRXXsWTjd7d3Lpod9BWXfDm6ZqfnW
 YzA8A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

A recent change in clang allows it to consider more expressions as
compile time constants, which causes it to point out an implicit
conversion in the scanf tests:

  lib/test_scanf.c:661:2: warning: implicit conversion from 'int' to 'unsigned char' changes value from -168 to 88 [-Wconstant-conversion]
    661 |         test_number_prefix(unsigned char,       "0xA7", "%2hhx%hhx", 0, 0xa7, 2, check_uchar);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  lib/test_scanf.c:609:29: note: expanded from macro 'test_number_prefix'
    609 |         T result[2] = {~expect[0], ~expect[1]};                                 \
        |                       ~            ^~~~~~~~~~
  1 warning generated.

The result of the bitwise negation is the type of the operand after
going through the integer promotion rules, so this truncation is
expected but harmless, as the initial values in the result array get
overwritten by _test() anyways. Add an explicit cast to the expected
type in test_number_prefix() to silence the warning. There is no
functional change, as all the tests still pass with GCC 13.1.0 and clang
18.0.0.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1899
Link: https://github.com/llvm/llvm-project/commit/610ec954e1f81c0e8fcadedcd25afe643f5a094e
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 lib/test_scanf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_scanf.c b/lib/test_scanf.c
index b620cf7de503..10d557b3738f 100644
--- a/lib/test_scanf.c
+++ b/lib/test_scanf.c
@@ -606,7 +606,7 @@ static void __init numbers_slice(void)
 #define test_number_prefix(T, str, scan_fmt, expect0, expect1, n_args, fn)	\
 do {										\
 	const T expect[2] = { expect0, expect1 };				\
-	T result[2] = {~expect[0], ~expect[1]};					\
+	T result[2] = {(T)~expect[0], (T)~expect[1]};				\
 										\
 	_test(fn, &expect, str, scan_fmt, n_args, &result[0], &result[1]);	\
 } while (0)

---
base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
change-id: 20230803-test_scanf-wconstant-conversion-d97efbf3bb5d

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

