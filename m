Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0686514AD0A;
	Thu, 15 Aug 2024 13:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729817; cv=none; b=r35C33fvOKkrUMuThvvLd/QMUB/TnVP3/YqVh7bDZXJbb9Pl/CxzrrQ4lO7HCXgfizVdpOk+yAOlQjAVgUtuYeKEYpTe2QSobWT5hapGBcd69FNR9Lm4Tpc58HSqNGC8wZg/4KvxU9gnFatRsEm8260mV757a4ESnjasoBYWePs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729817; c=relaxed/simple;
	bh=Ktc6GJVARtyEuLjb35CBG6GPk3rBEDh8c2/473DymAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SntHKVGPsiejQgkB4MhM1yJveC5uzb5Ze9wZIfRXZySqF10oNNNaRx6QORvS0Ggw8HlQb2O3nNFNADpqJOD+5qYA/acnBkE8i9b4H7/hUWriAwz/9kkzYQglW7MtxTCt3dASaHalFVw9YNKXwan4DYZE8U1bN4mszvEStplF8+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZqugBAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZqugBAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4BCC32786;
	Thu, 15 Aug 2024 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729816;
	bh=Ktc6GJVARtyEuLjb35CBG6GPk3rBEDh8c2/473DymAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZqugBAftJ6jaFAMV0Qyaouv+NaDKTSa13GgVo4Bl6dA3uUIcuL40v7u2uVVEmeIv
	 AyBD8PU+SWT9tD0MjWUc8SgoaqyKJDUqYjx2TVZtR0fHKwttV1UZibUu+WMa6Iw2X5
	 n0s9mORppk/PLTktzH4c3jHrihQkocPfOxDKhBvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 216/484] kbuild: Fix -S -c in x86 stack protector scripts
Date: Thu, 15 Aug 2024 15:21:14 +0200
Message-ID: <20240815131949.755344013@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 3415b10a03945b0da4a635e146750dfe5ce0f448 upstream.

After a recent change in clang to stop consuming all instances of '-S'
and '-c' [1], the stack protector scripts break due to the kernel's use
of -Werror=unused-command-line-argument to catch cases where flags are
not being properly consumed by the compiler driver:

  $ echo | clang -o - -x c - -S -c -Werror=unused-command-line-argument
  clang: error: argument unused during compilation: '-c' [-Werror,-Wunused-command-line-argument]

This results in CONFIG_STACKPROTECTOR getting disabled because
CONFIG_CC_HAS_SANE_STACKPROTECTOR is no longer set.

'-c' and '-S' both instruct the compiler to stop at different stages of
the pipeline ('-S' after compiling, '-c' after assembling), so having
them present together in the same command makes little sense. In this
case, the test wants to stop before assembling because it is looking at
the textual assembly output of the compiler for either '%fs' or '%gs',
so remove '-c' from the list of arguments to resolve the error.

All versions of GCC continue to work after this change, along with
versions of clang that do or do not contain the change mentioned above.

Cc: stable@vger.kernel.org
Fixes: 4f7fd4d7a791 ("[PATCH] Add the -fstack-protector option to the CFLAGS")
Fixes: 60a5317ff0f4 ("x86: implement x86_32 stack protector")
Link: https://github.com/llvm/llvm-project/commit/6461e537815f7fa68cef06842505353cf5600e9c [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-x86_32-has-stack-protector.sh |    2 +-
 scripts/gcc-x86_64-has-stack-protector.sh |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gcc-x86_32-has-stack-protector.sh
+++ b/scripts/gcc-x86_32-has-stack-protector.sh
@@ -5,4 +5,4 @@
 # -mstack-protector-guard-reg, added by
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81708
 
-echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -c -m32 -O0 -fstack-protector -mstack-protector-guard-reg=fs -mstack-protector-guard-symbol=__stack_chk_guard - -o - 2> /dev/null | grep -q "%fs"
+echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -m32 -O0 -fstack-protector -mstack-protector-guard-reg=fs -mstack-protector-guard-symbol=__stack_chk_guard - -o - 2> /dev/null | grep -q "%fs"
--- a/scripts/gcc-x86_64-has-stack-protector.sh
+++ b/scripts/gcc-x86_64-has-stack-protector.sh
@@ -1,4 +1,4 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
-echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -c -m64 -O0 -mcmodel=kernel -fno-PIE -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
+echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -m64 -O0 -mcmodel=kernel -fno-PIE -fstack-protector - -o - 2> /dev/null | grep -q "%gs"


