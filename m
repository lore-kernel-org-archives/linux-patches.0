Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFCB269CF6;
	Tue,  8 Apr 2025 11:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112013; cv=none; b=ofZKVtQess4DIKc9gjJ95V0DJdbCotuxgAEQL2GvnCEXRZ4GStoi34EjJsc2zieWuCtTnQjsgRHawufcNLRSNlP5i8PZ5B2HL2Ti8cZ3Ltpyj3Od8jJWsVBMeqXlfShm0SsY5ZOIFt8vr0aW2L8z0K1cL2ZTI1J6zgLHoD+UyjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112013; c=relaxed/simple;
	bh=wTMSfAWjIrCSN+ekRSNyf2HrOJ9P7/G9mdTWkeCc6iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3fMvwb7RBpqDpGMaSFYJrKBJ0K1nT3uoCp1NNApEPMc6Rou1T+XudGvXeaoKKcIBUTOJBHq967biNdnWOwEzARFG7weVsytuwdzUdYr4q9Nh4s4ZzXgCnkDy82uwRUKa0ZK4nWh1wtAvqQIRyIWW11EbktnP8J7B+IHUD1GQlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzIh7Df6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzIh7Df6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AC0C4CEE7;
	Tue,  8 Apr 2025 11:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112013;
	bh=wTMSfAWjIrCSN+ekRSNyf2HrOJ9P7/G9mdTWkeCc6iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzIh7Df6wYcrs29FlJOC6asPplFaVijaw9HaaGYrtTm7j7P4oDHjZbKWOULGsKC51
	 BJAlHe4u+KaT1XNUhWT0Dfur9lZufzo6wMPYXxvtg0cQZWkPXp0+1O6y+pniZeW48R
	 zR9ssM7Lty2/S8qfv7aYZ0VtBFgLk4WNLDsyIq6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 644/731] tools/power turbostat: Allow Zero return value for some RAPL registers
Date: Tue,  8 Apr 2025 12:49:01 +0200
Message-ID: <20250408104929.246450491@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit b312d880fb462d4759396950865ec914de9d253c ]

turbostat aborted with below messages on a dual-package system,

   turbostat: turbostat.c:3744: rapl_counter_accumulate: Assertion `dst->unit == src->unit' failed.
   Aborted

This is because
1. the MSR_DRAM_PERF_STATUS returns Zero for one package, and non-Zero
   for another package
2. probe_msr() treats Zero return value as a failure so this feature is
   enabled on one package, and disabled for another package.
3. turbostat aborts because the feature is invalid on some package

Unlike the RAPL energy counter registers, MSR_DRAM_PERF_STATUS can
return Zero value, and this should not be treated as a failure.

Fix the problem by allowing Zero return value for RAPL registers other
than the energy counters.

Fixes: 7c6fee25bdf5 ("tools/power turbostat: Check for non-zero value when MSR probing")
Reported-by: Artem Bityutskiy <artem.bityutskiy@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 8d5011a0bf60d..ff238798b7747 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2211,7 +2211,7 @@ int get_msr(int cpu, off_t offset, unsigned long long *msr)
 	return 0;
 }
 
-int probe_msr(int cpu, off_t offset)
+int probe_rapl_msr(int cpu, off_t offset, int index)
 {
 	ssize_t retval;
 	unsigned long long value;
@@ -2220,13 +2220,22 @@ int probe_msr(int cpu, off_t offset)
 
 	retval = pread(get_msr_fd(cpu), &value, sizeof(value), offset);
 
-	/*
-	 * Expect MSRs to accumulate some non-zero value since the system was powered on.
-	 * Treat zero as a read failure.
-	 */
-	if (retval != sizeof(value) || value == 0)
+	/* if the read failed, the probe fails */
+	if (retval != sizeof(value))
 		return 1;
 
+	/* If an Energy Status Counter MSR returns 0, the probe fails */
+	switch (index) {
+	case RAPL_RCI_INDEX_ENERGY_PKG:
+	case RAPL_RCI_INDEX_ENERGY_CORES:
+	case RAPL_RCI_INDEX_DRAM:
+	case RAPL_RCI_INDEX_GFX:
+	case RAPL_RCI_INDEX_ENERGY_PLATFORM:
+		if (value == 0)
+			return 1;
+	}
+
+	/* PKG,DRAM_PERF_STATUS MSRs, can return any value */
 	return 0;
 }
 
@@ -7896,7 +7905,7 @@ void rapl_perf_init(void)
 					rci->flags[cai->rci_index] = cai->flags;
 
 					/* Use MSR for this counter */
-				} else if (!no_msr && cai->msr && probe_msr(cpu, cai->msr) == 0) {
+				} else if (!no_msr && cai->msr && probe_rapl_msr(cpu, cai->msr, cai->rci_index) == 0) {
 					rci->source[cai->rci_index] = COUNTER_SOURCE_MSR;
 					rci->msr[cai->rci_index] = cai->msr;
 					rci->msr_mask[cai->rci_index] = cai->msr_mask;
@@ -8034,7 +8043,7 @@ void msr_perf_init_(void)
 					cai->present = true;
 
 					/* User MSR for this counter */
-				} else if (!no_msr && cai->msr && probe_msr(cpu, cai->msr) == 0) {
+				} else if (!no_msr && cai->msr && probe_rapl_msr(cpu, cai->msr, cai->rci_index) == 0) {
 					cci->source[cai->rci_index] = COUNTER_SOURCE_MSR;
 					cci->msr[cai->rci_index] = cai->msr;
 					cci->msr_mask[cai->rci_index] = cai->msr_mask;
@@ -8148,7 +8157,7 @@ void cstate_perf_init_(bool soft_c1)
 
 					/* User MSR for this counter */
 				} else if (!no_msr && cai->msr && pkg_cstate_limit >= cai->pkg_cstate_limit
-					   && probe_msr(cpu, cai->msr) == 0) {
+					   && probe_rapl_msr(cpu, cai->msr, cai->rci_index) == 0) {
 					cci->source[cai->rci_index] = COUNTER_SOURCE_MSR;
 					cci->msr[cai->rci_index] = cai->msr;
 				}
-- 
2.39.5



