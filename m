Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5C1221F00;
	Mon, 13 Oct 2025 15:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368595; cv=none; b=J3FIzbcdakTFxGbQ2YiAEIWSBWOl5gxxgyZ30mz6+6HkVw1pJ4XorG+yILbjuB1u73xgT7N5Nsz/dTxuSug+F4OmBJXpp51+EWza5JT370lVEGCZ4XNduz5hz0IUsHr2WVst6A8aNMcCBRPwAmHgLpKOoEz4cyh9EEEwW2/d+NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368595; c=relaxed/simple;
	bh=fgVtJs/sAab0R9tK7JfmOcVErXJqH07VFcQmKEgUXZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q+ZK6yr+pAA4I4YnwymMhXcE5cWDh28j20zf74rWSgUEu3SiCX64leS5cib4EiNLnG5e3AyomjUi4uEfaTKyZteuUDwvfVpWbRWFWcNFA/06l7oqqHQQ+axtsU1B+IR+/fu2hBcX3S3g+3+ktsHBRz/WUDW2bU+uISN3T6FTlFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxrHqhcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxrHqhcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDFDC4CEE7;
	Mon, 13 Oct 2025 15:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368595;
	bh=fgVtJs/sAab0R9tK7JfmOcVErXJqH07VFcQmKEgUXZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxrHqhcJJDKRfI9TFL/vEIzA/XesLPZXogE1k2OxeBnGx1eY7bweULW6Fj2zkeJh4
	 UO7lu30PT072n6ddj7FHIs7/nKDFn0H3csSaM4KoOCir0c0rUYstDsrTS11/D7ZmYe
	 +SWAJjD5Glx4FvMCjVpNyRIHwOmrWsTEINX4fg1Y=
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
Subject: [PATCH 6.12 183/262] coresight: tmc: Support atclk
Date: Mon, 13 Oct 2025 16:45:25 +0200
Message-ID: <20251013144332.718989370@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 8a79026926b329d4ab0c6d0921373a80ec8aab6e ]

The atclk is an optional clock for the CoreSight TMC, but the driver
misses to initialize it.  In most cases, TMC shares the atclk clock with
other CoreSight components.  Since these components enable the clock
before the TMC device is initialized, the TMC continues properly,
which is why we don’t observe any lockup issues.

This change enables atclk in probe of the TMC driver.  Given the clock
is optional, it is possible to return NULL if the clock does not exist.
IS_ERR() is tolerant for this case.

Dynamically disable and enable atclk during suspend and resume.  The
clock pointers will never be error values if the driver has successfully
probed, and the case of a NULL pointer case will be handled by the clock
core layer.  The driver data is always valid after probe. Therefore,
remove the related checks.  Also in the resume flow adds error handling.

Fixes: bc4bf7fe98da ("coresight-tmc: add CoreSight TMC driver")
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250731-arm_cs_fix_clock_v4-v6-1-1dfe10bb3f6f@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-tmc-core.c  | 22 ++++++++++++++-----
 drivers/hwtracing/coresight/coresight-tmc.h   |  2 ++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-core.c b/drivers/hwtracing/coresight/coresight-tmc-core.c
index 475fa4bb6813b..96ef2517dd439 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-core.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-core.c
@@ -480,6 +480,10 @@ static int __tmc_probe(struct device *dev, struct resource *res)
 	struct coresight_desc desc = { 0 };
 	struct coresight_dev_list *dev_list = NULL;
 
+	drvdata->atclk = devm_clk_get_optional_enabled(dev, "atclk");
+	if (IS_ERR(drvdata->atclk))
+		return PTR_ERR(drvdata->atclk);
+
 	ret = -ENOMEM;
 
 	/* Validity for the resource is already checked by the AMBA core */
@@ -700,18 +704,26 @@ static int tmc_runtime_suspend(struct device *dev)
 {
 	struct tmc_drvdata *drvdata = dev_get_drvdata(dev);
 
-	if (drvdata && !IS_ERR_OR_NULL(drvdata->pclk))
-		clk_disable_unprepare(drvdata->pclk);
+	clk_disable_unprepare(drvdata->atclk);
+	clk_disable_unprepare(drvdata->pclk);
+
 	return 0;
 }
 
 static int tmc_runtime_resume(struct device *dev)
 {
 	struct tmc_drvdata *drvdata = dev_get_drvdata(dev);
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
 
diff --git a/drivers/hwtracing/coresight/coresight-tmc.h b/drivers/hwtracing/coresight/coresight-tmc.h
index 2671926be62a3..2a53acbb5990b 100644
--- a/drivers/hwtracing/coresight/coresight-tmc.h
+++ b/drivers/hwtracing/coresight/coresight-tmc.h
@@ -166,6 +166,7 @@ struct etr_buf {
 
 /**
  * struct tmc_drvdata - specifics associated to an TMC component
+ * @atclk:	optional clock for the core parts of the TMC.
  * @pclk:	APB clock if present, otherwise NULL
  * @base:	memory mapped base address for this component.
  * @csdev:	component vitals needed by the framework.
@@ -191,6 +192,7 @@ struct etr_buf {
  * @perf_buf:	PERF buffer for ETR.
  */
 struct tmc_drvdata {
+	struct clk		*atclk;
 	struct clk		*pclk;
 	void __iomem		*base;
 	struct coresight_device	*csdev;
-- 
2.51.0



