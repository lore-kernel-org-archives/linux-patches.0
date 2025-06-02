Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966DF22259B;
	Mon,  2 Jun 2025 14:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873401; cv=none; b=Y2ZG0UgejHANnOmRU2mLCEIsm72+rZJoXfjPDkSFC05QHiWsCVyXbcBJbvJ9HyrUbOpMKoG3ReIKDgegbUmS163ImXlEtVf7rS4sP5T5WrUG+73/VLujDPrvic7FtItmrhM/j3dCxen9Qu+n3NglTBy037DJDVRTAAh02rrXd+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873401; c=relaxed/simple;
	bh=j2ucnx1lgeGnt2WSJcUUDhM3D+CF6MYDGWuyEd9LP9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgoJVGRhkI3KdJdEAiy/QUH9RiauTa7bfWAQ5QQAVkgn26O9L8LQKsIh+WCvwgBALMTsSxKMmWQGM8iLhDo308yPUT0xpXBqgvwxOvkCUBSGnm69go0VxqD9sEPHian7tnZ60cxqXVQz5XfhT3rGMHqkMzpqK+wqxA6cWJTq5B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoyemyDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoyemyDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF85C4CEEB;
	Mon,  2 Jun 2025 14:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873401;
	bh=j2ucnx1lgeGnt2WSJcUUDhM3D+CF6MYDGWuyEd9LP9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoyemyDcB5S+DYTLRvAkAWZyv4zz/WJ/v0VfuZYhAt5smnlyjp3sU+D/2+VASAR/v
	 5vfgsTb+DKOriG3vFIPc+UvSwlkfNVl427XuhxFUfUHAem7mGLrZfWbnv3JQ8r9b5n
	 I6Eu8lJ2YPjV0A0qie4lrwu5XTKbbgAxDfTzHlGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/444] cpufreq: tegra186: Share policy per cluster
Date: Mon,  2 Jun 2025 15:43:13 +0200
Message-ID: <20250602134346.122801563@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <luceoscutum@gmail.com>

[ Upstream commit be4ae8c19492cd6d5de61ccb34ffb3f5ede5eec8 ]

This functionally brings tegra186 in line with tegra210 and tegra194,
sharing a cpufreq policy between all cores in a cluster.

Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/tegra186-cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/tegra186-cpufreq.c b/drivers/cpufreq/tegra186-cpufreq.c
index 7b8fcfa55038b..4e5b6f9a56d1b 100644
--- a/drivers/cpufreq/tegra186-cpufreq.c
+++ b/drivers/cpufreq/tegra186-cpufreq.c
@@ -73,11 +73,18 @@ static int tegra186_cpufreq_init(struct cpufreq_policy *policy)
 {
 	struct tegra186_cpufreq_data *data = cpufreq_get_driver_data();
 	unsigned int cluster = data->cpus[policy->cpu].bpmp_cluster_id;
+	u32 cpu;
 
 	policy->freq_table = data->clusters[cluster].table;
 	policy->cpuinfo.transition_latency = 300 * 1000;
 	policy->driver_data = NULL;
 
+	/* set same policy for all cpus in a cluster */
+	for (cpu = 0; cpu < ARRAY_SIZE(tegra186_cpus); cpu++) {
+		if (data->cpus[cpu].bpmp_cluster_id == cluster)
+			cpumask_set_cpu(cpu, policy->cpus);
+	}
+
 	return 0;
 }
 
-- 
2.39.5



