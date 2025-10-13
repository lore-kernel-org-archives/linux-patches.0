Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D9C27AC21;
	Mon, 13 Oct 2025 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368785; cv=none; b=GiDgBKe5nswSE/aB+jbaJoVqKvQjTlzuasWke2a0On9hhhgCcWO+EwLNitm7I83h45z4hqTGUehvgukN0GAAlB7na7puNz2Qcd/G2gWTpF7+DGvFy+maa4s8juCLF/NbLTHIM/nELzrqB/ZRCRYh921r53MOHKRPG4iraWJTrgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368785; c=relaxed/simple;
	bh=Xpq9UeU9QgM1qK3TsT/SPSDudQAJBEb76BIj3SxavoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qt1MA5Q27DBwLLi4URi3wb94NzuPhKq9C/0kVXdMVwLm2SGFjz07BuH9vXWXBgr8pK0raC2CXnqwm9Phh/9WNaatciG1LCwBTFczFh4I4oV5vxTN585whkpHkmvWvwFPIx4ySnbxLKsEMlEhdglX66m/G/DX+mQnrwfN/dzx7Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtvnPF+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtvnPF+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B052DC4CEE7;
	Mon, 13 Oct 2025 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368785;
	bh=Xpq9UeU9QgM1qK3TsT/SPSDudQAJBEb76BIj3SxavoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtvnPF+DKQ39kYf1eaQz3dyLf/DA/au+oZ4RhqQQIMpPRxwjfT2wmT2BMVfTvzqwr
	 mFcKLny+3N2uAKqjcoE1r42nPvZvMQwrTweT5dO6Vl8+rDn3EImX+SFs5u5QWyxuoK
	 tPdGCBsc2Gv23JzKoQhFSjtNbNImiSDcgWB35pEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 6.17 005/563] Fix CC_HAS_ASM_GOTO_OUTPUT on non-x86 architectures
Date: Mon, 13 Oct 2025 16:37:46 +0200
Message-ID: <20251013144411.483446573@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit fde0ab43b9a30d08817adc5402b69fec83a61cb8 ]

There's a silly problem with the CC_HAS_ASM_GOTO_OUTPUT test: even with
a working compiler it will fail on some architectures simply because it
uses the mnemonic "jmp" for testing the inline asm.

And as reported by Geert, not all architectures use that mnemonic, so
the test fails spuriously on such platforms (including arm and riscv,
but also several other architectures).

This issue avoided any obvious test failures because the build still
works thanks to falling back on the old non-asm-goto code, which just
generates worse code.

Just use an empty asm statement instead.

Reported-and-tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Fixes: e2ffa15b9baa ("kbuild: Disable CC_HAS_ASM_GOTO_OUTPUT on clang < 17")
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index e5d6d798994ae..87c868f86a060 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -102,7 +102,7 @@ config CC_HAS_ASM_GOTO_OUTPUT
 	# Detect basic support
 	depends on $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
 	# Detect clang (< v17) scoped label issues
-	depends on $(success,echo 'void b(void **);void* c(void);int f(void){{asm goto("jmp %l0"::::l0);return 0;l0:return 1;}void *x __attribute__((cleanup(b)))=c();{asm goto("jmp %l0"::::l1);return 2;l1:return 3;}}' | $(CC) -x c - -c -o /dev/null)
+	depends on $(success,echo 'void b(void **);void* c(void);int f(void){{asm goto(""::::l0);return 0;l0:return 1;}void *x __attribute__((cleanup(b)))=c();{asm goto(""::::l1);return 2;l1:return 3;}}' | $(CC) -x c - -c -o /dev/null)
 
 config CC_HAS_ASM_GOTO_TIED_OUTPUT
 	depends on CC_HAS_ASM_GOTO_OUTPUT
-- 
2.51.0



