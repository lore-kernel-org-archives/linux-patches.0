Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E321E8826;
	Thu, 12 Feb 2026 01:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858616; cv=none; b=FTntgMB5wZn0ADOqOMK+PBYCGdVMMxtHLi2SukTujyZN8ODdbzJ5GR/VPZCQ/7UDOy85xWv/RxDxDiS4PjL5WvhcB7pymJvd8ldOmtPfmGrKPEzEH2MxqaC6nBxBYY+Id9OlWyjfvxX6/tYRIuwekL81q8AlpsuZOGbPTTAEf6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858616; c=relaxed/simple;
	bh=9QpUfoGBFUgI+aI9SJipx7pdiJQITD9AX/BNdWbpuI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pY4AX5eBo/1dDPVijjld6BUry+EXtpomHDo6r2FVHggCm8bQ6o3At280W2EzxccqDcY+PxQljnAkjvpFcAdy/SSMu3xr2ajh9ODv0XYMyn5J4RG8BQRKbX82fwCqChg4QcsgGW5uFuNKDrLlECXJQZlZF5FJwg/MojThDgNwGr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ei6iUwuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ei6iUwuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92421C2BC9E;
	Thu, 12 Feb 2026 01:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858615;
	bh=9QpUfoGBFUgI+aI9SJipx7pdiJQITD9AX/BNdWbpuI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ei6iUwuVTmFou/r2ZjLBDNgT6YbQlglj5ETZAGCuuXTUnQlKXShSkWhBHpM9mNbOT
	 kp0xNZJ8cWJGAmnFo1FjGLcmok80pmETaqVV8M8aGdMli9vyxe1GyKpORS9ASD9Dba
	 bDNYmX2kvu7sJUJ70oeoZrDPb/VB9auK9i1aQp9rPNJY+ERS43Zm8qbpo/nxGFRm5I
	 t/2ycVNXaF1CihvvUa58O2zAmpLFJ9oj5FkiMfkPAfWdFYv7El3rArmjLhOl2vZb30
	 06T2UcBkgqjT4RYz/n6k4XskOWnjrnSG6F25llyC31ugMpud/Vm9legtkH5UZz88Fq
	 i54edokl0u7ww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Anton Protopopov <a.s.protopopov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	daniel@iogearbox.net,
	andrii@kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] bpf: Properly mark live registers for indirect jumps
Date: Wed, 11 Feb 2026 20:09:34 -0500
Message-ID: <20260212010955.3480391-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit d1aab1ca576c90192ba961094d51b0be6355a4d6 ]

For a `gotox rX` instruction the rX register should be marked as used
in the compute_insn_live_regs() function. Fix this.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://lore.kernel.org/r/20260114162544.83253-2-a.s.protopopov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me summarize my analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit fixes `compute_insn_live_regs()` so that for a `gotox rX`
instruction (BPF indirect jump via register), the register `rX` is
properly marked as "used" in the DFA-based liveness analysis.

### 2. Code Change Analysis

The change is to the `BPF_JMP`/`BPF_JMP32` → `BPF_JA` case within
`compute_insn_live_regs()`.

**Before the fix**: `BPF_JA` fell through to `BPF_JCOND`, both setting
`def=0, use=0`. This means for a `gotox rX` instruction (`BPF_JA |
BPF_X`), the destination register was **not** marked as "used" — the
liveness analysis treated it as if no register was read.

**After the fix**: `BPF_JA` gets its own case block that distinguishes
between:
- `BPF_SRC == BPF_X` (gotox rX): `use = dst` — marks the destination
  register as used (correct)
- `BPF_SRC == BPF_K` (regular goto): `use = 0` — no register used (same
  as before)

### 3. Impact Assessment

The liveness data (`live_regs_before`) is consumed in two critical
verifier functions:

- **`clean_func_state()`** (line 18980): Clears registers that aren't
  live, calling `__mark_reg_not_init()`. If the gotox register is
  incorrectly marked as not-live, its state gets cleared before state
  comparison.
- **`func_states_equal()`** (line 19450): Only compares registers that
  are live. If the gotox register is incorrectly marked not-live, two
  states that differ in that register will be considered equal —
  potentially causing **incorrect state pruning**.

Incorrect state pruning in the BPF verifier is a **security-relevant
bug**: it could cause the verifier to accept BPF programs that should be
rejected, since it might skip verification paths where the gotox
register has a different (potentially unsafe) value.

### 4. Feature Timeline / Dependency Analysis

| Feature | Commit | First Appears |
|---------|--------|---------------|
| DFA live regs analysis | `14c8552db644` | v6.15 |
| `gotox` (indirect jumps) | `493d9e0d60833` | v6.19 |
| **This fix** | `d1aab1ca576c` | Not yet in mainline (only in next
tree) |

Key findings:
- **v6.19** (released Feb 8, 2026) contains both the liveness analysis
  AND the gotox feature — meaning v6.19.y has this bug
- **v6.18.y and earlier** do NOT have `gotox` at all — the
  `BPF_JA|BPF_X` instruction cannot appear in programs on those kernels,
  making the bug unreachable
- The fix is **only relevant to 6.19.y stable**

### 5. Fix Quality

- **Small and surgical**: +6 lines, -0 lines of logic; just splits a
  case label and adds a condition
- **Obviously correct**: An instruction that reads a register must mark
  that register as "used" in liveness analysis
- **No risk to existing paths**: The regular `goto` (BPF_K) path still
  gets `use=0`, and `BPF_JCOND` still gets `use=0` — behavior unchanged
  for all non-gotox instructions
- **Self-contained**: No dependencies on other patches

### 6. Stable Tree Applicability

- **6.19.y**: YES — has both the liveness analysis and gotox feature;
  this bug is live
- **6.18.y and earlier**: NOT applicable — no gotox feature exists, bug
  is unreachable
- **Risk**: Very low — the change is minimal and only affects the new
  gotox code path

### 7. Verdict

This is a genuine BPF verifier correctness bug with potential security
implications (incorrect state pruning could allow unsafe programs). The
fix is small, obviously correct, and self-contained. It applies to
v6.19.y stable where the gotox instruction exists. While the bug only
affects the relatively new `gotox` feature, that feature shipped in
v6.19 which is now a released kernel with an active stable tree. The BPF
verifier is a security-critical component and correctness bugs in it are
treated seriously.

**YES**

 kernel/bpf/verifier.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f90bf8b5d0ddd..c9c76c1672157 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24844,6 +24844,12 @@ static void compute_insn_live_regs(struct bpf_verifier_env *env,
 	case BPF_JMP32:
 		switch (code) {
 		case BPF_JA:
+			def = 0;
+			if (BPF_SRC(insn->code) == BPF_X)
+				use = dst;
+			else
+				use = 0;
+			break;
 		case BPF_JCOND:
 			def = 0;
 			use = 0;
-- 
2.51.0

