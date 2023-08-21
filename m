Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCB11171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FBBC433C9;
	Mon, 21 Aug 2023 20:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648343;
	bh=4nD8u9nNpJpZ5wAZW7xX1mvhw11J97gYxsm1YDatnJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kv8hf0UY/1JCC3px44iOapS7MgNKEchdK4a9zyEIXvA90+hxcNSoBD8WiCif1Owcg
	 3As2aKvK2LALVJoqYWfKuG0liIsEwYDKynwMjxtOOcwdC7ZupqTP/mNCgB4F1fmb3V
	 179wAk/ap3HwvKHLHCumUk7QhSRBF8zpVZ/s++74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 6.4 124/234] objtool/x86: Fixup frame-pointer vs rethunk
Date: Mon, 21 Aug 2023 21:41:27 +0200
Message-ID: <20230821194134.308191977@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
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

commit dbf46008775516f7f25c95b7760041c286299783 upstream.

For stack-validation of a frame-pointer build, objtool validates that
every CALL instruction is preceded by a frame-setup. The new SRSO
return thunks violate this with their RSB stuffing trickery.

Extend the __fentry__ exception to also cover the embedded_insn case
used for this. This cures:

  vmlinux.o: warning: objtool: srso_untrain_ret+0xd: call without frame pointer save/setup

Fixes: 4ae68b26c3ab ("objtool/x86: Fix SRSO mess")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20230816115921.GH980931@hirez.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2698,12 +2698,17 @@ static int decode_sections(struct objtoo
 	return 0;
 }
 
-static bool is_fentry_call(struct instruction *insn)
+static bool is_special_call(struct instruction *insn)
 {
-	if (insn->type == INSN_CALL &&
-	    insn_call_dest(insn) &&
-	    insn_call_dest(insn)->fentry)
-		return true;
+	if (insn->type == INSN_CALL) {
+		struct symbol *dest = insn_call_dest(insn);
+
+		if (!dest)
+			return false;
+
+		if (dest->fentry || dest->embedded_insn)
+			return true;
+	}
 
 	return false;
 }
@@ -3701,7 +3706,7 @@ static int validate_branch(struct objtoo
 			if (ret)
 				return ret;
 
-			if (opts.stackval && func && !is_fentry_call(insn) &&
+			if (opts.stackval && func && !is_special_call(insn) &&
 			    !has_valid_stack_frame(&state)) {
 				WARN_INSN(insn, "call without frame pointer save/setup");
 				return 1;


