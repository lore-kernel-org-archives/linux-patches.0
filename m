Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB6F53B7
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB4EC433C7;
	Wed,  9 Aug 2023 11:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579688;
	bh=IInDt4kWTBBXfokco1nrpq7DW+BCTjLU+UOPb9o0vyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hh5QYeOPJ1gydfHiI5raz1H1XOX6l9B2IeTDQ1x+QZ91PipSPRYpbt0m2R/9/OylZ
	 Dn1yvfRyysvOZjfb+JB1DIjiG8bjHUgAROUYjkIrZr4xBin53h2aggnv9yH4PTG6Ej
	 IZsm1B9aFmxp7BxvvKeOsBNWi+o8SM1apxFImdY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineet Gupta <vgupta@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/323] ARCv2: entry: push out the Z flag unclobber from common EXCEPTION_PROLOGUE
Date: Wed,  9 Aug 2023 12:38:39 +0200
Message-ID: <20230809103701.835650896@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit 23c0cbd0c75c3b564850294427fd2be2bc2a015b ]

Upon a taken interrupt/exception from User mode, HS hardware auto sets Z flag.
This helps shave a few instructions from EXCEPTION_PROLOGUE by eliding
re-reading ERSTATUS and some bit fiddling.

However TLB Miss Exception handler can clobber the CPU flags and still end
up in EXCEPTION_PROLOGUE in the slow path handling TLB handling case:

   EV_TLBMissD
     do_slow_path_pf
       EV_TLBProtV (aliased to call_do_page_fault)
          EXCEPTION_PROLOGUE

As a result, EXCEPTION_PROLOGUE need to "unclobber" the Z flag which this
patch changes. It is now pushed out to TLB Miss Exception handler.
The reasons beings:

 - The flag restoration is only needed for slowpath TLB Miss Exception
   handling, but currently being in EXCEPTION_PROLOGUE penalizes all
   exceptions such as ProtV and syscall Trap, where Z flag is already
   as expected.

 - Pushing unclobber out to where it was clobbered is much cleaner and
   also serves to document the fact.

 - Makes EXCEPTION_PROLGUE similar to INTERRUPT_PROLOGUE so easier to
   refactor the common parts which is what this series aims to do

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Stable-dep-of: 92e2921eeafd ("ARC: define ASM_NL and __ALIGN(_STR) outside #ifdef __ASSEMBLY__ guard")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/entry-arcv2.h |  8 --------
 arch/arc/mm/tlbex.S                | 11 +++++++++++
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arc/include/asm/entry-arcv2.h b/arch/arc/include/asm/entry-arcv2.h
index 1c3520d1fa420..3209a67629606 100644
--- a/arch/arc/include/asm/entry-arcv2.h
+++ b/arch/arc/include/asm/entry-arcv2.h
@@ -225,14 +225,6 @@
 
 	; -- for interrupts, regs above are auto-saved by h/w in that order --
 	; Now do what ISR prologue does (manually save r12, sp, fp, gp, r25)
-	;
-	; Set Z flag if this was from U mode (expected by INTERRUPT_PROLOGUE)
-	; Although H/w exception micro-ops do set Z flag for U mode (just like
-	; for interrupts), it could get clobbered in case we soft land here from
-	; a TLB Miss exception handler (tlbex.S)
-
-	and	r10, r10, STATUS_U_MASK
-	xor.f	0, r10, STATUS_U_MASK
 
 	INTERRUPT_PROLOGUE  exception
 
diff --git a/arch/arc/mm/tlbex.S b/arch/arc/mm/tlbex.S
index 0e1e47a67c736..e50cac799a518 100644
--- a/arch/arc/mm/tlbex.S
+++ b/arch/arc/mm/tlbex.S
@@ -396,6 +396,17 @@ EV_TLBMissD_fast_ret:	; additional label for VDK OS-kit instrumentation
 ;-------- Common routine to call Linux Page Fault Handler -----------
 do_slow_path_pf:
 
+#ifdef CONFIG_ISA_ARCV2
+	; Set Z flag if exception in U mode. Hardware micro-ops do this on any
+	; taken interrupt/exception, and thus is already the case at the entry
+	; above, but ensuing code would have already clobbered.
+	; EXCEPTION_PROLOGUE called in slow path, relies on correct Z flag set
+
+	lr	r2, [erstatus]
+	and	r2, r2, STATUS_U_MASK
+	bxor.f	0, r2, STATUS_U_BIT
+#endif
+
 	; Restore the 4-scratch regs saved by fast path miss handler
 	TLBMISS_RESTORE_REGS
 
-- 
2.39.2



