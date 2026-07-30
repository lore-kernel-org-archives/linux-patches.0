Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56E343F0B5;
	Thu, 30 Jul 2026 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423585; cv=none; b=esR/TTBvIC8Pn5l4EPKI8/pU/cRzLybmpo1pj7CnS9z6Y/FG8qd+MYqnu4NcwZH7HQGuldWv5fQaVIw9aa0DzbwQ6Ivjclit8sayKmiM3d3gPvGeAhfnAXqXoy2ZEqo6AEc05zSGFI+UEho9V3sWTVX3BlRRWYjXLdSqVSIbmig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423585; c=relaxed/simple;
	bh=8KdDULMqm82FMM3g92uhBOVF1gmwIKt5JrPKWRPw3Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HF3RYOID/TCEJOh7HGlP0PNc3ZSErziRuPZMrMKjjYzOVfFfQUoc8Kow0cYYHY/U2LtWkBmUpQ+tSf0qbLO1vsybUu8KkGqIHexX4tF7LCPrXjZJNT3jR01KRRSsCZQxbURgAFeIdN1okE9eXr3QLfJ0FEOVwF0uJ3Cid1TA2hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+6y7lYB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+6y7lYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1771F000E9;
	Thu, 30 Jul 2026 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423583;
	bh=ocTw3KbrtbCy4liVNIfu0BiKV81uLgflRAnEoO/C24A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+6y7lYBhoikFLxEDRkh59gI+USjgg5YwxP7bww4X7Hea/rt1wntXF6BoIMUshxwu
	 uSyZpRaCvbFdnvAeGyVMRPYeg+uu/zs66ychVkPrJEBeMIvMufNfRNoXy3x/SEj3Tv
	 s5KjLjVMlqDace1zpYSzGZd0Er5UFw07EEdvHwfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 6.18 095/675] cpufreq: Make cpufreq_update_pressure() fall back to cpuinfo.max_freq
Date: Thu, 30 Jul 2026 16:07:05 +0200
Message-ID: <20260730141447.148676690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit d2d5c129d07ea8eb91cd8a8633b5774116c4d171 ]

If arch_scale_freq_ref() is not defined for a given arch (like x86, for
example), cpufreq_update_pressure() will always set cpufreq_pressure to
zero for all CPUs in the system, which is generally problematic on
systems with asymmetric capacity [1].

However, in the absence of arch_scale_freq_ref(), it is reasonable
to assume that cpuinfo.max_freq is the maximum sustainable frequency
for the given cpufreq policy.  Moreover, there are cases in which
arch_scale_freq_ref() would need to be defined to return essentially
the cpuinfo.max_freq value anyway (for example, intel_pstate on
hybrid platforms).

For the above reasons, update cpufreq_update_pressure() to fall back to
using cpuinfo.max_freq as the reference frequency if zero is returned by
arch_scale_freq_ref().

Fixes: 75d659317bb1 ("cpufreq: Add a cpufreq pressure feedback for the scheduler")
Link: https://lore.kernel.org/lkml/CAKfTPtBuRLfYNnR4w--cFZYZy-R8gaPEgVwCcaMmbCcJ2H-muQ@mail.gmail.com/ [1]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Tested-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com> # cluster scheduling
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://patch.msgid.link/5086499.GXAFRqVoOG@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a70df77f9b7d11..ced96d9e254ee4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2584,6 +2584,9 @@ static void cpufreq_update_pressure(struct cpufreq_policy *policy)
 
 	cpu = cpumask_first(policy->related_cpus);
 	max_freq = arch_scale_freq_ref(cpu);
+	if (!max_freq)
+		max_freq = policy->cpuinfo.max_freq;
+
 	capped_freq = policy->max;
 
 	/*
-- 
2.53.0



