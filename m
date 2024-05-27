Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D23F15FA91;
	Mon, 27 May 2024 19:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837783; cv=none; b=slhNQQWj6+g0lbKOeAbpZlsDRih7ziHhbSx086d0UK8S8gWLJ5k3MukZ7pmKFvPchY8NGSPZ4v5SwqQ+blQXODq5h/cB8DAg3pRpSArH0HAlEVXdDa+CUD9BZxrd31djKuJdUprw8ce7dDfe9ZAcVMWGueyGxWb+cl2FIHcNPvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837783; c=relaxed/simple;
	bh=odwx+2jDo2l7+i1iqQniDzd/3FenZsvfuxPWVCuA0ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiZAaIuy79RtOxZUOCzRGUt6ib2UFwohf+8bh2WHGUxjytlRAI8q3TgkBQBHFzFD9ymWRiiQvAMyYYCyTB5NkVnN9HI7Nnx7J0MkLyE7XgF5bpYaz0dnZ17ly7rJpWMtNRmcveaAdw6cyNnUjP0Pt9X9dT0nHVr2wbFo+YyALNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKsj5D4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKsj5D4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32031C2BBFC;
	Mon, 27 May 2024 19:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837783;
	bh=odwx+2jDo2l7+i1iqQniDzd/3FenZsvfuxPWVCuA0ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKsj5D4TWRxjaQXh3q74xiCfnKbNrEi+xwLfz8gR+HJGjq5ujLkckkA1J6Dk1IC70
	 Vov5liLYBs7ZJgoTUqt8xyVYVLx8fqlDrK5tonjKAlzbFUsLx5/vByIJIvVMC73Vw7
	 ADCGOXdOmc3VgfnbKljEg+lwbzk75jecCtLDGyVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 144/493] firmware: qcom: scm: Fix __scm and waitq completion variable initialization
Date: Mon, 27 May 2024 20:52:26 +0200
Message-ID: <20240527185635.155339425@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/firmware/qcom/qcom_scm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index ca381cb2ee979..29c24578ad2bf 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1713,7 +1713,7 @@ static int qcom_scm_qseecom_init(struct qcom_scm *scm)
  */
 bool qcom_scm_is_available(void)
 {
-	return !!__scm;
+	return !!READ_ONCE(__scm);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_is_available);
 
@@ -1794,10 +1794,12 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	if (!scm)
 		return -ENOMEM;
 
+	scm->dev = &pdev->dev;
 	ret = qcom_scm_find_dload_address(&pdev->dev, &scm->dload_mode_addr);
 	if (ret < 0)
 		return ret;
 
+	init_completion(&scm->waitq_comp);
 	mutex_init(&scm->scm_bw_lock);
 
 	scm->path = devm_of_icc_get(&pdev->dev, NULL);
@@ -1829,10 +1831,8 @@ static int qcom_scm_probe(struct platform_device *pdev)
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



