Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805FB3839B2;
	Sat, 17 Oct 2026 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260778; cv=none; b=HcYwCz3mewXpwel3CwV+7gY/m6uCP+40AG5vO2osIHagHq/pd5oVK3mSM9WpEsoubKax+58mAWDh/OVyBTw49UrM5fUt9jTXajP7WTIMPtn1MwzsU9ov2tzUZCB1Mj2uz7pV/Q46JEa91Ozox7yPU/dBUnqQIKL4OdXZAMRAm/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260778; c=relaxed/simple;
	bh=kBVBKtVJy+RKC3n7j3y48RLVHWyipfmRODeijD48Jvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHn/tnWzup4zG4O/hTyvdlCH6QEQriCeqC4DsPQY0y8OQpVVrP0i9zHZa1sdwRmYQL/cHPIiuRgIlmu2fDwSkIo/pY7fPBnBIa/pHSff331JAiAb4EIaQL8XrDPC77WQdHNJ1Y/V+alsEN66tN4ivxU8jcPBAEOVNeFot7bYnco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mws1NjyI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mws1NjyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B6A1F000C4;
	Sat, 17 Oct 2026 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260777;
	bh=oHxoUpOm0eceNt9tI8FYzrH484XrP5dtkKV66qoyNXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mws1NjyIbdp1adw68rXk9OJBzJg+Z8hf4MSNw6dAeF76dOCA/YypgzU/pvqNF++MB
	 fVz8qC8INSxx5MvKrPvHlPRWfCOIN4ahH/UfVsUt4jqsg6iks66XlicJ+WOEPtXo9Z
	 Q+kMWOGgY7mzkhX8dqtbjkDI4iHauXQDODXf6QlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1630/1674] bpf: move is_branch_taken() down
Date: Sat, 17 Oct 2026 18:05:02 +0200
Message-ID: <20261017160512.919930711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit c697289efe4ef38bc5c62f119cb74433f784b826 ]

Move is_branch_taken() slightly down. In subsequent patched we'll need
both flip_opcode() and is_pkt_ptr_branch_taken() for is_branch_taken(),
but instead of sprinkling forward declarations around, it makes more
sense to move is_branch_taken() lower below is_pkt_ptr_branch_taken(),
and also keep it closer to very tightly related reg_set_min_max(), as
they are two critical parts of the same SCALAR range tracking logic.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231102033759.2541186-14-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: e51179a4e098 ("bpf: Don't predict JMP32 pointer vs zero comparisons")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 84 +++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6c088641c276d..da8ab195600cc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14246,48 +14246,6 @@ static int is_branch64_taken(struct bpf_reg_state *reg1, struct bpf_reg_state *r
 	return -1;
 }
 
-/* compute branch direction of the expression "if (<reg1> opcode <reg2>) goto target;"
- * and return:
- *  1 - branch will be taken and "goto target" will be executed
- *  0 - branch will not be taken and fall-through to next insn
- * -1 - unknown. Example: "if (reg1 < 5)" is unknown when register value
- *      range [0,10]
- */
-static int is_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_state *reg2,
-			   u8 opcode, bool is_jmp32)
-{
-	struct tnum reg2_tnum = is_jmp32 ? tnum_subreg(reg2->var_off) : reg2->var_off;
-	u64 val;
-
-	if (!tnum_is_const(reg2_tnum))
-		return -1;
-	val = reg2_tnum.value;
-
-	if (__is_pointer_value(false, reg1)) {
-		if (!reg_not_null(reg1))
-			return -1;
-
-		/* If pointer is valid tests against zero will fail so we can
-		 * use this to direct branch taken.
-		 */
-		if (val != 0)
-			return -1;
-
-		switch (opcode) {
-		case BPF_JEQ:
-			return 0;
-		case BPF_JNE:
-			return 1;
-		default:
-			return -1;
-		}
-	}
-
-	if (is_jmp32)
-		return is_branch32_taken(reg1, reg2, opcode);
-	return is_branch64_taken(reg1, reg2, opcode);
-}
-
 static int flip_opcode(u32 opcode)
 {
 	/* How can we transform "a <op> b" into "b <op> a"? */
@@ -14349,6 +14307,48 @@ static int is_pkt_ptr_branch_taken(struct bpf_reg_state *dst_reg,
 	return -1;
 }
 
+/* compute branch direction of the expression "if (<reg1> opcode <reg2>) goto target;"
+ * and return:
+ *  1 - branch will be taken and "goto target" will be executed
+ *  0 - branch will not be taken and fall-through to next insn
+ * -1 - unknown. Example: "if (reg1 < 5)" is unknown when register value
+ *      range [0,10]
+ */
+static int is_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_state *reg2,
+			   u8 opcode, bool is_jmp32)
+{
+	struct tnum reg2_tnum = is_jmp32 ? tnum_subreg(reg2->var_off) : reg2->var_off;
+	u64 val;
+
+	if (!tnum_is_const(reg2_tnum))
+		return -1;
+	val = reg2_tnum.value;
+
+	if (__is_pointer_value(false, reg1)) {
+		if (!reg_not_null(reg1))
+			return -1;
+
+		/* If pointer is valid tests against zero will fail so we can
+		 * use this to direct branch taken.
+		 */
+		if (val != 0)
+			return -1;
+
+		switch (opcode) {
+		case BPF_JEQ:
+			return 0;
+		case BPF_JNE:
+			return 1;
+		default:
+			return -1;
+		}
+	}
+
+	if (is_jmp32)
+		return is_branch32_taken(reg1, reg2, opcode);
+	return is_branch64_taken(reg1, reg2, opcode);
+}
+
 /* Adjusts the register min/max values in the case that the dst_reg is the
  * variable register that we are working on, and src_reg is a constant or we're
  * simply doing a BPF_K check.
-- 
2.53.0



