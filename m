Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0378F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9409C433D2;
	Mon, 13 Feb 2023 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300184;
	bh=zfY/whVn6HYIuiXAw3hxr53jrQkSstb/81pyrNbv6wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTNOmdmMJ54xBcMZBB0qbKyNaTihWoekWoVmCXHkHOGz1N3x1mZnJKyASwX2x22wY
	 xNS5p7ONrE5+CNNk4W26jeS6mH0Iwq5ojSQp2CE7tZaDbaDFRpT7ahyQX4ugBFXuSM
	 N1yxjuZ+zyKjimadVdKC4vnw3KjzUkU9DGm7aJP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sachin Sant <sachinp@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 096/114] powerpc/64s/interrupt: Fix interrupt exit race with security mitigation switch
Date: Mon, 13 Feb 2023 15:48:51 +0100
Message-Id: <20230213144747.144563374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

commit 2ea31e2e62bbc4d11c411eeb36f1b02841dbcab1 upstream.

The RFI and STF security mitigation options can flip the
interrupt_exit_not_reentrant static branch condition concurrently with
the interrupt exit code which tests that branch.

Interrupt exit tests this condition to set MSR[EE|RI] for exit, then
again in the case a soft-masked interrupt is found pending, to recover
the MSR so the interrupt can be replayed before attempting to exit
again. If the condition changes between these two tests, the MSR and irq
soft-mask state will become corrupted, leading to warnings and possible
crashes. For example, if the branch is initially true then false,
MSR[EE] will be 0 but PACA_IRQ_HARD_DIS clear and EE may not get
enabled, leading to warnings in irq_64.c.

Fixes: 13799748b957 ("powerpc/64: use interrupt restart table to speed up return from interrupt")
Cc: stable@vger.kernel.org # v5.14+
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230206042240.92103-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/interrupt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -50,16 +50,18 @@ static inline bool exit_must_hard_disabl
  */
 static notrace __always_inline bool prep_irq_for_enabled_exit(bool restartable)
 {
+	bool must_hard_disable = (exit_must_hard_disable() || !restartable);
+
 	/* This must be done with RI=1 because tracing may touch vmaps */
 	trace_hardirqs_on();
 
-	if (exit_must_hard_disable() || !restartable)
+	if (must_hard_disable)
 		__hard_EE_RI_disable();
 
 #ifdef CONFIG_PPC64
 	/* This pattern matches prep_irq_for_idle */
 	if (unlikely(lazy_irq_pending_nocheck())) {
-		if (exit_must_hard_disable() || !restartable) {
+		if (must_hard_disable) {
 			local_paca->irq_happened |= PACA_IRQ_HARD_DIS;
 			__hard_RI_enable();
 		}


