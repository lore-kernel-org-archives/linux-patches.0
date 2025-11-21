Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BAA34EEE3;
	Fri, 21 Nov 2025 13:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732404; cv=none; b=A6szmOGAfYwDz8/+8iO19DWvzXvokwFNjAf0BC8IkdnVl0UQ3TY6fvBj79jlW5Amp7sJh3T2gMIAKhUAWImlS0EeNO3NSL0HFkwCrUr4NOc2AaXxxMZrmvJKyx0LXtCjyB5dkqeqzEbgOrGdEM9qAjw6mlHUZXz8mTBFuGpo8mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732404; c=relaxed/simple;
	bh=ktvHv5+FqeL52r8HW40VBfzabxJK2DAFMwovFtrQ5bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okgVwcVagIGcnUnUH8SHmGTQpuerK7AW1uDpbrLLt6ONkFTqoasprphkq/EHNQftm4ol/geqELBkVN1Gqc6iVUbjrvP6tIOEVraH2EgCUNuP+hBdeDe+W1g0wSKxvrWwpM9yVqH9sDZYAXYwoGuRBdJGJFNkrvEuQxaWlyTwB44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WruMCmH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WruMCmH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D86C4CEF1;
	Fri, 21 Nov 2025 13:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732404;
	bh=ktvHv5+FqeL52r8HW40VBfzabxJK2DAFMwovFtrQ5bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WruMCmH+bT+3D1Z3UCYWbo0TJbv/syto4pnU46EAks9+xpb5ZudyfJhewWp+L+pDJ
	 LkPptUH6Yrek9BfXGXmrBKDv2Ma1uqlojoTGoHpdqwejjbNEq92/5Hm+NTHpgVB1hI
	 VXcSDySnwD1aw3iLDdz3e95gWGazyugCVQ99l5kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/529] tools/power x86_energy_perf_policy: Prefer driver HWP limits
Date: Fri, 21 Nov 2025 14:06:49 +0100
Message-ID: <20251121130234.939383523@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



