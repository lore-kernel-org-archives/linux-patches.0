Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76411863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD97C433EF;
	Wed, 28 Dec 2022 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239608;
	bh=9r4fFwVoGBI/fvrBhj1o+J5lS3aanaQFi+cPjeG3BGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MX3InsrvY+A7SJAiD/IUTSZL+kkDV6GxdmbJD6jAo/uxHszNSEH1IOB5eUZqnXrE/
	 Ag1KG2e18M8pm016G0HAuter7e/1Sb5lxXEHQN07aLDjTenBXxVcKjKBMuo8sOcBnv
	 hDNqjwaq8SBZ7zzuD1e4J880jc/mjW2iw3ba+rt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Punit Agrawal <punit.agrawal@bytedance.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0055/1073] perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()
Date: Wed, 28 Dec 2022 15:27:23 +0100
Message-Id: <20221228144329.599651407@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 6f2d566b46436a50a80d6445e82879686b89588c ]

arm_smmu_pmu_init() won't remove the callback added by
cpuhp_setup_state_multi() when platform_driver_register() failed. Remove
the callback by cpuhp_remove_multi_state() in fail path.

Similar to the handling of arm_ccn_init() in commit 26242b330093 ("bus:
arm-ccn: Prevent hotplug callback leak")

Fixes: 7d839b4b9e00 ("perf/smmuv3: Add arm64 smmuv3 pmu driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Punit Agrawal <punit.agrawal@bytedance.com>
Link: https://lore.kernel.org/r/20221115115540.6245-3-shangxiaojing@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_smmuv3_pmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
index 00d4c45a8017..25a269d431e4 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -959,6 +959,8 @@ static struct platform_driver smmu_pmu_driver = {
 
 static int __init arm_smmu_pmu_init(void)
 {
+	int ret;
+
 	cpuhp_state_num = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
 						  "perf/arm/pmcg:online",
 						  NULL,
@@ -966,7 +968,11 @@ static int __init arm_smmu_pmu_init(void)
 	if (cpuhp_state_num < 0)
 		return cpuhp_state_num;
 
-	return platform_driver_register(&smmu_pmu_driver);
+	ret = platform_driver_register(&smmu_pmu_driver);
+	if (ret)
+		cpuhp_remove_multi_state(cpuhp_state_num);
+
+	return ret;
 }
 module_init(arm_smmu_pmu_init);
 
-- 
2.35.1



