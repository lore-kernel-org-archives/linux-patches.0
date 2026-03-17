Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA54F3ACF1D;
	Tue, 17 Mar 2026 11:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747184; cv=none; b=SevacfGYgQT+gFRsVeVoxVOeqpI+CtESAO09bu623Ks0c33BtoMnFkFBySYK+WhsnxFArhRsgfAN9t241wVuHx5/svXwA3y2d9T6vx3B/CMLVUjs6PvyuEwHy2nswEys1PEhQ1d8q4wPQRiFSAARQtgBiF3GOnh9VaA+1jylcEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747184; c=relaxed/simple;
	bh=ocrzA554RPBN8PDIsqByge586AsLkqpsTPXG1Jp9Ue8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=smXAN8WdYN2hCfnegLMe/cp9OpZsQm3Ab8dh6NDsO4htPVymMmJPsy2UO/uKvd4pyO5Wp7JAr1ZqOw3uz7XB0FWfRZrIYx0YxY9SPjrYpTDpRzVCiGsdCLRDkiFQ803yKTH9+E8i3RUpH/eEK3IsCLlo2ys44uT3/vUBi4bqLzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lby4uTHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lby4uTHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61FAC2BCAF;
	Tue, 17 Mar 2026 11:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747184;
	bh=ocrzA554RPBN8PDIsqByge586AsLkqpsTPXG1Jp9Ue8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lby4uTHJFmUZCkRAvAfFyCdPKjwkRvsKJ4jBrLvEsBQ3k6qpXFaMA1F0qiCdysRUg
	 NSdBEcoviJJnJ75gcazRoY9A8QBitHHP8FczSdoVCl4kSSkJWOI/30ienlLB1hqbAy
	 gKzgC+wiOqCa1xQdwRtBVgH2Lq+sub/qaMuwp6Al8iVwSGETibf/vGQTYAUrfQw3Q8
	 Z5JJd9vaEmo9fO0s+S0s96jEGqE/c/LE+P88+RsXvdbhwQA6SNJlYxYm/ERY+DZKZE
	 ZodJbdiWg+Zq+iy+NyLBWmwktqcCDfAIWRTVBYNO6juPk/W7OWw8J5Ps9E9S3oj4gY
	 YEM65jSsShwvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>,
	peterz@infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] objtool: Handle Clang RSP musical chairs
Date: Tue, 17 Mar 2026 07:32:42 -0400
Message-ID: <20260317113249.117771-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Now I can see the full OP_SRC_REG handling. The new `else if` block goes
between line 2961 (end of stack swizzle case 2) and line 2964 (break).

Key insight about the decode.c change: Previously, only `mov %rsp, reg`
and `mov reg, %rsp` generated OP_SRC_REG operations. Now ALL `mov reg,
reg` instructions will generate OP_SRC_REG operations. But looking at
the check.c handler, the OP_SRC_REG case only does something when
specific conditions are met (source is CFI_SP, destination is CFI_BP,
destination is cfa->base, etc.). For an arbitrary `mov %rax, %rbx` where
neither register has special CFI state, none of the existing `if/else
if` branches match, and the new branch also won't match (since
`cfi->vals[op->src.reg].base` won't be CFI_CFA unless the register was
previously set). So the change falls through to `break` harmlessly. This
means the decode.c generalization is safe - it just generates more
operations that get filtered in check.c.

Now I have enough information to make my assessment.

---

## Analysis

### 1. What Problem Does This Fix?

This commit fixes objtool's inability to track RSP (stack pointer)
values when Clang moves RSP through multiple intermediate registers in a
"musical chairs" pattern:
```
mov %rsp, %rdx    → tracked by existing code
mov %rdx, %rbx    → NOT tracked before this fix (intermediate)
mov %rbx, %rsp    → tracked by existing code, BUT fails because %rbx's
CFI state is unknown
```

Without this fix, objtool loses track of the stack state, generating:
- `"undefined stack state"` warning (check.c line 2834, returns error
  code 1)
- `"unknown CFA base reg -1"` error (orc.c line 74, returns -1)

These are not mere cosmetic warnings - the ORC unwind data generation
**fails** for the affected function, meaning no valid stack unwinding
data is produced for that function.

### 2. Impact Assessment

**Build impact:** With `CONFIG_OBJTOOL_WERROR=y` (recommended, "If
unsure, say Y"), the objtool warnings become errors and **the build
fails**. Even without WERROR, ORC generation fails for affected
functions.

**Runtime impact:** Without proper ORC data, the kernel unwinder cannot
produce correct stack traces for affected functions. This affects OOPS
debugging, perf profiling, and live patching.

**Scope of affected users:** According to the original bug report by
Arnd Bergmann, this affects **Clang versions 18 through 22** on x86
builds, particularly with KMSAN config. Clang is used by many
distributions and the Android kernel.

### 3. Stable Kernel Rules Assessment

- **Obviously correct and tested:** Yes - authored by Josh Poimboeuf,
  the objtool maintainer. Accepted into `objtool/urgent` branch. The
  logic is straightforward: track CFI_CFA state through intermediate
  registers.
- **Fixes a real bug:** Yes - build failures with Clang, broken ORC
  data.
- **Important issue:** Build fix category (explicitly allowed for
  stable). Also fixes incorrect ORC unwind data.
- **Small and contained:** Moderate size - changes to two files in
  objtool tooling only. The decode.c restructuring is a bit large but
  logically simple (generalize reg-to-reg tracking). The check.c
  addition is a clean 14-line addition.
- **No new features:** Correct - this only enables objtool to correctly
  handle existing compiler output.

### 4. Risk Assessment

**Low risk:**
- Changes are confined to build-time tooling (objtool), not runtime
  kernel code
- The decode.c generalization (tracking all `mov reg, reg`) is safe
  because the check.c handler already filters based on CFI state -
  arbitrary register moves that don't involve CFI-tracked values hit the
  `break` at the end of the if-else chain
- The check.c addition only activates when a register actually holds a
  CFI_CFA value, which only happens after a previous `mov %rsp, %reg`
- Authored by the objtool maintainer, merged through objtool/urgent

**Potential concern:** The decode.c restructuring changes the code flow
for the 0x89 handler, but careful analysis shows it preserves all
existing semantics while adding general reg-to-reg tracking. The `mov
%rsp, disp(%reg)` case is still handled (but now outside the
`mod_is_reg()` branch). The `mov reg, %rsp` case is now handled by the
general `mov reg, reg` case.

### 5. Backport Complexity

The patch should apply relatively cleanly to recent stable trees (6.6+,
6.1+) since the 0x89 handler structure hasn't changed significantly.
Older trees may need minor adjustments depending on objtool evolution.

### Verification

- **Verified** the current tree has the old decode.c pattern (lines
  394-446) matching the patch's "before" state
- **Verified** the "Clang RSP musical chairs" comment is NOT in check.c,
  confirming the commit is not yet applied
- **Verified** objtool Makefile uses `-Werror` (line 50), and
  `CONFIG_OBJTOOL_WERROR` passes `--werror` to objtool at build time
- **Verified** `WARN_INSN` at check.c:2834 returns 1 (error), causing
  build failure with WERROR
- **Verified** `ERROR_INSN` at orc.c:74 returns -1, causing ORC
  generation failure
- **Verified** via lore.kernel.org that the patch was accepted into
  objtool/urgent, indicating the maintainer considers it an urgent fix
- **Verified** via the original bug report (Arnd Bergmann) that Clang
  versions 18-22 are affected on x86
- **Verified** that the OP_SRC_REG handler in check.c (lines 2849-2964)
  has guarded conditions that prevent spurious matches from the
  generalized decode.c output
- **Verified** the commit is standalone (no patch series dependencies
  mentioned in lore discussion)
- **Verified** the affected code (0x89 handler) has existed since at
  least v5.x (commit 2a512829840e added related decode logic in 2021)

### Conclusion

This is a build fix for Clang users that prevents objtool errors and
ensures correct ORC unwind data generation. Build fixes are explicitly
allowed in stable. The fix is authored by the objtool maintainer, was
merged through the `objtool/urgent` branch, is self-contained, and
carries low risk since it only modifies build-time tooling. The affected
Clang versions (18-22) are widely used. The change is logically sound
and well-bounded.

**YES**

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
index 37ec0d757e9b1..188c3095bf273 100644
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

