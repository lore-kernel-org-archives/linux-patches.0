Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041F620B00
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6OJ0igT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76992C433C7;
	Mon,  6 Nov 2023 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276217;
	bh=3FpPnofoFrcLfNCoVhgvo13INBBmTRzcRoo7K+ooXmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6OJ0igT1wTP77wSa8zk/degsVnvS8Yur4zGF+YnPjJNFAl4+euPJDCK6TaiI3aIv
	 daYzdPgoENQ76DtQV1JVsl+SLlWDk81xBTwVNIKjG8W0oH6b/ilT59GISgbrxrCO9Y
	 fOuP4tGBE9zMQPjMd/9XOLmOqQC0GJhWVhib4cAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>,
	Javier Rodriguez <josejavier.rodriguez@duagon.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/61] mcb-lpc: Reallocate memory region to avoid memory overlapping
Date: Mon,  6 Nov 2023 14:03:01 +0100
Message-ID: <20231106130259.757412753@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodríguez Barbarin, José Javier <JoseJavier.Rodriguez@duagon.com>

[ Upstream commit 2025b2ca8004c04861903d076c67a73a0ec6dfca ]

mcb-lpc requests a fixed-size memory region to parse the chameleon
table, however, if the chameleon table is smaller that the allocated
region, it could overlap with the IP Cores' memory regions.

After parsing the chameleon table, drop/reallocate the memory region
with the actual chameleon table size.

Co-developed-by: Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>
Signed-off-by: Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>
Signed-off-by: Javier Rodriguez <josejavier.rodriguez@duagon.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/20230411083329.4506-4-jth@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mcb/mcb-lpc.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/mcb/mcb-lpc.c b/drivers/mcb/mcb-lpc.c
index 945091a883546..7d292acbba539 100644
--- a/drivers/mcb/mcb-lpc.c
+++ b/drivers/mcb/mcb-lpc.c
@@ -26,7 +26,7 @@ static int mcb_lpc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct priv *priv;
-	int ret = 0;
+	int ret = 0, table_size;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -61,16 +61,43 @@ static int mcb_lpc_probe(struct platform_device *pdev)
 
 	ret = chameleon_parse_cells(priv->bus, priv->mem->start, priv->base);
 	if (ret < 0) {
-		mcb_release_bus(priv->bus);
-		return ret;
+		goto out_mcb_bus;
 	}
 
-	dev_dbg(&pdev->dev, "Found %d cells\n", ret);
+	table_size = ret;
+
+	if (table_size < CHAM_HEADER_SIZE) {
+		/* Release the previous resources */
+		devm_iounmap(&pdev->dev, priv->base);
+		devm_release_mem_region(&pdev->dev, priv->mem->start, resource_size(priv->mem));
+
+		/* Then, allocate it again with the actual chameleon table size */
+		res = devm_request_mem_region(&pdev->dev, priv->mem->start,
+					      table_size,
+					      KBUILD_MODNAME);
+		if (!res) {
+			dev_err(&pdev->dev, "Failed to request PCI memory\n");
+			ret = -EBUSY;
+			goto out_mcb_bus;
+		}
+
+		priv->base = devm_ioremap(&pdev->dev, priv->mem->start, table_size);
+		if (!priv->base) {
+			dev_err(&pdev->dev, "Cannot ioremap\n");
+			ret = -ENOMEM;
+			goto out_mcb_bus;
+		}
+
+		platform_set_drvdata(pdev, priv);
+	}
 
 	mcb_bus_add_devices(priv->bus);
 
 	return 0;
 
+out_mcb_bus:
+	mcb_release_bus(priv->bus);
+	return ret;
 }
 
 static int mcb_lpc_remove(struct platform_device *pdev)
-- 
2.42.0



