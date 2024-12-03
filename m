Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4265723CE;
	Tue,  3 Dec 2024 16:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241797; cv=none; b=fDznBNhixSK6QdNgez1fbWWz1V0doQsaSjNA6HwN/fVwdIEMrHf179FPN46Atx6k4drZsluzW2M224t8y+vam75hnjQA51sRBun0vK8pXc51+a2x8iKo9i7rHNUAMf3Pok+1RZ79QF7PmNmMvZEXXVIgx78NEiHdG9e99BX9NZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241797; c=relaxed/simple;
	bh=f1at/vdZXcrkzDjoIQnZ0hMIgk7lv5VddRCvLhe/p3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQIpnpEQ2qmLWQyXNdTTbfc/ahJIhiwjT3Oz8IOhJCFpSA7PdtMVPRUJCEmwBI641OpISDjVmY/7Mo6evM/NgNnxKPymgdMWVEmQkIxwTw/jQaYbSFHjae4T3KsDngEfJ/lUard8dSPY13FdPRZlgSUbIplTm6apjEz4Jts6srU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vp4j/2MG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vp4j/2MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68A1C4CECF;
	Tue,  3 Dec 2024 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241797;
	bh=f1at/vdZXcrkzDjoIQnZ0hMIgk7lv5VddRCvLhe/p3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vp4j/2MGIVMFYecVQYJK4ylGlEsLfOwS6YKgYq7lDmLoD0AoG6Zam6EqquMEF5/j1
	 xzmiH8hVnEh0OKAl+FgIJlbVOPkJ/Kd0rmrLLvhkXHJbGc7nYOkM0B5bi3gPwvK/JQ
	 h521rVXDSZhrpQUiXs/d7ZN6jkErdJ87yhc5Nkhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 520/826] remoteproc: qcom: adsp: Remove subdevs on the error path of adsp_probe()
Date: Tue,  3 Dec 2024 15:44:07 +0100
Message-ID: <20241203144804.046291303@linuxfoundation.org>
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



