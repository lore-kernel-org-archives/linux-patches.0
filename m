Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD99027EFE
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B75C433C8;
	Wed, 20 Sep 2023 11:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210746;
	bh=Bp7yoiIy326M010oPSSiusbLbF6InCcKKEvCRmE+waI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuJGdsULEUwndkCyYO50XRnu1r1Dzab8Et7BagmIQckPQIWGp5Mv6lkhYQvHet303
	 4bdVmvNN0IiOcTcyM3YuzLqr0n+kzEXSUci2EagyhAEh6rWjTH3mU/KUMIWhbAZ4io
	 F7KGO0ZHhDysvGDg+/wLPlGBqTgy7CGVbrJE/mow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Caleb Callaway <caleb.callaway@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 154/211] x86/sched: Restore the SD_ASYM_PACKING flag in the DIE domain
Date: Wed, 20 Sep 2023 13:29:58 +0200
Message-ID: <20230920112850.648170505@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 108af4b4bd3813610701379a58538e3339b162e4 ]

Commit 8f2d6c41e5a6 ("x86/sched: Rewrite topology setup") dropped the
SD_ASYM_PACKING flag in the DIE domain added in commit 044f0e27dec6
("x86/sched: Add the SD_ASYM_PACKING flag to the die domain of hybrid
processors"). Restore it on hybrid processors.

The die-level domain does not depend on any build configuration and now
x86_sched_itmt_flags() is always needed. Remove the build dependency on
CONFIG_SCHED_[SMT|CLUSTER|MC].

Fixes: 8f2d6c41e5a6 ("x86/sched: Rewrite topology setup")
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Caleb Callaway <caleb.callaway@intel.com>
Link: https://lkml.kernel.org/r/20230815035747.11529-1-ricardo.neri-calderon@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/smpboot.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7d82f0bd449c7..747b83a373a2d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -587,7 +587,6 @@ static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 }
 
 
-#if defined(CONFIG_SCHED_SMT) || defined(CONFIG_SCHED_CLUSTER) || defined(CONFIG_SCHED_MC)
 static inline int x86_sched_itmt_flags(void)
 {
 	return sysctl_sched_itmt_enabled ? SD_ASYM_PACKING : 0;
@@ -611,7 +610,14 @@ static int x86_cluster_flags(void)
 	return cpu_cluster_flags() | x86_sched_itmt_flags();
 }
 #endif
-#endif
+
+static int x86_die_flags(void)
+{
+	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
+	       return x86_sched_itmt_flags();
+
+	return 0;
+}
 
 /*
  * Set if a package/die has multiple NUMA nodes inside.
@@ -653,7 +659,7 @@ static void __init build_sched_topology(void)
 	 */
 	if (!x86_has_numa_in_package) {
 		x86_topology[i++] = (struct sched_domain_topology_level){
-			cpu_cpu_mask, SD_INIT_NAME(DIE)
+			cpu_cpu_mask, x86_die_flags, SD_INIT_NAME(DIE)
 		};
 	}
 
-- 
2.40.1



