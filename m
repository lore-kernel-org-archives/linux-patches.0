Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6833B321452;
	Tue,  2 Sep 2025 13:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819818; cv=none; b=I80qww5LmFTVtCReryKgLDKZOR5G7wiKrtke7E3WNz5zkQpQZ0Tc2VYJ7twZfawA9eOBhQ+xadLTp3959frEjkhP21vG+dekXBry4zifNTuLY290tJ6yAzJueEKTdWRHIZL7XqddMMoPVK5f9U0gqhMuDHqVNXv/rq+caPT2hI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819818; c=relaxed/simple;
	bh=gYx0F3jzTliU5qwaX0Nfkb1rsOLiulLm/xKmqB6yf0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKLpaWvpLBbJPVM/cLTP81+uB7oMH3xdCfHSTMT75eT98j7NeETg7CRlWkZtwtSt862GJrzA1EL2tZyCytwjn01BtcaNcOjBl+PxaWFbPDObbYeeSi28h/MhpU9HwKQ4gu1i/R0sOqnTxtTECYRJX/H7jI65pUTXE1NZAsmhXW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHNteHSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHNteHSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DB7C4CEED;
	Tue,  2 Sep 2025 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819818;
	bh=gYx0F3jzTliU5qwaX0Nfkb1rsOLiulLm/xKmqB6yf0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHNteHSRabErVtZ/+9jFsOuBoCovUKmc5qoSPZWMagyZALtQSBBgUDUV7nIhkLCdo
	 vaQjMLg9UQTOykXw8Fj8N8rmA2+pFXT7VZq7BQ20lP2nFaSC0OGnkT/4M5xh2X6m2l
	 JUbTwhqp5ugmODPQpRmISGGYhxDiN3mq8mlzY124=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.16 137/142] firmware: qcom: scm: initialize tzmem before marking SCM as available
Date: Tue,  2 Sep 2025 15:20:39 +0200
Message-ID: <20250902131953.527929308@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 87be3e7a2d0030cda6314d2ec96b37991f636ccd upstream.

Now that qcom_scm_shm_bridge_enable() uses the struct device passed to
it as argument to make the QCOM_SCM_MP_SHM_BRIDGE_ENABLE SCM call, we
can move the TZMem initialization before the assignment of the __scm
pointer in the SCM driver (which marks SCM as ready to users) thus
fixing the potential race between consumer calls and the memory pool
initialization.

Reported-by: Johan Hovold <johan+linaro@kernel.org>
Closes: https://lore.kernel.org/all/20250120151000.13870-1-johan+linaro@kernel.org/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20250630-qcom-scm-race-v2-3-fa3851c98611@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qcom/qcom_scm.c |   53 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -2256,7 +2256,32 @@ static int qcom_scm_probe(struct platfor
 	if (ret)
 		return ret;
 
-	/* Paired with smp_load_acquire() in qcom_scm_is_available(). */
+	ret = of_reserved_mem_device_init(scm->dev);
+	if (ret && ret != -ENODEV)
+		return dev_err_probe(scm->dev, ret,
+				     "Failed to setup the reserved memory region for TZ mem\n");
+
+	ret = qcom_tzmem_enable(scm->dev);
+	if (ret)
+		return dev_err_probe(scm->dev, ret,
+				     "Failed to enable the TrustZone memory allocator\n");
+
+	memset(&pool_config, 0, sizeof(pool_config));
+	pool_config.initial_size = 0;
+	pool_config.policy = QCOM_TZMEM_POLICY_ON_DEMAND;
+	pool_config.max_size = SZ_256K;
+
+	scm->mempool = devm_qcom_tzmem_pool_new(scm->dev, &pool_config);
+	if (IS_ERR(scm->mempool))
+		return dev_err_probe(scm->dev, PTR_ERR(scm->mempool),
+				     "Failed to create the SCM memory pool\n");
+
+	/*
+	 * Paired with smp_load_acquire() in qcom_scm_is_available().
+	 *
+	 * This marks the SCM API as ready to accept user calls and can only
+	 * be called after the TrustZone memory pool is initialized.
+	 */
 	smp_store_release(&__scm, scm);
 
 	irq = platform_get_irq_optional(pdev, 0);
@@ -2289,32 +2314,6 @@ static int qcom_scm_probe(struct platfor
 	if (of_property_read_bool(pdev->dev.of_node, "qcom,sdi-enabled") || !download_mode)
 		qcom_scm_disable_sdi();
 
-	ret = of_reserved_mem_device_init(__scm->dev);
-	if (ret && ret != -ENODEV) {
-		dev_err_probe(__scm->dev, ret,
-			      "Failed to setup the reserved memory region for TZ mem\n");
-		goto err;
-	}
-
-	ret = qcom_tzmem_enable(__scm->dev);
-	if (ret) {
-		dev_err_probe(__scm->dev, ret,
-			      "Failed to enable the TrustZone memory allocator\n");
-		goto err;
-	}
-
-	memset(&pool_config, 0, sizeof(pool_config));
-	pool_config.initial_size = 0;
-	pool_config.policy = QCOM_TZMEM_POLICY_ON_DEMAND;
-	pool_config.max_size = SZ_256K;
-
-	__scm->mempool = devm_qcom_tzmem_pool_new(__scm->dev, &pool_config);
-	if (IS_ERR(__scm->mempool)) {
-		ret = dev_err_probe(__scm->dev, PTR_ERR(__scm->mempool),
-				    "Failed to create the SCM memory pool\n");
-		goto err;
-	}
-
 	/*
 	 * Initialize the QSEECOM interface.
 	 *


