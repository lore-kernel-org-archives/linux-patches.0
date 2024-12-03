Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A8014A088;
	Tue,  3 Dec 2024 16:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241794; cv=none; b=fmIRuQ35Vv1mXo2YzvoYEqr3mzC8p0lgG9XUj9jo4f90x6vo8B28dnY9kSiRiFnlKLUPAyIysZ+moj1pLMU8jTdB4K3vxvjhWV7OE847qwv4bv9alaidO3M2NERVbrH/8QuerpLQxzMnawoOdusT8W/3HYEs69RdtTizVz8sYN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241794; c=relaxed/simple;
	bh=S8enkUJ4gQ7iM9EXYwORu1jOWQ5mMbBxMKezBXY8ryo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ir/5yh39MLC3LDBqGlmWFcaSoxxgzcMHnj1yh19GLjGcIZgGYPxxQludyLt5N1V2i1/WMiL+IHSwXqgRPvesoESPom6wHiAJxOuIwgYBezv9Sjz30Pf49rYMbGzU3BDm0S85aKtuhTM9HhHWiiYppI614iuuszAUAR4BWq4J5nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEpe9oHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEpe9oHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F00AC4CECF;
	Tue,  3 Dec 2024 16:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241793;
	bh=S8enkUJ4gQ7iM9EXYwORu1jOWQ5mMbBxMKezBXY8ryo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEpe9oHl0R4al+owi/hnOBTl3x9PGhmeHWkk7VL+JEak0JpxhgRZn6vPBz0USbwqH
	 7rPHPSgG1/1N9ecppxSyXo7kzqLr/dwlmV5qFWp/HKbBN4A8d2UDJenBHnxp8nmaXq
	 fsFnkHMSpPvjPaShwpKEOHGZx7+oKXkzNvv8mdXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 519/826] remoteproc: qcom: pas: Remove subdevs on the error path of adsp_probe()
Date: Tue,  3 Dec 2024 15:44:06 +0100
Message-ID: <20241203144804.007862312@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ef82835e98a4e..27b23a000c7ae 100644
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



