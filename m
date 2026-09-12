Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9A419D8BC;
	Sat, 12 Sep 2026 10:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208719; cv=none; b=STk4fnLjLPIL7ezIQTc4DtUzvtgeA8NL15u0MRglhiwHI8VCrfZsrsyQAvnxqFvE2A+t7Zyk18xVXnDeB4tqb3Cs0p/YoBdiOns4L6DOPshoeiaVA+l0THs68YxtDgpX4+bsnLCXcA0OBJb+4vW0R/E7uJXKsJlYQgUSqSI/bc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208719; c=relaxed/simple;
	bh=mT9A3K1CB1wWPkoHBGueeaeWZ6wZNsFvj2n/AEnzVZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbBxEyfAaaPn2AyKliMgMEbjx4hwn65OxTnqlrurIJFh84SZKcclZ6PQ3Ya8UsiGuY9eNqX26d5aaA5RoddvGupAeGXL3yzS27nNXhwymeZE3jiAjeKWfjPL/Un2YgIrBq8+akwC8edKm51LPOy0k7iH8wpxl5xdMf8P+TQwliI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9X1Id08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9X1Id08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092C51F000FF;
	Sat, 12 Sep 2026 10:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208718;
	bh=ZP6wuD3WF9HbBfvk8rp9wWsQ+I/H0vH4ES+02z5ABs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9X1Id08ndaHr95Kc9WdkrdRgjzn5U2T4A0E8NWmg10BYj7cejcP+p+Q9gqKPeDht
	 d48Yv6qJn1oC8AwJFdGlPfY8dLvmoD+lAW4TN+ZoQHlN//sBPMRMn3yrO/e7l9gxGC
	 E/h/gncewEWODao75x9VvLnxqeeVECqAki7Sy/iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0673/1518] firmware: qcom: scm: Fix reserved memory cleanup on probe failure
Date: Sat, 12 Sep 2026 08:47:22 +0200
Message-ID: <20260912065638.658047536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit b697b20cea4374d27e2134da4bb7b0ea39f36c8b ]

of_reserved_mem_device_init() adds an entry to a global list with no
devres counterpart. If qcom_scm_probe() fails after the call the
assignment is never cleaned up. A probe retry would add a duplicate
entry, leaking the original one permanently.

Add an err_rmem label that calls of_reserved_mem_device_release() and
route all error paths after of_reserved_mem_device_init() through it.
of_reserved_mem_device_release() is safe to call unconditionally as it
simply walks an empty list when nothing was assigned.

Fixes: a33b2579c8d3 ("firmware: qcom: scm: add support for SHM bridge memory carveout")
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260724094939.613844-3-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 73179a99935ba..226265b311fe9 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -2489,9 +2489,11 @@ static int qcom_scm_probe(struct platform_device *pdev)
 				     "Failed to setup the reserved memory region for TZ mem\n");
 
 	ret = qcom_tzmem_enable(scm->dev);
-	if (ret)
-		return dev_err_probe(scm->dev, ret,
-				     "Failed to enable the TrustZone memory allocator\n");
+	if (ret) {
+		ret = dev_err_probe(scm->dev, ret,
+				    "Failed to enable the TrustZone memory allocator\n");
+		goto err_rmem;
+	}
 
 	memset(&pool_config, 0, sizeof(pool_config));
 	pool_config.initial_size = 0;
@@ -2499,9 +2501,11 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	pool_config.max_size = SZ_256K;
 
 	scm->mempool = devm_qcom_tzmem_pool_new(scm->dev, &pool_config);
-	if (IS_ERR(scm->mempool))
-		return dev_err_probe(scm->dev, PTR_ERR(scm->mempool),
-				     "Failed to create the SCM memory pool\n");
+	if (IS_ERR(scm->mempool)) {
+		ret = dev_err_probe(scm->dev, PTR_ERR(scm->mempool),
+				    "Failed to create the SCM memory pool\n");
+		goto err_rmem;
+	}
 
 	ret = qcom_scm_query_waitq_count(scm);
 	scm->wq_cnt = ret < 0 ? QCOM_SCM_DEFAULT_WAITQ_COUNT : ret;
@@ -2569,6 +2573,10 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	qcom_scm_qtee_init(scm);
 
 	return 0;
+
+err_rmem:
+	of_reserved_mem_device_release(scm->dev);
+	return ret;
 }
 
 static void qcom_scm_shutdown(struct platform_device *pdev)
-- 
2.53.0



