Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B63A223C46;
	Thu, 12 Dec 2024 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019496; cv=none; b=hu2hT8pVG5Uv7D4miAIykgufbf4pxHysxv8YegPZ9EM4MyAZS9xjVIG1sb9ziSnfu5QtGLI0aPKkOnQUzqZ9AS48kin+2Q5580F8oaA6sj4FvV0SmJCFgPyHr3XInYzMqtz+WGADpDyoUG+2PCnUP571ihcVhIwfdytezzSp7ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019496; c=relaxed/simple;
	bh=mjcOYat/BMAwyAWD+OqKB6xlIUBW19WuOI4uukbqX/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVuonPyDoEel0KnbZ5TpyFP/IYSRKakB8V/TlmnczUigi3xM1n8/9sz9p+4+xt29EE6XMGhewVYVWht56PltnC79f1l4Dc1jHcFgAicOZ2iG0iF8hnDDc7ZpMRhmmZPO3gluYpVEwN+vunWTVCehp20HWFh0vGbhM57xQNh59hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFm0raOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFm0raOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69ECC4CECE;
	Thu, 12 Dec 2024 16:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019496;
	bh=mjcOYat/BMAwyAWD+OqKB6xlIUBW19WuOI4uukbqX/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFm0raOb3IuldKEQGhjVeVoeHXs8+ufp4jBMk2m7b+swMYtv1EMRwNeSNZrXXSfbE
	 IgoG3FNEIMybHfkUITDpUSc1w40rgc/M7S2psuMtTcQoeqJYrnFciuU3Sp6DhbVKlg
	 WyOR6Dndwu/Nr2o+bs3a/oxJ1JW9gTG+8LFKk4Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 221/772] cpufreq: CPPC: Fix possible null-ptr-deref for cpufreq_cpu_get_raw()
Date: Thu, 12 Dec 2024 15:52:46 +0100
Message-ID: <20241212144359.044862012@linuxfoundation.org>
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
index 0050242d382e7..d8c8363167a78 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -422,6 +422,9 @@ static int cppc_get_cpu_power(struct device *cpu_dev,
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



