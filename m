Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9811321433;
	Tue, 26 Aug 2025 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213779; cv=none; b=ZWGFdrs+EGscqT9Lq8vzcwSSl/ndGGNdXzl9HlL0u/rLzoxeLUB65jFO2ZbxE/EGYphDPsP8AuQwUrftbF8Wt6evrXYoKztAtSfaKbLXngTtARBPGSiQ4EmQ2H502p18faTW17wLvRdbMBZhxVq/6KYIo5wJ06Kb6Yl0oUulsLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213779; c=relaxed/simple;
	bh=TbDluUIJhr3aKwhr9YZX8GB9i2IDDHt/Fl7JL1aem5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISpAN/+Rx32fMJuAPifqbJoPxRI44OmeOm6fczt4jm4ODh10ApCnSxgY2c9OhLdstSb9yiIt0r4Mq2w7NyT6gHWjX3E9Z8YxSlgdWGTD0gbiR+OWmXDKBVAQ7NGhAW0fJZ1hwIGgrheWkpIkmtzmIApkxl3MVO/qUQIfpXC9O2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VE+Gr29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VE+Gr29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C21DC4CEF1;
	Tue, 26 Aug 2025 13:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213777;
	bh=TbDluUIJhr3aKwhr9YZX8GB9i2IDDHt/Fl7JL1aem5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VE+Gr29piyoO6DMFiBE1x8d/aR/adTjuu4nbkkh7czD8Pe+4al4WQToyqF9zfmCp
	 yhxF/Qz3U4sfGo6SVM2V5UQlqnhKB5+0+69giBGSipb3fQ9SWSCzR6kFgF/MAzXugQ
	 2sCSH/7z9SDBy9EzLJR1QbdR0zpAVmoM+MqCCgbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ingo Molnar <mingo@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.6 474/587] energy_model: Use a fixed reference frequency
Date: Tue, 26 Aug 2025 13:10:23 +0200
Message-ID: <20250826111005.027259296@linuxfoundation.org>
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

commit 15cbbd1d317e07b4e5c6aca5d4c5579539a82784 upstream.

The last item of a performance domain is not always the performance point
that has been used to compute CPU's capacity. This can lead to different
target frequency compared with other part of the system like schedutil and
would result in wrong energy estimation.

A new arch_scale_freq_ref() is available to return a fixed and coherent
frequency reference that can be used when computing the CPU's frequency
for an level of utilization. Use this function to get this reference
frequency.

Energy model is never used without defining arch_scale_freq_ref() but
can be compiled. Define a default arch_scale_freq_ref() returning 0
in such case.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://lore.kernel.org/r/20231211104855.558096-5-vincent.guittot@linaro.org
Stable-dep-of: e37617c8e53a ("sched/fair: Fix frequency selection for non-invariant case")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/energy_model.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/energy_model.h
+++ b/include/linux/energy_model.h
@@ -224,7 +224,7 @@ static inline unsigned long em_cpu_energ
 				unsigned long max_util, unsigned long sum_util,
 				unsigned long allowed_cpu_cap)
 {
-	unsigned long freq, scale_cpu;
+	unsigned long freq, ref_freq, scale_cpu;
 	struct em_perf_state *ps;
 	int cpu;
 
@@ -241,10 +241,10 @@ static inline unsigned long em_cpu_energ
 	 */
 	cpu = cpumask_first(to_cpumask(pd->cpus));
 	scale_cpu = arch_scale_cpu_capacity(cpu);
-	ps = &pd->table[pd->nr_perf_states - 1];
+	ref_freq = arch_scale_freq_ref(cpu);
 
 	max_util = min(max_util, allowed_cpu_cap);
-	freq = map_util_freq(max_util, ps->frequency, scale_cpu);
+	freq = map_util_freq(max_util, ref_freq, scale_cpu);
 
 	/*
 	 * Find the lowest performance state of the Energy Model above the


