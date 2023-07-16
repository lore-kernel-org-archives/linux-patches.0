Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227678F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B60BC433C9;
	Sun, 16 Jul 2023 20:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540389;
	bh=xAouBG5gE8m64yKnIaC2yuZMMRgf3+yUp+E56jogbQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yW2Pmte6ETJlH+6YkitLqik0TWE0ftLBQHlSs3s4OWjP0vn8VnWRrH79pz6UT2JWW
	 UVnaHgAT6myZdeycaOlyZSRX/PZGYvh8Ig3veKfNq6sUwVpwOpPLio+HKxBdrq/38V
	 Mc+lGCQSXI3XSLlc+bHH+7k8+qPRk3XMyjjOeDDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 319/591] powerpc: simplify ppc_save_regs
Date: Sun, 16 Jul 2023 21:47:38 +0200
Message-ID: <20230716194932.146088991@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 37195b820d32c23bdefce3f460ed7de48a57e5e4 ]

Adjust the pt_regs pointer so the interrupt frame offsets can be used
to save registers.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221127124942.1665522-7-npiggin@gmail.com
Stable-dep-of: b684c09f09e7 ("powerpc: update ppc_save_regs to save current r1 in pt_regs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/ppc_save_regs.S | 57 ++++++++---------------------
 1 file changed, 15 insertions(+), 42 deletions(-)

diff --git a/arch/powerpc/kernel/ppc_save_regs.S b/arch/powerpc/kernel/ppc_save_regs.S
index 2d4d21bb46a97..6e86f3bf46735 100644
--- a/arch/powerpc/kernel/ppc_save_regs.S
+++ b/arch/powerpc/kernel/ppc_save_regs.S
@@ -21,60 +21,33 @@
  * different ABIs, though).
  */
 _GLOBAL(ppc_save_regs)
-	PPC_STL	r0,0*SZL(r3)
+	/* This allows stack frame accessor macros and offsets to be used */
+	subi	r3,r3,STACK_FRAME_OVERHEAD
+	PPC_STL	r0,GPR0(r3)
 #ifdef CONFIG_PPC32
-	stmw	r2, 2*SZL(r3)
+	stmw	r2,GPR2(r3)
 #else
-	PPC_STL	r2,2*SZL(r3)
-	PPC_STL	r3,3*SZL(r3)
-	PPC_STL	r4,4*SZL(r3)
-	PPC_STL	r5,5*SZL(r3)
-	PPC_STL	r6,6*SZL(r3)
-	PPC_STL	r7,7*SZL(r3)
-	PPC_STL	r8,8*SZL(r3)
-	PPC_STL	r9,9*SZL(r3)
-	PPC_STL	r10,10*SZL(r3)
-	PPC_STL	r11,11*SZL(r3)
-	PPC_STL	r12,12*SZL(r3)
-	PPC_STL	r13,13*SZL(r3)
-	PPC_STL	r14,14*SZL(r3)
-	PPC_STL	r15,15*SZL(r3)
-	PPC_STL	r16,16*SZL(r3)
-	PPC_STL	r17,17*SZL(r3)
-	PPC_STL	r18,18*SZL(r3)
-	PPC_STL	r19,19*SZL(r3)
-	PPC_STL	r20,20*SZL(r3)
-	PPC_STL	r21,21*SZL(r3)
-	PPC_STL	r22,22*SZL(r3)
-	PPC_STL	r23,23*SZL(r3)
-	PPC_STL	r24,24*SZL(r3)
-	PPC_STL	r25,25*SZL(r3)
-	PPC_STL	r26,26*SZL(r3)
-	PPC_STL	r27,27*SZL(r3)
-	PPC_STL	r28,28*SZL(r3)
-	PPC_STL	r29,29*SZL(r3)
-	PPC_STL	r30,30*SZL(r3)
-	PPC_STL	r31,31*SZL(r3)
+	SAVE_GPRS(2, 31, r3)
 	lbz	r0,PACAIRQSOFTMASK(r13)
-	PPC_STL	r0,SOFTE-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r0,SOFTE(r3)
 #endif
 	/* go up one stack frame for SP */
 	PPC_LL	r4,0(r1)
-	PPC_STL	r4,1*SZL(r3)
+	PPC_STL	r4,GPR1(r3)
 	/* get caller's LR */
 	PPC_LL	r0,LRSAVE(r4)
-	PPC_STL	r0,_LINK-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r0,_LINK(r3)
 	mflr	r0
-	PPC_STL	r0,_NIP-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r0,_NIP(r3)
 	mfmsr	r0
-	PPC_STL	r0,_MSR-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r0,_MSR(r3)
 	mfctr	r0
-	PPC_STL	r0,_CTR-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r0,_CTR(r3)
 	mfxer	r0
-	PPC_STL	r0,_XER-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r0,_XER(r3)
 	mfcr	r0
-	PPC_STL	r0,_CCR-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r0,_CCR(r3)
 	li	r0,0
-	PPC_STL	r0,_TRAP-STACK_FRAME_OVERHEAD(r3)
-	PPC_STL	r0,ORIG_GPR3-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r0,_TRAP(r3)
+	PPC_STL	r0,ORIG_GPR3(r3)
 	blr
-- 
2.39.2



