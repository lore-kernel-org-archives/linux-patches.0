Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFD811703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24BDC433C9;
	Mon, 21 Aug 2023 19:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647720;
	bh=tBSM+B5fXAEkLBefmnCUPzA49dHFtnjSAUpKJDmvuHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcaE8d6cv6B4Tj6P884bu/oyv8pHQx3ND5tRbO1hYDsXumUAIKUlIeXNQQDtHQC8E
	 a1cI56XoL8a1BZSvXRwHwIwG/GJuhwHFAq03v8oCws/6T+0/KohNuvAck+XqeViMXr
	 bKsH7cPk0GOiQ4qjEt/vm2nJuYL3kTkjDdhW3js4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/194] net: pcs: Add missing put_device call in miic_create
Date: Mon, 21 Aug 2023 21:41:33 +0200
Message-ID: <20230821194127.704489207@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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
index c1424119e8212..847ab37f13671 100644
--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -317,15 +317,21 @@ struct phylink_pcs *miic_create(struct device *dev, struct device_node *np)
 
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



