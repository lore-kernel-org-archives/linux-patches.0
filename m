Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4A98481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2084C4339E;
	Fri, 10 Mar 2023 14:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457334;
	bh=vMw/KvoENkUA9MFbFksvsi+yNjoGUrGvqWqocmtou6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6YULzo+GOTvj7AfoT/tZA53DeORO2/dxxT66rs0S71/NarBhpXGAb8qJbt4ciEV6
	 9DlGflvHcL4sd2kgFGR4FoEwT/rTe75E8wau3UNKnLg9uqsBVfCs31x1k9qC99/4iM
	 /pXztoUxFqdZad21w9784U7N8C4b4gxV93mjOa7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <seanga2@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/200] net: sunhme: Fix region request
Date: Fri, 10 Mar 2023 14:37:58 +0100
Message-Id: <20230310133719.301787649@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Anderson <seanga2@gmail.com>

[ Upstream commit ee0a735fd97ccde766ab557d1fc722c92cebacda ]

devm_request_region is for I/O regions. Use devm_request_mem_region
instead.  This fixes the driver failing to probe since 99df45c9e0a4
("sunhme: fix an IS_ERR() vs NULL check in probe"), which checked the
result.

Fixes: 914d9b2711dd ("sunhme: switch to devres")
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230222204242.2658247-1-seanga2@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/sunhme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 1c16548415cdd..b0c7ab74a82ed 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2894,8 +2894,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		goto err_out_clear_quattro;
 	}
 
-	hpreg_res = devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
-					pci_resource_len(pdev, 0), DRV_NAME);
+	hpreg_res = devm_request_mem_region(&pdev->dev,
+					    pci_resource_start(pdev, 0),
+					    pci_resource_len(pdev, 0),
+					    DRV_NAME);
 	if (!hpreg_res) {
 		err = -EBUSY;
 		dev_err(&pdev->dev, "Cannot obtain PCI resources, aborting.\n");
-- 
2.39.2



