Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813301F7540;
	Tue,  3 Dec 2024 15:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238943; cv=none; b=NTjxEmtwvTAEX28exL2gXdsqjad89BkQwfe/neIaVS00CIn2NFNF16zPZd1eIO2/pmBA3JrKuVWjxN+qryuasBD+JItps0MJS7soqr9Zv5Xe6X4w1WsQfxfpo1YpR0OLMQRLnWRUt0qUmnfvB7okyphfMzywIfUojjNK2/NmkW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238943; c=relaxed/simple;
	bh=fk6jsLARIqqzRIm5t2MHnUYwaiFu4Lage6LNTwHG984=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQ4GWK8+3Rxh9171oqpd35URlbBtHyCiOy4RhtkfmFwZ+M34pRgmFqRlpCXvRwb9/y/g1CxYZDtdrJ0X94pvsCR8X99+kNDvoTl9XmsexfhnGIP7w/B++jXlP+deGotSLc5zs3FlsJ6oVYaB9fEfOTHqo4a3biZPHoLE11JNqV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FciLxn9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FciLxn9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1095C4CECF;
	Tue,  3 Dec 2024 15:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238943;
	bh=fk6jsLARIqqzRIm5t2MHnUYwaiFu4Lage6LNTwHG984=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FciLxn9oGIEY9egz68dRJNz+ZklE9cnlhe84b0pJv41pLDl+PfQ/iCiWFUB4CD+nr
	 EV1cMzwKrpt1LoXX310hs7S04oJ0SFYgrt3xkjn3dRx9svW00G2qgiQju0RhDFJdI8
	 KiMFTjqxB0O3Sg32QsCXYR9JfkxWceRbu7r+8v+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 451/817] cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_cost()
Date: Tue,  3 Dec 2024 15:40:23 +0100
Message-ID: <20241203144013.480714450@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 00556b4d83f83..27508b396846e 100644
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



