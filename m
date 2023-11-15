Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF213BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSRLB5Bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F61EC433CA;
	Wed, 15 Nov 2023 19:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076106;
	bh=011f/oP2k/fP6R16qC72XpWVAANsjfMq5JJ2tsLLG1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSRLB5Bwyzca5vgAXA+ioTxAmQ/tEgcKeF5rzP1grMjC7rAwNjTbfAtUU5Ya6WZQB
	 gO2XEijFmW3yTu9Xi24g4ZiGTDX2UnEsEkA9w7jMRUxaY+gPI7riDpQi28ZHNom/Me
	 pj4kHNKPvjqCBqZGDOszZQI9DAqjPdzXdmsjiZkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 080/550] cpufreq: tegra194: fix warning due to missing opp_put
Date: Wed, 15 Nov 2023 14:11:04 -0500
Message-ID: <20231115191606.244190290@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit bae8222a6c291dbe58c908dab5c2abd3a75d0d63 ]

Fix the warning due to missing dev_pm_opp_put() call and hence
wrong refcount value. This causes below warning message when
trying to remove the module.

 Call trace:
  dev_pm_opp_put_opp_table+0x154/0x15c
  dev_pm_opp_remove_table+0x34/0xa0
  _dev_pm_opp_cpumask_remove_table+0x7c/0xbc
  dev_pm_opp_of_cpumask_remove_table+0x10/0x18
  tegra194_cpufreq_exit+0x24/0x34 [tegra194_cpufreq]
  cpufreq_remove_dev+0xa8/0xf8
  subsys_interface_unregister+0x90/0xe8
  cpufreq_unregister_driver+0x54/0x9c
  tegra194_cpufreq_remove+0x18/0x2c [tegra194_cpufreq]
  platform_remove+0x24/0x74
  device_remove+0x48/0x78
  device_release_driver_internal+0xc8/0x160
  driver_detach+0x4c/0x90
  bus_remove_driver+0x68/0xb8
  driver_unregister+0x2c/0x58
  platform_driver_unregister+0x10/0x18
  tegra194_ccplex_driver_exit+0x14/0x1e0 [tegra194_cpufreq]
  __arm64_sys_delete_module+0x184/0x270

Fixes: f41e1442ac5b ("cpufreq: tegra194: add OPP support and set bandwidth")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
[ Viresh: Add a blank line ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/tegra194-cpufreq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/tegra194-cpufreq.c b/drivers/cpufreq/tegra194-cpufreq.c
index 75f1e611d0aab..f7b193b195dc9 100644
--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -450,6 +450,8 @@ static int tegra_cpufreq_init_cpufreq_table(struct cpufreq_policy *policy,
 		if (IS_ERR(opp))
 			continue;
 
+		dev_pm_opp_put(opp);
+
 		ret = dev_pm_opp_enable(cpu_dev, pos->frequency * KHZ);
 		if (ret < 0)
 			return ret;
-- 
2.42.0



