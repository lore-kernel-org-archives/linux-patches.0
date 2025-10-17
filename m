Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B2E32C946;
	Fri, 17 Oct 2025 15:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714133; cv=none; b=oJQAk+M38WlE8GWfVzjuaAA6Tb8QSgRhczglEYgTWEgrltxbKhVRpmbuTmhaxACRCXd/WJTiYGMCAUIc4bhBRlX1IqrTWHpEt4gxqpgOXAigRXhPidZ9wKKRGoLit70TsxlJFSZCIGHGkSGnMCSerjOXSwiBXPdeBltDKeEXoC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714133; c=relaxed/simple;
	bh=yZqJuFpXp5MpyIyNHFmxUhzFKgc7WLglqAwOW0f2Z1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjuINW8GqU6fKeeqEER7kHOIUCynnzouVQa35YMagcr0hgkjZLtdt7eCNj1CZ6WZeMnRf5q0pzpg/0jVUA6Xr+P6zb+dHD6NFBthcN4L15wkSg2oFgyq4C3Mv6xkvk4jtS9kxqvWyr4pSUruanxc/kHdZIqimEiYPj8/98GvZFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7bphFsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7bphFsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70931C4CEE7;
	Fri, 17 Oct 2025 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714132;
	bh=yZqJuFpXp5MpyIyNHFmxUhzFKgc7WLglqAwOW0f2Z1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7bphFsqGY41SkhRFOk/8LQxcoEMgxaXAW669G+DU3CbIW9LTeU4zQ/qWWnpPW03j
	 NWg4bqvW1zspuzwDdouHVOlyYneZNmRvta1Es3YwbDAR5+GOVuq4V7EetRBkzS7jQv
	 9N4cLCH6hwPHFNJg9nIrXoYhGkxqwHlY1lbuPSkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/277] cpufreq: tegra186: Set target frequency for all cpus in policy
Date: Fri, 17 Oct 2025 16:50:46 +0200
Message-ID: <20251017145148.574561153@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7b8fcfa55038b..39186008afbfd 100644
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



