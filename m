Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C27470105;
	Fri,  7 Aug 2026 15:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117479; cv=none; b=uzDbPuyigfdE+igYSqAm6LDPWNG+tVkeC8N4drHie2zCcjZmt9t3v9iZPDbKB+loiwJEpCftK9yEf7UeHGm99UTBDVjvViMWqC5360Sm2vApRN7VkxoXjJDGbXGC4LIfYX8RFPw85sF9Bjhu/EGJ2TXvzlP+0QI5O0gR4astzho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117479; c=relaxed/simple;
	bh=IYrEsfzm2MtH1lcTzbZUoVp38YLk04qpsqJrj2kjzhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaYxVmtYugyr/Od0gdAeHNGJa9TVCZypdxrDatEkUNq2WFGx+zuDvcGrOpISFyZ5e27+bXfku+CDIonVOHsuzMpYJhnfitnP1r6E5xUxR1qFKqU1vlP0ORHlqEX49Fmm/EeFV/4AutXMLP8+ecHuxGxpmh+hUrc55qEdPUejRXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSLcC2Qa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSLcC2Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D34B1F000E9;
	Fri,  7 Aug 2026 15:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117478;
	bh=KXxXNe24TShQl1OB1DURGsWU43HQi3hWrd/lrSzL/Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSLcC2QafXiqzd4PCtM8zktS1PzswXgb8YnJTA9KgD2HA9slRexTMqoxmjo6bS+LE
	 rdAsGD8zbMlwrsA11sj3PWbSviUdyiTfp2UcgS+KPbOWSY/YEGPo7w+DWkw9YOQ8zI
	 EmfQM3c1Pi/BnfaGqkGnHyJ3q0pETqtO4XaWC1tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.1 333/438] cpufreq: schedutil: Publish util hooks only after all sg_cpu are initialized
Date: Fri,  7 Aug 2026 16:38:49 +0200
Message-ID: <20260807143435.072465461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

commit f0a3f042293a8c5a2152346b3637ea60866c503a upstream.

Commit 16a03c71bba0 ("cpufreq: schedutil: Merge initialization code of
sg_cpu in single loop") merged the per-CPU initialization and the
utilization-hook registration into a single loop in sugov_start().

For a shared cpufreq policy this re-introduces the race originally fixed
by commit ab2f7cf141aa ("cpufreq: schedutil: Fix sugov_start() versus
sugov_update_shared() race").

The scheduler's util path reaches the hook under RCU-sched and never takes
policy->rwsem, so the rwsem held across sugov_start() cannot serialize the
two. Once the first CPU's hook is published, sugov_update_shared() may run
and, via sugov_next_freq_shared(), read/write each sibling sugov_cpu
(iowait_boost, util, bw_min, ...) concurrently with the memset() still
initializing them, with no lock common to both sides: the update side holds
sg_policy->update_lock while the init side holds only policy->rwsem, which
the scheduler's util path never takes.

The walk only accesses scalar members, never a pointer like ->sg_policy,
so it does not crash today; it merely uses stale (or zero on first start)
values that skew the frequency selection and tracepoints. It is still a
genuine data race, and a latent crash once any pointer member is
dereferenced there.

Restore the two-phase approach: initialize all per-CPU structures first,
and only then publish the per-CPU utilization update hooks.

Fixes: 16a03c71bba0 ("cpufreq: schedutil: Merge initialization code of sg_cpu in single loop")
Cc: stable@vger.kernel.org
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260716115159.848403-1-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cpufreq_schedutil.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -870,8 +870,19 @@ static int sugov_start(struct cpufreq_po
 		memset(sg_cpu, 0, sizeof(*sg_cpu));
 		sg_cpu->cpu = cpu;
 		sg_cpu->sg_policy = sg_policy;
+	}
+
+	/*
+	 * Publish the hooks only after all per-CPU data is initialized, so a
+	 * shared policy's sugov_update_shared() never reads an uninitialized
+	 * sibling sugov_cpu.
+	 */
+	for_each_cpu(cpu, policy->cpus) {
+		struct sugov_cpu *sg_cpu = &per_cpu(sugov_cpu, cpu);
+
 		cpufreq_add_update_util_hook(cpu, &sg_cpu->update_util, uu);
 	}
+
 	return 0;
 }
 


