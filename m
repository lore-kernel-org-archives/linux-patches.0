Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EEA1F3B87;
	Thu, 12 Feb 2026 01:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858623; cv=none; b=Q+b0TEw/CHZPZHaPrgkyzLaoKwIagOIN6IMBL6Rh+s10QlasSUiY8AvAUaPv8vIrF4/sb5J9MTKzQ/wVHwaAJKhAKRTOerGje9a5PJ8oSyITZHYVXr0T+kJhPCm2qoVh01NanF4HzfmQzgl++0XNudfqaYrYE3q7m1SaVOQNuc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858623; c=relaxed/simple;
	bh=modUTFKj8TAetEiD833303S3DI37/B4hc8/Xato7fv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOxzkghJkWgqfykDAp+n59rKeCCOhfubVxmq+c1XknilGA1BNrik0Slr1HN+wTuhCMLtGrSoTN+o10NZpbxG+nsbIIhVSIy+57IocYdYmrYLfa7H1BDqy3XmZrtUlrozHIm9fF8sR/p2zW93JniCq7SvXbnTvBX5rjZplDHbDBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPDTEOEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPDTEOEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB42C2BC86;
	Thu, 12 Feb 2026 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858623;
	bh=modUTFKj8TAetEiD833303S3DI37/B4hc8/Xato7fv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPDTEOEuDfQKSaOCaumF7+HR+Iacosuo3TXuiai+vH5lgn2AL2bWgdqfjfKynqoU8
	 RIpM0WiydE3VuRXUf40hHO+QD7qXVy3LLcGOHeEFT+fWAx4v1SPtYdJF/WkORCh7Ia
	 f/lGW1S9rPtRmx210g6XFU3L7gLNvo0SkUQQGjCpOPcg37A4CV5qVG/wFYX/0+9EFW
	 VIysklQm4burpg8TYFjdrSTyuoJQRawggPqzfpeSW/exzluHRr4NIAnEat7jv8bfnz
	 FXPPg5iL99BoLgn70PgMuEVe1/+PTIQ5mF+nQgjnuPt+LByfbn5wZI3v5MuTD0yqzm
	 5Fs0bgcedYjzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cupertino Miranda <cupertino.miranda@oracle.com>,
	Andrew Pinski <andrew.pinski@oss.qualcomm.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	David Faust <david.faust@oracle.com>,
	Jose Marchesi <jose.marchesi@oracle.com>,
	Elena Zannoni <elena.zannoni@oracle.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	daniel@iogearbox.net,
	andrii@kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] bpf: verifier improvement in 32bit shift sign extension pattern
Date: Wed, 11 Feb 2026 20:09:39 -0500
Message-ID: <20260212010955.3480391-16-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Cupertino Miranda <cupertino.miranda@oracle.com>

[ Upstream commit d18dec4b8990048ce75f0ece32bb96b3fbd3f422 ]

This patch improves the verifier to correctly compute bounds for
sign extension compiler pattern composed of left shift by 32bits
followed by a sign right shift by 32bits.  Pattern in the verifier was
limitted to positive value bounds and would reset bound computation for
negative values.  New code allows both positive and negative values for
sign extension without compromising bound computation and verifier to
pass.

This change is required by GCC which generate such pattern, and was
detected in the context of systemd, as described in the following GCC
bugzilla: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=119731

Three new tests were added in verifier_subreg.c.

Signed-off-by: Cupertino Miranda  <cupertino.miranda@oracle.com>
Signed-off-by: Andrew Pinski  <andrew.pinski@oss.qualcomm.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Cc: David Faust  <david.faust@oracle.com>
Cc: Jose Marchesi  <jose.marchesi@oracle.com>
Cc: Elena Zannoni  <elena.zannoni@oracle.com>
Link: https://lore.kernel.org/r/20251202180220.11128-2-cupertino.miranda@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile my findings.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** `bpf: verifier improvement in 32bit shift sign extension
pattern`

The commit message describes an **improvement** to the BPF verifier's
bounds tracking for a sign extension pattern (`<<32 s>>32`). Key points:
- The verifier was previously limited to tracking bounds only for
  **positive** values in the `<<32` special case
- When the 32-bit bounds were **negative**, the verifier would reset
  bounds to `[S64_MIN, S64_MAX]`, losing all tracking information
- This caused BPF programs compiled by **GCC** to fail verification,
  because GCC generates this sign extension pattern for code that
  includes negative values
- The GCC bugzilla (119731) confirms this was discovered in the context
  of **systemd** BPF programs

The commit is described as an "improvement" but its practical effect is
to **fix a verifier rejection** - BPF programs that should be valid are
being rejected because the verifier cannot track bounds through this
code pattern.

### 2. CODE CHANGE ANALYSIS

The change modifies a single function: `__scalar64_min_max_lsh()` in
`kernel/bpf/verifier.c`.

**Before (old code):**

```15314:15322:/home/sasha/linux-autosel/kernel/bpf/verifier.c
        if (umin_val == 32 && umax_val == 32 && dst_reg->s32_max_value
>= 0)
                dst_reg->smax_value = (s64)dst_reg->s32_max_value << 32;
        else
                dst_reg->smax_value = S64_MAX;

        if (umin_val == 32 && umax_val == 32 && dst_reg->s32_min_value
>= 0)
                dst_reg->smin_value = (s64)dst_reg->s32_min_value << 32;
        else
                dst_reg->smin_value = S64_MIN;
```

**After (new code):**
```c
        if (umin_val == 32 && umax_val == 32) {
                dst_reg->smax_value = (s64)dst_reg->s32_max_value << 32;
                dst_reg->smin_value = (s64)dst_reg->s32_min_value << 32;
        } else {
                dst_reg->smax_value = S64_MAX;
                dst_reg->smin_value = S64_MIN;
        }
```

**What changed:** The `&& dst_reg->s32_max_value >= 0` and `&&
dst_reg->s32_min_value >= 0` conditions were **removed**.

**Mathematical correctness analysis:**

The key insight is that `(s64)s32_value << 32` is an **order-
preserving** operation even for negative values:
- If `s32_min_value <= s32_max_value` (always true by definition), then
  `(s64)s32_min_value << 32 <= (s64)s32_max_value << 32`
- The cast `(s64)` sign-extends the 32-bit value to 64 bits, preserving
  sign
- The `<< 32` then shifts it left, which multiplies by 2^32 - this
  preserves the ordering of signed values
- For example: if s32 range is [-4095, 0], then the s64 shifted range is
  [-4095 * 2^32, 0], which is a valid signed 64-bit range

The original code was **overly conservative** - it only tracked the
pattern for positive s32 bounds because the author wasn't confident
about negative values. The comment even said "Perhaps we can generalize
this later." This commit does exactly that generalization, and the math
checks out.

**Importantly, the old code could cause the smin/smax to be set
inconsistently.** Consider a case where `s32_max_value >= 0` but
`s32_min_value < 0` (e.g., range [-5, 10]):
- `smax_value` would get the precise value `(s64)10 << 32`
- `smin_value` would get `S64_MIN` (because `s32_min_value < 0`)
- While this is *sound* (overly conservative), it causes the verifier to
  lose precision and **reject valid programs**

### 3. CLASSIFICATION

This is a **bug fix** that resolves **false-positive BPF verification
rejections**. When the BPF verifier rejects a valid program, users
cannot load their BPF programs. This is a real-world problem:
- Triggered by GCC-compiled BPF programs (increasing in usage)
- Discovered in the context of **systemd** (extremely widely deployed
  system daemon)
- systemd uses BPF for cgroup management, firewall rules, etc.
- If systemd's BPF programs fail to load, it impacts core system
  functionality

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 7 insertions, 11 deletions (net -4 lines).
  Extremely small.
- **Files touched:** 1 file (`kernel/bpf/verifier.c`)
- **Function modified:** 1 function (`__scalar64_min_max_lsh`)
- **Risk:** Very low. The change only **relaxes** a restriction (removes
  `>= 0` check), making the verifier **more permissive** in a
  mathematically sound way. It cannot cause a previously-accepted
  program to be rejected. It can only cause previously-rejected programs
  to be accepted.
- **Soundness concern:** Could this let through an UNSAFE program? No.
  The bounds after the shift are still correct - `(s64)s32_min << 32`
  through `(s64)s32_max << 32` is the exact signed range of the result.
  The subsequent `s>>32` (arithmetic right shift) in
  `scalar_min_max_arsh` handles the second half of the pattern correctly
  regardless of sign.

### 5. DEPENDENCIES

- The commit is **self-contained** - it modifies only
  `__scalar64_min_max_lsh` which was introduced in `3f50f132d8400e`
  (v5.7/v5.10 era) and **never modified since**
- It will apply cleanly to all stable branches (5.10.y, 5.15.y, 6.1.y,
  6.6.y, 6.12.y) since the code has been untouched
- The test changes are in a **separate commit** (`a5b4867fad18`) and are
  optional for the fix itself
- No other prerequisites are needed

### 6. USER IMPACT

**Who is affected:** Anyone running BPF programs compiled with GCC that
involve 32-bit to 64-bit sign extension patterns, particularly:
- **systemd** users (virtually all modern Linux systems)
- BPF program developers using GCC (growing as GCC BPF support matures)

**Severity:** Programs that should be valid are rejected by the
verifier. This can break:
- systemd cgroup management
- Firewall/filtering rules using BPF
- Monitoring and tracing tools

### 7. STABILITY INDICATORS

- **Acked-by:** Eduard Zingerman (BPF verifier reviewer)
- **Signed-off-by:** Alexei Starovoitov (BPF maintainer)
- The change is **conservative** - it only removes an unnecessary
  restriction
- The math is **provably correct** - left-shifting by exactly 32
  preserves ordering of s32 values when cast to s64
- Test cases in the companion commit confirm correctness for positive,
  negative, and mixed ranges

### 8. ARGUMENTS FOR BACKPORTING (YES)

1. **Fixes a real bug:** BPF programs compiled by GCC are falsely
   rejected
2. **systemd is affected:** This is a critical user-space component
3. **Extremely small and surgical:** 7 insertions, 11 deletions in 1
   function
4. **Mathematically sound:** The change only removes an unnecessary
   conservative restriction
5. **No dependencies:** Applies cleanly to all stable trees back to 5.10
6. **No regression risk:** Previously accepted programs remain accepted;
   only previously rejected valid programs now pass
7. **Acked by BPF verifier experts and maintainer**
8. **Function untouched for 5+ years:** Easy to apply to any stable tree

### 9. ARGUMENTS AGAINST BACKPORTING (NO)

1. **Described as "improvement"** rather than "fix" - could be seen as
   an enhancement
2. **No Cc: stable, no Fixes: tag** (expected for commits we're
   reviewing)
3. **Relaxes verifier restrictions** - the verifier is a security
   boundary, and making it more permissive could in theory allow unsafe
   programs. However, the mathematical analysis shows this is sound.
4. **GCC BPF compilation is relatively new** - older stable trees may
   have fewer users affected

### 10. VERDICT

The core question is: **Is this a bug fix or a feature?**

This is unequivocally a **bug fix**. The BPF verifier's purpose is to
accept all safe programs and reject all unsafe ones. When it rejects a
safe program, that is a false positive - a bug. The old code was overly
conservative because the original author was unsure about negative
values (as stated in the original comment: "Perhaps we can generalize
this later"). The new code generalizes it correctly.

The fact that this manifests in real-world scenarios (GCC-compiled
systemd BPF programs failing to load) and the fix is tiny, self-
contained, mathematically proven correct, and applies cleanly to all
stable trees makes this a strong candidate for backporting.

**YES**

 kernel/bpf/verifier.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3135643d56955..35aae8b33507e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15305,21 +15305,17 @@ static void __scalar64_min_max_lsh(struct bpf_reg_state *dst_reg,
 				   u64 umin_val, u64 umax_val)
 {
 	/* Special case <<32 because it is a common compiler pattern to sign
-	 * extend subreg by doing <<32 s>>32. In this case if 32bit bounds are
-	 * positive we know this shift will also be positive so we can track
-	 * bounds correctly. Otherwise we lose all sign bit information except
-	 * what we can pick up from var_off. Perhaps we can generalize this
-	 * later to shifts of any length.
+	 * extend subreg by doing <<32 s>>32. smin/smax assignments are correct
+	 * because s32 bounds don't flip sign when shifting to the left by
+	 * 32bits.
 	 */
-	if (umin_val == 32 && umax_val == 32 && dst_reg->s32_max_value >= 0)
+	if (umin_val == 32 && umax_val == 32) {
 		dst_reg->smax_value = (s64)dst_reg->s32_max_value << 32;
-	else
-		dst_reg->smax_value = S64_MAX;
-
-	if (umin_val == 32 && umax_val == 32 && dst_reg->s32_min_value >= 0)
 		dst_reg->smin_value = (s64)dst_reg->s32_min_value << 32;
-	else
+	} else {
+		dst_reg->smax_value = S64_MAX;
 		dst_reg->smin_value = S64_MIN;
+	}
 
 	/* If we might shift our top bit out, then we know nothing */
 	if (dst_reg->umax_value > 1ULL << (63 - umax_val)) {
-- 
2.51.0

