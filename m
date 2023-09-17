Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3B06FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB39C433C8;
	Sun, 17 Sep 2023 20:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981619;
	bh=rnEQd1DnjfRykfVRaBoagkC4v/zXWGm5IC/0zvqHjTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rox0vCmapkRXkMNWHWvEJCPlh0hh+W4ReyM+tHJzYehpY1HKvyGf9S1HdATZSFZcy
	 nMCGBa3Sm9USJE/Ztc6ReqoexLmjib8ej2bKtorZU3JMUrCujOJ9ynBkSFJ1PEnOxp
	 riWdfHFelwyJbHEkFPjZFOU+NsE0DB6qUOMAVSbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 6.1 148/219] lib: test_scanf: Add explicit type cast to result initialization in test_number_prefix()
Date: Sun, 17 Sep 2023 21:14:35 +0200
Message-ID: <20230917191046.375634669@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 92382d744176f230101d54f5c017bccd62770f01 upstream.

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

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linuxq/issues/1899
Link: https://github.com/llvm/llvm-project/commit/610ec954e1f81c0e8fcadedcd25afe643f5a094e
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20230807-test_scanf-wconstant-conversion-v2-1-839ca39083e1@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_scanf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_scanf.c
+++ b/lib/test_scanf.c
@@ -606,7 +606,7 @@ static void __init numbers_slice(void)
 #define test_number_prefix(T, str, scan_fmt, expect0, expect1, n_args, fn)	\
 do {										\
 	const T expect[2] = { expect0, expect1 };				\
-	T result[2] = {~expect[0], ~expect[1]};					\
+	T result[2] = { (T)~expect[0], (T)~expect[1] };				\
 										\
 	_test(fn, &expect, str, scan_fmt, n_args, &result[0], &result[1]);	\
 } while (0)


