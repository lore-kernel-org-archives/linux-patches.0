Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816EF1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BAEC433D2;
	Wed, 28 Dec 2022 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238851;
	bh=xLMSABwJiBXNgc997gcjKHd9GNASxvEMxkI0yI52mec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08QPh2JLfzodkNyyDvbBmdzP5uQX2W8fPwbbpMjtMaZ9fYiMtzUYBdOE/ZL8nDic2
	 UE5CiUUSQ8RMzQejNSFqzymrR/D/quvuFr9yD1KbTq9gTUGfgYTe1Vug3zJAutnsVR
	 MH4lXS9K41wAkOTCTmWvGr/FMlHRbsoTXk5UwN3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Punit Agrawal <punit.agrawal@bytedance.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/731] perf/arm_dmc620: Fix hotplug callback leak in dmc620_pmu_init()
Date: Wed, 28 Dec 2022 15:32:21 +0100
Message-Id: <20221228144257.540461642@linuxfoundation.org>
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

[ Upstream commit d9f564c966e63925aac4ba273a9319d7fb6f4b4e ]

dmc620_pmu_init() won't remove the callback added by
cpuhp_setup_state_multi() when platform_driver_register() failed. Remove
the callback by cpuhp_remove_multi_state() in fail path.

Similar to the handling of arm_ccn_init() in commit 26242b330093 ("bus:
arm-ccn: Prevent hotplug callback leak")

Fixes: 53c218da220c ("driver/perf: Add PMU driver for the ARM DMC-620 memory controller")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Punit Agrawal <punit.agrawal@bytedance.com>
Link: https://lore.kernel.org/r/20221115115540.6245-2-shangxiaojing@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_dmc620_pmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_dmc620_pmu.c b/drivers/perf/arm_dmc620_pmu.c
index 280a6ae3e27c..54aa4658fb36 100644
--- a/drivers/perf/arm_dmc620_pmu.c
+++ b/drivers/perf/arm_dmc620_pmu.c
@@ -725,6 +725,8 @@ static struct platform_driver dmc620_pmu_driver = {
 
 static int __init dmc620_pmu_init(void)
 {
+	int ret;
+
 	cpuhp_state_num = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
 				      DMC620_DRVNAME,
 				      NULL,
@@ -732,7 +734,11 @@ static int __init dmc620_pmu_init(void)
 	if (cpuhp_state_num < 0)
 		return cpuhp_state_num;
 
-	return platform_driver_register(&dmc620_pmu_driver);
+	ret = platform_driver_register(&dmc620_pmu_driver);
+	if (ret)
+		cpuhp_remove_multi_state(cpuhp_state_num);
+
+	return ret;
 }
 
 static void __exit dmc620_pmu_exit(void)
-- 
2.35.1



