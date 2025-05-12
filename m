Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B27296D28;
	Mon, 12 May 2025 17:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072573; cv=none; b=pWEYYSWGAEZMN03V6gwL5jvo7zJTIse9fTBRISCBZoNrdYef7FUkCNZ5WGNkAIhYVdbU143Wu9uf+IihnVLd+8H/8V6aluWPX0D+54xb0/739d3zyIJAJv57o+BV6hZP+0yw6UGE1cID/b1hakROD5tttkb7MVv899br+uaYF2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072573; c=relaxed/simple;
	bh=tQ0S5YRIlmO0jijnxdm3sIWbhR8aPlxiZL/SQAa+pL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShjNAu5wYobRUnawQqc3FguaAUDJdLoGre1Cw45jF2xPxjz4Wm3vLLbSf6G9jeYNNcUhQuoAB4ipeuFHAg0q+0A5X0/SdfnuDr9Ibkr3PZIhCxYZQNp1LuQ5OtE3f3wn6qJZarzhNe3cHOkF4eSQHMjn22FJEvBl54Jrz5JuXfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmiD3ymx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmiD3ymx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600B3C4CEE7;
	Mon, 12 May 2025 17:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072572;
	bh=tQ0S5YRIlmO0jijnxdm3sIWbhR8aPlxiZL/SQAa+pL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmiD3ymxGzKmt+KHMLAIRD8/lq6U0jPzMwuUOjbz9HIElXS4WJ1nWkjURugtQUgg2
	 tbEUP4TBuqojZmfK5GRg7WzSrdYrIw9Z1c4ue0LVpFwaVZUW6eIXiBmQtgHwmEnOUt
	 ++n8stx5tPmDQEEnuay2eoGiBMUOn6P5c2Si5e5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.1 82/92] x86/speculation: Add a conditional CS prefix to CALL_NOSPEC
Date: Mon, 12 May 2025 19:45:57 +0200
Message-ID: <20250512172026.465836346@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 052040e34c08428a5a388b85787e8531970c0c67 upstream.

Retpoline mitigation for spectre-v2 uses thunks for indirect branches. To
support this mitigation compilers add a CS prefix with
-mindirect-branch-cs-prefix. For an indirect branch in asm, this needs to
be added manually.

CS prefix is already being added to indirect branches in asm files, but not
in inline asm. Add CS prefix to CALL_NOSPEC for inline asm as well. There
is no JMP_NOSPEC for inline asm.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250228-call-nospec-v3-2-96599fed0f33@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -119,9 +119,8 @@
 .endm
 
 /*
- * Equivalent to -mindirect-branch-cs-prefix; emit the 5 byte jmp/call
- * to the retpoline thunk with a CS prefix when the register requires
- * a RAX prefix byte to encode. Also see apply_retpolines().
+ * Emits a conditional CS prefix that is compatible with
+ * -mindirect-branch-cs-prefix.
  */
 .macro __CS_PREFIX reg:req
 	.irp rs,r8,r9,r10,r11,r12,r13,r14,r15
@@ -281,11 +280,23 @@ extern void (*x86_return_thunk)(void);
 #ifdef CONFIG_X86_64
 
 /*
+ * Emits a conditional CS prefix that is compatible with
+ * -mindirect-branch-cs-prefix.
+ */
+#define __CS_PREFIX(reg)				\
+	".irp rs,r8,r9,r10,r11,r12,r13,r14,r15\n"	\
+	".ifc \\rs," reg "\n"				\
+	".byte 0x2e\n"					\
+	".endif\n"					\
+	".endr\n"
+
+/*
  * Inline asm uses the %V modifier which is only in newer GCC
  * which is ensured when CONFIG_RETPOLINE is defined.
  */
 #ifdef CONFIG_RETPOLINE
-#define CALL_NOSPEC	"call __x86_indirect_thunk_%V[thunk_target]\n"
+#define CALL_NOSPEC	__CS_PREFIX("%V[thunk_target]")	\
+			"call __x86_indirect_thunk_%V[thunk_target]\n"
 #else
 #define CALL_NOSPEC	"call *%[thunk_target]\n"
 #endif


