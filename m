Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7561BA869;
	Tue, 30 Jul 2024 15:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355061; cv=none; b=tPFF6hxCYuo6WEPlvq/9GIzBIE3hAMIOg1sF9E/UvX3mlZkFHcx9BN/MDasAIa0IpMV+rowtohnjXF3yPHdEiaW8nuPBmzGMpKqJXl+BvLFJnNiHykk3eFr+I9W20gzXfKvCBpr2dOUDcuCPEUVo/w+PHA7nlGQaYYKgxr/d89g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355061; c=relaxed/simple;
	bh=SyrFHrM6K0vce7BmjNTaMgWYzkrHHP1fc6XkooMW4E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKP44VGnNMOklI0S7fVGxeQqzt27+y7ToEuu4nnnExHYRPhpwHP4+c8b1hJC2GIKEVDGwrUjhH+XRnX9xsTA0gR/hL3wE0aqoAvVizX2UFcUUiyHIsYykXKOELtCT07tGVn6k5CrjHBsyjrD5H/F38xf1pzZIUhJdKGHn+CgniU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JU0Ci5Uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JU0Ci5Uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04602C32782;
	Tue, 30 Jul 2024 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355061;
	bh=SyrFHrM6K0vce7BmjNTaMgWYzkrHHP1fc6XkooMW4E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JU0Ci5UyzE8Hn/msET901xnfSALrRC14M/deJGw6vTimMBgPG+sVZcc1Z1ttOhPSH
	 tQPwVRDTLG/o8CC22cCFnV4Uqsh89e5QrcAt6LJFC+wExwHp2/mzKeNlLkG/v4ruWE
	 e1Icv31xLmwMNZq22ttw4othazDzhbe5uXyqeY/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steev Klimaszewski <steev@kali.org>,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 048/440] soc: qcom: pdr: protect locator_addr with the main mutex
Date: Tue, 30 Jul 2024 17:44:41 +0200
Message-ID: <20240730151617.639448714@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 107924c14e3ddd85119ca43c26a4ee1056fa9b84 ]

If the service locator server is restarted fast enough, the PDR can
rewrite locator_addr fields concurrently. Protect them by placing
modification of those fields under the main pdr->lock.

Fixes: fbe639b44a82 ("soc: qcom: Introduce Protection Domain Restart helpers")
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Steev Klimaszewski <steev@kali.org>
Tested-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240622-qcom-pd-mapper-v9-1-a84ee3591c8e@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pdr_interface.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/pdr_interface.c b/drivers/soc/qcom/pdr_interface.c
index 0034af927b488..fbf91d7904482 100644
--- a/drivers/soc/qcom/pdr_interface.c
+++ b/drivers/soc/qcom/pdr_interface.c
@@ -76,12 +76,12 @@ static int pdr_locator_new_server(struct qmi_handle *qmi,
 					      locator_hdl);
 	struct pdr_service *pds;
 
+	mutex_lock(&pdr->lock);
 	/* Create a local client port for QMI communication */
 	pdr->locator_addr.sq_family = AF_QIPCRTR;
 	pdr->locator_addr.sq_node = svc->node;
 	pdr->locator_addr.sq_port = svc->port;
 
-	mutex_lock(&pdr->lock);
 	pdr->locator_init_complete = true;
 	mutex_unlock(&pdr->lock);
 
@@ -104,10 +104,10 @@ static void pdr_locator_del_server(struct qmi_handle *qmi,
 
 	mutex_lock(&pdr->lock);
 	pdr->locator_init_complete = false;
-	mutex_unlock(&pdr->lock);
 
 	pdr->locator_addr.sq_node = 0;
 	pdr->locator_addr.sq_port = 0;
+	mutex_unlock(&pdr->lock);
 }
 
 static const struct qmi_ops pdr_locator_ops = {
@@ -365,12 +365,14 @@ static int pdr_get_domain_list(struct servreg_get_domain_list_req *req,
 	if (ret < 0)
 		return ret;
 
+	mutex_lock(&pdr->lock);
 	ret = qmi_send_request(&pdr->locator_hdl,
 			       &pdr->locator_addr,
 			       &txn, SERVREG_GET_DOMAIN_LIST_REQ,
 			       SERVREG_GET_DOMAIN_LIST_REQ_MAX_LEN,
 			       servreg_get_domain_list_req_ei,
 			       req);
+	mutex_unlock(&pdr->lock);
 	if (ret < 0) {
 		qmi_txn_cancel(&txn);
 		return ret;
-- 
2.43.0



