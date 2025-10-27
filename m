Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997AE1BC4E;
	Mon, 27 Oct 2025 19:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593254; cv=none; b=bEzZnmLo3H7E8mkEWqKomHjks4nDnd/XgHKMX0fcvr+yiXwKqG6rRuh0phsFFP9qlbZgCPiy4sfvDSHu1u6WKuXV0xkR4WHUe2M5XotEoAiIaxxmkwATTD8bgSh7AzNrRhLIQ4DAOIKKA/FzwwXIiF1kw/l20VzXOwT+tfIyS6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593254; c=relaxed/simple;
	bh=danlQ7lPFU15lc+uN0OBkoIER56uirKcuxAMFfIQGfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVPEgRh54ZUEh2zIrmE8aTynwbMxk2bpGUb0I0GkZMlcnlbGSOP1wdIbveuehtOo72xC4UN8UirGaUABZJM5ZmrGBM3X16aIdaNyM2i5kdpwhY2yH33sqb/ThXrwgmLv7V+C2y2UgDs8t45HzogKH7k7wLDcYV/PUaruz9kWAEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtoVQO7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtoVQO7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA36C4CEF1;
	Mon, 27 Oct 2025 19:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593254;
	bh=danlQ7lPFU15lc+uN0OBkoIER56uirKcuxAMFfIQGfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtoVQO7lOouW1JXe0yKVcu7P93iyZY41xGmQ4dLMJGLjDDxWh+DpZlHS/O5H4My56
	 LWtPpUfFwUZ4a2Xu18R3vQet4xxWpArQ0hKZXfuw5tskrYYY/qNDAb8XkgvBA6FjzR
	 PaueyVA2T6RVj/3pif2kWoyjyGYxHJTzUoBtbzgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 034/184] cpufreq/amd-pstate: Fix a regression leading to EPP 0 after hibernate
Date: Mon, 27 Oct 2025 19:35:16 +0100
Message-ID: <20251027183515.836346861@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 85d7dda5a9f665ea579741ec873a8841f37e8943 ]

After resuming from S4, all CPUs except the boot CPU have the wrong EPP
hint programmed.  This is because when the CPUs were offlined the EPP value
was reset to 0.

This is a similar problem as fixed by
commit ba3319e590571 ("cpufreq/amd-pstate: Fix a regression leading to EPP
0 after resume") and the solution is also similar.  When offlining rather
than reset the values to zero, reset them to match those chosen by the
policy. When the CPUs are onlined again these values will be restored.

Closes: https://community.frame.work/t/increased-power-usage-after-resuming-from-suspend-on-ryzen-7040-kernel-6-15-regression/74531/20?u=mario_limonciello
Fixes: 608a76b65288 ("cpufreq/amd-pstate: Add support for the "Requested CPU Min frequency" BIOS option")
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index b4c79fde1979b..e4f1933dd7d47 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1614,7 +1614,11 @@ static int amd_pstate_cpu_offline(struct cpufreq_policy *policy)
 	 * min_perf value across kexec reboots. If this CPU is just onlined normally after this, the
 	 * limits, epp and desired perf will get reset to the cached values in cpudata struct
 	 */
-	return amd_pstate_update_perf(policy, perf.bios_min_perf, 0U, 0U, 0U, false);
+	return amd_pstate_update_perf(policy, perf.bios_min_perf,
+				     FIELD_GET(AMD_CPPC_DES_PERF_MASK, cpudata->cppc_req_cached),
+				     FIELD_GET(AMD_CPPC_MAX_PERF_MASK, cpudata->cppc_req_cached),
+				     FIELD_GET(AMD_CPPC_EPP_PERF_MASK, cpudata->cppc_req_cached),
+				     false);
 }
 
 static int amd_pstate_suspend(struct cpufreq_policy *policy)
-- 
2.51.0



