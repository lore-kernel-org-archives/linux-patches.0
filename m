Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72D048035A;
	Wed, 23 Sep 2026 14:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173487; cv=none; b=a0sWjD3oKWt4+dfgKztXj78tNH2IjG7HMvF7+6VZkaNBWONn4WCFd+Upvxfwu68XUQSaQuQnHIB/dAOrLcorDn9S/gRQoy8APXSJ/MLDZJOogh/4vTUp8awVjCDmoukch0HYE+sYIlxcVWRDUt9bAqfYwtpQmaXPZtqU12wEg/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173487; c=relaxed/simple;
	bh=x4gXGnEVssIRHXR8o9EBMH4GYn8yT8Gl3utURpUZyxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wym+Lv3O9vfQGq1jLkBsS0npEbZRm/8gezJAIqNcZPX1hizAtNU5rwoosGXfyq3/knNOwjUroXntC0fHcnasZ1J/hFiH0DSEPKs6ZUyrI+FJE1B4Zkaslf8U/cjmU978uiJnnTEQcHNwj3I8tK4PCh/jFUgfE6chzqL65mhfIVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeyhAJ+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeyhAJ+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D131F000FF;
	Wed, 23 Sep 2026 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173485;
	bh=nsaLyV1/Y9I2+Xu1FT1fFSGx7sUlUwMJK7xno/NhX24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeyhAJ+qnPjR0oF5H39E/JKw3grRomZTkCW+WA3f+BYDdUPOXaTcJwD8V0qrH+WAW
	 7XqIHRyVTYcVxSmJ+q5gC8fEADNRQEk4vZ6NDcd+0YzTqcYe63nd1J6WGqVnrMf7gh
	 Hjhk4B3UIOITRCswHTGyUtlWTDwD03r1TASXvxHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Gofman <pgofman@codeweavers.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 228/438] x86/fred: Reconstruct the #GP context for rejected INT instructions
Date: Wed, 23 Sep 2026 16:04:09 +0200
Message-ID: <20260923140650.678241126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit 93f53499d0b945e8ae447f497faf743d60069f61 ]

FRED event delivery does not use the IDT, so the gate DPL check that
rejects a user INT n falls to software (Intel FRED specification [1],
section 8.3). fred_intx() rejects the same vectors as IDT delivery, but
reports a zero error code and the IP after the INT. This breaks the
signal ABI. Wine uses the error code to recognize INT 0x2d, so the
changed context turns a handled breakpoint into an access violation in
Elden Ring.

Rewind IP using the instruction length in the augmented SS and
synthesize the IDT selector error code, (vector << 3) | 2. Set RF in the
saved flags, as the CPU does for a #GP fault. Section 5.2.1 defines the
saved vector, instruction length and RF state. The supplied length
handles prefixes without reading user memory. Limit the changes to
already-rejected software interrupts, preserving the accepted INT3, INT4
and enabled INT80 paths and hardware exceptions. With IA32 emulation
disabled, INT 0x80 now reports the same #GP as the DPL 0 gate IDT
installs there. The rewound IP also stops fixup_iopl_exception() from
inspecting the byte after the INT.

Also clear the software event flag. Section 6.2.3 specifies that ERETU
with this flag and TF set traps before executing any user instruction. A
tracer that suppresses SIGSEGV and resumes with TF set expects the next
instruction to run first, as after IRET. The sigreturn path clears the
same flag for this reason in prevent_single_step_upon_eretu().

[1] Intel Flexible Return and Event Delivery (FRED) Specification,
revision 9.0 (346446-009US), sections 5.2.1, 6.2.3 and 8.3.

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Closes: https://gitlab.freedesktop.org/mesa/mesa/-/work_items/15745
Closes: https://gitlab.freedesktop.org/mesa/mesa/-/work_items/16132
Reported-by: Paul Gofman <pgofman@codeweavers.com>
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Link: https://cdrdv2.intel.com/v1/dl/getContent/678938 # [1]
Link: https://patch.msgid.link/20260917230907.2080792-2-matthew.schwartz@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_fred.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index fb3594ddf731f..854899bfec5d9 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -10,6 +10,7 @@
 #include <asm/desc.h>
 #include <asm/fred.h>
 #include <asm/idtentry.h>
+#include <asm/processor-flags.h>
 #include <asm/syscall.h>
 #include <asm/trapnr.h>
 #include <asm/traps.h>
@@ -71,7 +72,15 @@ static noinstr void fred_intx(struct pt_regs *regs)
 #endif
 
 	default:
-		return exc_general_protection(regs, 0);
+		/*
+		 * Reconstruct the #GP fault state that IDT delivery would produce.
+		 * Clear the software event flag so ERETU with TF set does not trap
+		 * before the resumed instruction. See prevent_single_step_upon_eretu().
+		 */
+		regs->ip -= regs->fred_ss.insnlen;
+		regs->flags |= X86_EFLAGS_RF;
+		regs->fred_ss.swevent = 0;
+		return exc_general_protection(regs, (regs->fred_ss.vector << 3) | 2);
 	}
 }
 
-- 
2.53.0



