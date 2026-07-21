Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516B845A291;
	Tue, 21 Jul 2026 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671105; cv=none; b=gn9KUKmEqslU+mVrzEPR5Lf6l0mH9Q9l48p+zAjDE/0I9BjH5PMZJQYdzZajr16UjrGpYY7ncm2wR5ljFb83D+dEinmhcd/sCqP8ufPRMNz4ek0kBIJRfEURhPgyoIebq7JfhxRapCpwGvKsrhlH0ZGzDX2XQLcKGQdnipGeA2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671105; c=relaxed/simple;
	bh=BIkE0DNgH2Mo9/9BiuluY98/9ueQk/i2TLNAW31iMCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzv9BABQTgEHfinnVfAaZafbA6UYF10vzmSJoFEY2EG0QoeweBuU514GopsSZDR3OHX3KFRYRDu4tsOCIfZydSOnMtyGxpMijhkC2Pi6cABmdTuORFUug3NSPGxdYwusfTtiboU/Cjbe3y7+BwJjfo+tYWaIu5EW/oPXxiv6eAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnaH8oVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnaH8oVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF9D1F00A3A;
	Tue, 21 Jul 2026 21:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671095;
	bh=Fe5/pB/ws+vJjm0o2TlHyAPpx48ekLo86Z88v5ZV2R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnaH8oVXdEIif8AzQSIP46DvHVSgjqh4HgKTdPSyWWPwjBRVAi6QfIntaQ8VYAII6
	 zH1tv3Yo0Hd4bMVdocE2OPFZbAOr9hEub2OqVoExANinMlulKxk8CgAtjxrGOyYDNO
	 HIs/PSNPMlNs/QCgkkZPF5HP1A+Mx4i7PDKoMBns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 116/843] cpufreq: intel_pstate: Sync policy->cur during CPU offline
Date: Tue, 21 Jul 2026 17:15:51 +0200
Message-ID: <20260721152408.614059110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

commit bcbdaa1086c25a8a5d48e04e1b82fdfb0682b681 upstream.

When a CPU goes offline with HWP disabled, intel_pstate_set_min_pstate()
sets the MSR_IA32_PERF_CTL to minimum frequency to prevent SMT siblings
from being restricted. However, the policy->cur value was not updated,
leaving it at the previous value.

When the CPU comes back online, governor->limits() checks if target_freq
equals policy->cur and skips the frequency adjustment if they match. Since
policy->cur still holds the previous value, the governor does not call
cpufreq_driver->target to update MSR_IA32_PERF_CTL.

Fix this by synchronizing policy->cur with the hardware state when setting
minimum pstate during CPU offline.

Fixes: bb18008f8086 ("intel_pstate: Set core to min P state during core offline")
Cc: stable@vger.kernel.org # 3.15+
Suggested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
[ rjw: Subject refinement ]
Link: https://patch.msgid.link/20260520032119.30615-1-fushuai.wang@linux.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2498,10 +2498,12 @@ static int intel_cpufreq_cpu_offline(str
 	 * from getting to lower performance levels, so force the minimum
 	 * performance on CPU offline to prevent that from happening.
 	 */
-	if (hwp_active)
+	if (hwp_active) {
 		intel_pstate_hwp_offline(cpu);
-	else
+	} else {
 		intel_pstate_set_min_pstate(cpu);
+		policy->cur = cpu->pstate.min_freq;
+	}
 
 	intel_pstate_exit_perf_limits(policy);
 


