Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201F9296BC5;
	Fri, 12 Dec 2025 02:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505364; cv=none; b=SMKpjIM7mTDoOwmaK97qVfESkQJZB0yg0Jr1JrjaEYs6rQ6uRwsw0KTb5/tVds5FlnFdfsyQacLV8HEKxs4AhC27lCH9XFdS3ISbscPqdtDZ4O1NCwn6JV4G9Z/AkLdTcxDOvPBq3OefZHxfE5IAKj4Z5jx8fs+CXokX0vYT/Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505364; c=relaxed/simple;
	bh=cBkruOZltISk9F/8zs8adLrbAEmRXV+aiUsIOUI+9Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cL7TPq7bME/Nr+0RWgmBH+xyzB3Tu7dFPnc5d4N3Nmi2itIx7bNsW9NBLUvRJPWjUtGbx+XAYLpu64yRlJzqKJB4iJkAYTBq+QKGWL696kFV7GvGL2Bh37KW8RpEYIe9VhMH6ICqqfmugEYWTqjasiLQE1h0lMzn1XxyZPQBdj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hls3buHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hls3buHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB472C19421;
	Fri, 12 Dec 2025 02:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765505363;
	bh=cBkruOZltISk9F/8zs8adLrbAEmRXV+aiUsIOUI+9Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hls3buHI4Dr0Go6AVWFzlD/HNYKvcT5F4C4YbMlDFVpQNsyg3ON0oYYziefvcMfcc
	 ObzV4guS0evoKStZHRPQkAxr6jQ0XQ304SQ+05xV/F6Ql/nQawYso9EPdDZJULT0RR
	 UtkpzPyXLlDd4S391owRWx3MYVp1B9eClXwtGpy5sWEfmCRdWbOMUOC84NK4pQjeiw
	 7CbBF/OKCLH6ltBq8Ca4T841r2V8eyaQDnOmxo7ncuQ0HbZZ565gks6mA07K3R+hsd
	 ZwkxyWbBqs+RU9TGR027C0zftqa4W9OB22VrCiH5zFZL1Iub9QTC6Ave2kzjk6BVvI
	 KNwTgKtgUf81w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] MIPS: ftrace: Fix memory corruption when kernel is located beyond 32 bits
Date: Thu, 11 Dec 2025 21:09:00 -0500
Message-ID: <20251212020903.4153935-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251212020903.4153935-1-sashal@kernel.org>
References: <20251212020903.4153935-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit 36dac9a3dda1f2bae343191bc16b910c603cac25 ]

Since commit e424054000878 ("MIPS: Tracing: Reduce the overhead of
dynamic Function Tracer"), the macro UASM_i_LA_mostly has been used,
and this macro can generate more than 2 instructions. At the same
time, the code in ftrace assumes that no more than 2 instructions can
be generated, which is why it stores them in an int[2] array. However,
as previously noted, the macro UASM_i_LA_mostly (and now UASM_i_LA)
causes a buffer overflow when _mcount is beyond 32 bits. This leads to
corruption of the variables located in the __read_mostly section.

This corruption was observed because the variable
__cpu_primary_thread_mask was corrupted, causing a hang very early
during boot.

This fix prevents the corruption by avoiding the generation of
instructions if they could exceed 2 instructions in
length. Fortunately, insn_la_mcount is only used if the instrumented
code is located outside the kernel code section, so dynamic ftrace can
still be used, albeit in a more limited scope. This is still
preferable to corrupting memory and/or crashing the kernel.

Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## COMPREHENSIVE ANALYSIS

### 1. COMMIT MESSAGE ANALYSIS
- **Subject**: Contains "Fix" and "memory corruption" - strong
  indicators of a serious bug fix
- **Body**: Clearly explains the buffer overflow mechanism and observed
  real-world impact
- **References**: Cites commit e424054000878 as the source of the bug
  (introduced in 2010, kernel 2.6.35)
- **No explicit Cc: stable tag**, but the nature of the fix makes it
  appropriate for stable

### 2. TECHNICAL ROOT CAUSE
The bug is in `ftrace_dyn_arch_init_insns()`:

1. **Buffer size**: `insn_la_mcount[2]` is declared as a 2-element array
   (8 bytes)
2. **UASM_i_LA behavior**: When address is NOT in 32-bit compat space,
   it can generate up to 5-6 instructions:
   - `lui` (always)
   - `daddiu` (conditional)
   - `dsll` (conditional)
   - `daddiu` (conditional)
   - `dsll` (conditional)
   - final `daddiu`/`addiu`
3. **Overflow**: Writing more than 2 instructions overwrites adjacent
   `__read_mostly` variables
4. **Observed impact**: Corruption of `__cpu_primary_thread_mask`
   causing boot hang

### 3. FIX MECHANISM
The fix adds two defensive checks:
1. **In `ftrace_dyn_arch_init_insns()`**: Only generate instructions if
   `uasm_in_compat_space_p(MCOUNT_ADDR)` - otherwise warn and skip
2. **In `ftrace_make_call()`**: Return `-EFAULT` if `insn_la_mcount`
   would be needed but wasn't generated

This gracefully degrades functionality rather than corrupting memory.

### 4. STABLE KERNEL CRITERIA ASSESSMENT

| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ Simple defensive check before buffer write |
| Fixes real bug | ✅ Memory corruption causing boot hang |
| Important issue | ✅ System crash/hang - very severe |
| Small and contained | ✅ Single file, ~30 lines changed |
| No new features | ✅ Actually reduces functionality in edge cases |
| No new APIs | ✅ Purely internal change |

### 5. DEPENDENCY CHECK
- **`uasm_in_compat_space_p()`**: Exists since kernel 2.6.x (commit
  e30ec4525d473)
- **Bug source commit**: e424054000878 from 2010 (2.6.35)
- **Dependencies**: None - fix is self-contained

### 6. RISK vs BENEFIT

**Risk**: Very LOW
- Defensive check - prevents execution rather than changing behavior
- Worst case: ftrace doesn't work for code outside kernel text on 64-bit
  MIPS with addresses beyond 32 bits
- Architecture-specific (MIPS only)

**Benefit**: HIGH
- Prevents memory corruption that causes boot hangs
- Bug has existed since 2010 - affects all stable kernels
- Observable real-world failure

### 7. USER IMPACT

- **Affected users**: MIPS 64-bit users with kernel loaded at addresses
  beyond 32 bits
- **Severity**: Critical - boot hang due to memory corruption
- **Reproducibility**: Deterministic when conditions are met (not a
  race)

### 8. CONCERNS

- **No explicit Cc: stable@vger.kernel.org tag**: However, the commit
  clearly fixes a serious memory corruption bug
- **Partial functionality loss**: Some ftrace capabilities reduced for
  64-bit addresses, but this is far preferable to memory corruption

### CONCLUSION

This commit is an excellent stable backport candidate:
1. **Fixes a serious bug**: Memory corruption causing system boot hangs
2. **Minimal risk**: Defensive check that gracefully degrades
   functionality
3. **Self-contained**: Single file change with no dependencies on new
   code
4. **Long-standing bug**: Affects all kernels since 2.6.35
5. **MIPS maintainer signed-off**: Thomas Bogendoerfer approved the fix

The fix is small, surgical, and meets all stable kernel criteria. The
trade-off (reduced ftrace functionality in edge cases vs memory
corruption) strongly favors the fix.

**YES**

 arch/mips/kernel/ftrace.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index f39e85fd58fa9..b15615b285690 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -54,10 +54,20 @@ static inline void ftrace_dyn_arch_init_insns(void)
 	u32 *buf;
 	unsigned int v1;
 
-	/* la v1, _mcount */
-	v1 = 3;
-	buf = (u32 *)&insn_la_mcount[0];
-	UASM_i_LA(&buf, v1, MCOUNT_ADDR);
+	/* If we are not in compat space, the number of generated
+	 * instructions will exceed the maximum expected limit of 2.
+	 * To prevent buffer overflow, we avoid generating them.
+	 * insn_la_mcount will not be used later in ftrace_make_call.
+	 */
+	if (uasm_in_compat_space_p(MCOUNT_ADDR)) {
+		/* la v1, _mcount */
+		v1 = 3;
+		buf = (u32 *)&insn_la_mcount[0];
+		UASM_i_LA(&buf, v1, MCOUNT_ADDR);
+	} else {
+		pr_warn("ftrace: mcount address beyond 32 bits is not supported (%lX)\n",
+			MCOUNT_ADDR);
+	}
 
 	/* jal (ftrace_caller + 8), jump over the first two instruction */
 	buf = (u32 *)&insn_jal_ftrace_caller;
@@ -189,6 +199,13 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned int new;
 	unsigned long ip = rec->ip;
 
+	/* When the code to patch does not belong to the kernel code
+	 * space, we must use insn_la_mcount. However, if MCOUNT_ADDR
+	 * is not in compat space, insn_la_mcount is not usable.
+	 */
+	if (!core_kernel_text(ip) && !uasm_in_compat_space_p(MCOUNT_ADDR))
+		return -EFAULT;
+
 	new = core_kernel_text(ip) ? insn_jal_ftrace_caller : insn_la_mcount[0];
 
 #ifdef CONFIG_64BIT
-- 
2.51.0

