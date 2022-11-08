Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99E215CAF
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3959C433C1;
	Tue,  8 Nov 2022 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916068;
	bh=pyUg1ELiTpeSPM5xWlY5ivnmPGO6RWR9CpolmE2vxMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PgwTGk6qKcwMP9sOaFjPVfOGQP1XbzLl1gHxVcGSxYiyHOWUFF1MTRv+rmm6LmBt9
	 xCBGcIJiM5aLixhAXgvl9VzOO/Dh+0DOsr+Y9nD3xwGXjpSsyDjMtCIbybTgF86zml
	 R0GQt23C8vYCt+gCqdPJV4oh/Og6bUkDclrxGOsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Peibao <liupeibao@loongson.cn>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/144] stmmac: dwmac-loongson: fix invalid mdio_node
Date: Tue,  8 Nov 2022 14:38:51 +0100
Message-Id: <20221108133347.548970104@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Peibao <liupeibao@loongson.cn>

[ Upstream commit 2ae34111fe4eebb69986f6490015b57c88804373 ]

In current code "plat->mdio_node" is always NULL, the mdio
support is lost as there is no "mdio_bus_data". The original
driver could work as the "mdio" variable is never set to
false, which is described in commit <b0e03950dd71> ("stmmac:
dwmac-loongson: fix uninitialized variable ......"). And
after this commit merged, the "mdio" variable is always
false, causing the mdio supoort logic lost.

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Liu Peibao <liupeibao@loongson.cn>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221101060218.16453-1-liupeibao@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index ecf759ee1c9f..220bb454626c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -51,7 +51,6 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	struct stmmac_resources res;
 	struct device_node *np;
 	int ret, i, phy_mode;
-	bool mdio = false;
 
 	np = dev_of_node(&pdev->dev);
 
@@ -69,12 +68,10 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (!plat)
 		return -ENOMEM;
 
+	plat->mdio_node = of_get_child_by_name(np, "mdio");
 	if (plat->mdio_node) {
-		dev_err(&pdev->dev, "Found MDIO subnode\n");
-		mdio = true;
-	}
+		dev_info(&pdev->dev, "Found MDIO subnode\n");
 
-	if (mdio) {
 		plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
 						   sizeof(*plat->mdio_bus_data),
 						   GFP_KERNEL);
-- 
2.35.1



