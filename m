Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A140737996C;
	Wed,  7 Jan 2026 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801236; cv=none; b=ak+Bb3T8kWHuC+B26CIa1C2S8YJA/b/J/4vOLczJwrtx37vQ/xpbRQKNaAcP3VBb5lfyJsNlNaosgJO7JB+IWSkdQEUzxZBjSdkWgbREPP2kmmzQ8yf3bK7do3D+ie1wqWFOxDEc/fQLfzavuo5GuuTN6lVxJib+B03iDMjPoew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801236; c=relaxed/simple;
	bh=iAxVfRTXVTe2JGeObQQ/jNjHNR45g20PNAJM33yX/U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JFCIe6nvfmFdJhOFIzayKa43ogNdb0ZGMn100UReNbtJFPLmtAVn8J6U9fORbjEnwmmco1jl0s4CIffUUCVGEY+SbT8UYNOOIkAa4Un6eBS3TOBT8imGLVHCMs9us67hkSoGLrkf84GbhAKWh7aunjjXn9CFkZXeGUBgYNArQFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqrn1+Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqrn1+Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B8BC4CEF7;
	Wed,  7 Jan 2026 15:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767801235;
	bh=iAxVfRTXVTe2JGeObQQ/jNjHNR45g20PNAJM33yX/U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqrn1+Zh4aApERyJQL/YFZ3K1bOgZ0DuwbsxkDJqSDDLXtlX7jSWFteWjVCa3Po0W
	 5DzKo2udCgmQ0NTdvc+MPrRbX2QlaBbcqEQ6oA/0sQScJYGL+mAqumTiflUdraPfaI
	 5gvPWmRuzybKRIXLtxPcKxRV91/hJQ09Mf2LXFdiHuxX4jUnDtMoNX4KOY+qqBC8li
	 v1f3aUAEj2b3AiOVQMBoh8/RealKE+dYC1hHf71yUeSHbEwDRIj1dXtzkJ5aaSxbVD
	 pRvLiCI8KSy2rCBEQ3HZTkGNHuboGdcZG7azQPYIqiYv3wE6U7ZPYAhT+h6bS7sdGZ
	 vGqjXg2FKHAUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yao Zi <ziyao@disroot.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	richardcochran@gmail.com,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	shaul.triebitz@intel.com,
	emmanuel.grumbach@intel.com,
	netdev@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: Implement settime64 as stub for MVM/MLD PTP
Date: Wed,  7 Jan 2026 10:53:13 -0500
Message-ID: <20260107155329.4063936-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260107155329.4063936-1-sashal@kernel.org>
References: <20260107155329.4063936-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 81d90d93d22ca4f61833cba921dce9a0bd82218f ]

Since commit dfb073d32cac ("ptp: Return -EINVAL on ptp_clock_register if
required ops are NULL"), PTP clock registered through ptp_clock_register
is required to have ptp_clock_info.settime64 set, however, neither MVM
nor MLD's PTP clock implementation sets it, resulting in warnings when
the interface starts up, like

WARNING: drivers/ptp/ptp_clock.c:325 at ptp_clock_register+0x2c8/0x6b8, CPU#1: wpa_supplicant/469
CPU: 1 UID: 0 PID: 469 Comm: wpa_supplicant Not tainted 6.18.0+ #101 PREEMPT(full)
ra: ffff800002732cd4 iwl_mvm_ptp_init+0x114/0x188 [iwlmvm]
ERA: 9000000002fdc468 ptp_clock_register+0x2c8/0x6b8
iwlwifi 0000:01:00.0: Failed to register PHC clock (-22)

I don't find an appropriate firmware interface to implement settime64()
for iwlwifi MLD/MVM, thus instead create a stub that returns
-EOPTNOTSUPP only, suppressing the warning and allowing the PTP clock to
be registered.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20251108044822.GA3262936@ax162/
Signed-off-by: Yao Zi <ziyao@disroot.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
tested-by: damian Tometzki damian@riscv-rocks.de
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251204123204.9316-1-ziyao@disroot.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary Analysis

### Problem Being Fixed
This commit fixes a **regression** caused by commit dfb073d32cac ("ptp:
Return -EINVAL on ptp_clock_register if required ops are NULL"), which
made `settime64` mandatory for PTP clock registration. Without this fix:

1. **Immediate symptom**: PTP clock registration fails with -EINVAL
   (error -22), producing a kernel WARNING
2. **Underlying issue**: Prevents a potential NULL pointer dereference
   in `ptp_clock_settime()` (line 107 of `drivers/ptp/ptp_clock.c`)
   which unconditionally calls `ptp->info->settime64()` when userspace
   calls `clock_settime()` on the PTP device

### Code Change Analysis
The fix is extremely simple and surgical:
- Adds two trivial 5-line stub functions (`iwl_mld_ptp_settime` and
  `iwl_mvm_ptp_settime`) that simply return `-EOPNOTSUPP`
- Registers these stubs in the respective `ptp_clock_info` structures
- Total change: ~14 lines of obvious, trivial code

### Stable Tree Criteria Evaluation
| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ Stub returns standard "not supported" error |
| Fixes real bug | ✅ Fixes PTP registration failure and potential NULL
deref |
| Important issue | ✅ Prevents kernel WARNING and failed functionality |
| Small and contained | ✅ ~14 lines, 2 files, same driver |
| No new features | ✅ Just adds required stub, no new functionality |

### Evidence of Similar Fixes Being Backported
The similar commits `329d050bbe63` (gve) and `6d080f810ffd` (iavf) that
add identical `settime64` stubs have been backported to stable
(confirmed in `stable/linux-6.18.y`). This establishes precedent.

### Testing and Review Quality
Excellent:
- 4 different Tested-by tags (Nathan Chancellor, damian Tometzki, Oliver
  Hartkopp, and implicit by Johannes Berg who merged it)
- Reviewed-by from Simon Horman
- Acked-by from Intel iwlwifi maintainer (Miri Korenblit)
- Bug was reported with a lore.kernel.org link

### Risk Assessment
**Risk: Essentially zero.** The stub function just returns
`-EOPNOTSUPP`. It cannot cause any regressions because:
- It only gets called if userspace explicitly tries to set the PTP clock
  time
- Returning -EOPNOTSUPP is the correct response for unsupported
  functionality
- The alternative (no stub) causes immediate registration failure

### Dependency Considerations
- The MVM part (`mvm/ptp.c`) applies to kernels with iwlwifi MVM PTP
  support (v6.3+)
- The MLD part (`mld/ptp.c`) is only relevant for very recent kernels
  (v6.11+)
- Stable maintainers can easily drop the MLD hunk for older kernels that
  don't have it

### Conclusion
This is a textbook stable backport candidate: a small, obvious fix for a
real regression affecting production users of Intel WiFi hardware. The
fix pattern has already been applied and backported for other drivers
(gve, iavf). The risk is essentially zero, and the benefit is clear
(functional PTP clock registration and prevention of potential NULL
dereference).

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/ptp.c | 7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
index ffeb37a7f830..231920425c06 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
@@ -121,6 +121,12 @@ static int iwl_mld_ptp_gettime(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int iwl_mld_ptp_settime(struct ptp_clock_info *ptp,
+			       const struct timespec64 *ts)
+{
+	return -EOPNOTSUPP;
+}
+
 static int iwl_mld_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct iwl_mld *mld = container_of(ptp, struct iwl_mld,
@@ -279,6 +285,7 @@ void iwl_mld_ptp_init(struct iwl_mld *mld)
 
 	mld->ptp_data.ptp_clock_info.owner = THIS_MODULE;
 	mld->ptp_data.ptp_clock_info.gettime64 = iwl_mld_ptp_gettime;
+	mld->ptp_data.ptp_clock_info.settime64 = iwl_mld_ptp_settime;
 	mld->ptp_data.ptp_clock_info.max_adj = 0x7fffffff;
 	mld->ptp_data.ptp_clock_info.adjtime = iwl_mld_ptp_adjtime;
 	mld->ptp_data.ptp_clock_info.adjfine = iwl_mld_ptp_adjfine;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
index 06a4c9f74797..ad156b82eaa9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -220,6 +220,12 @@ static int iwl_mvm_ptp_gettime(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int iwl_mvm_ptp_settime(struct ptp_clock_info *ptp,
+			       const struct timespec64 *ts)
+{
+	return -EOPNOTSUPP;
+}
+
 static int iwl_mvm_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct iwl_mvm *mvm = container_of(ptp, struct iwl_mvm,
@@ -281,6 +287,7 @@ void iwl_mvm_ptp_init(struct iwl_mvm *mvm)
 	mvm->ptp_data.ptp_clock_info.adjfine = iwl_mvm_ptp_adjfine;
 	mvm->ptp_data.ptp_clock_info.adjtime = iwl_mvm_ptp_adjtime;
 	mvm->ptp_data.ptp_clock_info.gettime64 = iwl_mvm_ptp_gettime;
+	mvm->ptp_data.ptp_clock_info.settime64 = iwl_mvm_ptp_settime;
 	mvm->ptp_data.scaled_freq = SCALE_FACTOR;
 
 	/* Give a short 'friendly name' to identify the PHC clock */
-- 
2.51.0

