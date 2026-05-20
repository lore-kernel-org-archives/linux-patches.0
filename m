Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC94336A376;
	Wed, 20 May 2026 16:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295036; cv=none; b=frbzWoi75BiikaEe9xxkJ2WuNVV2P31AQvGRKyEXIfxUorh+KVyPm0IOSGgk+JoCNBIEmpZuHev77ZOGK2uKiIfCLm79LzidmYZvLM/MfdDzg2FnUIArTX3wYT5liZzry7LLRjdwN0IXNMb265BCqFX8iNjjzU96qfugAcroA5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295036; c=relaxed/simple;
	bh=afCNoqytbfD8CqKUt2nBQg5FgYP5xtKWxaxojA0sSVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMjA9+cDcGYdDlf7wheH+/CXznygeSU7vTHX+zUQP7PNmD1CnUdFWAj0NHxCO2eOZzWjdGWM7TtyCvwB2X2b/iKUwJCjKUlPaS+ieZJXa/sI1aup4b8/dkAuW8k/7DqVSDS65N8VFoMplbl4QWbwn0v5IAng+cim42Cj29QqQAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U239HRYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U239HRYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7101F000E9;
	Wed, 20 May 2026 16:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295034;
	bh=X9c4FNvBEdgHaBe6FZdfAoxDibpeTxSnzuL9MTntKDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U239HRYQTuvRp90wmwIhxR2zN7xY0Y8mf+dvSa8Xw3MlI5k44+XmC4yYadyoz5BfJ
	 oyeSXmZ7Z/yRlkUErz5jnrYL4OHwdiuzHAOFLhgJyTSBKv+26lFUtEqocADf/S92NB
	 ZOLrs4I1TZxuGQ7wm1y1UnAacWNpWYd42l8n75C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senchuan Zhang <zhangsenchuan@eswincomputing.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0267/1146] PCI: dwc: Perform cleanup in the error path of dw_pcie_resume_noirq()
Date: Wed, 20 May 2026 18:08:37 +0200
Message-ID: <20260520162154.267267637@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit edb5ca3262e2255cf938a5948709d3472d4871ad ]

If the dw_pcie_resume_noirq() API fails, it just returns the errno without
doing cleanup in the error path, leading to resource leak.

So perform cleanup in the error path.

Fixes: 4774faf854f5 ("PCI: dwc: Implement generic suspend/resume functionality")
Reported-by: Senchuan Zhang <zhangsenchuan@eswincomputing.com>
Closes: https://lore.kernel.org/linux-pci/78296255.3869.19c8eb694d6.Coremail.zhangsenchuan@eswincomputing.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260226133951.296743-1-mani@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 6ae6189e9b8a9..c3c2dec728eea 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -1300,15 +1300,24 @@ int dw_pcie_resume_noirq(struct dw_pcie *pci)
 
 	ret = dw_pcie_start_link(pci);
 	if (ret)
-		return ret;
+		goto err_deinit;
 
 	ret = dw_pcie_wait_for_link(pci);
-	if (ret)
-		return ret;
+	if (ret == -ETIMEDOUT)
+		goto err_stop_link;
 
 	if (pci->pp.ops->post_init)
 		pci->pp.ops->post_init(&pci->pp);
 
+	return 0;
+
+err_stop_link:
+	dw_pcie_stop_link(pci);
+
+err_deinit:
+	if (pci->pp.ops->deinit)
+		pci->pp.ops->deinit(&pci->pp);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dw_pcie_resume_noirq);
-- 
2.53.0



