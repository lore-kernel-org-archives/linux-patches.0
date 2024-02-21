Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217726F074;
	Wed, 21 Feb 2024 13:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522392; cv=none; b=XjhcqEdv0n8O13nE4qE6xWx7ToAjh4k+4y6jEP86DsuFBexYoQtVkwJwKq7oj8ifrFiHdxpAmdbVy9COWrZ0qH0Mgdwb1byNeHKIA5qj32FYIOFKjLOZ+oYxG2VltKk486MH+7QnPgQX4IocJihdNtXc4VEAPtDQMuT0fPnQoXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522392; c=relaxed/simple;
	bh=wy4mZ99YuqORxH2bceluzgguMyQJNYCsBWJaf/GPDHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ry0i7PWONoYnScUbWhmdxcBv4Gresn6NVGTQvn0bEdCTaRqEIH5Act2Bn/SiggMFj4+NQuY5Jm5YZo4i5mJD70Qazfj+dGoJpaKYoATLu7kMm4IE2TdE9l9wucTasDpvu7G/3KA7LoayjJg17bHKqUVDGPp7KT5/291hBiCVB1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1NF9obC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1NF9obC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C47C433C7;
	Wed, 21 Feb 2024 13:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522390;
	bh=wy4mZ99YuqORxH2bceluzgguMyQJNYCsBWJaf/GPDHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1NF9obCc48a1zCOobp79O7AcTu7LA4CrV/fWVS8y+E1PQEl/tUM5Hc1CMp2UOvcN
	 4qG5qlTfSOXPkjcL+hoh7iqCUhIAdnfEa2kcOjuPFi+QbQ0KNi8AkxfQVrAyV3FPcF
	 0QiUW4YWnnA5ZWsl6p2KCscgXERZhMaMuzV+eqJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/476] cpufreq: intel_pstate: Drop redundant intel_pstate_get_hwp_cap() call
Date: Wed, 21 Feb 2024 14:02:45 +0100
Message-ID: <20240221130012.202488106@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 458b03f81afbb27143c45d47c2d8f418b2ba2407 ]

It is not necessary to call intel_pstate_get_hwp_cap() from
intel_pstate_update_perf_limits(), because it gets called from
intel_pstate_verify_cpu_policy() which is either invoked directly
right before intel_pstate_update_perf_limits(), in
intel_cpufreq_verify_policy() in the passive mode, or called
from driver callbacks in a sequence that causes it to be followed
by an immediate intel_pstate_update_perf_limits().

Namely, in the active mode intel_cpufreq_verify_policy() is called
by intel_pstate_verify_policy() which is the ->verify() callback
routine of intel_pstate and gets called by the cpufreq core right
before intel_pstate_set_policy(), which is the driver's ->setoplicy()
callback routine, where intel_pstate_update_perf_limits() is called.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 192cdb1c907f ("cpufreq: intel_pstate: Refine computation of P-state for given frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 736cb2cfcbb0..f2a94afb6eec 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2332,18 +2332,14 @@ static void intel_pstate_update_perf_limits(struct cpudata *cpu,
 	 * HWP needs some special consideration, because HWP_REQUEST uses
 	 * abstract values to represent performance rather than pure ratios.
 	 */
-	if (hwp_active) {
-		intel_pstate_get_hwp_cap(cpu);
-
-		if (cpu->pstate.scaling != perf_ctl_scaling) {
-			int scaling = cpu->pstate.scaling;
-			int freq;
-
-			freq = max_policy_perf * perf_ctl_scaling;
-			max_policy_perf = DIV_ROUND_UP(freq, scaling);
-			freq = min_policy_perf * perf_ctl_scaling;
-			min_policy_perf = DIV_ROUND_UP(freq, scaling);
-		}
+	if (hwp_active && cpu->pstate.scaling != perf_ctl_scaling) {
+		int scaling = cpu->pstate.scaling;
+		int freq;
+
+		freq = max_policy_perf * perf_ctl_scaling;
+		max_policy_perf = DIV_ROUND_UP(freq, scaling);
+		freq = min_policy_perf * perf_ctl_scaling;
+		min_policy_perf = DIV_ROUND_UP(freq, scaling);
 	}
 
 	pr_debug("cpu:%d min_policy_perf:%d max_policy_perf:%d\n",
-- 
2.43.0



