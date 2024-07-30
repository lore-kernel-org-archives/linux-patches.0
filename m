Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557EC14D29B;
	Tue, 30 Jul 2024 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357152; cv=none; b=mnF1fCoIvFaFS5TCo06LCB6FPxFXtT3/kciNhBB+ObGnujp6f9ahfydD1RQkDgWhV8J25C3XQCQ4FPmul/awfJyEucPehq05akSzSl6ha6uKBua/mx7CBMsKPfOxdAOK6c5MZaQyvAnicdl2gkbWwI0p58veI3tfqZe7WvUhAsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357152; c=relaxed/simple;
	bh=2C+U7WxRt0rJQcwOk+jsEhkCm856GAZvMrVdL5olEsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZI2VJgdB/w3YobJgqkBLbMDnKW46L+r/FkgitQBcDYVuVuvVaNwOQ2Kwg/wuJ6fGbX0wAtWOm7afRMDsn/Qfvftaw9aeE1kzKfFwG1FU/3GiiPkiX0fFdk+7p4OF7++KNg1GN99811OVrIrbaFmqH7tljsYRMcdBw8/b4jrQE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/XFwqX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/XFwqX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50AFC32782;
	Tue, 30 Jul 2024 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357152;
	bh=2C+U7WxRt0rJQcwOk+jsEhkCm856GAZvMrVdL5olEsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/XFwqX1HUwSluvMstUhCjwuRV5qz1Vox8VDtfZNZOiW0lNO78K8WQyjfU+KWMmFM
	 Jq6BVYZxiizC4tmuQPeEkYWBcJy8kWiWpyDOAg39IQjwTOZ4y0Au6H2j9U+8a66PAg
	 YRCuvhAu+TzyZhQnZVV9HKXfzxLXRCS6s/Up5GgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 227/809] perf/x86/amd/uncore: Avoid PMU registration if counters are unavailable
Date: Tue, 30 Jul 2024 17:41:43 +0200
Message-ID: <20240730151733.572300700@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit f997e208b6c96858a2f6c0855debfbdb9b52f131 ]

X86_FEATURE_PERFCTR_NB and X86_FEATURE_PERFCTR_LLC are derived from
CPUID leaf 0x80000001 ECX bits 24 and 28 respectively and denote the
availability of DF and L3 counters. When these bits are not set, the
corresponding PMUs have no counters and hence, should not be registered.

Fixes: 07888daa056e ("perf/x86/amd/uncore: Move discovery and registration")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20240626074404.1044230-1-sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 4ccb8fa483e61..b78e05ab4a737 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -654,17 +654,20 @@ int amd_uncore_df_ctx_init(struct amd_uncore *uncore, unsigned int cpu)
 {
 	struct attribute **df_attr = amd_uncore_df_format_attr;
 	struct amd_uncore_pmu *pmu;
+	int num_counters;
 
 	/* Run just once */
 	if (uncore->init_done)
 		return amd_uncore_ctx_init(uncore, cpu);
 
+	num_counters = amd_uncore_ctx_num_pmcs(uncore, cpu);
+	if (!num_counters)
+		goto done;
+
 	/* No grouping, single instance for a system */
 	uncore->pmus = kzalloc(sizeof(*uncore->pmus), GFP_KERNEL);
-	if (!uncore->pmus) {
-		uncore->num_pmus = 0;
+	if (!uncore->pmus)
 		goto done;
-	}
 
 	/*
 	 * For Family 17h and above, the Northbridge counters are repurposed
@@ -674,7 +677,7 @@ int amd_uncore_df_ctx_init(struct amd_uncore *uncore, unsigned int cpu)
 	pmu = &uncore->pmus[0];
 	strscpy(pmu->name, boot_cpu_data.x86 >= 0x17 ? "amd_df" : "amd_nb",
 		sizeof(pmu->name));
-	pmu->num_counters = amd_uncore_ctx_num_pmcs(uncore, cpu);
+	pmu->num_counters = num_counters;
 	pmu->msr_base = MSR_F15H_NB_PERF_CTL;
 	pmu->rdpmc_base = RDPMC_BASE_NB;
 	pmu->group = amd_uncore_ctx_gid(uncore, cpu);
@@ -785,17 +788,20 @@ int amd_uncore_l3_ctx_init(struct amd_uncore *uncore, unsigned int cpu)
 {
 	struct attribute **l3_attr = amd_uncore_l3_format_attr;
 	struct amd_uncore_pmu *pmu;
+	int num_counters;
 
 	/* Run just once */
 	if (uncore->init_done)
 		return amd_uncore_ctx_init(uncore, cpu);
 
+	num_counters = amd_uncore_ctx_num_pmcs(uncore, cpu);
+	if (!num_counters)
+		goto done;
+
 	/* No grouping, single instance for a system */
 	uncore->pmus = kzalloc(sizeof(*uncore->pmus), GFP_KERNEL);
-	if (!uncore->pmus) {
-		uncore->num_pmus = 0;
+	if (!uncore->pmus)
 		goto done;
-	}
 
 	/*
 	 * For Family 17h and above, L3 cache counters are available instead
@@ -805,7 +811,7 @@ int amd_uncore_l3_ctx_init(struct amd_uncore *uncore, unsigned int cpu)
 	pmu = &uncore->pmus[0];
 	strscpy(pmu->name, boot_cpu_data.x86 >= 0x17 ? "amd_l3" : "amd_l2",
 		sizeof(pmu->name));
-	pmu->num_counters = amd_uncore_ctx_num_pmcs(uncore, cpu);
+	pmu->num_counters = num_counters;
 	pmu->msr_base = MSR_F16H_L2I_PERF_CTL;
 	pmu->rdpmc_base = RDPMC_BASE_LLC;
 	pmu->group = amd_uncore_ctx_gid(uncore, cpu);
-- 
2.43.0



