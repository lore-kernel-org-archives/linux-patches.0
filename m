Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C4D241673;
	Tue, 26 Aug 2025 13:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213770; cv=none; b=FagGv9bP9YlaycMRdcif81YeRNTIDnPPBGDRX/VEE851yxE6pLBh5uurUOxyVGzgI2wu41/RufiowIYnh4UE0ToVW554KpXce3l01WU3joaNnT0W4uf+wjUsO3/eQ4D3mdX21l3FPqkCblq9pOYfw8CRw6MoZhRgCPulf5ltGhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213770; c=relaxed/simple;
	bh=oZE20AVi6dYo7cG8Uv8BnwY/50X+W2N7FIFF+yhGybk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGSAX6lIOt0s0Qv0qRHJBlnutDAXhjGd2unwJeyvx2L2LNh6yJmjMLqzqGwNDXI/SgG6N3sUm4SYBkhRLupkUQ5fXMbzmJtmdo5I2i8D/5kzK0O1xakWtibpvRpFlJOu8nIhgmOqBnk4fEK8J0QrF7CyURP/zrI7f3iXhISORU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqQfJGVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqQfJGVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD61C116D0;
	Tue, 26 Aug 2025 13:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213769;
	bh=oZE20AVi6dYo7cG8Uv8BnwY/50X+W2N7FIFF+yhGybk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqQfJGVXmud7ACfY2J6+PI1jA8VwwEHJiZqdgLBwqWjosrFCTRJDuuKDM8qv+Vgp/
	 B8DdUheczkF8qkJMfprfIBiXg9h8WhNRFI6g6AYrnCixebSVAEyx3X3V7GpaB0fWyP
	 p58tpfMdirWaEt5Cpvu4R1euPeFBFN9eKhFfZMfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ingo Molnar <mingo@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.6 472/587] cpufreq: Use the fixed and coherent frequency for scaling capacity
Date: Tue, 26 Aug 2025 13:10:21 +0200
Message-ID: <20250826111004.980065583@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vincent Guittot <vincent.guittot@linaro.org>

commit 599457ba15403037b489fe536266a3d5f9efaed7 upstream.

cpuinfo.max_freq can change at runtime because of boost as an example. This
implies that the value could be different from the frequency that has been
used to compute the capacity of a CPU.

The new arch_scale_freq_ref() returns a fixed and coherent frequency
that can be used to compute the capacity for a given frequency.

[ Also fix a arch_set_freq_scale()  newline style wart in <linux/cpufreq.h>. ]

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/r/20231211104855.558096-3-vincent.guittot@linaro.org
Stable-dep-of: e37617c8e53a ("sched/fair: Fix frequency selection for non-invariant case")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    4 ++--
 include/linux/cpufreq.h   |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -454,7 +454,7 @@ void cpufreq_freq_transition_end(struct
 
 	arch_set_freq_scale(policy->related_cpus,
 			    policy->cur,
-			    policy->cpuinfo.max_freq);
+			    arch_scale_freq_ref(policy->cpu));
 
 	spin_lock(&policy->transition_lock);
 	policy->transition_ongoing = false;
@@ -2205,7 +2205,7 @@ unsigned int cpufreq_driver_fast_switch(
 
 	policy->cur = freq;
 	arch_set_freq_scale(policy->related_cpus, freq,
-			    policy->cpuinfo.max_freq);
+			    arch_scale_freq_ref(policy->cpu));
 	cpufreq_stats_record_transition(policy, freq);
 
 	if (trace_cpu_frequency_enabled()) {
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -1245,6 +1245,7 @@ void arch_set_freq_scale(const struct cp
 {
 }
 #endif
+
 /* the following are really really optional */
 extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
 extern struct freq_attr cpufreq_freq_attr_scaling_boost_freqs;


