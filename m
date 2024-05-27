Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766DF1078F;
	Mon, 27 May 2024 19:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836781; cv=none; b=jZQG+ZdH6UrEQDHoHqaX4wVNRez2bE/2mgkvyjkKkjJuHRrqSqnREUC6X1owo8I6UgtnQqAzTbkNDFyKsxigpGrSEW3i1ZHqJolkEeg65VV789qgvrmCI4Vj6nxPwiKYtn30skQL+pW/bq2qyyIfiGJP2MUoElvNiJR2akQetB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836781; c=relaxed/simple;
	bh=IPUFSjqVjE+NHSu5ce6WebTLJucaoGLoYtsiLwz37aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZMqChMT1hrylFj7sZoU1uEqEjhgoIfUCowDexVeg72/K4OCdzzVRTZRQLApcK0sx+WbD39GQiP3U2z8rKbZ7N7vR5NRh0evFLx/q2F7XPBPLvFPmLFBCAl4p3glVFJl/5QspxLqFoZClWGsZHEYq2gj+nTTRpT+UOGPuBnRyOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnZqJlP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnZqJlP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5C4C2BBFC;
	Mon, 27 May 2024 19:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836781;
	bh=IPUFSjqVjE+NHSu5ce6WebTLJucaoGLoYtsiLwz37aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnZqJlP70oc20OBTXiHMSsPP+xYgkGD743CRcypZYiskJcgwy06E50aHTVDLb1uxz
	 AuAp/ElhzKRcPycRdwiZOU+6OQzI9l/X/yBiv7cUMRIw5fJrEDsairlR5gKv2d7e9F
	 eQwcfdTqX/JdRSsQN8NNlGmXQDV2pg73NqehINTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 143/427] x86/boot/64: Clear most of CR4 in startup_64(), except PAE, MCE and LA57
Date: Mon, 27 May 2024 20:53:10 +0200
Message-ID: <20240527185615.223343174@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



