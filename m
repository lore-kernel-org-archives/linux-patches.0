Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DFE2566;
	Mon, 13 Oct 2025 15:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368598; cv=none; b=qrA+cKkIJzzo+5Cpkh0sFq4yJgu/C1oMo4IMRPuqB7nlAdlW1mqBsReykoCrM/sCltDDaB08WGqmP2i70EOPeRqxziZfz/w/M6yonBPdHBxEbYPjpiiyjzdawhBYiYwJ2sKunPqZWxheuzIf4k+xof0Pho4kypMbMFqeXWLtpeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368598; c=relaxed/simple;
	bh=lBeYqI3q0xqorbvc4Y38kLueYjUD6u9igsX/tGddTMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah/W7vCfsqJSvC+qHyYZIZ+ycr7+jVowrTGwEZjR2bUS3rGwppKp0kAo0K/7wbDTTQz/beGhQAvhJ4Q2Ec5Kcg89bQsa2g+KyPSeq2x1r7/Su39NcKc16oHGprOle89Hia3AQYsB71+wAbSKPCfXjMBOC50lQJ8ngAAYI12NOAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axhWDVqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axhWDVqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1C3C4CEE7;
	Mon, 13 Oct 2025 15:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368598;
	bh=lBeYqI3q0xqorbvc4Y38kLueYjUD6u9igsX/tGddTMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axhWDVqvr/F9AM6K0C8poYc30IWyn69oSN5h43DLh7jwCMKmgWauLqUyELEIn1Yu3
	 PW1YTrNY0SD0vNDvztl1LScgfDw0DHnlfkOHT1zS2iQEINtpX1g7Pkb9ut+pTiNsZC
	 gaD08QhN+ss3JYTcP4el59Oglf8+wyjiE1qDENoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/262] coresight: catu: Support atclk
Date: Mon, 13 Oct 2025 16:45:26 +0200
Message-ID: <20251013144332.754325015@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 5483624effea2e893dc0df6248253a6a2a085451 ]

The atclk is an optional clock for the CoreSight CATU, but the driver
misses to initialize it.

This change enables atclk in probe of the CATU driver, and dynamically
control the clock during suspend and resume.

The checks for driver data and clocks in suspend and resume are not
needed, remove them.  Add error handling in the resume function.

Fixes: fcacb5c154ba ("coresight: Introduce support for Coresight Address Translation Unit")
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250731-arm_cs_fix_clock_v4-v6-2-1dfe10bb3f6f@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-catu.c | 22 +++++++++++++++-----
 drivers/hwtracing/coresight/coresight-catu.h |  1 +
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-catu.c b/drivers/hwtracing/coresight/coresight-catu.c
index 25fd02955c38d..abfff42b20c93 100644
--- a/drivers/hwtracing/coresight/coresight-catu.c
+++ b/drivers/hwtracing/coresight/coresight-catu.c
@@ -521,6 +521,10 @@ static int __catu_probe(struct device *dev, struct resource *res)
 	struct coresight_platform_data *pdata = NULL;
 	void __iomem *base;
 
+	drvdata->atclk = devm_clk_get_optional_enabled(dev, "atclk");
+	if (IS_ERR(drvdata->atclk))
+		return PTR_ERR(drvdata->atclk);
+
 	catu_desc.name = coresight_alloc_device_name(&catu_devs, dev);
 	if (!catu_desc.name)
 		return -ENOMEM;
@@ -668,18 +672,26 @@ static int catu_runtime_suspend(struct device *dev)
 {
 	struct catu_drvdata *drvdata = dev_get_drvdata(dev);
 
-	if (drvdata && !IS_ERR_OR_NULL(drvdata->pclk))
-		clk_disable_unprepare(drvdata->pclk);
+	clk_disable_unprepare(drvdata->atclk);
+	clk_disable_unprepare(drvdata->pclk);
+
 	return 0;
 }
 
 static int catu_runtime_resume(struct device *dev)
 {
 	struct catu_drvdata *drvdata = dev_get_drvdata(dev);
+	int ret;
 
-	if (drvdata && !IS_ERR_OR_NULL(drvdata->pclk))
-		clk_prepare_enable(drvdata->pclk);
-	return 0;
+	ret = clk_prepare_enable(drvdata->pclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(drvdata->atclk);
+	if (ret)
+		clk_disable_unprepare(drvdata->pclk);
+
+	return ret;
 }
 #endif
 
diff --git a/drivers/hwtracing/coresight/coresight-catu.h b/drivers/hwtracing/coresight/coresight-catu.h
index 755776cd19c5b..6e6b7aac206dc 100644
--- a/drivers/hwtracing/coresight/coresight-catu.h
+++ b/drivers/hwtracing/coresight/coresight-catu.h
@@ -62,6 +62,7 @@
 
 struct catu_drvdata {
 	struct clk *pclk;
+	struct clk *atclk;
 	void __iomem *base;
 	struct coresight_device *csdev;
 	int irq;
-- 
2.51.0



