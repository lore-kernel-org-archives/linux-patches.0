Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A842128B517;
	Sat, 12 Sep 2026 08:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200434; cv=none; b=N0fRK/kyeEEdrSILHKelKQYy8OTE+sRilpZ4lPxx5NCkrMuEBPuLzyAKN1jHCYwucAGvhagOE6k7B5rQnzXX0i5rcEkW6ThZfSu8QSa7gxZhX7xyafA4DhbptDDutU7d0IOvfmbEO2vBfroCj0oKMe+x+sdauCjwB4ozC679hAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200434; c=relaxed/simple;
	bh=bPbG1mN4iA6xeS76dLQoDlIQq881y2sBD1tI4KOm9tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3U3GIhVFncnQ1FNB2eRm9ehu1W5ucKF5xYtWi92VaMm+SHcQhQVuizDYW5erLQeJFV6mnprRiYtU5CedM2iXS2PeF+axRWUSo9E/SouONPW8y1teP/8IWgYawv0CuTwvFOrwv5Kj8kM0rudJEOyjgNeomAarAcqRsNxgJkWQTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpyeytHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpyeytHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1CB1F000FF;
	Sat, 12 Sep 2026 08:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200433;
	bh=ANWlprkYczc3AsRS01ZIrAdSbZyPlODVP0LjT9IRAAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpyeytHHPGOjS3+q4UzLxy8Jrf5pmuV4Fa0SzY3iGEzYF5xjr23ztcJDk+SHqPprK
	 UivpainBLO0QAe6IEUo6zAjvOw8L3eU0xFgZByXciHN8U9z+gYeE7Bjiy0Fj0TV+8L
	 rxFhySkHqi0UqNjSSFvK/AE55s+Ee2fK9pOxY2Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0790/1815] firmware: qcom: scm: Fix reserved memory cleanup on probe failure
Date: Sat, 12 Sep 2026 08:42:20 +0200
Message-ID: <20260912065707.456764807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 464ae3b4ca43d..26bf87247afa1 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -2785,9 +2785,11 @@ static int qcom_scm_probe(struct platform_device *pdev)
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
@@ -2795,9 +2797,11 @@ static int qcom_scm_probe(struct platform_device *pdev)
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
@@ -2868,6 +2872,10 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	qcom_scm_gunyah_wdt_init(scm);
 
 	return 0;
+
+err_rmem:
+	of_reserved_mem_device_release(scm->dev);
+	return ret;
 }
 
 static void qcom_scm_shutdown(struct platform_device *pdev)
-- 
2.53.0



