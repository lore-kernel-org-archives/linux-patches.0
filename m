Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C174D990C;
	Tue, 21 Jul 2026 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649140; cv=none; b=EcjCd5tHaWTEHlSYBsM1Z96JOGEzvveisyogt4Qhijp7PTN8OkJFci+JkgU109h4X6Qqzaf6ov2Qrd5NSUi2Bv6vV2vomTzp5eUfSJP4W/xNj78Ne4cH5cIZIJ3zyEmLPW+2hmOK4sAO3l6f7Y/nhZ6GVCsMhJ1l2/BUfWHk8Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649140; c=relaxed/simple;
	bh=u6xm65v8CsboDM33m5GM+XNCVnZW70PKFVPBwY+zEs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gj7zL23XjQf1so78J7MIFYIY11Kp72AWi6zQH4nHkStvO0WuQRfwS9SNek5ylLFunHak31ZhNUsFjuzFN4b86Qccer5d+xXoixmFuFQcb9ODoY3Dfy0UfgfqnJklUupq/YQhZdT7e5dnEfHE/zBc1FWUHn2NdjJpdfV9X7/8YzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhQnHn6U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhQnHn6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EAE1F000E9;
	Tue, 21 Jul 2026 15:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649139;
	bh=8ptvy/NM79gp2/dS1fHANLlZSQypAOHaC42sVTqvgxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WhQnHn6Ub/3cL/UdevovELfLhFaP/BTvMjWY2nQF5ZsNqHjRRdhuVTfVpm5gxCvQG
	 Q4XgrTtMmXBybzoNk8Na95cGqtl3jNoovG6dCDzbi26WE9rXow7WQFv2AP+RngZUBp
	 oJ5ktI9Vz1fW6Oaeiec0t/8dmzMDhrWF+RSwUUwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0466/2077] perf/x86/amd/uncore: Use Node ID to identify DF and UMC domains
Date: Tue, 21 Jul 2026 17:02:19 +0200
Message-ID: <20260721152603.784842546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 67d27727854def4a7e2b386429941f5c4741ccc4 ]

For DF and UMC PMUs, a single context is shared across all CPUs that
are connected to the same Data Fabric (DF) instance. Currently, the
Package ID, which also happens to be the Socket ID, is used to identify
DF instances. This approach works for configurations having a single IO
Die (IOD) but fails in the following cases.
  * Older Zen 1 processors, where each chiplet has its own DF instance.
  * Any configurations with multiple DF instances or multiple IODs in
    the same package.

The correct way to identify DF instances is through the Node ID (not to
be confused with NUMA Node ID). This is available in ECX[7:0] of CPUID
leaf 0x8000001e and returned via topology_amd_node_id(). Hence, replace
usage of topology_logical_package_id() with topology_amd_node_id().

Fixes: 07888daa056e ("perf/x86/amd/uncore: Move discovery and registration")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/e7a71a727c6a7b118c23d3e469929c538c4665aa.1780315832.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index dd956cfcadefad..a0364ca2f91737 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -700,7 +700,7 @@ void amd_uncore_df_ctx_scan(struct amd_uncore *uncore, unsigned int cpu)
 	info.split.aux_data = 0;
 	info.split.num_pmcs = NUM_COUNTERS_NB;
 	info.split.gid = 0;
-	info.split.cid = topology_logical_package_id(cpu);
+	info.split.cid = topology_amd_node_id(cpu);
 
 	if (pmu_version >= 2) {
 		ebx.full = cpuid_ebx(EXT_PERFMON_DEBUG_FEATURES);
@@ -999,8 +999,8 @@ void amd_uncore_umc_ctx_scan(struct amd_uncore *uncore, unsigned int cpu)
 	cpuid(EXT_PERFMON_DEBUG_FEATURES, &eax, &ebx.full, &ecx, &edx);
 	info.split.aux_data = ecx;	/* stash active mask */
 	info.split.num_pmcs = ebx.split.num_umc_pmc;
-	info.split.gid = topology_logical_package_id(cpu);
-	info.split.cid = topology_logical_package_id(cpu);
+	info.split.gid = topology_amd_node_id(cpu);
+	info.split.cid = topology_amd_node_id(cpu);
 	*per_cpu_ptr(uncore->info, cpu) = info;
 }
 
-- 
2.53.0



