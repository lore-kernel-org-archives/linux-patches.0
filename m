Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCB82690FB;
	Tue,  8 Apr 2025 12:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113601; cv=none; b=DsSeZdguP90ppzVVDhmrS9Q7DRpO3L9TzqlUznE3cWGV5mfMm4ChHLYy2tGhs0oWzDlAXkrV8gjXsruWe/KhMZI1aTNTLmdFj8Pl4HbdiTTkPzUirW/Q5UndT67pDWeHQLRCOL00X/YuCwaMrPOuihBG6qLeyiMGT30w08r31/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113601; c=relaxed/simple;
	bh=5SWyBvnXChl+Ib7VDzNZPaG8YgFR3CiG7TcYTctKCCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CerBw9ilV4VKOyC715Srfl6dAc5QG3R+NDlodrkJudifyZ9WovR0HHR8l698aA7b0/Hrgc0lcb048dMTLGAQBCviQfvZKkPiwLmpoIQoud4xgmpEGKMfgAnvBLYfqoiZZv46zaYEEoEUXOJKMVFd8zg0Ixz+D96mT5DRCZRPmTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIFigsPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIFigsPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF73C4CEE5;
	Tue,  8 Apr 2025 12:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113601;
	bh=5SWyBvnXChl+Ib7VDzNZPaG8YgFR3CiG7TcYTctKCCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIFigsPv6GrrF4FEGC1LTrtJ83ShSyj6+DeI2P1c+JCPIbP3X5TWaUjWMIPTUTFpp
	 XTEp8zbRl8ivjNR1PQLZj+TTG55A1Gs1pliYA5+7tGyxQ41C9KH2sgWVEWFugWeCtY
	 TRJdgAj2C8TpoBHs1vUU3VTblEjXqOsfymbaKmXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/268] arcnet: Add NULL check in com20020pci_probe()
Date: Tue,  8 Apr 2025 12:50:31 +0200
Message-ID: <20250408104834.518873160@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit fda8c491db2a90ff3e6fbbae58e495b4ddddeca3 ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
com20020pci_probe() does not check for this case, which results in a
NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue and ensure
no resources are left allocated.

Fixes: 6b17a597fc2f ("arcnet: restoring support for multiple Sohard Arcnet cards")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://patch.msgid.link/20250402135036.44697-1-bsdhenrymartin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/arcnet/com20020-pci.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 7b5c8bb02f119..e7db6a4e4dc9d 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -250,18 +250,33 @@ static int com20020pci_probe(struct pci_dev *pdev,
 			card->tx_led.default_trigger = devm_kasprintf(&pdev->dev,
 							GFP_KERNEL, "arc%d-%d-tx",
 							dev->dev_id, i);
+			if (!card->tx_led.default_trigger) {
+				ret = -ENOMEM;
+				goto err_free_arcdev;
+			}
 			card->tx_led.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 							"pci:green:tx:%d-%d",
 							dev->dev_id, i);
-
+			if (!card->tx_led.name) {
+				ret = -ENOMEM;
+				goto err_free_arcdev;
+			}
 			card->tx_led.dev = &dev->dev;
 			card->recon_led.brightness_set = led_recon_set;
 			card->recon_led.default_trigger = devm_kasprintf(&pdev->dev,
 							GFP_KERNEL, "arc%d-%d-recon",
 							dev->dev_id, i);
+			if (!card->recon_led.default_trigger) {
+				ret = -ENOMEM;
+				goto err_free_arcdev;
+			}
 			card->recon_led.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 							"pci:red:recon:%d-%d",
 							dev->dev_id, i);
+			if (!card->recon_led.name) {
+				ret = -ENOMEM;
+				goto err_free_arcdev;
+			}
 			card->recon_led.dev = &dev->dev;
 
 			ret = devm_led_classdev_register(&pdev->dev, &card->tx_led);
-- 
2.39.5



