Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375FD46C4AE;
	Tue, 21 Jul 2026 17:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656356; cv=none; b=py49ifvNUtIeQeInucD7MQ4rguXRWniWz0cy8sTBn2U1RJtTd+6CB6zdZrfblH5OtTGbkNNgbqkrk8jGz9s1XZTazMLMxEE3BCoTpsHgnf52bYJ+yL6Rm/ewcV6xX4hMmZlIVgUr73al6vUaWHe+/kH+chg33/bPEXeDJgDbxec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656356; c=relaxed/simple;
	bh=OWgs+pwsy11nth53GR+Jo0i4rMAN0mVZw/Tbv7Vw6JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnxzwzsI7npggSI1nto+fTox5x0tjkcu8qYQU6J1CYHu6poOJdewFIkQbfLNG5mZez5XiX1z0JFsdRBJ5z1IDhcGEavHDl84WjOTIhcuKRI2t+GBpcw0yJnRFI2Y3cqZa5nZ7gtNuoDc/YdHNa6fIwhCpDWBb4loSw6XH5b9P1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcuO90L2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcuO90L2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC5E1F000E9;
	Tue, 21 Jul 2026 17:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656355;
	bh=tx8/GXPrBZ6QbF6uJqT4HlJ+Eu33PG5yOcXVkFugBRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wcuO90L2ZBp9NkYHnRaPZBwdzB2aZRZNq9/lQd+1JwaxUB64/HTPf0kSNaezBW7kt
	 GnwMLgtmV9o03mYhdtXPS0VMb0u2ZrNJXrr6XeV/fSQlNCXY4fYLuoAtMjjScN0JLt
	 MAD92jn3SdvtRYrIHQEIq2oc762v2bewIdjf+KSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0329/1611] perf/x86/amd/uncore: Use Node ID to identify DF and UMC domains
Date: Tue, 21 Jul 2026 17:07:25 +0200
Message-ID: <20260721152522.494073005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9293ce50574dad..9a13a9f21d2f86 100644
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



