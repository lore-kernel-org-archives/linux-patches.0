Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377CB23B60A;
	Wed,  3 Dec 2025 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779012; cv=none; b=R99k0L5bdsyzApgGQc5pqsreNx65R7mbfix+4hmZcB/wVnCRm4rodW/l2FEVJ93ISRdhaxH8GNiucykL315Ublm7uNCH6uCmSPf+1RrzqVp9GKw7ouCcqgUz6ay7LGTAGmhpmlZGfOy6nMu7KEqMRV0gvzpWFkKXl0GfO6JNCWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779012; c=relaxed/simple;
	bh=gfekilF7r16zx37P6saTxtS2NiTl5nUk1ALVvZiGd84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E77R3aksRyYudNBOZQEy2mAoFHDUyAJ/8PCMwxKNDHsqgzoBK8bu3icvP/gD//czKSdKjjZoFP9Eh4Wf2eRhYKwdgWSoqy7vNTm7kmnsdJhzvmzEsz2ERpAedJGmwmeDwQVgWSRbIXJYs4g0f+lwSe3XR9lDyuPeoNLfKtSSOg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onb8SFfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onb8SFfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7416C4CEF5;
	Wed,  3 Dec 2025 16:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779012;
	bh=gfekilF7r16zx37P6saTxtS2NiTl5nUk1ALVvZiGd84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onb8SFfpXMV2mSdaDMgkFJTo6hYq1/DIkgVTw3F5HLkk4gDNDY2ZagK8tZSJ/lbfx
	 gqrxsEf9zL6OTNbb0D7vkLWIhx6zQCRvPwkvVYDBlaJoFJ/ozMKSIQO+/Mhyl8Ftwb
	 JYBd7xpVQXEuBc3+nDPmglsMI49UumguZPD6YLQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/568] tools/power x86_energy_perf_policy: Prefer driver HWP limits
Date: Wed,  3 Dec 2025 16:22:10 +0100
Message-ID: <20251203152445.416928772@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0bda8e3ae7f77..891738116c8b2 100644
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
@@ -951,8 +952,10 @@ int ratio_2_sysfs_khz(int ratio)
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
@@ -1007,6 +1010,8 @@ int update_sysfs(int cpu)
 	if (update_hwp_max)
 		update_cpufreq_scaling_freq(1, cpu, req_update.hwp_max);
 
+	hwp_limits_done_via_sysfs = 1;
+
 	return 0;
 }
 
@@ -1085,10 +1090,10 @@ int update_hwp_request(int cpu)
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



