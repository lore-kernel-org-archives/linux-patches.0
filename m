Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D651DDCE;
	Tue, 16 Jul 2024 16:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146361; cv=none; b=pRbqjbSDkutDp8Ox4RslOiWzPDFGULZqETnSIrOndVd/prGxMVZK1i2AYl78rEmosVA1cciqaHE3dM51qYPR0xiR10e4s0JcrzHnGz4KfTo1PMFq421z5q7BcskaOUlpRN2GQER+72leRyIJSofG6fmmLokrNomR7O8J6RKRG8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146361; c=relaxed/simple;
	bh=qTxGmI4Uzx602UcB/1HXGxwkBPtNJzmvMwTONVbnYo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOeDC3O4bH58oFPj6wGQZkeyW/utiDAD5aZd9IV/aVWHcyAldUhWFm7OKzwh8X0af0lKY5dQyj3dZl48Gtgw39mi2KbXD7mX7qQbvj69rt9RjBk54OWS0dvz3N1o32qZUH25eeLCnkMJUDmTlGxCXhLrRPRU0unpvHevOXfx8jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIFYrB1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIFYrB1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C684C116B1;
	Tue, 16 Jul 2024 16:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146360;
	bh=qTxGmI4Uzx602UcB/1HXGxwkBPtNJzmvMwTONVbnYo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIFYrB1cO/HXxz4vPsIQ7BOtIzuYSCSZVpRFYgQIiZSG9ze0NMojHXUVyhk4KxNDa
	 tXJFSGA00c1paZsFtBpKlowJLbYtjqowBh+Swf/D3Gl86LoyggWidCn4pkJz34SctE
	 hKD+I8QtPGglROFutaarYc7BFtmcefZizSzKzSK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Maity <suman.m.maity@oracle.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/144] x86/bhi: Avoid warning in #DB handler due to BHI mitigation
Date: Tue, 16 Jul 2024 17:33:31 +0200
Message-ID: <20240716152757.967975945@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Chartre <alexandre.chartre@oracle.com>

[ Upstream commit ac8b270b61d48fcc61f052097777e3b5e11591e0 ]

When BHI mitigation is enabled, if SYSENTER is invoked with the TF flag set
then entry_SYSENTER_compat() uses CLEAR_BRANCH_HISTORY and calls the
clear_bhb_loop() before the TF flag is cleared. This causes the #DB handler
(exc_debug_kernel()) to issue a warning because single-step is used outside the
entry_SYSENTER_compat() function.

To address this issue, entry_SYSENTER_compat() should use CLEAR_BRANCH_HISTORY
after making sure the TF flag is cleared.

The problem can be reproduced with the following sequence:

  $ cat sysenter_step.c
  int main()
  { asm("pushf; pop %ax; bts $8,%ax; push %ax; popf; sysenter"); }

  $ gcc -o sysenter_step sysenter_step.c

  $ ./sysenter_step
  Segmentation fault (core dumped)

The program is expected to crash, and the #DB handler will issue a warning.

Kernel log:

  WARNING: CPU: 27 PID: 7000 at arch/x86/kernel/traps.c:1009 exc_debug_kernel+0xd2/0x160
  ...
  RIP: 0010:exc_debug_kernel+0xd2/0x160
  ...
  Call Trace:
  <#DB>
   ? show_regs+0x68/0x80
   ? __warn+0x8c/0x140
   ? exc_debug_kernel+0xd2/0x160
   ? report_bug+0x175/0x1a0
   ? handle_bug+0x44/0x90
   ? exc_invalid_op+0x1c/0x70
   ? asm_exc_invalid_op+0x1f/0x30
   ? exc_debug_kernel+0xd2/0x160
   exc_debug+0x43/0x50
   asm_exc_debug+0x1e/0x40
  RIP: 0010:clear_bhb_loop+0x0/0xb0
  ...
  </#DB>
  <TASK>
   ? entry_SYSENTER_compat_after_hwframe+0x6e/0x8d
  </TASK>

  [ bp: Massage commit message. ]

Fixes: 7390db8aea0d ("x86/bhi: Add support for clearing branch history at syscall entry")
Reported-by: Suman Maity <suman.m.maity@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20240524070459.3674025-1-alexandre.chartre@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64_compat.S | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index d03f0cfbcb1e8..4f67e01febc4f 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -114,10 +114,6 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
 
 	cld
 
-	IBRS_ENTER
-	UNTRAIN_RET
-	CLEAR_BRANCH_HISTORY
-
 	/*
 	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
 	 * ourselves.  To save a few cycles, we can check whether
@@ -141,6 +137,16 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
 	jnz	.Lsysenter_fix_flags
 .Lsysenter_flags_fixed:
 
+	/*
+	 * CPU bugs mitigations mechanisms can call other functions. They
+	 * should be invoked after making sure TF is cleared because
+	 * single-step is ignored only for instructions inside the
+	 * entry_SYSENTER_compat function.
+	 */
+	IBRS_ENTER
+	UNTRAIN_RET
+	CLEAR_BRANCH_HISTORY
+
 	movq	%rsp, %rdi
 	call	do_SYSENTER_32
 	/* XEN PV guests always use IRET path */
-- 
2.43.0



