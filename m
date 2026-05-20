Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C404A3F787E;
	Wed, 20 May 2026 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300333; cv=none; b=ARawW5Y/oCehsHG+b/qXlq4uo3aUyz8U9aqvqTT7/m3mRv22CujlxwCcCt8Krtu78YGle1GfBjWraiJNWCmZ0TzxxY3GORknQOiVeFTWlfygSImDTsTp2pevjzNelvtP3v3pOO04FFbpwe6y5r17L1g3mGVE+FZODonFmGZL4Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300333; c=relaxed/simple;
	bh=TZ1iOJylTw8zv+8PWUzMW8aEsutTfwL5A2sZ+vBmzYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPxb8llJOYfNP2KtZUm+yjYSmG5q2e0AUhgIK265zo2wxESBRHMkQiOZHONINikzdJW/tFxO/nbqa3CRXkN42SM2V1twq5GS7fzDPNQ8KJ0MfflY2MsgzbAdRIhVn3jLq7khYq7Lohjw/lqr6BAZDEBJDvWsSizBnmT5uuFriE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izqeNkAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izqeNkAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CDA1F000E9;
	Wed, 20 May 2026 18:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300332;
	bh=kgRat6izESs+6rNqUV7TUz8ItXctLU10CfhaQnChsrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izqeNkAuF3ytGTfSzQ4LtstHexz/hNQByToWEw0X/9RczdRRYbSLO8BrjwOyt7hHT
	 HxdQ+HRSVuX0NURBmQYNflkPCpEc9wivr++zdYOJFEN3H28q7IEEdVaQRaZSdLP8qu
	 62W3HaVu9u/HhUE4Z/rJ8b+dD0HOTATGBe1dPeuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senchuan Zhang <zhangsenchuan@eswincomputing.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/666] PCI: dwc: Perform cleanup in the error path of dw_pcie_resume_noirq()
Date: Wed, 20 May 2026 18:15:47 +0200
Message-ID: <20260520162114.158563981@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 92fd4810f2e21..deda5b040d7a0 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -984,15 +984,24 @@ int dw_pcie_resume_noirq(struct dw_pcie *pci)
 
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



