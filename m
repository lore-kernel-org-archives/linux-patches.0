Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3791F5F6;
	Tue, 11 Nov 2025 01:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823028; cv=none; b=Z01RYMjSKJnd6Gc7vaV10cx+JIDdstmRNOSi1RIuc/yYa7qSgPO2X2wbpvEbX/VuMd/AoN4Gu428Rr+Dkli+h/FBGeMDh1CEpKbIa1Uh4okoyF42Vb8fnrcjiyBZ+eInfMlafD9eNDVovpWHNAD0TFp3NmdYIvKi9T/1HRQzypA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823028; c=relaxed/simple;
	bh=69Rl8ns5SfZ66ENHtDrtQ0sTxF8oY2ANjDamrSbMRgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZBomDwfkCNGx1s9O5obyvQLJt+FAn01lWsZixSl5h2OTCwBI247cPJ6kvc15wxVSmE2iZTK0EQTcDd3ga8ffyak9tfvQI23z4pO6bipW8kJ+RbD3y7FeWkVYQTAoVQUsJEdHp09uv6UvvLbbJKZsyZjaE0BT01gpqhywcXyd1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tyy1CaO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tyy1CaO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26CDC16AAE;
	Tue, 11 Nov 2025 01:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823028;
	bh=69Rl8ns5SfZ66ENHtDrtQ0sTxF8oY2ANjDamrSbMRgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tyy1CaO48Ip99kWn5UqUoY8AFsj+W6rnZEscP0zsbOlcyVc9LKHMmlhMLbJfetZaD
	 D3U5vzAqXofSBATWvki0vkYiH6Y3t3chLMMRPSiqgHOooI8itirbV2jX9g4zwL4DBI
	 PVdfx5J3zPC9XMQSiK3wvh2RQToVEw7chT9PcAP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 217/849] tools/power x86_energy_perf_policy: Prefer driver HWP limits
Date: Tue, 11 Nov 2025 09:36:27 +0900
Message-ID: <20251111004541.687742421@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



