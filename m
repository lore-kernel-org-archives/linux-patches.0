Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB621171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE6DC433C8;
	Mon, 21 Aug 2023 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648351;
	bh=Fie8AtBgF1CncOa9vCsuWh5AKjr2wnVKnrqVdiDvHzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liBPuPYCMm1xcixAZUTln4eI3PRgif0y1fYzQkaD0ta5R75H8U2IPIlyZ5kd2wG5M
	 ZqsyCjNVNp6MO6aa+PtbhNTVIj4UYi6YxWSBb/I+xIM+CPhxebXGoJQyi/oD5WVL5J
	 nGhQe85EDV1ai2dixWny7Ci3yVmE5bP7oVX2GtWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 144/234] net: pcs: Add missing put_device call in miic_create
Date: Mon, 21 Aug 2023 21:41:47 +0200
Message-ID: <20230821194135.200036443@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiang Yang <xiangyang3@huawei.com>

[ Upstream commit 829c6524d6729d05a82575dbcc16f99be5ee843d ]

The reference of pdev->dev is taken by of_find_device_by_node, so
it should be released when not need anymore.

Fixes: 7dc54d3b8d91 ("net: pcs: add Renesas MII converter driver")
Signed-off-by: Xiang Yang <xiangyang3@huawei.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-rzn1-miic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-miic.c
index 323bec5e57f83..3560991690038 100644
--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -313,15 +313,21 @@ struct phylink_pcs *miic_create(struct device *dev, struct device_node *np)
 
 	pdev = of_find_device_by_node(pcs_np);
 	of_node_put(pcs_np);
-	if (!pdev || !platform_get_drvdata(pdev))
+	if (!pdev || !platform_get_drvdata(pdev)) {
+		if (pdev)
+			put_device(&pdev->dev);
 		return ERR_PTR(-EPROBE_DEFER);
+	}
 
 	miic_port = kzalloc(sizeof(*miic_port), GFP_KERNEL);
-	if (!miic_port)
+	if (!miic_port) {
+		put_device(&pdev->dev);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	miic = platform_get_drvdata(pdev);
 	device_link_add(dev, miic->dev, DL_FLAG_AUTOREMOVE_CONSUMER);
+	put_device(&pdev->dev);
 
 	miic_port->miic = miic;
 	miic_port->port = port - 1;
-- 
2.40.1



