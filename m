Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A267168C4;
	Mon, 27 May 2024 19:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837965; cv=none; b=fhZH4TU4bweM2sX4MAgpzH99IdL3vcRpC9cFi/XFYoXBIW0r5KetkmsBWHAEayeK64TnspS9M7NgTYeRw5nW7YrE5MO25Oaogsq+mIA3YbobGZGw68bcjeSWBgg/zgvGaHIKw8BsSy9VTCkg6DpdNBMW9NxjZiZEtZlVb3cGG7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837965; c=relaxed/simple;
	bh=oaYgcQgxa8Qunh96MmjaCfJkdJfe5c6DqEYyDr2Yj5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrMovyk5t3gXM2SThlePqXqphLJei6Ev6UuTEFWo4iV0HPgMj7kkwc1KKJBxaN9Chnmxy4w0ycfzjJUJ/5SdJ+K2WUBXY2Fj3qAfhWIT9TLMYq6Y3YgTk6tB5TjYYBhP7sPYvvH2ZhGNid9U0hPh6ElYMsAHzKL3a/jr+fZTRF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoMkFnY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoMkFnY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3ADC2BBFC;
	Mon, 27 May 2024 19:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837965;
	bh=oaYgcQgxa8Qunh96MmjaCfJkdJfe5c6DqEYyDr2Yj5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoMkFnY3kITR/69acALmRkH8Uv0cgNeyaFhMrONVQnL7ULp8AE4fxh9jiCru6eEnP
	 hNzpyGhxcJRuNHlCCLg+/6I8ggfBqqBDblLSsqffxpjFMyu6sztOMW3aAmr8gg9xiK
	 65IME7Sk8YFPSM9ZLUh4XddPaHvSWDmLiqWMcAHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 212/493] x86/boot/64: Clear most of CR4 in startup_64(), except PAE, MCE and LA57
Date: Mon, 27 May 2024 20:53:34 +0200
Message-ID: <20240527185637.248032914@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit a0025f587c685e5ff842fb0194036f2ca0b6eaf4 ]

The early 64-bit boot code must be entered with a 1:1 mapping of the
bootable image, but it cannot operate without a 1:1 mapping of all the
assets in memory that it accesses, and therefore, it creates such
mappings for all known assets upfront, and additional ones on demand
when a page fault happens on a memory address.

These mappings are created with the global bit G set, as the flags used
to create page table descriptors are based on __PAGE_KERNEL_LARGE_EXEC
defined by the core kernel, even though the context where these mappings
are used is very different.

This means that the TLB maintenance carried out by the decompressor is
not sufficient if it is entered with CR4.PGE enabled, which has been
observed to happen with the stage0 bootloader of project Oak. While this
is a dubious practice if no global mappings are being used to begin
with, the decompressor is clearly at fault here for creating global
mappings and not performing the appropriate TLB maintenance.

Since commit:

  f97b67a773cd84b ("x86/decompressor: Only call the trampoline when changing paging levels")

CR4 is no longer modified by the decompressor if no change in the number
of paging levels is needed. Before that, CR4 would always be set to a
consistent value with PGE cleared.

So let's reinstate a simplified version of the original logic to put CR4
into a known state, and preserve the PAE, MCE and LA57 bits, none of
which can be modified freely at this point (PAE and LA57 cannot be
changed while running in long mode, and MCE cannot be cleared when
running under some hypervisors).

This effectively clears PGE and works around the project Oak bug.

Fixes: f97b67a773cd84b ("x86/decompressor: Only call the trampoline when ...")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/20240410151354.506098-2-ardb+git@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/head_64.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index bf4a10a5794f1..1dcb794c5479e 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -398,6 +398,11 @@ SYM_CODE_START(startup_64)
 	call	sev_enable
 #endif
 
+	/* Preserve only the CR4 bits that must be preserved, and clear the rest */
+	movq	%cr4, %rax
+	andl	$(X86_CR4_PAE | X86_CR4_MCE | X86_CR4_LA57), %eax
+	movq	%rax, %cr4
+
 	/*
 	 * configure_5level_paging() updates the number of paging levels using
 	 * a trampoline in 32-bit addressable memory if the current number does
-- 
2.43.0



