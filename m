Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214D61C3306;
	Thu,  9 Oct 2025 16:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025620; cv=none; b=IGlxT20DFUt89k5KtIIFmmurqjN3R7ihNC/9aL0ey6VSFV4uSRP/Y8XJ+vvdWCNXA3omvkkBESGBNt18Xy0pmJ4IOgkwR5efXonG/RoUMePf4IJ5Qx3fV3tuwHOlE0xcvjnoTc5MbNvzH28EtIXFu55BiuEG3suAN85MN3gQrgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025620; c=relaxed/simple;
	bh=qJj6VFYyihd6mLBLTCq9U1HtWyMDMR77u0FFKakKHXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I9qcagd9D3x22iYblkV5nQ1QRFwIJ2AwRUTxFD4t9oM0CG1GrioijzySToCcLb15v4AZWlqbasQDUf0CdDurXN8xm8FUh6CBNeKP9qh+Z196HIYG3NGa/mPMD/jZI0PC55g9RHg+pP25Ie+GVqvH3aUQZX8jQLzvwX5l/8HZjxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s22EIAkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s22EIAkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C0CC4CEE7;
	Thu,  9 Oct 2025 16:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025620;
	bh=qJj6VFYyihd6mLBLTCq9U1HtWyMDMR77u0FFKakKHXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s22EIAkUKpa7ZtAj4QE3BAroYOQtW2F0B0Jz1EcimafGXBbDrY9CU4V3SwQzh10Dc
	 rpBahMsgEyb2e04GnBob+pbY1EypYVji27bCwjA7n7aBRjaKDuAdNYqBOaWGbLGlNM
	 6cxDh91BaiA8Of8sq8PnvOJZiB7Pbsjkyc4766aAednIk3b5jU9T3d/3v+UX5amR3w
	 haauS2oy2tsJWUH/53jnXo7T4uyqAGFpePC8DrApjrbMWyvnNNgagHWodTIIXCXRfm
	 z9nUyhdcsZhJBQ9MIBcV5PPiHaIXv9klVNf+agz1kOpZ5tfwA9rSyhfojd0w3GeFWY
	 zBUBg0sH8PksQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kaushlendra.kumar@intel.com
Subject: [PATCH AUTOSEL 6.17-5.4] tools/power x86_energy_perf_policy: Prefer driver HWP limits
Date: Thu,  9 Oct 2025 11:55:44 -0400
Message-ID: <20251009155752.773732-78-sashal@kernel.org>
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

[ Upstream commit 2734fdbc9bb8a3aeb309ba0d62212d7f53f30bc7 ]

When we are successful in using cpufreq min/max limits,
skip setting the raw MSR limits entirely.

This is necessary to avoid undoing any modification that
the cpufreq driver makes to our sysfs request.

eg. intel_pstate may take our request for a limit
that is valid according to HWP.CAP.MIN/MAX and clip
it to be within the range available in PLATFORM_INFO.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents x86_energy_perf_policy from undoing cpufreq/intel_pstate
    clipping of HWP min/max requests. Previously the tool wrote cpufreq
    sysfs limits and then also wrote the raw HWP MSR limits, potentially
    overriding the driver’s adjusted values (e.g., clipping to
    PLATFORM_INFO). The commit makes the tool prefer the driver’s
    interpretation when sysfs is used.

- Key changes
  - Adds a global flag to track sysfs-based limit application: `unsigned
    char hwp_limits_done_via_sysfs;`
    (tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c).
  - Marks sysfs path as authoritative when used: in `update_sysfs(...)`,
    after writing `scaling_min_freq` and/or `scaling_max_freq`, sets
    `hwp_limits_done_via_sysfs = 1;` so the driver’s chosen limits take
    precedence.
  - Skips raw MSR overwrites if sysfs handled limits: in
    `update_hwp_request_msr(...)`, assignments to `req.hwp_min` and
    `req.hwp_max` now check `&& !hwp_limits_done_via_sysfs` before
    updating. This avoids reprogramming the MSR min/max after the driver
    has possibly clipped the request via sysfs.
  - Clarifies intent in comments: explains that intel_pstate may clip
    values outside PLATFORM_INFO and that driver-chosen values take
    precedence.

- Why it’s a good stable backport
  - Real user-visible bug: Without this change, using the tool on HWP
    systems with intel_pstate can lead to the driver clipping sysfs
    limits, only for the tool to immediately overwrite min/max in the
    raw MSR, defeating the driver’s safety/correctness decisions.
  - Small, contained, low-risk change: Only one userspace file is
    modified, with ~13 lines touched. No kernel ABI/API changes, no
    architecture or subsystem redesign.
  - Behavior is strictly safer:
    - If cpufreq sysfs is not present or HWP updates aren’t requested,
      behavior is unchanged.
    - If cpufreq sysfs is present, the driver’s interpretation
      (including clipping) is preserved by avoiding the subsequent raw
      MSR write.
  - No functional expansion or new features: This is corrective logic to
    avoid regressions caused by conflicting writes.
  - Tools-only change: Lives under `tools/power/`, not core kernel code;
    regression risk to the running kernel is negligible.

- Dependencies and backport notes
  - Upstream this change lands after a refactor that renamed functions
    to `read_hwp_request_msr(...)` and `update_hwp_request_msr(...)`.
    Older stable trees (like your current tree) may still use
    `read_hwp_request(...)` and `update_hwp_request(...)`. The backport
    is trivial: add the `hwp_limits_done_via_sysfs` global, set it in
    `update_sysfs(...)`, and gate the MSR assignments in the (pre-
    refactor) `update_hwp_request(...)` using the same `&&
    !hwp_limits_done_via_sysfs` condition.
  - No additional fixes or reverts appear related to this change in the
    file’s history, and no “Fixes:”/stable Cc tags are present, but the
    change clearly matches stable criteria (bugfix with minimal risk).

- Security and regression considerations
  - Security: None apparent; this reduces the chance of programming
    unsafe or out-of-range HWP limits by honoring the driver’s clipping.
  - Regression risk: Low. If sysfs is available, defers to the driver;
    if not, previous MSR behavior remains. The global flag defaults to
    zero and is set only when the sysfs path is detected and used.

Conclusion: This is an important, minimal tool fix that prevents
incorrect behavior on HWP/intel_pstate systems and should be backported
to stable trees, with trivial adaptation for function names in pre-
refactor branches.

 .../x86_energy_perf_policy/x86_energy_perf_policy.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 0bda8e3ae7f77..891738116c8b2 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -62,6 +62,7 @@ unsigned char turbo_update_value;
 unsigned char update_hwp_epp;
 unsigned char update_hwp_min;
 unsigned char update_hwp_max;
+unsigned char hwp_limits_done_via_sysfs;
 unsigned char update_hwp_desired;
 unsigned char update_hwp_window;
 unsigned char update_hwp_use_pkg;
@@ -951,8 +952,10 @@ int ratio_2_sysfs_khz(int ratio)
 }
 /*
  * If HWP is enabled and cpufreq sysfs attribtes are present,
- * then update sysfs, so that it will not become
- * stale when we write to MSRs.
+ * then update via sysfs. The intel_pstate driver may modify (clip)
+ * this request, say, when HWP_CAP is outside of PLATFORM_INFO limits,
+ * and the driver-chosen value takes precidence.
+ *
  * (intel_pstate's max_perf_pct and min_perf_pct will follow cpufreq,
  *  so we don't have to touch that.)
  */
@@ -1007,6 +1010,8 @@ int update_sysfs(int cpu)
 	if (update_hwp_max)
 		update_cpufreq_scaling_freq(1, cpu, req_update.hwp_max);
 
+	hwp_limits_done_via_sysfs = 1;
+
 	return 0;
 }
 
@@ -1085,10 +1090,10 @@ int update_hwp_request(int cpu)
 	if (debug)
 		print_hwp_request(cpu, &req, "old: ");
 
-	if (update_hwp_min)
+	if (update_hwp_min && !hwp_limits_done_via_sysfs)
 		req.hwp_min = req_update.hwp_min;
 
-	if (update_hwp_max)
+	if (update_hwp_max && !hwp_limits_done_via_sysfs)
 		req.hwp_max = req_update.hwp_max;
 
 	if (update_hwp_desired)
-- 
2.51.0

