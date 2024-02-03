Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B12FBF2;
	Sat,  3 Feb 2024 04:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933491; cv=none; b=J3j5EDUcJ7/4nbNGEHwVeIio3S01ry5x/lF+gEFnmiH4vUyB+wgfGYIjTdDOhMrbMQDZWOCjpX+G1vFYGlWw2mTYFHG34UsIVGisZpGMWidBfKutcFAq3B3Zy7sT3pQuqeEY+72jm7+pWj4xuFPA8kx7C4KCfBRvIqacST32d+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933491; c=relaxed/simple;
	bh=GN2hLcUcchX1zgO0uZK6hUycR2h1kHl85SbyGSBcb+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bei+VEt5QLnQTj6Lyj2T9B8tkZCKMO1jREYy8fVem2OxX04M4O7Cogb1mNyI0BgUHgCLLPeWfmDC4pCjgjB2JVf5oloL58n/Lc0Ucc7kKI7fgHR8KphyDUjpyX1IdFQcoyf10jAApxLlkpyyr9i146o2MkR2oVuRjHyH8qX6QZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvM/ql+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvM/ql+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8D1C43394;
	Sat,  3 Feb 2024 04:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933490;
	bh=GN2hLcUcchX1zgO0uZK6hUycR2h1kHl85SbyGSBcb+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvM/ql+zeOPxsnz4eEiP3OOcEBaWUu19HxiF6PtaLgGpJBef1vEB5rSxe1XP72m4J
	 HXCWg3hkCb9px59PfaZrKyTsYNlz/H6w0k6274QVTAnAhRAlwVHd/2Sz1pF9CTkffP
	 YmKh6hW2YNZRyz7BZEq4nV+CEGtQW+FUfWffcEsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junichi Nomura <junichi.nomura@nec.com>,
	Derek Barbosa <debarbos@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/322] x86/boot: Ignore NMIs during very early boot
Date: Fri,  2 Feb 2024 20:01:46 -0800
Message-ID: <20240203035359.352287007@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun'ichi Nomura <junichi.nomura@nec.com>

[ Upstream commit 78a509fba9c9b1fcb77f95b7c6be30da3d24823a ]

When there are two racing NMIs on x86, the first NMI invokes NMI handler and
the 2nd NMI is latched until IRET is executed.

If panic on NMI and panic kexec are enabled, the first NMI triggers
panic and starts booting the next kernel via kexec. Note that the 2nd
NMI is still latched. During the early boot of the next kernel, once
an IRET is executed as a result of a page fault, then the 2nd NMI is
unlatched and invokes the NMI handler.

However, NMI handler is not set up at the early stage of boot, which
results in a boot failure.

Avoid such problems by setting up a NOP handler for early NMIs.

[ mingo: Refined the changelog. ]

Signed-off-by: Jun'ichi Nomura <junichi.nomura@nec.com>
Signed-off-by: Derek Barbosa <debarbos@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/ident_map_64.c    | 5 +++++
 arch/x86/boot/compressed/idt_64.c          | 1 +
 arch/x86/boot/compressed/idt_handlers_64.S | 1 +
 arch/x86/boot/compressed/misc.h            | 1 +
 4 files changed, 8 insertions(+)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index 08f93b0401bb..aead80ec70a0 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -385,3 +385,8 @@ void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 */
 	kernel_add_identity_map(address, end);
 }
+
+void do_boot_nmi_trap(struct pt_regs *regs, unsigned long error_code)
+{
+	/* Empty handler to ignore NMI during early boot */
+}
diff --git a/arch/x86/boot/compressed/idt_64.c b/arch/x86/boot/compressed/idt_64.c
index 3cdf94b41456..d100284bbef4 100644
--- a/arch/x86/boot/compressed/idt_64.c
+++ b/arch/x86/boot/compressed/idt_64.c
@@ -61,6 +61,7 @@ void load_stage2_idt(void)
 	boot_idt_desc.address = (unsigned long)boot_idt;
 
 	set_idt_entry(X86_TRAP_PF, boot_page_fault);
+	set_idt_entry(X86_TRAP_NMI, boot_nmi_trap);
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	/*
diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
index 22890e199f5b..4d03c8562f63 100644
--- a/arch/x86/boot/compressed/idt_handlers_64.S
+++ b/arch/x86/boot/compressed/idt_handlers_64.S
@@ -70,6 +70,7 @@ SYM_FUNC_END(\name)
 	.code64
 
 EXCEPTION_HANDLER	boot_page_fault do_boot_page_fault error_code=1
+EXCEPTION_HANDLER	boot_nmi_trap do_boot_nmi_trap error_code=0
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 EXCEPTION_HANDLER	boot_stage1_vc do_vc_no_ghcb		error_code=1
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index cc70d3fb9049..aae1a2db4251 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -197,6 +197,7 @@ static inline void cleanup_exception_handling(void) { }
 
 /* IDT Entry Points */
 void boot_page_fault(void);
+void boot_nmi_trap(void);
 void boot_stage1_vc(void);
 void boot_stage2_vc(void);
 
-- 
2.43.0



