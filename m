Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807F73A1C6;
	Mon, 18 Dec 2023 14:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFQ2oJ7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB36C433C8;
	Mon, 18 Dec 2023 14:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908405;
	bh=3a85cNJlSC4iej43BJShFyHdQU8RTSX9ZrPYHk/sS1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFQ2oJ7W8TXRPGcWTDFvZkhADeX1auxv+3kDoHFzp1P4xl0TiP72RNcmxxEgRBc4q
	 7A65N6Pd1skXaihlOScZzs7zTUv9lH3lyi/lRjzm9WQrHjAO0oNTD4KNUjqmU/1HgJ
	 JX4kJlI5NnkSXoptEbJNmTr1ZZtot0AYgpZy4FkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangrui Song <maskray@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.6 165/166] x86/speculation, objtool: Use absolute relocations for annotations
Date: Mon, 18 Dec 2023 14:52:11 +0100
Message-ID: <20231218135112.502265588@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Fangrui Song <maskray@google.com>

commit b8ec60e1186cdcfce41e7db4c827cb107e459002 upstream.

.discard.retpoline_safe sections do not have the SHF_ALLOC flag.  These
sections referencing text sections' STT_SECTION symbols with PC-relative
relocations like R_386_PC32 [0] is conceptually not suitable.  Newer
LLD will report warnings for REL relocations even for relocatable links [1]:

    ld.lld: warning: vmlinux.a(drivers/i2c/busses/i2c-i801.o):(.discard.retpoline_safe+0x120): has non-ABS relocation R_386_PC32 against symbol ''

Switch to absolute relocations instead, which indicate link-time
addresses.  In a relocatable link, these addresses are also output
section offsets, used by checks in tools/objtool/check.c.  When linking
vmlinux, these .discard.* sections will be discarded, therefore it is
not a problem that R_X86_64_32 cannot represent a kernel address.

Alternatively, we could set the SHF_ALLOC flag for .discard.* sections,
but I think non-SHF_ALLOC for sections to be discarded makes more sense.

Note: if we decide to never support REL architectures (e.g. arm, i386),
we can utilize R_*_NONE relocations (.reloc ., BFD_RELOC_NONE, sym),
making .discard.* sections zero-sized.  That said, the section content
waste is 4 bytes per entry, much smaller than sizeof(Elf{32,64}_Rel).

  [0] commit 1c0c1faf5692 ("objtool: Use relative pointers for annotations")
  [1] https://github.com/ClangBuiltLinux/linux/issues/1937

Signed-off-by: Fangrui Song <maskray@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20230920001728.1439947-1-maskray@google.com
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h   |    4 ++--
 arch/x86/include/asm/nospec-branch.h |    4 ++--
 include/linux/objtool.h              |   10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -58,7 +58,7 @@
 #define ANNOTATE_IGNORE_ALTERNATIVE				\
 	"999:\n\t"						\
 	".pushsection .discard.ignore_alts\n\t"			\
-	".long 999b - .\n\t"					\
+	".long 999b\n\t"					\
 	".popsection\n\t"
 
 /*
@@ -352,7 +352,7 @@ static inline int alternatives_text_rese
 .macro ANNOTATE_IGNORE_ALTERNATIVE
 	.Lannotate_\@:
 	.pushsection .discard.ignore_alts
-	.long .Lannotate_\@ - .
+	.long .Lannotate_\@
 	.popsection
 .endm
 
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -196,7 +196,7 @@
 .macro ANNOTATE_RETPOLINE_SAFE
 .Lhere_\@:
 	.pushsection .discard.retpoline_safe
-	.long .Lhere_\@ - .
+	.long .Lhere_\@
 	.popsection
 .endm
 
@@ -334,7 +334,7 @@
 #define ANNOTATE_RETPOLINE_SAFE					\
 	"999:\n\t"						\
 	".pushsection .discard.retpoline_safe\n\t"		\
-	".long 999b - .\n\t"					\
+	".long 999b\n\t"					\
 	".popsection\n\t"
 
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -48,13 +48,13 @@
 #define ANNOTATE_NOENDBR					\
 	"986: \n\t"						\
 	".pushsection .discard.noendbr\n\t"			\
-	".long 986b - .\n\t"					\
+	".long 986b\n\t"					\
 	".popsection\n\t"
 
 #define ASM_REACHABLE							\
 	"998:\n\t"							\
 	".pushsection .discard.reachable\n\t"				\
-	".long 998b - .\n\t"						\
+	".long 998b\n\t"						\
 	".popsection\n\t"
 
 #else /* __ASSEMBLY__ */
@@ -66,7 +66,7 @@
 #define ANNOTATE_INTRA_FUNCTION_CALL				\
 	999:							\
 	.pushsection .discard.intra_function_calls;		\
-	.long 999b - .;						\
+	.long 999b;						\
 	.popsection;
 
 /*
@@ -118,7 +118,7 @@
 .macro ANNOTATE_NOENDBR
 .Lhere_\@:
 	.pushsection .discard.noendbr
-	.long	.Lhere_\@ - .
+	.long	.Lhere_\@
 	.popsection
 .endm
 
@@ -142,7 +142,7 @@
 .macro REACHABLE
 .Lhere_\@:
 	.pushsection .discard.reachable
-	.long	.Lhere_\@ - .
+	.long	.Lhere_\@
 	.popsection
 .endm
 


