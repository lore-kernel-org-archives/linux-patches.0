Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C11415F0E;
	Tue, 21 Jul 2026 19:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661975; cv=none; b=dltb9MzO6S925f0FKXilV/v1P5ALB466CdH5cRbJfrCYhUN/wSBb5p3L3gNZtmlxpHFE5s1ny8oN8rrGiQLK61KvAi6jCLhh+DBn9qRNqb6/Rk1jV/GEZO4pa62oUfkUj3L6b/LgAi6zmafYZNj0FX/tzNSwY7YtH6p9SnJzlWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661975; c=relaxed/simple;
	bh=H1gRY7Fr3V+xRc62xIHzwERh9pAtC73TW4XSChbMaAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9Q7q1LsW0VObtV9zvLKFCdxRTKgGtt2uxQ4wwV7L2qMWPteXHyd2AExAe2vTY2FS2wWsOhbMlSoIZ+9SCCKt02tgTXL832qor9wGxVrAm3w964h5Qy34aA105oAFx8vpfkL2BiFiHQs8X4LzSumLXWi75/CBTY1kjAhaUAecwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvvKvnq2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvvKvnq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457161F000E9;
	Tue, 21 Jul 2026 19:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661974;
	bh=ifMj90iF8a/RZr87w3gHXhDWx//cLVVbbThN5vFlXtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvvKvnq2uUvXDDg/jmbK7heLbPnlE+ytadZGj36B9ObKdUJR36DMWbBZCO6GZ9rho
	 cJpuQL+wPrLci6MYz6bet3NrkhUogLbXynekk2eAkaHHZPPopyEUqkP2jFKZgZbZDo
	 rHqk662U2Iz4QYh+2tHaUq6vcXshNBwYldNOwqIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0232/1276] perf/x86/amd/uncore: Use Node ID to identify DF and UMC domains
Date: Tue, 21 Jul 2026 17:11:15 +0200
Message-ID: <20260721152451.282819331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0bb60fde1f4fce..cad240e88b4ff2 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -639,7 +639,7 @@ void amd_uncore_df_ctx_scan(struct amd_uncore *uncore, unsigned int cpu)
 	info.split.aux_data = 0;
 	info.split.num_pmcs = NUM_COUNTERS_NB;
 	info.split.gid = 0;
-	info.split.cid = topology_logical_package_id(cpu);
+	info.split.cid = topology_amd_node_id(cpu);
 
 	if (pmu_version >= 2) {
 		ebx.full = cpuid_ebx(EXT_PERFMON_DEBUG_FEATURES);
@@ -932,8 +932,8 @@ void amd_uncore_umc_ctx_scan(struct amd_uncore *uncore, unsigned int cpu)
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



