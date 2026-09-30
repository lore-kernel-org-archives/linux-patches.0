Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CAB263F4A;
	Wed, 30 Sep 2026 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788536; cv=none; b=eYnIrjtUv7Ht3H3tzFfYyhB9A0UEuXzP44EmlL7jjYoiJbzfq8/tH34eKeShOn0f3ztYg+7gE6+Z1HFBBbc3ncOFgUNttgB1FzgAWbkhiSDhek3+SShTBdck0uAe8jWRLFgy5cf0fn0idp/FmwbspYs4pySFo8gPrpqpMBQchFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788536; c=relaxed/simple;
	bh=GbLPWcu6jeGtXVH//1NUBXbFnQCABZHTJcCdvkaKZaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvzL/T5E+EKjJtYxFiEjnWw1HfLtp8GYFeTtioSjoar6T2gkK1/ky5OWv4XcJ6LV6yrV4Y2rS25WX2DDO/vncmdRoh+UFnoJWKB2JjBqeEoc9qqnucg2f+T8WKDeAYsNRoGS9QRlIL9zFcLcwBVEuB98sqsa6vMG5nY0xA/1cH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aqtuHx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aqtuHx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE951F000FF;
	Wed, 30 Sep 2026 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788535;
	bh=X/D0CZ3tbX9xK+4BVjudXCDBQTyUWor9yngGMQMQxdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1aqtuHx2Y1X1Ehfd2OzwJnD9HxkOGk0GzRSWtG6lRrrm4rortk/l6S7WegDHnV2i3
	 7ymDX8U2XM8mqDiuAqzEz6UCE8q7FMJV0PtMVFOaWmqbhTXhRDvMuu9utGisjqEBYf
	 Zdd+OKhgTsIKJQRXpl0OPEk40yPWDOIkOuNt1iak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Gofman <pgofman@codeweavers.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/877] x86/fred: Reconstruct the #GP context for rejected INT instructions
Date: Wed, 30 Sep 2026 17:17:48 +0200
Message-ID: <20260930152418.108652537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 9f50f0c1c00f5..c43c750fa26dc 100644
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



