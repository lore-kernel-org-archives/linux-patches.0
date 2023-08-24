Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA83311C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680CDC433C8;
	Thu, 24 Aug 2023 14:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889025;
	bh=n78b82LqZ3YLUJW3cgoQUSFG8HjhyCZRO39gsdQSsMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/GrQ5J7zzqmGKlm76Q92XRuf7Zfaq8arC0exYWxh2du6c9/kMOycF4hmsJpCxg0D
	 O0E2lcbcWYEzJoV8x2Os60ctp76mlcphUIGYLcJwIgqAbutd0YkAYHjhNXZw5+ozLo
	 /Dwbci0hYBrEFRlotuE+046F8tPhsxy51EUbGB74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kees Cook <keescook@chromium.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/139] x86/ibt: Add ANNOTATE_NOENDBR
Date: Thu, 24 Aug 2023 16:50:50 +0200
Message-ID: <20230824145028.981156932@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
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
 include/linux/objtool.h       | 16 ++++++++++++++++
 tools/include/linux/objtool.h | 16 ++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index d59e69df821eb..51f5b24af8342 100644
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
@@ -134,6 +140,13 @@ struct unwind_hint {
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
@@ -144,12 +157,15 @@ struct unwind_hint {
 	"\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
+#define ANNOTATE_NOENDBR
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
+.macro ANNOTATE_NOENDBR
+.endm
 #endif
 
 #endif /* CONFIG_STACK_VALIDATION */
diff --git a/tools/include/linux/objtool.h b/tools/include/linux/objtool.h
index d59e69df821eb..51f5b24af8342 100644
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
@@ -134,6 +140,13 @@ struct unwind_hint {
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
@@ -144,12 +157,15 @@ struct unwind_hint {
 	"\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
+#define ANNOTATE_NOENDBR
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
+.macro ANNOTATE_NOENDBR
+.endm
 #endif
 
 #endif /* CONFIG_STACK_VALIDATION */
-- 
2.40.1



