Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1ED1FBEB0;
	Wed,  5 Feb 2025 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767487; cv=none; b=BFUvh69kFCT06dBFVxTyme5fXskrrc6Tv5vO/lT/pFeOXRbR8ewFV/+Q2xevGjoNNYmy+/3IUG5b97NHcxRmt/6FY0YxE47EFcso37PIOFtpOss6dDvT1NA+rcK9zqwArjA9N8dAJp+OiTnWjo3NZe+/gqPvTz69KUEiGtcVp/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767487; c=relaxed/simple;
	bh=C6RzqAJF0pgWFbm3sXx0krEnxdHASkfMT/97DTNBz28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9efU4mGAeZl5187m53rR4cUpvUSB39LFn8j6+Q+1G2BMopGVsbV5Do2McpZzLzCgAnASXzQFKDic2LTaGMjPnxjpjC8XW/cta9mYH8iifz71DJVkckoARi1uB4nvAcbBWzfjbvH0R8n0bcq+CVkAUYeuz3v3q7+1iXNVJ/Xmrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVOnyeb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVOnyeb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A58C4CEE3;
	Wed,  5 Feb 2025 14:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767487;
	bh=C6RzqAJF0pgWFbm3sXx0krEnxdHASkfMT/97DTNBz28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVOnyeb0pyhCtVvd3EJYA2SR8AZfGfBqMqSaZCIwi+pExPEwNvO4OLWSYP9k46/7a
	 yqnw/91PfCyTzAPPYGAbHwf/JBh2NWqEVyJABlfRX0/lWU1gLNFTsgGpYlV96m4gHM
	 hRay2OdJH5Lsk5gbm6PPneV9aufqqQ8HCLwzbZlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 411/623] firmware: qcom: scm: Cleanup global __scm on probe failures
Date: Wed,  5 Feb 2025 14:42:33 +0100
Message-ID: <20250205134511.946686362@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 1e76b546e6fca7eb568161f408133904ca6bcf4f ]

If SCM driver fails the probe, it should not leave global '__scm'
variable assigned, because external users of this driver will assume the
probe finished successfully.  For example TZMEM parts ('__scm->mempool')
are initialized later in the probe, but users of it (__scm_smc_call())
rely on the '__scm' variable.

This fixes theoretical NULL pointer exception, triggered via introducing
probe deferral in SCM driver with call trace:

  qcom_tzmem_alloc+0x70/0x1ac (P)
  qcom_tzmem_alloc+0x64/0x1ac (L)
  qcom_scm_assign_mem+0x78/0x194
  qcom_rmtfs_mem_probe+0x2d4/0x38c
  platform_probe+0x68/0xc8

Fixes: 40289e35ca52 ("firmware: qcom: scm: enable the TZ mem allocator")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241209-qcom-scm-missing-barriers-and-all-sort-of-srap-v2-4-9061013c8d92@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 42 ++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 72bf87ddcd969..26312a5131d2a 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -2029,13 +2029,17 @@ static int qcom_scm_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq_optional(pdev, 0);
 	if (irq < 0) {
-		if (irq != -ENXIO)
-			return irq;
+		if (irq != -ENXIO) {
+			ret = irq;
+			goto err;
+		}
 	} else {
 		ret = devm_request_threaded_irq(__scm->dev, irq, NULL, qcom_scm_irq_handler,
 						IRQF_ONESHOT, "qcom-scm", __scm);
-		if (ret < 0)
-			return dev_err_probe(scm->dev, ret, "Failed to request qcom-scm irq\n");
+		if (ret < 0) {
+			dev_err_probe(scm->dev, ret, "Failed to request qcom-scm irq\n");
+			goto err;
+		}
 	}
 
 	__get_convention();
@@ -2054,14 +2058,18 @@ static int qcom_scm_probe(struct platform_device *pdev)
 		qcom_scm_disable_sdi();
 
 	ret = of_reserved_mem_device_init(__scm->dev);
-	if (ret && ret != -ENODEV)
-		return dev_err_probe(__scm->dev, ret,
-				     "Failed to setup the reserved memory region for TZ mem\n");
+	if (ret && ret != -ENODEV) {
+		dev_err_probe(__scm->dev, ret,
+			      "Failed to setup the reserved memory region for TZ mem\n");
+		goto err;
+	}
 
 	ret = qcom_tzmem_enable(__scm->dev);
-	if (ret)
-		return dev_err_probe(__scm->dev, ret,
-				     "Failed to enable the TrustZone memory allocator\n");
+	if (ret) {
+		dev_err_probe(__scm->dev, ret,
+			      "Failed to enable the TrustZone memory allocator\n");
+		goto err;
+	}
 
 	memset(&pool_config, 0, sizeof(pool_config));
 	pool_config.initial_size = 0;
@@ -2069,9 +2077,11 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	pool_config.max_size = SZ_256K;
 
 	__scm->mempool = devm_qcom_tzmem_pool_new(__scm->dev, &pool_config);
-	if (IS_ERR(__scm->mempool))
-		return dev_err_probe(__scm->dev, PTR_ERR(__scm->mempool),
-				     "Failed to create the SCM memory pool\n");
+	if (IS_ERR(__scm->mempool)) {
+		dev_err_probe(__scm->dev, PTR_ERR(__scm->mempool),
+			      "Failed to create the SCM memory pool\n");
+		goto err;
+	}
 
 	/*
 	 * Initialize the QSEECOM interface.
@@ -2087,6 +2097,12 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	WARN(ret < 0, "failed to initialize qseecom: %d\n", ret);
 
 	return 0;
+
+err:
+	/* Paired with smp_load_acquire() in qcom_scm_is_available(). */
+	smp_store_release(&__scm, NULL);
+
+	return ret;
 }
 
 static void qcom_scm_shutdown(struct platform_device *pdev)
-- 
2.39.5



