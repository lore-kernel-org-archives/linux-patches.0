Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F02F171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A294BC4339B;
	Mon, 22 May 2023 19:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783711;
	bh=U1T2evskaLiklMZRE+CQy1wv86bZejcZV645N5cjG6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw6FFRCuZKek2xIBr8yhS0z7LG4KzXYvOlhdZ4XhIs6o6qJRfYtkQLAANAOmubkRx
	 CusSaCu9kzlQ0T+kvo2bXVgdNiXtPYEDcl4zN2l2HVvwRipIhXrNiiziNNedUqq108
	 pxVB/YYSSXWePgUrqsPjewKr97dMFv370XM9FTNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>,
	Javier Rodriguez <josejavier.rodriguez@duagon.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/292] mcb-pci: Reallocate memory region to avoid memory overlapping
Date: Mon, 22 May 2023 20:08:13 +0100
Message-Id: <20230522190409.365097459@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodríguez Barbarin, José Javier <JoseJavier.Rodriguez@duagon.com>

[ Upstream commit 9be24faadd085c284890c3afcec7a0184642315a ]

mcb-pci requests a fixed-size memory region to parse the chameleon
table, however, if the chameleon table is smaller that the allocated
region, it could overlap with the IP Cores' memory regions.

After parsing the chameleon table, drop/reallocate the memory region
with the actual chameleon table size.

Co-developed-by: Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>
Signed-off-by: Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>
Signed-off-by: Javier Rodriguez <josejavier.rodriguez@duagon.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/20230411083329.4506-3-jth@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mcb/mcb-pci.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/mcb/mcb-pci.c b/drivers/mcb/mcb-pci.c
index dc88232d9af83..53d9202ff9a7c 100644
--- a/drivers/mcb/mcb-pci.c
+++ b/drivers/mcb/mcb-pci.c
@@ -31,7 +31,7 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct resource *res;
 	struct priv *priv;
-	int ret;
+	int ret, table_size;
 	unsigned long flags;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(struct priv), GFP_KERNEL);
@@ -90,7 +90,30 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret < 0)
 		goto out_mcb_bus;
 
-	dev_dbg(&pdev->dev, "Found %d cells\n", ret);
+	table_size = ret;
+
+	if (table_size < CHAM_HEADER_SIZE) {
+		/* Release the previous resources */
+		devm_iounmap(&pdev->dev, priv->base);
+		devm_release_mem_region(&pdev->dev, priv->mapbase, CHAM_HEADER_SIZE);
+
+		/* Then, allocate it again with the actual chameleon table size */
+		res = devm_request_mem_region(&pdev->dev, priv->mapbase,
+						table_size,
+						KBUILD_MODNAME);
+		if (!res) {
+			dev_err(&pdev->dev, "Failed to request PCI memory\n");
+			ret = -EBUSY;
+			goto out_mcb_bus;
+		}
+
+		priv->base = devm_ioremap(&pdev->dev, priv->mapbase, table_size);
+		if (!priv->base) {
+			dev_err(&pdev->dev, "Cannot ioremap\n");
+			ret = -ENOMEM;
+			goto out_mcb_bus;
+		}
+	}
 
 	mcb_bus_add_devices(priv->bus);
 
-- 
2.39.2



