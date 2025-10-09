Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0722B2FA0D3;
	Thu,  9 Oct 2025 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025559; cv=none; b=iaqiQMPNDGG4Lf55zshQvtXgaWBpDkCJ0xCCORzgkosErQV8HvcGt/2pXx2/8g8FTku8QjtvPTXBWX0w9uImVrcLLRCUea/mCQfG7odQBz4q1jWRowTej2p5Ej33Pnwgj41BdEHu66ecyhr/cpZdNK3T29qOaPLqqeOFJtujl0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025559; c=relaxed/simple;
	bh=kakDyfPV2orZiCF9NvOHlrtjbYvU+q15powmNkwZrBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bw3+8zi3QJmjTRTffL7en0SuTMNA2G3C+3v/aYCb4aMstf8bBPfOi1JGuYQGZ+0ahJhhGMh0/w5rDNu3Yi98HMRZN/3N1qkNQq59B6Zv2rQQWaaaSHbjDFLQoWTU2y3urMtSQgpWuW5IhXDBP5baiUG262QZO3y0mHOOZrSAYL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+fC3SiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+fC3SiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F76C4CEE7;
	Thu,  9 Oct 2025 15:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025558;
	bh=kakDyfPV2orZiCF9NvOHlrtjbYvU+q15powmNkwZrBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+fC3SiBXzzJhdig9szoAqaCW18iP9MjlX6igZxSQV8BEKFN+OTHiPJ747RrHXars
	 A+Y93MRZ5s01KRseyjqwBSql+Eryp+nelsukVFE8NgWW7qbDS2m5oqfKRUloAb4Gcd
	 hJXw0vO6aDQ3lyY4eQSZE3qQoYX8XwFdLd2BAhmhZX5/FjcldwGdPf8Fb1FlFEq1gO
	 8Zh1YBZzLP/JAaf/IR2OX7HpA3wazyEM22AlqnfyP45P6W7/hGLR8AFCZgP7RKkznt
	 qzPYmaQbuTR5XnogVUaroYEW+H3WdbDuF5Mdnv6HZHjgc0fVOQOku4/lY+RDvtx1pd
	 XHuMbgJkuJkeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kaushlendra.kumar@intel.com
Subject: [PATCH AUTOSEL 6.17-5.4] tools/power x86_energy_perf_policy: Enhance HWP enable
Date: Thu,  9 Oct 2025 11:55:12 -0400
Message-ID: <20251009155752.773732-46-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Len Brown <len.brown@intel.com>

[ Upstream commit c97c057d357c4b39b153e9e430bbf8976e05bd4e ]

On enabling HWP, preserve the reserved bits in MSR_PM_ENABLE.

Also, skip writing the MSR_PM_ENABLE if HWP is already enabled.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**What It Fixes**
- Preserves IA32_PM_ENABLE reserved bits instead of zeroing them:
  - Old behavior wrote a literal `1` unconditionally, clearing all other
    bits: `put_msr(cpu, MSR_PM_ENABLE, 1)` (tools/power/x86/x86_energy_p
    erf_policy/x86_energy_perf_policy.c:1169 in the pre-change context
    shown in the diff).
  - New behavior reads the MSR, ORs in the enable bit, and writes back:
    `get_msr(...) -> new_msr = old_msr | 1 -> put_msr(...)` (tools/power
    /x86/x86_energy_perf_policy/x86_energy_perf_policy.c:1176, 1182).
    This avoids clobbering reserved bits that firmware/hardware may set.
- Skips redundant writes when HWP is already enabled:
  - Adds early return if `old_msr & 1` is set (tools/power/x86/x86_energ
    y_perf_policy/x86_energy_perf_policy.c:1179). This prevents
    unnecessary MSR writes and reduces potential races.

**Why It Matters**
- IA32_PM_ENABLE (MSR 0x770) has bit 0 for HWP enable, with other bits
  reserved. Writing a raw `1` previously cleared those bits, which risks
  undoing firmware-initialized or future-defined bits. Preserving them
  (`old_msr | 1`) is the correct, robust pattern.
- Reducing writes when already enabled avoids touching MSRs
  unnecessarily, which is generally safer and can avoid subtle
  interactions with concurrent management agents or firmware.

**Scope and Risk**
- Change is small and self-contained to `enable_hwp_on_cpu()` in the
  userspace tool, not a kernel subsystem:
  - A few lines changed, no architectural refactor, no new features.
  - No API/ABI changes; only verbose logging format changes from decimal
    to hex (`%llX`) (tools/power/x86/x86_energy_perf_policy/x86_energy_p
    erf_policy.c:1185). This is developer-facing and gated by `verbose`.
- Aligns with standard MSR handling practice: read-modify-write for
  registers with reserved bits.
- Regression risk is minimal. If reserved bits were zero (as they should
  be on some parts), preserving them keeps them zero; if firmware set
  them, they won’t be inadvertently cleared.

**Backport Considerations**
- Independent of other recent refactoring in this tool. The function and
  helpers (`get_msr`, `put_msr`) exist across older branches.
- No dependency on kernel internal changes; applies cleanly to the tool.
- Improves correctness and robustness without adding new behavior.

**Conclusion**
- This is a clear bug fix that prevents reserved-bit clobbering and
  avoids unnecessary writes. It is small, low risk, and confined to the
  userspace tool. It fits stable rules and should be backported.

 .../x86_energy_perf_policy/x86_energy_perf_policy.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index c883f211dbcc9..0bda8e3ae7f77 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1166,13 +1166,18 @@ int update_hwp_request_pkg(int pkg)
 
 int enable_hwp_on_cpu(int cpu)
 {
-	unsigned long long msr;
+	unsigned long long old_msr, new_msr;
+
+	get_msr(cpu, MSR_PM_ENABLE, &old_msr);
+
+	if (old_msr & 1)
+		return 0;	/* already enabled */
 
-	get_msr(cpu, MSR_PM_ENABLE, &msr);
-	put_msr(cpu, MSR_PM_ENABLE, 1);
+	new_msr = old_msr | 1;
+	put_msr(cpu, MSR_PM_ENABLE, new_msr);
 
 	if (verbose)
-		printf("cpu%d: MSR_PM_ENABLE old: %d new: %d\n", cpu, (unsigned int) msr, 1);
+		printf("cpu%d: MSR_PM_ENABLE old: %llX new: %llX\n", cpu, old_msr, new_msr);
 
 	return 0;
 }
-- 
2.51.0

