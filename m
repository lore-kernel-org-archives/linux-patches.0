Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D4C44AB68;
	Tue, 21 Jul 2026 21:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668437; cv=none; b=RbqhDwHBi+tNv6k8j49TQ8tS5y3Vk2AXzpgxfP3Pihyaj+SbG0ubPNEnOMwo4rbKNmAf8+vLigda74Rc5J6Dm+9VfCjCHsnF4krORvfsXzfy+trXZpqFt5wln7SdengtfiRhRtw3ireIzTGsbVXmSTCF3SzNzPvi2VU3Ih9ldkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668437; c=relaxed/simple;
	bh=CKU6Mg01Nak9TSqQzQANqSEiKoltzcR/YU97OV0+oCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vu5OscNhlaR9W4w4Olzollx80MbW88H5yIkEEiDOkYfnOGhiB6/baPFdlsENHgioadJNSJdVgDA1SAjxItgSPL98BtBAmXFIwVcpsCsIbT7zADRWO0Sragyi1qkIkSSgxhmj6+emDwUYtUxufY/rqh3LdaerGvsscu8jxbriNcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abU0UcMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abU0UcMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B817E1F000E9;
	Tue, 21 Jul 2026 21:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668436;
	bh=0qvRrdZurlb8ivXl/aZi/ZjW20b78B7gHVolQqQjGT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abU0UcMKdQ7MKrdgthQPdkwae8cY0q+TF4lxhKx/gFxQ3VoBhjR2hG5oWK1j3WR2m
	 YyT0LFLVg2tK9w45eStG6djScsTPw3VW3s7NNn4GCjNHVrMiQVO1wymA/Oj+Zjzarj
	 XlOxtfZ9ziu/CWAIX2b/PIw/WzRw3uBkY9jlo2Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 0148/1067] cpufreq: intel_pstate: Sync policy->cur during CPU offline
Date: Tue, 21 Jul 2026 17:12:29 +0200
Message-ID: <20260721152427.905518196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -2631,10 +2631,12 @@ static int intel_cpufreq_cpu_offline(str
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
 


