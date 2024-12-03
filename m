Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECDB1F7063;
	Tue,  3 Dec 2024 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241486; cv=none; b=X0eujFkN5Niw1lhmA0Vzhs1a04+tJzpdjtHcMEAPl1+o5mvT7aUb4kpQrqfvIcdtRjCjoRzw376KrPegdq14AwjdeKwdC5Ebgg9D/ixB+juAom/+qsDuCUuhKx9MZn3954O8v3xc+uIuwiUw3RU96nt44AFdAKZvfvOkecLO3j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241486; c=relaxed/simple;
	bh=FxxsVl6o8grV9NUz4A1MTaKlAa8Rg2GOtCfmAIjJedY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkCsHIuXKd2udqxRnN15AF39jCA4uyLRhxi2LNZR8EvSfbwMQGAlLgPVl0/d+qo0OPY5fXXwXot5DGqAnY9c/G6JfyjOvNejtMBIRVFFcbDoswEK8hURfPlLrNhmHT6nr/1LHbwQA6MOVpUy80zWqkRt9E6QeTeA3QqU9973C+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsPaFowK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsPaFowK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD7EC4CED8;
	Tue,  3 Dec 2024 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241486;
	bh=FxxsVl6o8grV9NUz4A1MTaKlAa8Rg2GOtCfmAIjJedY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsPaFowKO8wOSuDVjgGNUT+yLF7b295t9V281N1cRSPRKEbP/ElY/Oke8ne6dOIdl
	 62lMX/Mm4OikCRmcsOgeIrgKoR4gkIfI6R7b+IDvUabYtX9PssYOAKh69jv1+rBqv2
	 qR9CUw5vuadkIL1GXs/0nTAvaYRfIpjZXNTW8ySo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 431/826] cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_cost()
Date: Tue,  3 Dec 2024 15:42:38 +0100
Message-ID: <20241203144800.573865927@linuxfoundation.org>
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

[ Upstream commit be392aa80f1e5b0b65ccc2a540b9304fefcfe3d8 ]

cppc_get_cpu_cost() return 0 if the policy is NULL. Then in
em_compute_costs(), the later zero check for cost is not valid
as cost is uninitialized. As Quentin pointed out, kernel energy model
core check the return value of get_cost() first, so if the callback
failed it should tell the core. Return -EINVAL to fix it.

Fixes: 1a1374bb8c59 ("cpufreq: CPPC: Fix possible null-ptr-deref for cppc_get_cpu_cost()")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/c4765377-7830-44c2-84fa-706b6e304e10@stanley.mountain/
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Quentin Perret <qperret@google.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 975fb9fa23cac..2993b8a4c7f17 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -494,7 +494,7 @@ static int cppc_get_cpu_cost(struct device *cpu_dev, unsigned long KHz,
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
 	if (!policy)
-		return 0;
+		return -EINVAL;
 
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
-- 
2.43.0



