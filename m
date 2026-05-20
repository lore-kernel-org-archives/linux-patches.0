Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2555B3F58D6;
	Wed, 20 May 2026 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300331; cv=none; b=Gts1FSX+8bVOqlHbJ6aj9IDCsJY7R6dKCM8WfgNyO/vQYjteiU96IfZHzLxYlq7m7pAvqz7wyRZ7J/bsqk1vIJNX6OgSxCqEevdgO/lbpaI512qYgYcypPLeETzyaRPPyN6vtvsIg2ETgEsjSSvlx9KCwtA57mT/rSpKUKa3usM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300331; c=relaxed/simple;
	bh=KhLZgjWqj8V6jzKuDr9s/6hiiMlHys2JPm/FBm45UtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrR4szfPoYedYI3hkPdS5sMcHoIMhsDUf6M0Z81fnQVB0MTlNa7mw+TDf+/NzS6c/XooCyZOn9+kO2EBIN74xs47PA+/MgDfAoVniFkAR+T8kFowFUjEu4C1yyjQJu/1Y1VxOuSL18GXn71S9mbHhkNChF3t/lJFfHfVMdekI/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QF7Op7O9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QF7Op7O9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8901E1F000E9;
	Wed, 20 May 2026 18:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300330;
	bh=/ERzw6/wR4vChasmLHaGZkpk5pnSXVAnjSS6JvvnFQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QF7Op7O99BtkuNSHJ/N70TbqqQsX5IJy9TmjQCs1WvJt+ghzkG0cP573rhaxU3inZ
	 qO/w1aSaN7s83nK6RKj1bc3GfFy9PN0Sy+N5zdds/M4Zx0/I4pnHqRdAbF0G4MfG0q
	 qj+d3LYHJIQEWAHH6XAlCjR7pSN6oEemnomMilrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/666] PCI: dwc: Invoke post_init in dw_pcie_resume_noirq()
Date: Wed, 20 May 2026 18:15:46 +0200
Message-ID: <20260520162114.137588418@linuxfoundation.org>
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

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit c577ce2881f9c76892de5ffc1a122e3ef427ecee ]

In some SoCs like i.MX95, CLKREQ# is pulled low by the controller driver
before link up. After link up, if the 'supports-clkreq' property is
specified in DT, the driver will release CLKREQ# so that it can go high and
the endpoint can pull it low whenever required i.e., during exit from L1
Substates.

Hence, at the end of dw_pcie_resume_noirq(), invoke the '.post_init()'
callback if exists to perform the above mentioned action.

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251015030428.2980427-9-hongxing.zhu@nxp.com
Stable-dep-of: edb5ca3262e2 ("PCI: dwc: Perform cleanup in the error path of dw_pcie_resume_noirq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 3e3168204e303..92fd4810f2e21 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -990,6 +990,9 @@ int dw_pcie_resume_noirq(struct dw_pcie *pci)
 	if (ret)
 		return ret;
 
+	if (pci->pp.ops->post_init)
+		pci->pp.ops->post_init(&pci->pp);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dw_pcie_resume_noirq);
-- 
2.53.0



