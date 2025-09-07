Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201DD189BB0;
	Sun,  7 Sep 2025 20:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276671; cv=none; b=b9054EI5fTVB2pK5q1cuqxuB7Udxf5TSKlYEQ4r+ZhPKWqshgvOL1HGKGkCxTklE9W0qhkafSg88SfeOJsyEgXplvxzBoW7C87VyoLjzCH2itoQgPiUXxaiae8Y1G9RnBK8Z0CKodFIO4ZufVljJyn2GFKqLkBnnEBnN44VGN3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276671; c=relaxed/simple;
	bh=4gSoPuqSifWUWBhTniE00uH+H5IZTN+pVgRoztjXKrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htZom+CFqPW3u892lOpS2tyl4PXiH9vKkfpQxyZnEZ8ZGpDlIjmk5qwSYrNZQd2oWXkfhJwCzB16QAeoouxbhjahgLJwy8G8jme1khWmcw+yKNPLA+noIqGmbjqIlE3gZ4tk2YkAANegVZxRzmH76h/OM2JZHQT4/C4hfHWXWxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Br89MDqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Br89MDqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F431C4CEF0;
	Sun,  7 Sep 2025 20:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276670;
	bh=4gSoPuqSifWUWBhTniE00uH+H5IZTN+pVgRoztjXKrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Br89MDqecIbZ6BzLQ/wZFZEh1m8+9AUkECOojgjYIcQLFwUScR2Ml2u+Dyrbrk0k3
	 MgZ+s+iMgrIShm2md8o8IUo94LKstuyBSfRTRxqRIEa3j798S2ujZggjlI7CrCHOBy
	 8hBF0Kpc8btV0+vU8Y0e+ldPD5NHjMv6wxutPRuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/121] cpufreq: intel_pstate: Fold intel_pstate_max_within_limits() into caller
Date: Sun,  7 Sep 2025 21:58:29 +0200
Message-ID: <20250907195611.710168076@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2027,14 +2027,6 @@ static void intel_pstate_set_min_pstate(
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
@@ -2608,12 +2600,15 @@ static int intel_pstate_set_policy(struc
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


