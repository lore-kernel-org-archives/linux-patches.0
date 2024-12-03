Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021051F76B5;
	Tue,  3 Dec 2024 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239203; cv=none; b=NzPIFX4SMeCy7tF4wdSoa4ZGFCm4d8EivRCK6b9vDGc4ipK2EK2huc9bnUrQT1h8uJnIqbBUBUK2Xp720GhR5lk/6u4gzVVdE3rbDx3uviwzU7u6YWEBjVcrlZJWW6CylP9UAm+Heljw09QVH1wdba1Ybaf9oMsBPFFclX6I1VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239203; c=relaxed/simple;
	bh=p5Y9tbXR79kZwB/3eR3lvRGi+eIU/JIVwpemCfOsIlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxg/YE02q7eEgWjaFRgDU4C9b+wuhnYcVpwnlskxl3vNKyzIPPYwbToAuXdRzrunL5JjsXYuYl1hgcMJU+r2ZbwKzK8ilE6idVRW0nAdnv10Fvst7VjSp8cWupoB5awHrCVORmwBaeeMP3PABnA5yDb2+5I9X0drzBZBkF+YpMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+/db+fG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+/db+fG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F56DC4CED6;
	Tue,  3 Dec 2024 15:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239202;
	bh=p5Y9tbXR79kZwB/3eR3lvRGi+eIU/JIVwpemCfOsIlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+/db+fGD2WBQPwb+tBkPOJXPC80nSx5H2kvG9SoSYsySPjokRm1gIOVuHmaLdTrP
	 8fFKoa9FAuKZtkBS6PEfszrE+DcUKQKVbniD10lqvz2nTX/GM6a+RO09CeyUZucrCt
	 qEg9X+mGHqhCOH1ns/a6ESCa1FgyvuxI2Ln8RlIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 534/817] remoteproc: qcom: pas: Remove subdevs on the error path of adsp_probe()
Date: Tue,  3 Dec 2024 15:41:46 +0100
Message-ID: <20241203144016.744267884@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 587b67cf62a91b10a47f41c20ed8ad71db375334 ]

Current implementation of adsp_probe() in qcom_q6v5_pas.c does not
remove the subdevs of adsp on the error path. Fix this bug by calling
qcom_remove_{ssr,sysmon,pdm,smd,glink}_subdev(), qcom_q6v5_deinit(), and
adsp_unassign_memory_region() appropriately.

Fixes: 4b48921a8f74 ("remoteproc: qcom: Use common SMD edge handler")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://lore.kernel.org/r/a1cabc64240022a7f1d5237aa2aa6f72d8fb7052.1731038950.git.joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 88e7b84f223c0..65467876f09e2 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -759,16 +759,16 @@ static int adsp_probe(struct platform_device *pdev)
 
 	ret = adsp_init_clock(adsp);
 	if (ret)
-		goto free_rproc;
+		goto unassign_mem;
 
 	ret = adsp_init_regulator(adsp);
 	if (ret)
-		goto free_rproc;
+		goto unassign_mem;
 
 	ret = adsp_pds_attach(&pdev->dev, adsp->proxy_pds,
 			      desc->proxy_pd_names);
 	if (ret < 0)
-		goto free_rproc;
+		goto unassign_mem;
 	adsp->proxy_pd_count = ret;
 
 	ret = qcom_q6v5_init(&adsp->q6v5, pdev, rproc, desc->crash_reason_smem, desc->load_state,
@@ -784,18 +784,28 @@ static int adsp_probe(struct platform_device *pdev)
 					      desc->ssctl_id);
 	if (IS_ERR(adsp->sysmon)) {
 		ret = PTR_ERR(adsp->sysmon);
-		goto detach_proxy_pds;
+		goto deinit_remove_pdm_smd_glink;
 	}
 
 	qcom_add_ssr_subdev(rproc, &adsp->ssr_subdev, desc->ssr_name);
 	ret = rproc_add(rproc);
 	if (ret)
-		goto detach_proxy_pds;
+		goto remove_ssr_sysmon;
 
 	return 0;
 
+remove_ssr_sysmon:
+	qcom_remove_ssr_subdev(rproc, &adsp->ssr_subdev);
+	qcom_remove_sysmon_subdev(adsp->sysmon);
+deinit_remove_pdm_smd_glink:
+	qcom_remove_pdm_subdev(rproc, &adsp->pdm_subdev);
+	qcom_remove_smd_subdev(rproc, &adsp->smd_subdev);
+	qcom_remove_glink_subdev(rproc, &adsp->glink_subdev);
+	qcom_q6v5_deinit(&adsp->q6v5);
 detach_proxy_pds:
 	adsp_pds_detach(adsp, adsp->proxy_pds, adsp->proxy_pd_count);
+unassign_mem:
+	adsp_unassign_memory_region(adsp);
 free_rproc:
 	device_init_wakeup(adsp->dev, false);
 
-- 
2.43.0



