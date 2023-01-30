Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B4F28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8CAC433EF;
	Mon, 30 Jan 2023 14:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087251;
	bh=brPNg4hXs3Yuj/UKNSzP5rYxjn1E9VnP1uYNFwKVvKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3Kk89lJTwTaHlrLR5mouff4z5vBYjQYjFi2a7EvoxN5KsdLtl8VsA7g6EwwlIn6Q
	 Cgvo1yEZI6oTol2CVbhgCAkHIBUkWR5GtEN6amVCGqmkaTEkYwBIhA7oSkdnZuIt3d
	 Rsz0EIQRQlMpuKIm+FGoApw1bq/W4nIirXDl1b8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/313] cpufreq: CPPC: Add u64 casts to avoid overflowing
Date: Mon, 30 Jan 2023 14:49:42 +0100
Message-Id: <20230130134343.504125346@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre Gondois <pierre.gondois@arm.com>

[ Upstream commit f5f94b9c8b805d87ff185caf9779c3a4d07819e3 ]

The fields of the _CPC object are unsigned 32-bits values.
To avoid overflows while using _CPC's values, add 'u64' casts.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 432dfb4e8027..022e3555407c 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -487,7 +487,8 @@ static unsigned int get_perf_level_count(struct cpufreq_policy *policy)
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
 	max_cap = arch_scale_cpu_capacity(cpu);
-	min_cap = div_u64(max_cap * perf_caps->lowest_perf, perf_caps->highest_perf);
+	min_cap = div_u64((u64)max_cap * perf_caps->lowest_perf,
+			  perf_caps->highest_perf);
 	if ((min_cap == 0) || (max_cap < min_cap))
 		return 0;
 	return 1 + max_cap / CPPC_EM_CAP_STEP - min_cap / CPPC_EM_CAP_STEP;
@@ -519,10 +520,10 @@ static int cppc_get_cpu_power(struct device *cpu_dev,
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
 	max_cap = arch_scale_cpu_capacity(cpu_dev->id);
-	min_cap = div_u64(max_cap * perf_caps->lowest_perf,
-			perf_caps->highest_perf);
-
-	perf_step = CPPC_EM_CAP_STEP * perf_caps->highest_perf / max_cap;
+	min_cap = div_u64((u64)max_cap * perf_caps->lowest_perf,
+			  perf_caps->highest_perf);
+	perf_step = div_u64((u64)CPPC_EM_CAP_STEP * perf_caps->highest_perf,
+			    max_cap);
 	min_step = min_cap / CPPC_EM_CAP_STEP;
 	max_step = max_cap / CPPC_EM_CAP_STEP;
 
-- 
2.39.0



