Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6B4129EC8;
	Mon, 18 Dec 2023 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUI6kxCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4139EC433C8;
	Mon, 18 Dec 2023 13:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907834;
	bh=eNyj66gX066jB/dJiawrOowG6euyfmsRQYRle+3gojs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUI6kxCuE/DQBqT7yli9y1laTLjnoI0bOu8RxqRuIm+AR38ZJCxXjPCxgFk9rXo0j
	 W72qBG5Vk6iEXwo6e5IOOgALtpuGo9cM6QnD/HvGXCbssSptBi6tVsPJ0YpoFE4Rvc
	 E+r4F3mKi0OBBj3QKPRHXBW1RxoKOOUoNjeub+lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <siyanteng@loongson.cn>,
	Feiyang Chen <chenfeiyang@loongson.cn>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/106] stmmac: dwmac-loongson: Make sure MDIO is initialized before use
Date: Mon, 18 Dec 2023 14:50:49 +0100
Message-ID: <20231218135056.539273642@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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

From: Yanteng Si <siyanteng@loongson.cn>

[ Upstream commit e87d3a1370ce9f04770d789bcf7cce44865d2e8d ]

Generic code will use mdio. If it is not initialized before use,
the kernel will Oops.

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index a25c187d31853..49c7aa86faaa8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -68,17 +68,15 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (!plat)
 		return -ENOMEM;
 
+	plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
+					   sizeof(*plat->mdio_bus_data),
+					   GFP_KERNEL);
+	if (!plat->mdio_bus_data)
+		return -ENOMEM;
+
 	plat->mdio_node = of_get_child_by_name(np, "mdio");
 	if (plat->mdio_node) {
 		dev_info(&pdev->dev, "Found MDIO subnode\n");
-
-		plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
-						   sizeof(*plat->mdio_bus_data),
-						   GFP_KERNEL);
-		if (!plat->mdio_bus_data) {
-			ret = -ENOMEM;
-			goto err_put_node;
-		}
 		plat->mdio_bus_data->needs_reset = true;
 	}
 
-- 
2.43.0



