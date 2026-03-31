Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724B0423A62;
	Tue, 31 Mar 2026 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974853; cv=none; b=JyC+sg9UAeWDRv2VxhsJW2j47zIcJZ8FXidiEbDZ3j3FDXm35OILO6Pbmije3/qu+BJFHAAfgXMgB+tbgIakYN2oIlvTxKnnnsK5w1RNR23jxEeYe0EUc204EtYNSL9xdS5IgkFpG9nxKlnIAI7Y8pMH/nL+1qB8f7/glyeG8yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974853; c=relaxed/simple;
	bh=thCXMQgGjhMqNhcJq90CPaVvmleWit9k1GVwhVP/xkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSlHSkgPmLYW577wnK04uRhaJkyE6WOxHVBBuAJgfz/aTJ8dm4w2dBfrYRkKnwlW0f4ROokVS/bwF3I2aA/KVM3Hi2EMaiW+t/GMrakmhfF6tJQukOmNfeHPBZKNiV2cMFdDvbz7U2BzID0qdS0RG6shcmLz3HPE8wR/ZEjE8BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkxRWdiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkxRWdiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07101C19423;
	Tue, 31 Mar 2026 16:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974853;
	bh=thCXMQgGjhMqNhcJq90CPaVvmleWit9k1GVwhVP/xkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkxRWdiKlTuqRffatOT3n+0iJSxUygX2i7DzruEknJ2lzytvjGZ79BA792+CskVSZ
	 zNHJ2IfgN+lLP1nmhISEKj1IMpfFjh2AhCEBdGPpyal6RvNh5Y3eGqXeHKcZperAMx
	 TRoQT35w+i1PDINEdFOWbpbEB711WdvgoDI0HMoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 070/342] objtool: Handle Clang RSP musical chairs
Date: Tue, 31 Mar 2026 18:18:23 +0200
Message-ID: <20260331161801.471818630@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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
index f4af825082284..4544c2cb44400 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -395,52 +395,36 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
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
index eba35bb8c0bdf..30609aed5d37e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2960,6 +2960,20 @@ static int update_cfi_state(struct instruction *insn,
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



