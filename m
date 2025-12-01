Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B662E6100;
	Mon,  1 Dec 2025 11:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588550; cv=none; b=jve8m1l81qwPkApqiYK2VS4m/FfnQECeDceW20z+Z07Gbl23IuRkIv+DGy7PiRPyLwzDjyBq6zjydPOX5yRWSj0tVOmh9zJVU+x35wK85OHqRVCkAoOfYQjbEHE3pwkYEUuPD500tJfTubu0zgFETBQ9Ylv/76jVVbs5Sksy9Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588550; c=relaxed/simple;
	bh=cZUTsioaliCrNOfP/sQ32e+5Ml2HTbWIRE22uvF4q2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScBapt4GszFAOut5umUrlmEPpeOv6h/IijcgO8w4zZbMDfP3ZKxYS4blalxIEBlT2eYVZB5+gQrbr2PPk4r0P5N9rsx9rHKJ0Ux9w0N5zPcY47SrfhLwcOIxmkKFxQQBt4KNOiBcjAcD++UXnQn8o1pILdmTKKnCoOK/x7ub5EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3ctqFGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3ctqFGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A551C113D0;
	Mon,  1 Dec 2025 11:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588549;
	bh=cZUTsioaliCrNOfP/sQ32e+5Ml2HTbWIRE22uvF4q2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3ctqFGdxO/I6ZhoC6s0cZT1hseV+q2WoOWsTh7SutI137LEZ/ypRSOYyhKRNPMZC
	 HS1jbUWCnegU7k9uyYnQffb9cogqQIGhzAnRltiAT7/jIhkJ6I1RhH5ycM1okBEOXn
	 Q/hP3omHUfaA7BpSOmgaAqPdmonNNY7DsRm4BzpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/187] tools/power x86_energy_perf_policy: Prefer driver HWP limits
Date: Mon,  1 Dec 2025 12:22:32 +0100
Message-ID: <20251201112242.840466398@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 2734fdbc9bb8a3aeb309ba0d62212d7f53f30bc7 ]

When we are successful in using cpufreq min/max limits,
skip setting the raw MSR limits entirely.

This is necessary to avoid undoing any modification that
the cpufreq driver makes to our sysfs request.

eg. intel_pstate may take our request for a limit
that is valid according to HWP.CAP.MIN/MAX and clip
it to be within the range available in PLATFORM_INFO.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86_energy_perf_policy/x86_energy_perf_policy.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 0cb17e13c002b..c878e2e1cabea 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -62,6 +62,7 @@ unsigned char turbo_update_value;
 unsigned char update_hwp_epp;
 unsigned char update_hwp_min;
 unsigned char update_hwp_max;
+unsigned char hwp_limits_done_via_sysfs;
 unsigned char update_hwp_desired;
 unsigned char update_hwp_window;
 unsigned char update_hwp_use_pkg;
@@ -809,8 +810,10 @@ int ratio_2_sysfs_khz(int ratio)
 }
 /*
  * If HWP is enabled and cpufreq sysfs attribtes are present,
- * then update sysfs, so that it will not become
- * stale when we write to MSRs.
+ * then update via sysfs. The intel_pstate driver may modify (clip)
+ * this request, say, when HWP_CAP is outside of PLATFORM_INFO limits,
+ * and the driver-chosen value takes precidence.
+ *
  * (intel_pstate's max_perf_pct and min_perf_pct will follow cpufreq,
  *  so we don't have to touch that.)
  */
@@ -865,6 +868,8 @@ int update_sysfs(int cpu)
 	if (update_hwp_max)
 		update_cpufreq_scaling_freq(1, cpu, req_update.hwp_max);
 
+	hwp_limits_done_via_sysfs = 1;
+
 	return 0;
 }
 
@@ -943,10 +948,10 @@ int update_hwp_request(int cpu)
 	if (debug)
 		print_hwp_request(cpu, &req, "old: ");
 
-	if (update_hwp_min)
+	if (update_hwp_min && !hwp_limits_done_via_sysfs)
 		req.hwp_min = req_update.hwp_min;
 
-	if (update_hwp_max)
+	if (update_hwp_max && !hwp_limits_done_via_sysfs)
 		req.hwp_max = req_update.hwp_max;
 
 	if (update_hwp_desired)
-- 
2.51.0



