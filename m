Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C752236EA;
	Thu, 12 Dec 2024 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019500; cv=none; b=i8Y0mhXeL+GRzjPTjAn3+2HPMWKNBatTyjWoGm3E7zNcVIPF7Nhrgft970zsMIeZcH29Q7v5Vc6585p/+BaiTW9mxrRA07Kvgbiwk/UvV8xlv3/jeTkO+D4sugBIWY/SJ+rgw/rg9eOfvOunYJ8AmbDuYGxvRsVcTruk/Bsurw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019500; c=relaxed/simple;
	bh=HligZ3IuhUORdvBBBR4xa1HSkaYDftftCM+Xo1aZwSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+UisCAS4/Z5mRWK3NPIr+cqbe+lTflh9uvQh7KsnxJ0efCP5puk1ucFbo2NEG/RGLofh32nJ9y5izi4QWgkdS5URTqR0YmqBL7KYcmhcjlhCSHHOggtj4u2nH0Q4sapi/M8lBZdx5hNdZNOtYq2pTdTE1wq6EWmZkg13hqNhao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vtzcsv31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vtzcsv31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E56C4CECE;
	Thu, 12 Dec 2024 16:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019499;
	bh=HligZ3IuhUORdvBBBR4xa1HSkaYDftftCM+Xo1aZwSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vtzcsv31XP566HjHgTzZQVyA3A5Zf+rSgsGK3xhDnlS5Y19pZM08uArgXYo4SOFrJ
	 X1Rr18v8g7qi+VDAtOkT9NIeFvdnvrpNjT1lVuX2SPrRnaBozunlABrSYC2sNbBKQZ
	 plErM/zyJ9bK3tExeQAu5ddhpMjTyekYCANFB2eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 222/772] cpufreq: CPPC: Fix possible null-ptr-deref for cppc_get_cpu_cost()
Date: Thu, 12 Dec 2024 15:52:47 +0100
Message-ID: <20241212144359.083376859@linuxfoundation.org>
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

[ Upstream commit 1a1374bb8c5926674973d849feed500bc61ad535 ]

cpufreq_cpu_get_raw() may return NULL if the cpu is not in
policy->cpus cpu mask and it will cause null pointer dereference,
so check NULL for cppc_get_cpu_cost().

Fixes: 740fcdc2c20e ("cpufreq: CPPC: Register EM based on efficiency class information")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index d8c8363167a78..0a2c21d5bc1c8 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -492,6 +492,9 @@ static int cppc_get_cpu_cost(struct device *cpu_dev, unsigned long KHz,
 	int step;
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
+	if (!policy)
+		return 0;
+
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
 	max_cap = arch_scale_cpu_capacity(cpu_dev->id);
-- 
2.43.0



