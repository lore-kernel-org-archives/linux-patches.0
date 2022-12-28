Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393521863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAF4C433EF;
	Wed, 28 Dec 2022 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238854;
	bh=o/63evzikijMXM82Yty6BXn3o60sRba2ZaN6y8PcAI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XecByGdmzUpGveaUi2Kq09TeMR0LXDzRRu+Efep4fHaZxS92mgyb6/7NkZzPFOAmT
	 XjdKmXbBTpxKSRWk5oVmSpgRG+tmg8IwjJ3vEJj4x13cyAwjve0AJoiA482NFUXqD0
	 zY0oo2+0wrlayj+97vQsoToggvG3tcqRuTL9peFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Punit Agrawal <punit.agrawal@bytedance.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/731] perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()
Date: Wed, 28 Dec 2022 15:32:22 +0100
Message-Id: <20221228144257.569287570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 226348822ab3..5933ad151f86 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -896,6 +896,8 @@ static struct platform_driver smmu_pmu_driver = {
 
 static int __init arm_smmu_pmu_init(void)
 {
+	int ret;
+
 	cpuhp_state_num = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
 						  "perf/arm/pmcg:online",
 						  NULL,
@@ -903,7 +905,11 @@ static int __init arm_smmu_pmu_init(void)
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



