Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8F241AB8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sp36/+oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1774C433CC;
	Wed, 15 Nov 2023 19:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076955;
	bh=U10DjcbL2XGDJO7vCSTVmMaMcjZr0AqwDvh10vHydKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sp36/+oClv/JoYbweTG5Qw2lZlIfs43LC5n0Mhct/v1toLoooQaa72Sfhst8uKzJu
	 FUYG0PtOOww4+1KwGamTVljM6Jozg5IfxlBE6b4CGFgo+XbxRBjJXU99tRFVRZ9dNb
	 AoSwLTRr52eoxdSQmBAtmWoNf1r3OwDPKrIrNqH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/603] cpufreq: tegra194: fix warning due to missing opp_put
Date: Wed, 15 Nov 2023 14:10:23 -0500
Message-ID: <20231115191618.520069104@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 88ef5e57ccd05..386aed3637b4e 100644
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



