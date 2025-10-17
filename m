Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5766932C929;
	Fri, 17 Oct 2025 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715010; cv=none; b=PVA04uiqeNIFjHLPL9m042+Wyrw9K6J26bEcOoKcgT6qSUdnTAHKT/Hun7zmYeKefhRgsKA7MxcWcYAaKF7mFkdOAkADeskg3/4BIdo6nL5YHiyIO15yg2iWhB+VmN5I1bL8m+cugA9tutjDd5mNR98enUOn8DpeE2yvZ5hIl3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715010; c=relaxed/simple;
	bh=+Lmg8IxSprLhdGzdG+BecBuWLqzJXhFOUaIHLsGadRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bs6XVLHhz3gEqQIf+2g86gEO87YLq6rVG0XH9vgNeNhbPQCXOf6LiDiw0puGDaXy34eOaGxW8+1LGgN3esxH0x9qJBXQwPrlkzHg6HZHnjsH+6kRFPw4ir/Kkp8pEXcOE7EvRyy1ZJrax5KusuAsBBPDXVn80H0/t2OSR215bro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKG3XvPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKG3XvPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D501DC4CEE7;
	Fri, 17 Oct 2025 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715010;
	bh=+Lmg8IxSprLhdGzdG+BecBuWLqzJXhFOUaIHLsGadRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKG3XvPEpVNkpmDrCt+SEf8RqrT/B2CosQLqxYx4FDEdZbK1jtG9RfwrI7Y28T6Lo
	 c86J8A9i5CqFDi8qDhrn8LeUrTZK9x620L91u+MXYEFAUw5L7bAsGtB2/RIU4gn+il
	 O5iuZY86M7wWKGmT0TYh9P0zF6NrOA0cPui5xc5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 067/371] cpufreq: tegra186: Set target frequency for all cpus in policy
Date: Fri, 17 Oct 2025 16:50:42 +0200
Message-ID: <20251017145204.359294573@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 0b1bb980fd7cae126ee3d59f817068a13e321b07 ]

The original commit set all cores in a cluster to a shared policy, but
did not update set_target to apply a frequency change to all cores for
the policy. This caused most cores to remain stuck at their boot
frequency.

Fixes: be4ae8c19492 ("cpufreq: tegra186: Share policy per cluster")
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/tegra186-cpufreq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/tegra186-cpufreq.c b/drivers/cpufreq/tegra186-cpufreq.c
index cbabb726c6645..6c394b429b618 100644
--- a/drivers/cpufreq/tegra186-cpufreq.c
+++ b/drivers/cpufreq/tegra186-cpufreq.c
@@ -93,10 +93,14 @@ static int tegra186_cpufreq_set_target(struct cpufreq_policy *policy,
 {
 	struct tegra186_cpufreq_data *data = cpufreq_get_driver_data();
 	struct cpufreq_frequency_table *tbl = policy->freq_table + index;
-	unsigned int edvd_offset = data->cpus[policy->cpu].edvd_offset;
+	unsigned int edvd_offset;
 	u32 edvd_val = tbl->driver_data;
+	u32 cpu;
 
-	writel(edvd_val, data->regs + edvd_offset);
+	for_each_cpu(cpu, policy->cpus) {
+		edvd_offset = data->cpus[cpu].edvd_offset;
+		writel(edvd_val, data->regs + edvd_offset);
+	}
 
 	return 0;
 }
-- 
2.51.0



