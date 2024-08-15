Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DBB1714A8;
	Thu, 15 Aug 2024 13:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729206; cv=none; b=RBSCMYjqGC4R5Ok4wxI+/iN5s1Y4epUR3iFK5vDguNBgcGdC6VHaJAZtPDYEBOF78POH8WgdXZrDTgoUc4agTsiGKFJYhpwqR0g+/RMzgaIYvTMjjR26iU9+ZJwEiLLPIQBFLd73umUJzrYiFflG+iOItQs4/dzUcRLLfD/OVPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729206; c=relaxed/simple;
	bh=D6D7oop62HjEo+w/e/5AnVsSpp1mTPPrHNGVtSpn4jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRAz7b8n6bqQpU/nX5DiaJOF6LovVstacC1jTZ6bFheDRZ1jYkRTdmUS0tLDCNBntXaOUSEnBAsFMdezj+HSRhc9D03bFcs95pSw/eEZ73WqaaS12FcbE5vVlMBosByBz0wwMHeTM2mAv0o9t5aoASTFWhjpYVgtX+Eh8TUbAwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmSaxKU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmSaxKU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AC9C32786;
	Thu, 15 Aug 2024 13:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729206;
	bh=D6D7oop62HjEo+w/e/5AnVsSpp1mTPPrHNGVtSpn4jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmSaxKU908PVVNvEVJh8DgBQ+5FUTrj274hiCtgBx4PGqITkLBzueRKs0IzQ3EAUs
	 92xbkkYM9ma0s2hpq1y11RURm5OrC+F/a+QQ1B15lBL4iiHUh69fKLSKtnGwpU2wOt
	 wUX7zy3+ZaQ3mX1m0y+++D27WSVdJGC20tcOS7ak=
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
Subject: [PATCH 5.15 024/484] soc: qcom: pdr: protect locator_addr with the main mutex
Date: Thu, 15 Aug 2024 15:18:02 +0200
Message-ID: <20240815131942.207704270@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 915d5bc3d46e6..b308d942bbd6c 100644
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
@@ -366,12 +366,14 @@ static int pdr_get_domain_list(struct servreg_get_domain_list_req *req,
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



