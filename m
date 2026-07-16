Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813705A79B;
	Thu, 16 Jul 2026 14:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210958; cv=none; b=pShHzbSYwWsUMW1rFW/PzKd6XMsfcausf++qZ1OMJVnfynPvu3p/X0Hs+qf1eEdr3x3faTejhB82v7U3KX9ji6MiOOmRprglqzWPMPR75wIFvAC9r0Tsu+rVshewB/cTTwDdigfG1ALi9Vzci2tCx2pF0RYoI6azohCM7S3v8TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210958; c=relaxed/simple;
	bh=VaFe5bFxAMcAf8evWFY9F1SVqfEuFZOW9uKd/5bZk90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USXqjA4cLBeIayb8XRrHD7F25oJ8zc9tB6uyUMZE4JSa41d6Po2Brw3RmR1omUjWdq76MD2CVd24KzlKfTPVVJUYpkBbTpeqaD8L7cTI/hh2LVSTViR9TW5PwYavn6yuhioxxCx7ew0DdudNqhCOof1rrycNYB2NVZhNGmcxi7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jtp1S8rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jtp1S8rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BCC1F000E9;
	Thu, 16 Jul 2026 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210957;
	bh=G+OUg+AMNEF/YBJU2h+guUYbu9pKYS9X2dh9rVv/if4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jtp1S8rhWyVmZEcuI5gOOJevghKKEAzQhceGTuwVzwF+sE0xsTsuWlWdF9CVjxuRZ
	 EalsPOlj0Vb8ex61EPBrxqgM7GTzsY7ZSx3ayg/t1+L1I2uoqjb4nA875Q09Norj5s
	 lz5MXKtO6/tt2+L/MziQJa+C2rNen+rW5hfm6E9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 246/480] cpufreq: intel_pstate: Sync policy->cur during CPU offline
Date: Thu, 16 Jul 2026 15:29:53 +0200
Message-ID: <20260716133050.140112005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3016,10 +3016,12 @@ static int intel_cpufreq_cpu_offline(str
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
 


