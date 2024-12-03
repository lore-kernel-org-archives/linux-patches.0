Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6549B1F7566;
	Tue,  3 Dec 2024 15:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239206; cv=none; b=ZBYRWZVahXgtX8rN85haAI96KuhmAJPNm+LFTKOEupl1ejQjzQh4bWJa7anR9Umz3EM2iA+/sJCELLKN4Yc87+F9xg1vVtYAnu1+ca/ahb/xZQrdeVWsMjXs0r+Pm3zwgUvM4QH7TdklV/EMltqrheiLwozhBTUiWnwDOFEbImY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239206; c=relaxed/simple;
	bh=ytCMnM81aM0eHn3W9OueEmiS2Tr56KEZr8sp4vg5uzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeVzV+01CVJFjWqzfUEIB7XeH8uqeGdGBOMtALcjTGiq43ALuHZiu70cmEaW+lgI9jTeMHZl0RL2rosRA5O11836fEUO8II+hMJGfkPoh9gMO7XArMwk/NJtiO0HtDTcyLaeq+HbKCQG6PwV1naw1kcvi5T+6Xu40Q1nA4KB3K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmFZdxUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmFZdxUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7877EC4CECF;
	Tue,  3 Dec 2024 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239205;
	bh=ytCMnM81aM0eHn3W9OueEmiS2Tr56KEZr8sp4vg5uzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmFZdxUfc3LENEG+SuuJksCClIhoo2ovwI9GOGmQBqDFbqg5neosk3V66FGfX7Xeo
	 4QvPmYwuib/lHKECTj8kcYAbXh4J84rQNgEqFTTOQmty0ttq7nx+uloMFOqq66Fea2
	 qBED27r4pOQPWnzURObj6q4hIfsTLpaUyrY/F9ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 535/817] remoteproc: qcom: adsp: Remove subdevs on the error path of adsp_probe()
Date: Tue,  3 Dec 2024 15:41:47 +0100
Message-ID: <20241203144016.783299532@linuxfoundation.org>
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

[ Upstream commit fe80d3205e91e36e67f4d3d6c326793298d15766 ]

Current implementation of adsp_probe() in qcom_q6v5_adsp.c and does not
remove the subdevs of adsp on the error path. Fix this bug by calling
qcom_remove_{ssr,sysmon,pdm,smd,glink}_subdev(), and qcom_q6v5_deinit()
appropriately.

Fixes: dc160e449122 ("remoteproc: qcom: Introduce Non-PAS ADSP PIL driver")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://lore.kernel.org/r/fed3df4219543d46b88bacf87990d947f3fac8d7.1731038950.git.joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_adsp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_adsp.c b/drivers/remoteproc/qcom_q6v5_adsp.c
index 572dcb0f055b7..223f6ca0745d3 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -734,15 +734,22 @@ static int adsp_probe(struct platform_device *pdev)
 					      desc->ssctl_id);
 	if (IS_ERR(adsp->sysmon)) {
 		ret = PTR_ERR(adsp->sysmon);
-		goto disable_pm;
+		goto deinit_remove_glink_pdm_ssr;
 	}
 
 	ret = rproc_add(rproc);
 	if (ret)
-		goto disable_pm;
+		goto remove_sysmon;
 
 	return 0;
 
+remove_sysmon:
+	qcom_remove_sysmon_subdev(adsp->sysmon);
+deinit_remove_glink_pdm_ssr:
+	qcom_q6v5_deinit(&adsp->q6v5);
+	qcom_remove_glink_subdev(rproc, &adsp->glink_subdev);
+	qcom_remove_pdm_subdev(rproc, &adsp->pdm_subdev);
+	qcom_remove_ssr_subdev(rproc, &adsp->ssr_subdev);
 disable_pm:
 	qcom_rproc_pds_detach(adsp);
 
-- 
2.43.0



