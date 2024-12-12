Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1575B1F8ACC;
	Thu, 12 Dec 2024 16:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019587; cv=none; b=fAT8zr5OzHHel6OvAgij4YZS3Z2m0uhNaLsfZYe4OGSANV3bezacpQLy5ehkWqn7EFZP0HhsZAJJSv6MuXTXaveETribOs736YghwkDUxrIo6ucgGD2Jd7vplciEEo8i05y6/6iOFgslsjjd2qbdBHtFpoa3oCRX5GMQrqO18io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019587; c=relaxed/simple;
	bh=bqI6g9/uoOklpGOMUTdK5lXD3I32zot+N85C8fKL1hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFyX0eboaj2UyHhPGCL1WdF89e6xpqHP5jJ90J8mFs8b0JM8EiJH4QBPrDOlW5CHAOFHdD7rHFszHm9V5b9QwmBdgwn+6LIQu2qjaOYb6H+7mAKYXIkGVw6QVo7xDpWaq+ymGfZnzUgVxfJu9UWsynxA+7rnULijLS37GRgXdhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnG6EHcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnG6EHcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1E7C4CECE;
	Thu, 12 Dec 2024 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019586;
	bh=bqI6g9/uoOklpGOMUTdK5lXD3I32zot+N85C8fKL1hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnG6EHclIzYfSXg24wGcL1lSpUBEhzwGpTUGrCUQ0dLY9anEp9RVXAoq6wENBHUeh
	 asL9Z/qqU7CwZrnbjmSjBBivN6jcRm0Cch2wj8c03DdB+Zg+HBp0+ubMxdMRvIKW4X
	 QXzROh0TzHUwmQ0tCnbSqj77Z0ufzxY3iby15glc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 245/772] cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_cost()
Date: Thu, 12 Dec 2024 15:53:10 +0100
Message-ID: <20241212144400.034132933@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0a2c21d5bc1c8..fd02702de504c 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -493,7 +493,7 @@ static int cppc_get_cpu_cost(struct device *cpu_dev, unsigned long KHz,
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
 	if (!policy)
-		return 0;
+		return -EINVAL;
 
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
-- 
2.43.0



