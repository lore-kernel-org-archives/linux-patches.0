Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24CB1A01D2;
	Thu, 15 Aug 2024 13:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729028; cv=none; b=NMhiLcZqGDv6O9Ui0vFsUoI6XkJZkZ7kzoBP3+tY0Mu5bwuzt8eezkE1+BHWwm8fskgNsF1HjKlxxbT8t0okcVBlCoG0hAhGewvUC0io11SvwrdpDLZ8r1DtRplVRnxyvEby+wfF4J0meQ7mp3yv0zYv5MDb1kJRhSMZP4cTM8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729028; c=relaxed/simple;
	bh=nguDHzyJ0W0uucxTjWC2a9v7sO/09DN1oouOdnJU5Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPVHgR6B9rEHZcmfDP6Ot6iLGuHvkitnHPR7LbPgOLtZEYxLHVkp6jYOMadyWIDahJdunMwAlAI/iaR4+vRAER1Gph0kbgSCTL/UnaopcTYCpzTfF+GdrmBsS5c6V/HefHPpSiCVCW13ZPKCXiEGx/3LQ1AhoAJ1SuUKNQPKwmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nhh4fmH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nhh4fmH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFDAC32786;
	Thu, 15 Aug 2024 13:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729027;
	bh=nguDHzyJ0W0uucxTjWC2a9v7sO/09DN1oouOdnJU5Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nhh4fmH+MVs3GERDnFheB4b2UK9BwgLdKKJC8/FXp8b9Z0ZrHJ+8Xxb89Ehwx+vNz
	 JvM4JjoM3aUSZhLcX4Nf1oENUdlU2cwTg1nX1xBUDmBPYe4wLRUNNoqnAoXqK+B46Y
	 glb9Sy87+r/kRtaSx+svXbS8ELPmKOrE1e9Wtau4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 188/196] kbuild: Fix -S -c in x86 stack protector scripts
Date: Thu, 15 Aug 2024 15:25:05 +0200
Message-ID: <20240815131859.263858000@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
[nathan: Fixed conflict in 32-bit version due to lack of 3fb0fdb3bbe7]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-x86_32-has-stack-protector.sh |    2 +-
 scripts/gcc-x86_64-has-stack-protector.sh |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gcc-x86_32-has-stack-protector.sh
+++ b/scripts/gcc-x86_32-has-stack-protector.sh
@@ -1,4 +1,4 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
-echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -c -m32 -O0 -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
+echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -m32 -O0 -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
--- a/scripts/gcc-x86_64-has-stack-protector.sh
+++ b/scripts/gcc-x86_64-has-stack-protector.sh
@@ -1,4 +1,4 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
-echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -c -m64 -O0 -mcmodel=kernel -fno-PIE -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
+echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -m64 -O0 -mcmodel=kernel -fno-PIE -fstack-protector - -o - 2> /dev/null | grep -q "%gs"


