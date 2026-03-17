Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686E83F54A6;
	Tue, 17 Mar 2026 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766145; cv=none; b=Qed2KFb0aNBWyX5+mHVMWtbvzBlw6QYjufL997EOozX34fxhHHRS8x8mt4IkSNA0dx1nxcNAwMRJuoJdErT8AFOwsbXkrPPCnykN2Z9i2vny5EG9JonswTPx2PBCDoydNckup+ns7A7jGWveY+GvrRVT5f5W3bvWQbheJdO9mZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766145; c=relaxed/simple;
	bh=l3injB/bLXU277XZDx4vcwyF2nAj1VLJS2L1Py2HUhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqTLPzZTxgIDef5ffu2PRnDt/POKjIBxKi/welnIsjHP61sA+QAUUXmcsOWO9C07x25tMrDACIdTWv884612Z0lp5HqzAcFz6KsxM2wSd8OU3JepHQjrYunJqTsBCjFIlXl86XSEWe1h36D1OGPMo8qdWRRa0xj3535KZOe7+KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPr6zIUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPr6zIUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CF2C2BCB0;
	Tue, 17 Mar 2026 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766145;
	bh=l3injB/bLXU277XZDx4vcwyF2nAj1VLJS2L1Py2HUhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPr6zIUMnypb1YPDkZprJNTCrsiAtKk3FUVaeD+p9Vm3vptXnbnr/V0cU4FhAp+3v
	 Cv3oc3RllArzY6yZSigWEHprGtyLJqIFGItryep1qc8fZklIrR7BwxJ9R9HdE8CELi
	 a8cZTaeRxnYIDrg+I/EHX3sFHn4chlLQgfkBJd+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 180/378] objtool: Fix another stack overflow in validate_branch()
Date: Tue, 17 Mar 2026 17:32:17 +0100
Message-ID: <20260317163013.630659940@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 9a73f085dc91980ab7fcc5e9716f4449424b3b59 ]

The insn state is getting saved on the stack twice for each recursive
iteration.  No need for that, once is enough.

Fixes the following reported stack overflow:

  drivers/scsi/qla2xxx/qla_dbg.o: error: SIGSEGV: objtool stack overflow!
  Segmentation fault

Fixes: 70589843b36f ("objtool: Add option to trace function validation")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Closes: https://lore.kernel.org/90956545-2066-46e3-b547-10c884582eb0@app.fastmail.com
Link: https://patch.msgid.link/8b97f62d083457f3b0a29a424275f7957dd3372f.1772821683.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 37ec0d757e9b1..eba35bb8c0bdf 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3694,7 +3694,7 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 static int validate_branch(struct objtool_file *file, struct symbol *func,
 			   struct instruction *insn, struct insn_state state);
 static int do_validate_branch(struct objtool_file *file, struct symbol *func,
-			      struct instruction *insn, struct insn_state state);
+			      struct instruction *insn, struct insn_state *state);
 
 static int validate_insn(struct objtool_file *file, struct symbol *func,
 			 struct instruction *insn, struct insn_state *statep,
@@ -3959,7 +3959,7 @@ static int validate_insn(struct objtool_file *file, struct symbol *func,
  * tools/objtool/Documentation/objtool.txt.
  */
 static int do_validate_branch(struct objtool_file *file, struct symbol *func,
-			      struct instruction *insn, struct insn_state state)
+			      struct instruction *insn, struct insn_state *state)
 {
 	struct instruction *next_insn, *prev_insn = NULL;
 	bool dead_end;
@@ -3990,7 +3990,7 @@ static int do_validate_branch(struct objtool_file *file, struct symbol *func,
 			return 1;
 		}
 
-		ret = validate_insn(file, func, insn, &state, prev_insn, next_insn,
+		ret = validate_insn(file, func, insn, state, prev_insn, next_insn,
 				    &dead_end);
 
 		if (!insn->trace) {
@@ -4001,7 +4001,7 @@ static int do_validate_branch(struct objtool_file *file, struct symbol *func,
 		}
 
 		if (!dead_end && !next_insn) {
-			if (state.cfi.cfa.base == CFI_UNDEFINED)
+			if (state->cfi.cfa.base == CFI_UNDEFINED)
 				return 0;
 			if (file->ignore_unreachables)
 				return 0;
@@ -4026,7 +4026,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 	int ret;
 
 	trace_depth_inc();
-	ret = do_validate_branch(file, func, insn, state);
+	ret = do_validate_branch(file, func, insn, &state);
 	trace_depth_dec();
 
 	return ret;
-- 
2.51.0



