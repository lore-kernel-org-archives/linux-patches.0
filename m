Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AA233120E;
	Tue, 31 Mar 2026 16:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975754; cv=none; b=uQP18EkGg6tKzyXtShy7R9OU7igvirLRs2iay1xWEB3m68kx04ZejxUo/Pwo0I5JCo7hdpqip6jQVBnLZsynu07dgp96VtsoC2U0IvY34ugf3qtPfp31a/q4upKvJ06wNEoXep2NZ4u9R2+Mr95IZbeLwqnSdlX8cLNh3TMRD3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975754; c=relaxed/simple;
	bh=bQYArPzY/siTpP7U3fgPGvC1BttN5s1ntOkESjt0SEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaZKnQY6GuyCYHOqvTbFs22h6K0F7fvDxnBPLkisxdz+EvjCNXsbIhy1fSzYzmnKadMlfoJolkOWx2n+siVhNmUWRj/UsILB1qsku6HO+l0axYr36SgFPTLmrRBN8alMCOMZTIvhmYz27K+gKTkvxrWtco3sPfjNhrLBbEZOw3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqiS3QFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqiS3QFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9846AC19423;
	Tue, 31 Mar 2026 16:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975753;
	bh=bQYArPzY/siTpP7U3fgPGvC1BttN5s1ntOkESjt0SEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqiS3QFjKkBeNOs5rnNbDfK/Jj/qXRsY+OuBbeOi0IeoO+m7kqfshHaL/4BV6fAz4
	 DpgqVCA56pgbdXMFgs924ZvPf65m3tloTsMIK2pUYmX9NskoQqJ4OiiQOvk/ZQfTZw
	 O1ClKpA6DWWvLT9jwjXyGToxwVrlVUbmSjINNfuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/244] objtool: Handle Clang RSP musical chairs
Date: Tue, 31 Mar 2026 18:19:50 +0200
Message-ID: <20260331161743.179407713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 7fdaa640c810cb42090a182c33f905bcc47a616a ]

For no apparent reason (possibly related to CONFIG_KMSAN), Clang can
randomly pass the value of RSP to other registers and then back again to
RSP.  Handle that accordingly.

Fixes the following warnings:

  drivers/input/misc/uinput.o: warning: objtool: uinput_str_to_user+0x165: undefined stack state
  drivers/input/misc/uinput.o: warning: objtool: uinput_str_to_user+0x165: unknown CFA base reg -1

Reported-by: Arnd Bergmann <arnd@arndb.de>
Closes: https://lore.kernel.org/90956545-2066-46e3-b547-10c884582eb0@app.fastmail.com
Link: https://patch.msgid.link/240e6a172cc73292499334a3724d02ccb3247fc7.1772818491.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/arch/x86/decode.c | 62 ++++++++++++---------------------
 tools/objtool/check.c           | 14 ++++++++
 2 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index ed6bff0e01dcd..f96b7b47babd5 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -331,52 +331,36 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 		if (!rex_w)
 			break;
 
-		if (modrm_reg == CFI_SP) {
-
-			if (mod_is_reg()) {
-				/* mov %rsp, reg */
-				ADD_OP(op) {
-					op->src.type = OP_SRC_REG;
-					op->src.reg = CFI_SP;
-					op->dest.type = OP_DEST_REG;
-					op->dest.reg = modrm_rm;
-				}
-				break;
-
-			} else {
-				/* skip RIP relative displacement */
-				if (is_RIP())
-					break;
-
-				/* skip nontrivial SIB */
-				if (have_SIB()) {
-					modrm_rm = sib_base;
-					if (sib_index != CFI_SP)
-						break;
-				}
-
-				/* mov %rsp, disp(%reg) */
-				ADD_OP(op) {
-					op->src.type = OP_SRC_REG;
-					op->src.reg = CFI_SP;
-					op->dest.type = OP_DEST_REG_INDIRECT;
-					op->dest.reg = modrm_rm;
-					op->dest.offset = ins.displacement.value;
-				}
-				break;
+		if (mod_is_reg()) {
+			/* mov reg, reg */
+			ADD_OP(op) {
+				op->src.type = OP_SRC_REG;
+				op->src.reg = modrm_reg;
+				op->dest.type = OP_DEST_REG;
+				op->dest.reg = modrm_rm;
 			}
-
 			break;
 		}
 
-		if (rm_is_reg(CFI_SP)) {
+		/* skip RIP relative displacement */
+		if (is_RIP())
+			break;
 
-			/* mov reg, %rsp */
+		/* skip nontrivial SIB */
+		if (have_SIB()) {
+			modrm_rm = sib_base;
+			if (sib_index != CFI_SP)
+				break;
+		}
+
+		/* mov %rsp, disp(%reg) */
+		if (modrm_reg == CFI_SP) {
 			ADD_OP(op) {
 				op->src.type = OP_SRC_REG;
-				op->src.reg = modrm_reg;
-				op->dest.type = OP_DEST_REG;
-				op->dest.reg = CFI_SP;
+				op->src.reg = CFI_SP;
+				op->dest.type = OP_DEST_REG_INDIRECT;
+				op->dest.reg = modrm_rm;
+				op->dest.offset = ins.displacement.value;
 			}
 			break;
 		}
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 4adb3f3d9aed8..ad83bb3197225 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3021,6 +3021,20 @@ static int update_cfi_state(struct instruction *insn,
 				cfi->stack_size += 8;
 			}
 
+			else if (cfi->vals[op->src.reg].base == CFI_CFA) {
+				/*
+				 * Clang RSP musical chairs:
+				 *
+				 *   mov %rsp, %rdx [handled above]
+				 *   ...
+				 *   mov %rdx, %rbx [handled here]
+				 *   ...
+				 *   mov %rbx, %rsp [handled above]
+				 */
+				cfi->vals[op->dest.reg].base = CFI_CFA;
+				cfi->vals[op->dest.reg].offset = cfi->vals[op->src.reg].offset;
+			}
+
 
 			break;
 
-- 
2.51.0



