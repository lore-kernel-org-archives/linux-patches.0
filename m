Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0C51170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7EBC433C9;
	Mon, 11 Sep 2023 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441851;
	bh=4l5843avEpi1/1KbUbU7MnL3t7zrI0ZENmnwQzHCgvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTgcc4ivDlsBlcgFnl2oppEPFrV+RG2rar5co8eeSp9piZtjq4XGK4vEAJrXoUCXM
	 d1n2bfycUgGBtKm568dNhCh/5gwkSECFHRQarRNXXAwN1X8zG7j/rdgHjvOtbC/y4F
	 np7xs/PtoBpoBMMAZASdiiej1fQtlt2Sp90W30Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 559/739] coresight: trbe: Allocate platform data per device
Date: Mon, 11 Sep 2023 15:45:58 +0200
Message-ID: <20230911134706.695135989@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 39744738a67de9153d73e11817937c0004feab2e ]

Coresight TRBE driver shares a single platform data (which is empty btw).
However, with the commit 4e8fe7e5c3a5
("coresight: Store pointers to connections rather than an array of them")
the coresight core would free up the pdata, resulting in multiple attempts
to free the same pdata for TRBE instances. Fix this by allocating a pdata per
coresight_device.

Fixes: 4e8fe7e5c3a5 ("coresight: Store pointers to connections rather than an array of them")
Link: https://lore.kernel.org/r/20230814093813.19152-3-hejunhao3@huawei.com
Reported-by: Junhao He <hejunhao3@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: James Clark <james.clark@arm.com>
Tested-by: Junhao He <hejunhao3@huawei.com>
Link: https://lore.kernel.org/r/20230816141008.535450-2-suzuki.poulose@arm.com
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 7720619909d65..8e4eb37e66e82 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -1244,10 +1244,13 @@ static void arm_trbe_register_coresight_cpu(struct trbe_drvdata *drvdata, int cp
 	if (!desc.name)
 		goto cpu_clear;
 
+	desc.pdata = coresight_get_platform_data(dev);
+	if (IS_ERR(desc.pdata))
+		goto cpu_clear;
+
 	desc.type = CORESIGHT_DEV_TYPE_SINK;
 	desc.subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_SINK_PERCPU_SYSMEM;
 	desc.ops = &arm_trbe_cs_ops;
-	desc.pdata = dev_get_platdata(dev);
 	desc.groups = arm_trbe_groups;
 	desc.dev = dev;
 	trbe_csdev = coresight_register(&desc);
@@ -1479,7 +1482,6 @@ static void arm_trbe_remove_irq(struct trbe_drvdata *drvdata)
 
 static int arm_trbe_device_probe(struct platform_device *pdev)
 {
-	struct coresight_platform_data *pdata;
 	struct trbe_drvdata *drvdata;
 	struct device *dev = &pdev->dev;
 	int ret;
@@ -1494,12 +1496,7 @@ static int arm_trbe_device_probe(struct platform_device *pdev)
 	if (!drvdata)
 		return -ENOMEM;
 
-	pdata = coresight_get_platform_data(dev);
-	if (IS_ERR(pdata))
-		return PTR_ERR(pdata);
-
 	dev_set_drvdata(dev, drvdata);
-	dev->platform_data = pdata;
 	drvdata->pdev = pdev;
 	ret = arm_trbe_probe_irq(pdev, drvdata);
 	if (ret)
-- 
2.40.1



