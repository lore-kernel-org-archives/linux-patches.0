Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C34C54705C;
	Wed, 30 Sep 2026 19:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796662; cv=none; b=C2d9r9YsAE3w2BcX8iy/7cdvWcAhj9JSLBpRPBSUiZ9KOCOHJeY3AO57TigF41+EID3wlKIII9gI3mSHPjl6+10Q3f/nldcxkuh1z0tSmE+zqSYlUOJ7rTlV9olqGINV2fUMzmH5SjDPaLd1jTlbVcGfyjDj35Es6ACZTRFKLZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796662; c=relaxed/simple;
	bh=OiLK+I0dsykiBKriu08s5S3PZ56sbF6FoXws/EhQQ0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVgiDY3OHZQyjub7XfdgM1n9ntc8gDJft46njXsQIrf/e8pcdj0pTXSu8QmR5L1RFUwMqg4pLX4ek/A6YJP/dKD9BiVHhbL3YSQApgHw8Jf+cmb6rST58y+9op8rKo8TIsaUorXQWR/5IXNjybntueNHMHKooPngR0oVyKqZ3GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOMy/EmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOMy/EmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F591F000FF;
	Wed, 30 Sep 2026 19:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796661;
	bh=hjlVEjob4QZeEh43XzdAkFXfJ0F550Qio6ZNayzvTyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOMy/EmQ3MIhdt+B7zmtcCEhsVSaOOCb2wU+N/pCt/eHslverm5PGDcq1YdSWiPkG
	 eMxO0s8VV9Eybrl7nSOOjNX2BHnaq1uiMnwlJJKIRsuVtF3BDA4XJix8CILVgJUexU
	 4WgtfJBu1xxsVGTdueH418bStuidFYmAVAIgJL5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0990/1193] bpf: Restrict CO-RE poisoning to relocatable instructions
Date: Wed, 30 Sep 2026 17:27:54 +0200
Message-ID: <20260930152456.239350604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 394ae398337c5f87e567f6cd63b937fc2b2f6ddc ]

CO-RE relocation records can name any instruction offset. When a
relocation cannot be resolved, bpf_core_patch_insn() currently poisons its
target before checking whether that instruction is a valid relocation
target. Malformed metadata can therefore replace jumps, calls, exits,
register-source arithmetic, or non-immediate loads instead of failing at
the relocation step.

Handle poisoning only after the instruction has passed the same class and
operand-form checks used for a resolved relocation. Route invalid forms
through the existing diagnostic and return a hard error. Keep poisoning
supported instructions, including both halves of a plain ldimm64, so an
unresolved relocation in dead code remains valid.

Extend bpf_core_poison_insn() to poison both halves of ldimm64, and return
its status directly from each validated instruction case. This avoids
routing the success path through a common label and leaves the helper free
to report errors.

The shared relocation code applies this restriction to both libbpf and
in-kernel CO-RE.

Fixes: d7a252708dbc ("libbpf: Improve handling of failed CO-RE relocations")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260917233222.2542500-7-memxor@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/relo_core.c | 58 +++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index 04c8febfc0aa7..4367378d272b3 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -965,23 +965,30 @@ static int bpf_core_calc_relo(const char *prog_name,
 }
 
 /*
- * Turn instruction for which CO_RE relocation failed into invalid one with
+ * Turn instruction for which CO-RE relocation failed into invalid one with
  * distinct signature.
  */
-static void bpf_core_poison_insn(const char *prog_name, int relo_idx,
-				 int insn_idx, struct bpf_insn *insn)
+static int bpf_core_poison_insn(const char *prog_name, int relo_idx,
+				struct bpf_insn *insn, int insn_idx)
 {
-	pr_debug("prog '%s': relo #%d: substituting insn #%d w/ invalid insn\n",
-		 prog_name, relo_idx, insn_idx);
-	insn->code = BPF_JMP | BPF_CALL;
-	insn->dst_reg = 0;
-	insn->src_reg = 0;
-	insn->off = 0;
-	/* if this instruction is reachable (not a dead code),
-	 * verifier will complain with the following message:
-	 * invalid func unknown#195896080
-	 */
-	insn->imm = 195896080; /* => 0xbad2310 => "bad relo" */
+	int insn_cnt = is_ldimm64_insn(insn) ? 2 : 1;
+	int i;
+
+	for (i = 0; i < insn_cnt; i++) {
+		pr_debug("prog '%s': relo #%d: substituting insn #%d w/ invalid insn\n",
+			 prog_name, relo_idx, insn_idx + i);
+		insn[i].code = BPF_JMP | BPF_CALL;
+		insn[i].dst_reg = 0;
+		insn[i].src_reg = 0;
+		insn[i].off = 0;
+		/*
+		 * If this instruction is reachable (not dead code), the verifier
+		 * will complain with "invalid func unknown#195896080".
+		 */
+		insn[i].imm = 195896080; /* => 0xbad2310 => "bad relo" */
+	}
+
+	return 0;
 }
 
 static int insn_bpf_size_to_bytes(struct bpf_insn *insn)
@@ -1032,17 +1039,6 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 
 	class = BPF_CLASS(insn->code);
 
-	if (res->poison) {
-poison:
-		/* poison second part of ldimm64 to avoid confusing error from
-		 * verifier about "unknown opcode 00"
-		 */
-		if (is_ldimm64_insn(insn))
-			bpf_core_poison_insn(prog_name, relo_idx, insn_idx + 1, insn + 1);
-		bpf_core_poison_insn(prog_name, relo_idx, insn_idx, insn);
-		return 0;
-	}
-
 	orig_val = res->orig_val;
 	new_val = res->new_val;
 
@@ -1050,7 +1046,9 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 	case BPF_ALU:
 	case BPF_ALU64:
 		if (BPF_SRC(insn->code) != BPF_K)
-			return -EINVAL;
+			goto bad_insn;
+		if (res->poison)
+			return bpf_core_poison_insn(prog_name, relo_idx, insn, insn_idx);
 		if (res->validate && insn->imm != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (ALU/ALU64) value: got %u, exp %llu -> %llu\n",
 				prog_name, relo_idx,
@@ -1067,6 +1065,8 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 	case BPF_LDX:
 	case BPF_ST:
 	case BPF_STX:
+		if (res->poison)
+			return bpf_core_poison_insn(prog_name, relo_idx, insn, insn_idx);
 		if (res->validate && insn->off != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDX/ST/STX) value: got %u, exp %llu -> %llu\n",
 				prog_name, relo_idx, insn_idx, insn->off, (unsigned long long)orig_val,
@@ -1082,7 +1082,7 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 			pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) accesses field incorrectly. "
 				"Make sure you are accessing pointers, unsigned integers, or fields of matching type and size.\n",
 				prog_name, relo_idx, insn_idx);
-			goto poison;
+			return bpf_core_poison_insn(prog_name, relo_idx, insn, insn_idx);
 		}
 
 		orig_val = insn->off;
@@ -1125,6 +1125,9 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 			return -EINVAL;
 		}
 
+		if (res->poison)
+			return bpf_core_poison_insn(prog_name, relo_idx, insn, insn_idx);
+
 		imm = (__u32)insn[0].imm | ((__u64)insn[1].imm << 32);
 		if (res->validate && imm != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDIMM64) value: got %llu, exp %llu -> %llu\n",
@@ -1142,6 +1145,7 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 		break;
 	}
 	default:
+bad_insn:
 		pr_warn("prog '%s': relo #%d: trying to relocate unrecognized insn #%d, code:0x%x, src:0x%x, dst:0x%x, off:0x%x, imm:0x%x\n",
 			prog_name, relo_idx, insn_idx, insn->code,
 			insn->src_reg, insn->dst_reg, insn->off, insn->imm);
-- 
2.53.0



