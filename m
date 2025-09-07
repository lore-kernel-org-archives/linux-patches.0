Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040A314BFA2;
	Sun,  7 Sep 2025 20:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276456; cv=none; b=RfUh67KEU3EezoqdZ1A4gWqCG1I7cwQNAf31R4gv/syD70uUXpsTn1xS6a1sdus5uI/zK3tUZYBQ2cVeK8UoBx2iVLu1a0cohPOj7OmiJ/MmNwGZMZLJz8LYXP2HsETYcAOyUboR+F/ptwJmlFfnS1rzCaDv0Z3ZjIb25S33IDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276456; c=relaxed/simple;
	bh=YZe9Sa9C3pgHXZ0tHd+sCQbj8gBGWC0UuzFcQv/VJFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prF45y54JPly1XvaMUbe6+JfNcRwDC/t4tq+2IJIi4kK0lSwuEdWNzAZfug+puzCPGaWKmb0oDfGnKMCdUMaICfEcQBLQd2GxIuY39nvmKmEmlTmBX21HkW41U97oFZLDAZoHYRANE2k4EG/yxn5GvlF8SB4espKwlGu9ardxzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIm4Gcnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIm4Gcnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A086C4CEF0;
	Sun,  7 Sep 2025 20:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276455;
	bh=YZe9Sa9C3pgHXZ0tHd+sCQbj8gBGWC0UuzFcQv/VJFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIm4GcnjhMGCGqsC2l4khO9d7ptIDifmqhT2bbMl0cYdpT9FrRl62D26IqDLILV6D
	 M4Jbi08L4k5xD8Fz0s7XCt4jm29LYUGzZHSbvFcW/8FhmJzWCzELXoqhET+jxsD6sx
	 eYW/X+DZ88BCrRL7oUoPE+YIniZ1x41bBfYXLuvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/104] cpufreq: intel_pstate: Fold intel_pstate_max_within_limits() into caller
Date: Sun,  7 Sep 2025 21:58:27 +0200
Message-ID: <20250907195609.495930320@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 032c5565eb80edb6f2faeb31939540c897987119 ]

Fold intel_pstate_max_within_limits() into its only caller.

No functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Stable-dep-of: ac4e04d9e378 ("cpufreq: intel_pstate: Unchecked MSR aceess in legacy mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1984,14 +1984,6 @@ static void intel_pstate_set_min_pstate(
 	intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
 }
 
-static void intel_pstate_max_within_limits(struct cpudata *cpu)
-{
-	int pstate = max(cpu->pstate.min_pstate, cpu->max_perf_ratio);
-
-	update_turbo_state();
-	intel_pstate_set_pstate(cpu, pstate);
-}
-
 static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 {
 	int perf_ctl_max_phys = pstate_funcs.get_max_physical(cpu->cpu);
@@ -2573,12 +2565,15 @@ static int intel_pstate_set_policy(struc
 	intel_pstate_update_perf_limits(cpu, policy->min, policy->max);
 
 	if (cpu->policy == CPUFREQ_POLICY_PERFORMANCE) {
+		int pstate = max(cpu->pstate.min_pstate, cpu->max_perf_ratio);
+
 		/*
 		 * NOHZ_FULL CPUs need this as the governor callback may not
 		 * be invoked on them.
 		 */
 		intel_pstate_clear_update_util_hook(policy->cpu);
-		intel_pstate_max_within_limits(cpu);
+		update_turbo_state();
+		intel_pstate_set_pstate(cpu, pstate);
 	} else {
 		intel_pstate_set_update_util_hook(policy->cpu);
 	}


