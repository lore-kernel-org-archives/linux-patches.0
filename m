Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2520D30C345;
	Tue, 31 Mar 2026 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974297; cv=none; b=qFcwmJ2hb/E4kb+ib9mTFtqyPeL3wGmeLvgs5zGC21lI+s9HFqGU3Skhu12y0xgZVxe2FR67tNfHUv/PnhP/5XicUSZOwdykrNaigNoe8eOyjdveV3lEJR70+5XWxuf09BljUp1HE2UNETHe82C0nMTPP3MuxYLxv5kt1O9Dsfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974297; c=relaxed/simple;
	bh=ez8jx2xjKK4/nFL1CC10HcnWTlvLEU4dLddSMX8Kphs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlEO13n0EZRkDtEPNk06OCt0o31eP5ZwqYgSztZyrvlR9PKrunsYSfdE3mDoJyKDEpz+xmZ9BDK2SYLaZlAV2VZkZ+3XQO9neCke7C5aS5J7WpnwdgUPB0QUnFHUUh4uIOFtCUyrzoc1rulpBj6qKWd+CKWoZuXLP8rZrdzsngU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpMbNUco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpMbNUco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797F9C19423;
	Tue, 31 Mar 2026 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974296;
	bh=ez8jx2xjKK4/nFL1CC10HcnWTlvLEU4dLddSMX8Kphs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpMbNUco2zpv3ZGVBRInXQBzvXmxG2cKIV5MIaCcBmprcTL5J+QRM/rHbGCcUFLqs
	 ZRYYoNzyzhHPGGWlyOVGrLRGXHCiOJ/CKlp3DlTfcv3UJmiWZ85ADxSeWkDQ3kcaTs
	 2w8LfIASpWyaTMl0NnSf2iyLuH3m3wXLbt3xokn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/175] objtool: Handle Clang RSP musical chairs
Date: Tue, 31 Mar 2026 18:20:14 +0200
Message-ID: <20260331161730.893627302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c0f25d00181ec..40a5aa02bd831 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -325,52 +325,36 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
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
index c021798ba8372..6497c80fd6f77 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2969,6 +2969,20 @@ static int update_cfi_state(struct instruction *insn,
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



