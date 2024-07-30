Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF06A1A6195;
	Tue, 30 Jul 2024 16:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357159; cv=none; b=gPGOMo3zQXCdD/IjnOVULjpwQzPUKpBVRhUB+/lUlnN2FDwsKqi4LtDQ/Vtq0C7tU7jaQCzOQHww8NnKRyDZNgfdex5VZKyiT6JBmQb5zLwLhneYHg0GVCcIoQuIWbHfeuf96bmESKZ9Ayxv/bd7ib/vESMRSycnWtpzNdR4jgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357159; c=relaxed/simple;
	bh=3vSH9DHGhVkz9eh/1uCrptbVbtAAaKK+tWU55HeFXjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQyrUZOcUcciXZzR9VYHCgd8i3bl0+2JeNWR3iXU8lbr5LUE+TGOVHWDW16XyWF7swUn8+ccRd9fs/bNloNOI7c+rGwrh7XRFCQhUuEVIJCa5HSxo5u2UfgRUF+tR+aVHZFiu0KiOULX/E6a7Kqj5B6ZTlCyA/G64jnZJ2TPzfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0hZA5l4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0hZA5l4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6ADC32782;
	Tue, 30 Jul 2024 16:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357158;
	bh=3vSH9DHGhVkz9eh/1uCrptbVbtAAaKK+tWU55HeFXjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0hZA5l4j+ykQWc8WXJUHHJvSk6me2J48WDaxtR5lr5Ic3+e7HSwgGfk1AnGc1SQc
	 EIYj0RGC/W51V2ITcM5xuzcD85PQuMcuKA1tkmWDBXwRBcP/5g0EYxd1HrRrdeLUc+
	 RCSHIfvC1Xsl82BfiOPEeYwwOgMJKsqOO210+70E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 228/809] perf/x86/amd/uncore: Fix DF and UMC domain identification
Date: Tue, 30 Jul 2024 17:41:44 +0200
Message-ID: <20240730151733.612977408@linuxfoundation.org>
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

[ Upstream commit 57e11990f45f89bc29d0f84dd7b13a4e4263eeb2 ]

For uncore PMUs, a single context is shared across all CPUs in a domain.
The domain can be a CCX, like in the case of the L3 PMU, or a socket,
like in the case of DF and UMC PMUs. This information is available via
the PMU's cpumask.

For contexts shared across a socket, the domain is currently determined
from topology_die_id() which is incorrect after the introduction of
commit 63edbaa48a57 ("x86/cpu/topology: Add support for the AMD
0x80000026 leaf") as it now returns a CCX identifier on Zen 4 and later
systems which support CPUID leaf 0x80000026.

Use topology_logical_package_id() instead as it always returns a socket
identifier irrespective of the availability of CPUID leaf 0x80000026.

Fixes: 63edbaa48a57 ("x86/cpu/topology: Add support for the AMD 0x80000026 leaf")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20240626074942.1044818-1-sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index b78e05ab4a737..5a4bfe9aea237 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -639,7 +639,7 @@ void amd_uncore_df_ctx_scan(struct amd_uncore *uncore, unsigned int cpu)
 	info.split.aux_data = 0;
 	info.split.num_pmcs = NUM_COUNTERS_NB;
 	info.split.gid = 0;
-	info.split.cid = topology_die_id(cpu);
+	info.split.cid = topology_logical_package_id(cpu);
 
 	if (pmu_version >= 2) {
 		ebx.full = cpuid_ebx(EXT_PERFMON_DEBUG_FEATURES);
@@ -899,8 +899,8 @@ void amd_uncore_umc_ctx_scan(struct amd_uncore *uncore, unsigned int cpu)
 	cpuid(EXT_PERFMON_DEBUG_FEATURES, &eax, &ebx.full, &ecx, &edx);
 	info.split.aux_data = ecx;	/* stash active mask */
 	info.split.num_pmcs = ebx.split.num_umc_pmc;
-	info.split.gid = topology_die_id(cpu);
-	info.split.cid = topology_die_id(cpu);
+	info.split.gid = topology_logical_package_id(cpu);
+	info.split.cid = topology_logical_package_id(cpu);
 	*per_cpu_ptr(uncore->info, cpu) = info;
 }
 
-- 
2.43.0



