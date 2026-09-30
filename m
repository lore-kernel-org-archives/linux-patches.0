Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6030A509F06;
	Wed, 30 Sep 2026 18:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792447; cv=none; b=TO5VlJlPWwTSZCDzK8axlpClm5D0aRfUsEwKxPOXhPLJjJZtiwp4V9vtskV/Dx1efCtxViqJSMGaas7BbxVpypZE17g7GrYhe2K7LIEsiHrYBSeKMsDhglqfM+HDOb3yHCpTiMXuOtCVrwUu986cD3AkKUEDap8HqcdKuBpFc+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792447; c=relaxed/simple;
	bh=Pno/NWanxGr/tBSQSbXj6SuEYFLZ37HfcPLbA5OHQD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1EAsRpWf6+Tdnq2Q4mpsTmdedm24k6vFlENwLrEf+5YJqUzV6LADV8iX0dVLs4W+1QdUyPsm8FTkQAowb3tcN1Mj9dvm5VZAtKqMZZpsqCt7/4rPuDAuEcUHzc0Upcz8GojnJwysKeJlGeAIm2kttCCc9DGVum8Tb2SrKS5x2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iz6vYNuH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iz6vYNuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94E51F000FF;
	Wed, 30 Sep 2026 18:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792446;
	bh=vlqV5Xxb/ss2o+aV2sTT48DRcUQmnP2TzcbJF8T1gVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iz6vYNuHjfaUKFto5LSWdY2dG32xcuVrrBsN41I7nDD8tAlhItL+LiRJKE0b8tl8d
	 2Qd3kTIpKilCdIxngK7a3RabI4tzjGjAeAF/o7Jqv/hZW3c8CveOzuu/la882Wolw+
	 L+R/ARp1lykelsEnJyn8OulW4M2QILyiWSzI+NSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 613/752] bpf: Restrict CO-RE poisoning to relocatable instructions
Date: Wed, 30 Sep 2026 17:28:03 +0200
Message-ID: <20260930152411.548359893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 871a2ea8674ae..328c3e5cd8485 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -860,23 +860,30 @@ static int bpf_core_calc_relo(const char *prog_name,
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
@@ -927,17 +934,6 @@ static int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 
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
 
@@ -945,7 +941,9 @@ static int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 	case BPF_ALU:
 	case BPF_ALU64:
 		if (BPF_SRC(insn->code) != BPF_K)
-			return -EINVAL;
+			goto bad_insn;
+		if (res->poison)
+			return bpf_core_poison_insn(prog_name, relo_idx, insn, insn_idx);
 		if (res->validate && insn->imm != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (ALU/ALU64) value: got %u, exp %u -> %u\n",
 				prog_name, relo_idx,
@@ -961,6 +959,8 @@ static int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 	case BPF_LDX:
 	case BPF_ST:
 	case BPF_STX:
+		if (res->poison)
+			return bpf_core_poison_insn(prog_name, relo_idx, insn, insn_idx);
 		if (res->validate && insn->off != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDX/ST/STX) value: got %u, exp %u -> %u\n",
 				prog_name, relo_idx, insn_idx, insn->off, orig_val, new_val);
@@ -975,7 +975,7 @@ static int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 			pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) accesses field incorrectly. "
 				"Make sure you are accessing pointers, unsigned integers, or fields of matching type and size.\n",
 				prog_name, relo_idx, insn_idx);
-			goto poison;
+			return bpf_core_poison_insn(prog_name, relo_idx, insn, insn_idx);
 		}
 
 		orig_val = insn->off;
@@ -1017,6 +1017,9 @@ static int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 			return -EINVAL;
 		}
 
+		if (res->poison)
+			return bpf_core_poison_insn(prog_name, relo_idx, insn, insn_idx);
+
 		imm = (__u32)insn[0].imm | ((__u64)insn[1].imm << 32);
 		if (res->validate && imm != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDIMM64) value: got %llu, exp %u -> %u\n",
@@ -1034,6 +1037,7 @@ static int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 		break;
 	}
 	default:
+bad_insn:
 		pr_warn("prog '%s': relo #%d: trying to relocate unrecognized insn #%d, code:0x%x, src:0x%x, dst:0x%x, off:0x%x, imm:0x%x\n",
 			prog_name, relo_idx, insn_idx, insn->code,
 			insn->src_reg, insn->dst_reg, insn->off, insn->imm);
-- 
2.53.0



