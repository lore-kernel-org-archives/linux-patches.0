Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C4A1A5A7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrEU7UV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2088DC433C7;
	Mon, 16 Oct 2023 09:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446945;
	bh=BvQHC1WOOVmR5TDmBJx52GB9LG2QWAqc+bXH2S+v2z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrEU7UV3GC61cVabUMlQRGv2e/T2Yw8JQVAhsWI0nUecKrlVgSI5tB9xLy46uvM6W
	 +qPtDeWOGmreKUMJ35V9AIJwgzlq96268q7xkukxn0P2rcO9KVLyO9dmZhCokz9FUj
	 /n5nIELislPLZwsCcg9BC+cDzCcdqswlmkug7A1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.1 102/131] powerpc/47x: Fix 47x syscall return crash
Date: Mon, 16 Oct 2023 10:41:25 +0200
Message-ID: <20231016084002.597741280@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit f0eee815babed70a749d2496a7678be5b45b4c14 upstream.

Eddie reported that newer kernels were crashing during boot on his 476
FSP2 system:

  kernel tried to execute user page (b7ee2000) - exploit attempt? (uid: 0)
  BUG: Unable to handle kernel instruction fetch
  Faulting instruction address: 0xb7ee2000
  Oops: Kernel access of bad area, sig: 11 [#1]
  BE PAGE_SIZE=4K FSP-2
  Modules linked in:
  CPU: 0 PID: 61 Comm: mount Not tainted 6.1.55-d23900f.ppcnf-fsp2 #1
  Hardware name: ibm,fsp2 476fpe 0x7ff520c0 FSP-2
  NIP:  b7ee2000 LR: 8c008000 CTR: 00000000
  REGS: bffebd83 TRAP: 0400   Not tainted (6.1.55-d23900f.ppcnf-fs p2)
  MSR:  00000030 <IR,DR>  CR: 00001000  XER: 20000000
  GPR00: c00110ac bffebe63 bffebe7e bffebe88 8c008000 00001000 00000d12 b7ee2000
  GPR08: 00000033 00000000 00000000 c139df10 48224824 1016c314 10160000 00000000
  GPR16: 10160000 10160000 00000008 00000000 10160000 00000000 10160000 1017f5b0
  GPR24: 1017fa50 1017f4f0 1017fa50 1017f740 1017f630 00000000 00000000 1017f4f0
  NIP [b7ee2000] 0xb7ee2000
  LR [8c008000] 0x8c008000
  Call Trace:
  Instruction dump:
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
  ---[ end trace 0000000000000000 ]---

The problem is in ret_from_syscall where the check for
icache_44x_need_flush is done. When the flush is needed the code jumps
out-of-line to do the flush, and then intends to jump back to continue
the syscall return.

However the branch back to label 1b doesn't return to the correct
location, instead branching back just prior to the return to userspace,
causing bogus register values to be used by the rfi.

The breakage was introduced by commit 6f76a01173cc
("powerpc/syscall: implement system call entry/exit logic in C for PPC32") which
inadvertently removed the "1" label and reused it elsewhere.

Fix it by adding named local labels in the correct locations. Note that
the return label needs to be outside the ifdef so that CONFIG_PPC_47x=n
compiles.

Fixes: 6f76a01173cc ("powerpc/syscall: implement system call entry/exit logic in C for PPC32")
Cc: stable@vger.kernel.org # v5.12+
Reported-by: Eddie James <eajames@linux.ibm.com>
Tested-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/linuxppc-dev/fdaadc46-7476-9237-e104-1d2168526e72@linux.ibm.com/
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://msgid.link/20231010114750.847794-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/entry_32.S |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -135,8 +135,9 @@ ret_from_syscall:
 	lis	r4,icache_44x_need_flush@ha
 	lwz	r5,icache_44x_need_flush@l(r4)
 	cmplwi	cr0,r5,0
-	bne-	2f
+	bne-	.L44x_icache_flush
 #endif /* CONFIG_PPC_47x */
+.L44x_icache_flush_return:
 	kuep_unlock
 	lwz	r4,_LINK(r1)
 	lwz	r5,_CCR(r1)
@@ -170,10 +171,11 @@ syscall_exit_finish:
 	b	1b
 
 #ifdef CONFIG_44x
-2:	li	r7,0
+.L44x_icache_flush:
+	li	r7,0
 	iccci	r0,r0
 	stw	r7,icache_44x_need_flush@l(r4)
-	b	1b
+	b	.L44x_icache_flush_return
 #endif  /* CONFIG_44x */
 
 	.globl	ret_from_fork


