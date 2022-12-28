Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864CF1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC48C433F0;
	Wed, 28 Dec 2022 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239928;
	bh=gprZVFOfP36KQHoBILWVO1kcVWCcF/5hhE/hd46qvUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxMgaTYdg7qKC+VT7hJ66EmOPiuAVbq0GX2zuZ6AkIX1Bc1lB+bwoHt7W4D0O+Qku
	 OX6YnusI9s46JPTRuMKFKWsQmWr2ndcKQxZklHq3Du2VYr5c5poH8fB0UbHGE45bb/
	 6VnRXzpMAagCRs4LDAl8VhNfe6CdFptACLTQjWRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0059/1146] perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()
Date: Wed, 28 Dec 2022 15:26:38 +0100
Message-Id: <20221228144331.762474479@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 4a15c86f45ef..fe2abb412c00 100644
--- a/drivers/perf/arm_dsu_pmu.c
+++ b/drivers/perf/arm_dsu_pmu.c
@@ -858,7 +858,11 @@ static int __init dsu_pmu_init(void)
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



