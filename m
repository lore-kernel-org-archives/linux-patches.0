Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE5A43AC4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbrdT6rX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E528C4AF6C;
	Wed, 15 Nov 2023 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081408;
	bh=VTabyq6f+Hg/6e6+M3COpRCHV7Q7Xsga+bPb+8b/VCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbrdT6rXCf9zvJ8EdCeEpgOl2DIWJqmcA1gW7GfxsCrkDOAmuCYh0h6pgUEEWMmfp
	 h3Pp9MKEi2Zs7mdQtuNPP5AQSMVLiIFXGt3gqzPMamHB9lUIy4QkJVQd6ogAUG8TWb
	 d+QyfWJU+BexX9WNSUy14H2uDGwQoZwU6xhYzy5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/244] perf: hisi: Fix use-after-free when register pmu fails
Date: Wed, 15 Nov 2023 15:35:02 -0500
Message-ID: <20231115203554.946745235@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit b805cafc604bfdb671fae7347a57f51154afa735 ]

When we fail to register the uncore pmu, the pmu context may not been
allocated. The error handing will call cpuhp_state_remove_instance()
to call uncore pmu offline callback, which migrate the pmu context.
Since that's liable to lead to some kind of use-after-free.

Use cpuhp_state_remove_instance_nocalls() instead of
cpuhp_state_remove_instance() so that the notifiers don't execute after
the PMU device has been failed to register.

Fixes: a0ab25cd82ee ("drivers/perf: hisi: Add support for HiSilicon PA PMU driver")
FIxes: 3bf30882c3c7 ("drivers/perf: hisi: Add support for HiSilicon SLLC PMU driver")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Link: https://lore.kernel.org/r/20231024113630.13472-1-hejunhao3@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_uncore_pa_pmu.c   | 4 ++--
 drivers/perf/hisilicon/hisi_uncore_sllc_pmu.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/perf/hisilicon/hisi_uncore_pa_pmu.c b/drivers/perf/hisilicon/hisi_uncore_pa_pmu.c
index 83264ec0a9573..7b096f1dc9eb1 100644
--- a/drivers/perf/hisilicon/hisi_uncore_pa_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_pa_pmu.c
@@ -434,8 +434,8 @@ static int hisi_pa_pmu_probe(struct platform_device *pdev)
 	ret = perf_pmu_register(&pa_pmu->pmu, name, -1);
 	if (ret) {
 		dev_err(pa_pmu->dev, "PMU register failed, ret = %d\n", ret);
-		cpuhp_state_remove_instance(CPUHP_AP_PERF_ARM_HISI_PA_ONLINE,
-					    &pa_pmu->node);
+		cpuhp_state_remove_instance_nocalls(CPUHP_AP_PERF_ARM_HISI_PA_ONLINE,
+						    &pa_pmu->node);
 		return ret;
 	}
 
diff --git a/drivers/perf/hisilicon/hisi_uncore_sllc_pmu.c b/drivers/perf/hisilicon/hisi_uncore_sllc_pmu.c
index 6aedc303ff56a..f3cd00fc9bbe6 100644
--- a/drivers/perf/hisilicon/hisi_uncore_sllc_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_sllc_pmu.c
@@ -463,8 +463,8 @@ static int hisi_sllc_pmu_probe(struct platform_device *pdev)
 	ret = perf_pmu_register(&sllc_pmu->pmu, name, -1);
 	if (ret) {
 		dev_err(sllc_pmu->dev, "PMU register failed, ret = %d\n", ret);
-		cpuhp_state_remove_instance(CPUHP_AP_PERF_ARM_HISI_SLLC_ONLINE,
-					    &sllc_pmu->node);
+		cpuhp_state_remove_instance_nocalls(CPUHP_AP_PERF_ARM_HISI_SLLC_ONLINE,
+						    &sllc_pmu->node);
 		return ret;
 	}
 
-- 
2.42.0



