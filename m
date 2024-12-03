Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB011AB6C9;
	Tue,  3 Dec 2024 15:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241320; cv=none; b=W6SKLlXNuFuWTyGAGUOl6RjbmTXMo1Sr83ZjBd3YXeIL9Yl9ISvznPgT1exWEk/Yv7JzIObmBQGFl08YUrMDjxAxKA/GPnC7KhE5p31eoDCr3Bql6JWnVHfEraP1qm7w+nJ5BX7/4Yln6MbsBz8AhYBanrejYO1dGQEVxhPCO8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241320; c=relaxed/simple;
	bh=VgJQxmdc/JjEVl4/+iJorIcHzFETFacC4M8Gm2DNjHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwMuRWJLSFKrh3wxxQ8xnUCXko4Vu3JrYdEtPU7+qRqq+DlxSdsRsQP7rmU2XBC42/xCaCj+gG+p/fV+r9+389fBg1uKNhYl+eUMdGFzywYVyRdXyVf+nnBaAoa3kA9BoCPaQ3kADLVuoxXnFUojq1MhwlfTWwQkHwMliLcRQF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mwca+NLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mwca+NLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DC6C4CED6;
	Tue,  3 Dec 2024 15:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241320;
	bh=VgJQxmdc/JjEVl4/+iJorIcHzFETFacC4M8Gm2DNjHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mwca+NLbOJZor+xUdAdGDu1QfWv+sV/GVIITemH8tEhgMPi0jwOjA1RKj1XzCzjSU
	 2TtRDa+1umbPFLEvqA9xn5tD70jGiaR6IzYce93gzFscjLhALF7uFVht0UzB+xGOo6
	 2twNtkXtVF7MWUK0VP0hhFdptHzdWRHHNcxX68/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 387/826] cpufreq: CPPC: Fix possible null-ptr-deref for cpufreq_cpu_get_raw()
Date: Tue,  3 Dec 2024 15:41:54 +0100
Message-ID: <20241203144758.858461469@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit a78e7207564258db6e373e86294a85f9d646d35a ]

cpufreq_cpu_get_raw() may return NULL if the cpu is not in
policy->cpus cpu mask and it will cause null pointer dereference.

Fixes: 740fcdc2c20e ("cpufreq: CPPC: Register EM based on efficiency class information")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 1a8f95e6cc8d0..c907638810057 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -423,6 +423,9 @@ static int cppc_get_cpu_power(struct device *cpu_dev,
 	struct cppc_cpudata *cpu_data;
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
+	if (!policy)
+		return 0;
+
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
 	max_cap = arch_scale_cpu_capacity(cpu_dev->id);
-- 
2.43.0



