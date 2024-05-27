Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407FA1078F;
	Mon, 27 May 2024 19:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836485; cv=none; b=cr5npxQUe5FMb+gj3pLjTFU4lJMChiyFILeIHaseF+2a43+x4Nk4sG+aD+t19tbLICvzwWeCPh8a8HolmFjLLoUtP3NfT1u0wxHI5AerE45M2zyi/I7Q/o0o4EovNo9nMY0sswQsUEEmgFAT1/C6lSwWjvqbvYSuWx6tJ7x9oXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836485; c=relaxed/simple;
	bh=ECGVzxMlKFAlU5fegUCEhfDSQ4mETD9jLKdQpjH6LAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBnvx/2J0EaPqpsSDgrHsWGQCl+uS4EGX1xwQdeEgogzQ7DLAavQwRaEf+KpfqlGIFpcKFh0eVktnt5b1N4CTkO3Ooz37eAq4cWRscsafYBz2QsbvBilIwoR8OuX4EawFVlEYX2iYfA9ZAKrtxAyw2KZL0yz8tkXK18d6Wkx4DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXgWOS+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXgWOS+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08FFC32781;
	Mon, 27 May 2024 19:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836485;
	bh=ECGVzxMlKFAlU5fegUCEhfDSQ4mETD9jLKdQpjH6LAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXgWOS+TDJctFaFqNhTrqUVe7vONP9//uYaumE3zkt8GsWXHXI6HjfOOIK2ftCyal
	 JDGovG8Ty35BPbqoKHf4pLmlcM3tRTul9jG43CkFGdI4V3ObQgwb9dlGkwJvMMK2qR
	 LgbRLMRCVpso7Y9RxVb3hKiflVghc0QrNq1aU3fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 072/427] firmware: qcom: scm: Fix __scm and waitq completion variable initialization
Date: Mon, 27 May 2024 20:51:59 +0200
Message-ID: <20240527185608.594195962@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



