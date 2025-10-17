Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCF23370F6;
	Fri, 17 Oct 2025 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713126; cv=none; b=DQoM15ol42yg3HNsXEAL9oZrVGzISnrypzjB5yc+nGIEP4e26d75PbUvxb+AHbM+mbFto02HJON/+usCv4kt1jGybf7xDOoJkTvS/OS+lxy4YdvE+CTtqA4J2YqCqqUiGdlk1IPyuSCoxOJ0gpfKe3wJ6iTAKFEwP7qUY+UbzS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713126; c=relaxed/simple;
	bh=iOha8GcYN2egPeVP3WATPPY4zR2XRW4eVnxE3P4eNv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diH+1clUDfvqO2ww3qFVY06NU3IOsv3xm3037/Vm0+lUmgHtcq+FjL960kEBeeN3HlTncGfCmmuMk2vWWdFggZWCNImlQrsg+91cnovGO7YsaIstFg71iuf6NN+fG215sWHQkBFb3e0Z0mIbxXU1c0guU1hJbqUa1v1NoHD6qX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/0CBYjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/0CBYjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605CFC4CEE7;
	Fri, 17 Oct 2025 14:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713125;
	bh=iOha8GcYN2egPeVP3WATPPY4zR2XRW4eVnxE3P4eNv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/0CBYjLiGtXloUGCu5pfNs0InLhWjBCH1Gg1u+Tr6fiFgc7sYtpcRW7y3lLiDRoz
	 wurrv9U2+RRlasCH0x8ScMeWb6/OcN2Zbfo4LqoxSPYBeUNd/bYdMNkg558i/3Ub4Q
	 BkNLixH3bMmLqFxqwChTQC3sYx2yM3mAMeJ1YKdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/168] cpufreq: tegra186: Set target frequency for all cpus in policy
Date: Fri, 17 Oct 2025 16:51:42 +0200
Message-ID: <20251017145129.873301416@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6c88827f4e625..ee57676bbee14 100644
--- a/drivers/cpufreq/tegra186-cpufreq.c
+++ b/drivers/cpufreq/tegra186-cpufreq.c
@@ -86,10 +86,14 @@ static int tegra186_cpufreq_set_target(struct cpufreq_policy *policy,
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



