Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8336197543;
	Thu,  6 Jun 2024 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683170; cv=none; b=mvsUIrmmjBeEiuSV46EBzCTMtCSJif7Xxr3NyiL/Q9JVBsqKd0KVedDjXCclCAHNL8fyiA4eCb/2di/Ad6COsHih6eNXhva+tB3Jy6SVPzHAcSJOd7Gj5g/KITXEePawQ5k7YURGI6ZrPDL5xsqquSjFQA7iP5yEWGbsYSURz3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683170; c=relaxed/simple;
	bh=IKQRgDESD/QLqPh0oYWembQPfyrNuQGr0tQwGYyFlXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uI7pcKv5EKTQ6Zwx7yWroX4IBTnPu1ySCFQCpfgRKCKTnlJo0domXSTLsspp/LYWy5azw5YZZWcZ59NsgDl9OKu7wgFW8gZ4/MK/zMiq17+DZECG5eda6VS9s7ZCyEuYRsxEIBgSV323u4Prohm4+tt2+JXL6EGfCOcgKqOQFWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9zGUOD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9zGUOD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611F6C32782;
	Thu,  6 Jun 2024 14:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683170;
	bh=IKQRgDESD/QLqPh0oYWembQPfyrNuQGr0tQwGYyFlXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9zGUOD83CYilq/fHqAHEnik9AfhL9tV1S3naaxA0SNZvhYcBDxPZVgOZlrF77vs9
	 tKMH6VkXrUFXj1N35gacXqNhNbkHEGSk3CRfHZRSPBVEi5jPf1P+txhu98xeQFgTlI
	 IeIeLA8JXamaBot52kl9NL1ek7gcjI4/58BvGFRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/744] firmware: qcom: scm: Fix __scm and waitq completion variable initialization
Date: Thu,  6 Jun 2024 15:56:27 +0200
Message-ID: <20240606131736.088312649@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <quic_mojha@quicinc.com>

[ Upstream commit 2e4955167ec5c04534cebea9e8273a907e7a75e1 ]

It is possible qcom_scm_is_available() gives wrong indication that
if __scm is initialized while __scm->dev is not and similar issue
is also possible with __scm->waitq_comp.

Fix this appropriately by the use of release barrier and read barrier
that will make sure if __scm is initialized so, is all of its field
variable.

Fixes: d0f6fa7ba2d6 ("firmware: qcom: scm: Convert SCM to platform driver")
Fixes: 6bf325992236 ("firmware: qcom: scm: Add wait-queue handling logic")
Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Link: https://lore.kernel.org/r/1711034642-22860-4-git-send-email-quic_mojha@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 69831f1d91e3f..ff7c155239e31 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -1333,7 +1333,7 @@ static int qcom_scm_find_dload_address(struct device *dev, u64 *addr)
  */
 bool qcom_scm_is_available(void)
 {
-	return !!__scm;
+	return !!READ_ONCE(__scm);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_is_available);
 
@@ -1414,10 +1414,12 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	if (!scm)
 		return -ENOMEM;
 
+	scm->dev = &pdev->dev;
 	ret = qcom_scm_find_dload_address(&pdev->dev, &scm->dload_mode_addr);
 	if (ret < 0)
 		return ret;
 
+	init_completion(&scm->waitq_comp);
 	mutex_init(&scm->scm_bw_lock);
 
 	scm->path = devm_of_icc_get(&pdev->dev, NULL);
@@ -1449,10 +1451,8 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	__scm = scm;
-	__scm->dev = &pdev->dev;
-
-	init_completion(&__scm->waitq_comp);
+	/* Let all above stores be available after this */
+	smp_store_release(&__scm, scm);
 
 	irq = platform_get_irq_optional(pdev, 0);
 	if (irq < 0) {
-- 
2.43.0



