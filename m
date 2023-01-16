Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364EA6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE11BC433EF;
	Mon, 16 Jan 2023 16:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887117;
	bh=06yKw/v3JO85P5VVB5xSu9jWPv7fIvnmmkEgBNFiGf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZB29Xe5w3hMHfASHGKe0qrmV3a8i1g1ElRUitoDDfWrMIw/6BEoulNNPDL8Im2ev
	 EjO2Yho+R2zOO8VuPvP66L3KPFVWrNLLPFIzirTdDCu87vdczGeGSgWCm6pF4B6De7
	 9PYG/sTwpviZUpAOH+PV9koe8+si6qy+4a3VhamA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/521] perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()
Date: Mon, 16 Jan 2023 16:44:49 +0100
Message-Id: <20230116154848.522214291@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit facafab7611f7b872c6b9eeaff53461ef11f482e ]

dsu_pmu_init() won't remove the callback added by cpuhp_setup_state_multi()
when platform_driver_register() failed. Remove the callback by
cpuhp_remove_multi_state() in fail path.

Similar to the handling of arm_ccn_init() in commit 26242b330093 ("bus:
arm-ccn: Prevent hotplug callback leak")

Fixes: 7520fa99246d ("perf: ARM DynamIQ Shared Unit PMU support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20221115070207.32634-2-yuancan@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_dsu_pmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_dsu_pmu.c b/drivers/perf/arm_dsu_pmu.c
index 660cb8ac886a..961533ba33e7 100644
--- a/drivers/perf/arm_dsu_pmu.c
+++ b/drivers/perf/arm_dsu_pmu.c
@@ -823,7 +823,11 @@ static int __init dsu_pmu_init(void)
 	if (ret < 0)
 		return ret;
 	dsu_pmu_cpuhp_state = ret;
-	return platform_driver_register(&dsu_pmu_driver);
+	ret = platform_driver_register(&dsu_pmu_driver);
+	if (ret)
+		cpuhp_remove_multi_state(dsu_pmu_cpuhp_state);
+
+	return ret;
 }
 
 static void __exit dsu_pmu_exit(void)
-- 
2.35.1



