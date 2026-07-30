Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46079432E6E;
	Thu, 30 Jul 2026 14:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421520; cv=none; b=WqFW/dJwYZ7ckk0WJnjBZ3WPdpQfY1diyf2r+muoh11mr2JVNtG98FcX2tZnVro5+/CcDXmQ1VVqPMSd7xJNUTivLLZL/W9qOWkyfnQBnIC47ufKpJvBnm/W3LMfk6h6UYIHWpu6Z4xKf3JsYEHRO74s0C+zhz60KGq5wNDUEG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421520; c=relaxed/simple;
	bh=0c3YYZQ9+EbNO4bJ5STd0qhyJsmS0I6N1DZ99rhsJHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcvChN9WsBl60hN/RDvke6hxBbUqUFDNpmkI3MsOLfVzPE9q/Jqj9QTYLT0fEWNgqB3KXcemLuB/k7ddFVA+8v5m5Ec2/324w+vGXEWVMsVJB6CGEjA5oOA0HZk08ZPBqeCTiNg9S+/NUZUrRNYsggZiprsVCGRhK5TmoWYpiMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2v4Piv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2v4Piv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7981F000E9;
	Thu, 30 Jul 2026 14:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421518;
	bh=EZwGN339dlYfFL5hRfpsO405ArMHM96+a9jrKfjQYvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N2v4Piv5/u7mRMLJ6lnmpFtvhl1jM++KW6K3lquCa+uo/u9aEfcQV3auXy1TDNF9r
	 SvHNS9zOCTpYbGBqc73w6mxz2FKv6NFuxvC59RhULrBmBwUHrsdmfDCz1Rm/PeLxB8
	 jkBKCrmcGtlW0oGHUOg37qBZtCg1/pjhsy/oE8jE=
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
Subject: [PATCH 7.1 086/744] cpufreq: Make cpufreq_update_pressure() fall back to cpuinfo.max_freq
Date: Thu, 30 Jul 2026 16:05:59 +0200
Message-ID: <20260730141446.095665110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
index d41067cd1f1b25..2debe39fc477be 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2583,6 +2583,9 @@ static void cpufreq_update_pressure(struct cpufreq_policy *policy)
 
 	cpu = cpumask_first(policy->related_cpus);
 	max_freq = arch_scale_freq_ref(cpu);
+	if (!max_freq)
+		max_freq = policy->cpuinfo.max_freq;
+
 	capped_freq = policy->max;
 
 	/*
-- 
2.53.0



