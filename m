Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1403D74
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 12:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E54C433C1;
	Mon, 21 Nov 2022 12:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669034680;
	bh=YGfTrH/XCYdAcmvlSU3rPMRSaVp9GxTpcu0loJ9SueA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PM6belHAwwcUKBtEMJFwNtOLx50w68A5NDu8ZLMZKrab9IIDiOSu0Tr0tDwhGVUAU
	 DUIQkOAtSCAoernj5rZFqspBNmiGLHafAucgg8TWYchprcvUkdk6oClbOi9ADeo8p9
	 b+m20zh5tXkRsnnwlKMAEgjcAT1O+BW11E/NNUGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
	Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 19/34] x86/speculation: Change FILL_RETURN_BUFFER to work with objtool
Date: Mon, 21 Nov 2022 13:43:41 +0100
Message-Id: <20221121124151.578607852@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

commit 089dd8e53126ebaf506e2dc0bf89d652c36bfc12 upstream.

Change FILL_RETURN_BUFFER so that objtool groks it and can generate
correct ORC unwind information.

 - Since ORC is alternative invariant; that is, all alternatives
   should have the same ORC entries, the __FILL_RETURN_BUFFER body
   can not be part of an alternative.

   Therefore, move it out of the alternative and keep the alternative
   as a sort of jump_label around it.

 - Use the ANNOTATE_INTRA_FUNCTION_CALL annotation to white-list
   these 'funny' call instructions to nowhere.

 - Use UNWIND_HINT_EMPTY to 'fill' the speculation traps, otherwise
   objtool will consider them unreachable.

 - Move the RSP adjustment into the loop, such that the loop has a
   deterministic stack layout.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/20200428191700.032079304@infradead.org
[cascardo: fixup because of backport of ba6e31af2be96c4d0536f2152ed6f7b6c11bca47 ("x86/speculation: Add LFENCE to RSB fill sequence")]
[cascardo: no intra-function call validation support]
[cascardo: avoid UNWIND_HINT_EMPTY because of svm]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -4,11 +4,13 @@
 #define _ASM_X86_NOSPEC_BRANCH_H_
 
 #include <linux/static_key.h>
+#include <linux/frame.h>
 
 #include <asm/alternative.h>
 #include <asm/alternative-asm.h>
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
+#include <asm/unwind_hints.h>
 
 /*
  * Fill the CPU return stack buffer.
@@ -51,9 +53,9 @@
 	lfence;					\
 	jmp	775b;				\
 774:						\
+	add	$(BITS_PER_LONG/8) * 2, sp;	\
 	dec	reg;				\
 	jnz	771b;				\
-	add	$(BITS_PER_LONG/8) * nr, sp;	\
 	/* barrier for jnz misprediction */	\
 	lfence;
 #else
@@ -158,10 +160,8 @@
   */
 .macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
 #ifdef CONFIG_RETPOLINE
-	ANNOTATE_NOSPEC_ALTERNATIVE
-	ALTERNATIVE "jmp .Lskip_rsb_\@",				\
-		__stringify(__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP))	\
-		\ftr
+	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
+	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
 .Lskip_rsb_\@:
 #endif
 .endm


