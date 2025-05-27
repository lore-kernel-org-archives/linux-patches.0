Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C901DB34C;
	Tue, 27 May 2025 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366244; cv=none; b=asu2G1ovuH+pqHBfKMzi0J+R3AX+jd56jsW60va+S8odbO0oXgXwiEewH8W+84i0+PuJtHHrNmhwkzgYnwAmccTe679kdQ1pFygeN15NPo/jFPD1DJMDqmw41LdYS6SgkpRJ13e3GEzuLrq67O+hzDjt0Kzp89Xa1dWLCHbiFBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366244; c=relaxed/simple;
	bh=1KX06KKxsvQDPkgkTJcu3RxtStj0jBZdQ0MNXnbdk90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qc68OVb3Mt05ZqUrAUP+YE1bXnz7Aw0e4KwgBVadc5VClrtn19dswS6b0i1h8Xhpi/b6JscIcRNvn871+rG+8Lm/lA76b96zNEmXHBWnG2HJNVIXIohfL0J5Wb5N9PRCP7Uo9mf9gxhXAFeN+F7+aK+kliUwktfCIF9ug34Lpkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSm0LuO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSm0LuO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5878C4CEE9;
	Tue, 27 May 2025 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366244;
	bh=1KX06KKxsvQDPkgkTJcu3RxtStj0jBZdQ0MNXnbdk90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSm0LuO32KtfMl5Qlknw1n3z3WxY6+jrxW78WgiYS9mpS4sG0+iuRq6HvxnrkklQ6
	 odv7CPzGieS0i1Qn3Iv3QX/LjeatjQKESijzoEwueimsA4cKxhG/Kn5Ojn+mSUs0+N
	 r0Rq1QRmF5eVs24Gd+THqBM7R2LD9+2WQRqkB3So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 617/626] kbuild: Properly disable -Wunterminated-string-initialization for clang
Date: Tue, 27 May 2025 18:28:30 +0200
Message-ID: <20250527162510.067689488@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 4f79eaa2ceac86a0e0f304b0bab556cca5bf4f30 upstream.

Clang and GCC have different behaviors around disabling warnings
included in -Wall and -Wextra and the order in which flags are
specified, which is exposed by clang's new support for
-Wunterminated-string-initialization.

  $ cat test.c
  const char foo[3] = "FOO";
  const char bar[3] __attribute__((__nonstring__)) = "BAR";

  $ clang -fsyntax-only -Wextra test.c
  test.c:1:21: warning: initializer-string for character array is too long, array size is 3 but initializer has size 4 (including the null terminating character); did you mean to use the 'nonstring' attribute? [-Wunterminated-string-initialization]
      1 | const char foo[3] = "FOO";
        |                     ^~~~~
  $ clang -fsyntax-only -Wextra -Wno-unterminated-string-initialization test.c
  $ clang -fsyntax-only -Wno-unterminated-string-initialization -Wextra test.c
  test.c:1:21: warning: initializer-string for character array is too long, array size is 3 but initializer has size 4 (including the null terminating character); did you mean to use the 'nonstring' attribute? [-Wunterminated-string-initialization]
      1 | const char foo[3] = "FOO";
        |                     ^~~~~

  $ gcc -fsyntax-only -Wextra test.c
  test.c:1:21: warning: initializer-string for array of ‘char’ truncates NUL terminator but destination lacks ‘nonstring’ attribute (4 chars into 3 available) [-Wunterminated-string-initialization]
      1 | const char foo[3] = "FOO";
        |                     ^~~~~
  $ gcc -fsyntax-only -Wextra -Wno-unterminated-string-initialization test.c
  $ gcc -fsyntax-only -Wno-unterminated-string-initialization -Wextra test.c

Move -Wextra up right below -Wall in Makefile.extrawarn to ensure these
flags are at the beginning of the warning options list. Move the couple
of warning options that have been added to the main Makefile since
commit e88ca24319e4 ("kbuild: consolidate warning flags in
scripts/Makefile.extrawarn") to scripts/Makefile.extrawarn after -Wall /
-Wextra to ensure they get properly disabled for all compilers.

Fixes: 9d7a0577c9db ("gcc-15: disable '-Wunterminated-string-initialization' entirely for now")
Link: https://github.com/llvm/llvm-project/issues/10359
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                   |    7 -------
 scripts/Makefile.extrawarn |    9 ++++++++-
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -997,13 +997,6 @@ NOSTDINC_FLAGS += -nostdinc
 # perform bounds checking.
 KBUILD_CFLAGS += $(call cc-option, -fstrict-flex-arrays=3)
 
-#Currently, disable -Wstringop-overflow for GCC 11, globally.
-KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERFLOW) += $(call cc-disable-warning, stringop-overflow)
-KBUILD_CFLAGS-$(CONFIG_CC_STRINGOP_OVERFLOW) += $(call cc-option, -Wstringop-overflow)
-
-#Currently, disable -Wunterminated-string-initialization as broken
-KBUILD_CFLAGS += $(call cc-disable-warning, unterminated-string-initialization)
-
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow
 
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -8,6 +8,7 @@
 
 # Default set of warnings, always enabled
 KBUILD_CFLAGS += -Wall
+KBUILD_CFLAGS += -Wextra
 KBUILD_CFLAGS += -Wundef
 KBUILD_CFLAGS += -Werror=implicit-function-declaration
 KBUILD_CFLAGS += -Werror=implicit-int
@@ -68,6 +69,13 @@ KBUILD_CFLAGS += -Wno-pointer-sign
 # globally built with -Wcast-function-type.
 KBUILD_CFLAGS += $(call cc-option, -Wcast-function-type)
 
+# Currently, disable -Wstringop-overflow for GCC 11, globally.
+KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERFLOW) += $(call cc-disable-warning, stringop-overflow)
+KBUILD_CFLAGS-$(CONFIG_CC_STRINGOP_OVERFLOW) += $(call cc-option, -Wstringop-overflow)
+
+# Currently, disable -Wunterminated-string-initialization as broken
+KBUILD_CFLAGS += $(call cc-disable-warning, unterminated-string-initialization)
+
 # The allocators already balk at large sizes, so silence the compiler
 # warnings for bounds checks involving those possible values. While
 # -Wno-alloc-size-larger-than would normally be used here, earlier versions
@@ -97,7 +105,6 @@ KBUILD_CFLAGS += $(call cc-option,-Wenum
 # Explicitly clear padding bits during variable initialization
 KBUILD_CFLAGS += $(call cc-option,-fzero-init-padding-bits=all)
 
-KBUILD_CFLAGS += -Wextra
 KBUILD_CFLAGS += -Wunused
 
 #


