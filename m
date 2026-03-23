Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8F51E5B88;
	Mon, 23 Mar 2026 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275556; cv=none; b=O1isix88LG+f2f5Ozq2HzU1aHLBDAc+LcJguyP93RqbUgjn5ip6XLPjNzJMlu4+FovnlOnyM/1cWHQWureu+6Y3FTSHApBSfu7xwUKiLizKDoOydMbB63COBKrYXGy7g0yVJiHT1jXvhlB8arvDZZC3en+NUFtTEtpoH2j76TLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275556; c=relaxed/simple;
	bh=2vP35+j9wrGxuLzio8Tt5/BuQwqJC6pTjcoYb/w5yEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFPp8dBCo/IEOcnlGZB6DzVlaPB4+cQMcuNpGfNu3PX+53ctn3lfdWaSDRNRxVonWj/ryjcuSLYVeGMIb1pLofB32XL09TarfdE4jdDjXTLQCbabiB2j7yG+RlLVcgJb4MX7KYk6H23rs7SfDJl3006Kt84Hlpfa7aShywmtZ1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMN+UW0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMN+UW0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921D3C4CEF7;
	Mon, 23 Mar 2026 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275556;
	bh=2vP35+j9wrGxuLzio8Tt5/BuQwqJC6pTjcoYb/w5yEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMN+UW0m4hkDhuejrMWFSI2YIVuGICdejXpfcFVS/hqC2wNoElkIbz+AXUq+ik8+1
	 K0gsDGGskCckkIq3iox5A5bQbTW+LKGnko+yDtMKJsTPs/MMGdLlVCpN8mF/KDDE0a
	 z95Y9qhLa3xtQVRbwxbGPHCdT7YYU+dRw+c26PfQ=
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
Subject: [PATCH 6.12 140/460] Fix CC_HAS_ASM_GOTO_OUTPUT on non-x86 architectures
Date: Mon, 23 Mar 2026 14:42:16 +0100
Message-ID: <20260323134530.031526305@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1a39330252c59..f4b91b1857bf8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -107,7 +107,7 @@ config CC_HAS_ASM_GOTO_OUTPUT
 	# Detect basic support
 	depends on $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
 	# Detect clang (< v17) scoped label issues
-	depends on $(success,echo 'void b(void **);void* c(void);int f(void){{asm goto("jmp %l0"::::l0);return 0;l0:return 1;}void *x __attribute__((cleanup(b)))=c();{asm goto("jmp %l0"::::l1);return 2;l1:return 3;}}' | $(CC) -x c - -c -o /dev/null)
+	depends on $(success,echo 'void b(void **);void* c(void);int f(void){{asm goto(""::::l0);return 0;l0:return 1;}void *x __attribute__((cleanup(b)))=c();{asm goto(""::::l1);return 2;l1:return 3;}}' | $(CC) -x c - -c -o /dev/null)
 
 config CC_HAS_ASM_GOTO_TIED_OUTPUT
 	depends on CC_HAS_ASM_GOTO_OUTPUT
-- 
2.51.0



