Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5841863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5CAC433D2;
	Wed, 28 Dec 2022 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239587;
	bh=yXaZLheoiO4PxKdoSQgLF1jcKV5ev5XwmmUT8LYPM/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALnkcTTeQDu9y3CZc8Ht2RILhOJxKi18H98WRryWCYDHexxf01Z/xxNKqgyuFghFG
	 j7oDUd3TuPQmJh1Pc+/Fjw/blCTA97wfwORTSqtO3wX8ygG80hYpGnVFnldkMpq2PM
	 TGgWHLwY2olUTsfFslkvndpB2VvxWG3B/DItpZl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0053/1073] drivers: perf: marvell_cn10k: Fix hotplug callback leak in tad_pmu_init()
Date: Wed, 28 Dec 2022 15:27:21 +0100
Message-Id: <20221228144329.549663710@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 973ae93d80d9d262f695eb485a1902b74c4b9098 ]

tad_pmu_init() won't remove the callback added by cpuhp_setup_state_multi()
when platform_driver_register() failed. Remove the callback by
cpuhp_remove_multi_state() in fail path.

Similar to the handling of arm_ccn_init() in commit 26242b330093 ("bus:
arm-ccn: Prevent hotplug callback leak")

Fixes: 036a7584bede ("drivers: perf: Add LLC-TAD perf counter support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221115070207.32634-3-yuancan@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/marvell_cn10k_tad_pmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/marvell_cn10k_tad_pmu.c b/drivers/perf/marvell_cn10k_tad_pmu.c
index 69c3050a4348..a1166afb3702 100644
--- a/drivers/perf/marvell_cn10k_tad_pmu.c
+++ b/drivers/perf/marvell_cn10k_tad_pmu.c
@@ -408,7 +408,11 @@ static int __init tad_pmu_init(void)
 	if (ret < 0)
 		return ret;
 	tad_pmu_cpuhp_state = ret;
-	return platform_driver_register(&tad_pmu_driver);
+	ret = platform_driver_register(&tad_pmu_driver);
+	if (ret)
+		cpuhp_remove_multi_state(tad_pmu_cpuhp_state);
+
+	return ret;
 }
 
 static void __exit tad_pmu_exit(void)
-- 
2.35.1



