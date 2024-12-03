Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0410A1F6698;
	Tue,  3 Dec 2024 15:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238932; cv=none; b=VqgfGqeUU2fyfefDgcFza/nppvVS4mnNEWlxf5CihXL8vduQ9gKIoPf8QyWu+cNopA1xHCm3TCTZfbdHRVN/Stpq9PCoBOX5ceIRZ8XOXiauhdvNGOvrhmBKhOiKCbyL1yLk5tZNtyHtRKF2EPt5ZIM9U2TDlpqNp1WF9DrxGYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238932; c=relaxed/simple;
	bh=n3sxS/TyUhaDqA3LumsV0AB2suyViPSf1N63y0t4Yps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjjRrdMiVub/iBXZzBAjKsCT/wrLBKfOEka/XJKXo6Gti7ZJDkqSmKfRgJcGvDuMCVKW6B6MMmtSDC4222aFL1ksrGCqcT/1sJQ6B/4Q7kcQvCjTbWA4gGsZFnlBgDrFysT4w3nP18CtSXFa4aTOXs9czchiFrlIB6z9hBjc9hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTOwlQwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTOwlQwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E58FC4CECF;
	Tue,  3 Dec 2024 15:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238931;
	bh=n3sxS/TyUhaDqA3LumsV0AB2suyViPSf1N63y0t4Yps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTOwlQwpwMmoiCHCTASGiRQW8NfFYbj6ZNSm0WjrlQLqSsNecXjrQ4DBh7cB9wA08
	 fm9yHeFJzaq0B5h3Aa+KPC1noESAI+Ru9KMQbyAL+VfgGTUI8HPJ+suM2a2Xeg1+Wq
	 sIWpscq4dOJMNy6t3B9vdhEu5pOSNAccN8/4E1vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 405/817] cpufreq: CPPC: Fix possible null-ptr-deref for cpufreq_cpu_get_raw()
Date: Tue,  3 Dec 2024 15:39:37 +0100
Message-ID: <20241203144011.683826190@linuxfoundation.org>
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
index 357dc7f4a98ce..32045075c596f 100644
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



