Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156DE14A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896A3C433C8;
	Thu, 24 Aug 2023 17:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897698;
	bh=TIwoDhcGtTPi1gD5Pf5x9e20JYl8qP42N/f3ksjMF3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCFVjUraUKIAd9r3B3SNxIMHJy1vjXo9r4MVHn8lkMTPI8q3GOmAYLGvgE8tDGQ6n
	 Aj2+d3aCLNtKDNV0hCrIbOg0Bjsb+gJtOrhgNugo4rD2ufNDeJVVbbmFytnolXeC3c
	 +xMZYFWnMICOwaAEsDEe8nqKl3GqJTJ5rEg9FO54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kees Cook <keescook@chromium.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/135] x86/ibt: Add ANNOTATE_NOENDBR
Date: Thu, 24 Aug 2023 19:09:55 +0200
Message-ID: <20230824170622.611914350@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c8c301abeae58ec756b8fcb2178a632bd3c9e284 ]

In order to have objtool warn about code references to !ENDBR
instruction, we need an annotation to allow this for non-control-flow
instances -- consider text range checks, text patching, or return
trampolines etc.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154317.578968224@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/objtool.h       |   16 ++++++++++++++++
 tools/include/linux/objtool.h |   16 ++++++++++++++++
 2 files changed, 32 insertions(+)

--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -82,6 +82,12 @@ struct unwind_hint {
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #endif
 
+#define ANNOTATE_NOENDBR					\
+	"986: \n\t"						\
+	".pushsection .discard.noendbr\n\t"			\
+	_ASM_PTR " 986b\n\t"					\
+	".popsection\n\t"
+
 #else /* __ASSEMBLY__ */
 
 /*
@@ -128,6 +134,13 @@ struct unwind_hint {
 	.popsection
 .endm
 
+.macro ANNOTATE_NOENDBR
+.Lhere_\@:
+	.pushsection .discard.noendbr
+	.quad	.Lhere_\@
+	.popsection
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_STACK_VALIDATION */
@@ -138,10 +151,13 @@ struct unwind_hint {
 	"\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
+#define ANNOTATE_NOENDBR
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .endm
+.macro ANNOTATE_NOENDBR
+.endm
 #endif
 
 #endif /* CONFIG_STACK_VALIDATION */
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -82,6 +82,12 @@ struct unwind_hint {
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #endif
 
+#define ANNOTATE_NOENDBR					\
+	"986: \n\t"						\
+	".pushsection .discard.noendbr\n\t"			\
+	_ASM_PTR " 986b\n\t"					\
+	".popsection\n\t"
+
 #else /* __ASSEMBLY__ */
 
 /*
@@ -128,6 +134,13 @@ struct unwind_hint {
 	.popsection
 .endm
 
+.macro ANNOTATE_NOENDBR
+.Lhere_\@:
+	.pushsection .discard.noendbr
+	.quad	.Lhere_\@
+	.popsection
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_STACK_VALIDATION */
@@ -138,10 +151,13 @@ struct unwind_hint {
 	"\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
+#define ANNOTATE_NOENDBR
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .endm
+.macro ANNOTATE_NOENDBR
+.endm
 #endif
 
 #endif /* CONFIG_STACK_VALIDATION */


