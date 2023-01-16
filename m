Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48EF6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A07EC433EF;
	Mon, 16 Jan 2023 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888363;
	bh=HVzxMLyn3rcyoX8oN2/qx564qZ+DfW0ZR5/sOHVsmXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZZFhb7Qz1JUrbr9vi+kfTuJT4bVryYiHi3U2KAUv1d1H0RUhVdvIzFTQXiEbhXcz
	 ldfvdempbsXLOxA1TmKH/Yvb8fWwzQSg3D/YfeMoDOhuuYMSdoh9hFwo2ZW7SSOvLq
	 z6j2gGM89VcG+ZhD4qHFpK8LzuuatGrHSk7XJj4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 4.19 501/521] x86/boot: Avoid using Intel mnemonics in AT&T syntax asm
Date: Mon, 16 Jan 2023 16:52:43 +0100
Message-Id: <20230116154909.604392588@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

commit 7c6dd961d0c8e7e8f9fdc65071fb09ece702e18d upstream.

With 'GNU assembler (GNU Binutils for Debian) 2.39.90.20221231' the
build now reports:

  arch/x86/realmode/rm/../../boot/bioscall.S: Assembler messages:
  arch/x86/realmode/rm/../../boot/bioscall.S:35: Warning: found `movsd'; assuming `movsl' was meant
  arch/x86/realmode/rm/../../boot/bioscall.S:70: Warning: found `movsd'; assuming `movsl' was meant

  arch/x86/boot/bioscall.S: Assembler messages:
  arch/x86/boot/bioscall.S:35: Warning: found `movsd'; assuming `movsl' was meant
  arch/x86/boot/bioscall.S:70: Warning: found `movsd'; assuming `movsl' was meant

Which is due to:

  PR gas/29525

  Note that with the dropped CMPSD and MOVSD Intel Syntax string insn
  templates taking operands, mixed IsString/non-IsString template groups
  (with memory operands) cannot occur anymore. With that
  maybe_adjust_templates() becomes unnecessary (and is hence being
  removed).

More details: https://sourceware.org/bugzilla/show_bug.cgi?id=29525

Borislav Petkov further explains:

  " the particular problem here is is that the 'd' suffix is
    "conflicting" in the sense that you can have SSE mnemonics like movsD %xmm...
    and the same thing also for string ops (which is the case here) so apparently
    the agreement in binutils land is to use the always accepted suffixes 'l' or 'q'
    and phase out 'd' slowly... "

Fixes: 7a734e7dd93b ("x86, setup: "glove box" BIOS calls -- infrastructure")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/Y71I3Ex2pvIxMpsP@hirez.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/bioscall.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/boot/bioscall.S
+++ b/arch/x86/boot/bioscall.S
@@ -35,7 +35,7 @@ intcall:
 	movw	%dx, %si
 	movw	%sp, %di
 	movw	$11, %cx
-	rep; movsd
+	rep; movsl
 
 	/* Pop full state from the stack */
 	popal
@@ -70,7 +70,7 @@ intcall:
 	jz	4f
 	movw	%sp, %si
 	movw	$11, %cx
-	rep; movsd
+	rep; movsl
 4:	addw	$44, %sp
 
 	/* Restore state and return */


