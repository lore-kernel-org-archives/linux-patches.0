Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C15D347BC6;
	Tue, 21 Jul 2026 22:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674736; cv=none; b=WNNMcYvwUjVDLGb2CiikGYkcTkA6djfTTQoRT5GB8HuTO7WN8cMR3F/nqOSeDcbPJmsGYK06dszYPlOe+QYxsAGFChuLoERH2FygE6iBHXGFiY553HSUJRHdzlXCrELC+IqhEYcmHEO1Iwy6CPDZ3jHwc8ERwYPEoBQbgP4HMbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674736; c=relaxed/simple;
	bh=9NgsmP6JhB4HKKEiFpt/jGcm0zB1pm0Ard5VL29zN+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=demJo258AQpGLbswaYSw35wBMxHAgmkMUW7zIUJNuJkXwaMvmsz1zMB34ao081Aju1j7+m4LoZGSIZBps819mT08oMS6POAwzPR2AVMYNIEUKzIjrD8kHj/CY16V2dNWNK6l9BqJmSBkVtQAV96hdvAtuB7ELyPX6egdXkgonXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkxIaSvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkxIaSvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8439A1F000E9;
	Tue, 21 Jul 2026 22:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674735;
	bh=tO8lkG5fW7CLBw6Jhg4Smgvxt24nXqYRBtCm6k2GVQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkxIaSvNl6gEYYkFz7jWfOxnq2cH0yWnWRZN46k3nNkFJJmhPsC+i05pb750UFXKs
	 DG/XN8Jhmza81t+U9ESXQclKp2K0Vv+Tp8gVp96ZlbMBrW9gXKyQi1BdtOj8DZrVRA
	 99yM+5HXJfHx9VkpuvssmwFnjrpNd95DGJlGoKKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 653/699] cpufreq: intel_pstate: Sync policy->cur during CPU offline
Date: Tue, 21 Jul 2026 17:26:52 +0200
Message-ID: <20260721152410.489833483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit bcbdaa1086c25a8a5d48e04e1b82fdfb0682b681 ]

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
[ replaced `cpu->pstate.min_freq` with `cpu->pstate.min_pstate * cpu->pstate.scaling` since 5.10 lacks the min_freq field ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2355,10 +2355,12 @@ static int intel_pstate_cpu_offline(stru
 	 * from getting to lower performance levels, so force the minimum
 	 * performance on CPU offline to prevent that from happening.
 	 */
-	if (hwp_active)
+	if (hwp_active) {
 		intel_pstate_hwp_offline(cpu);
-	else
+	} else {
 		intel_pstate_set_min_pstate(cpu);
+		policy->cur = cpu->pstate.min_pstate * cpu->pstate.scaling;
+	}
 
 	intel_pstate_exit_perf_limits(policy);
 


