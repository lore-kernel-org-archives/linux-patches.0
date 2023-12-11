Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20849FC06;
	Mon, 11 Dec 2023 18:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUl2BvyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8F3C433C8;
	Mon, 11 Dec 2023 18:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320143;
	bh=KkfQjITq/nggrnRzVmwKTlqJF6+L5RQ/Uu7Wmx9vNwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUl2BvyKrglncc/nyVc9NUVWP8btlkfyXkT5/5QYsmVl6L1+0XVsFTwrlnqCInHrA
	 6rViv17vbq2BnxnmYQwsWktthuY3WVgzb6bMvXrLqcXNUvq7fEKqvBLddRH9IpbLEB
	 wKEMx/pbku+WgeAKNMjkX7aVNjzQkOFYrDbrMcyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tong Zhang <ztong0001@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/67] net: arcnet: com20020 fix error handling
Date: Mon, 11 Dec 2023 19:22:04 +0100
Message-ID: <20231211182015.955987464@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 6577b9a551aedb86bca6d4438c28386361845108 ]

There are two issues when handling error case in com20020pci_probe()

1. priv might be not initialized yet when calling com20020pci_remove()
from com20020pci_probe(), since the priv is set at the very last but it
can jump to error handling in the middle and priv remains NULL.
2. memory leak - the net device is allocated in alloc_arcdev but not
properly released if error happens in the middle of the big for loop

[    1.529110] BUG: kernel NULL pointer dereference, address: 0000000000000008
[    1.531447] RIP: 0010:com20020pci_remove+0x15/0x60 [com20020_pci]
[    1.536805] Call Trace:
[    1.536939]  com20020pci_probe+0x3f2/0x48c [com20020_pci]
[    1.537226]  local_pci_probe+0x48/0x80
[    1.539918]  com20020pci_init+0x3f/0x1000 [com20020_pci]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6b17a597fc2f ("arcnet: restoring support for multiple Sohard Arcnet cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/arcnet/com20020-pci.c | 34 +++++++++++++++++--------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index b4f8798d8c509..28dccbc0e8d8f 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -127,6 +127,8 @@ static int com20020pci_probe(struct pci_dev *pdev,
 	int i, ioaddr, ret;
 	struct resource *r;
 
+	ret = 0;
+
 	if (pci_enable_device(pdev))
 		return -EIO;
 
@@ -142,6 +144,8 @@ static int com20020pci_probe(struct pci_dev *pdev,
 	priv->ci = ci;
 	mm = &ci->misc_map;
 
+	pci_set_drvdata(pdev, priv);
+
 	INIT_LIST_HEAD(&priv->list_dev);
 
 	if (mm->size) {
@@ -164,7 +168,7 @@ static int com20020pci_probe(struct pci_dev *pdev,
 		dev = alloc_arcdev(device);
 		if (!dev) {
 			ret = -ENOMEM;
-			goto out_port;
+			break;
 		}
 		dev->dev_port = i;
 
@@ -181,7 +185,7 @@ static int com20020pci_probe(struct pci_dev *pdev,
 			pr_err("IO region %xh-%xh already allocated\n",
 			       ioaddr, ioaddr + cm->size - 1);
 			ret = -EBUSY;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 
 		/* Dummy access after Reset
@@ -219,18 +223,18 @@ static int com20020pci_probe(struct pci_dev *pdev,
 		if (arcnet_inb(ioaddr, COM20020_REG_R_STATUS) == 0xFF) {
 			pr_err("IO address %Xh is empty!\n", ioaddr);
 			ret = -EIO;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 		if (com20020_check(dev)) {
 			ret = -EIO;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 
 		card = devm_kzalloc(&pdev->dev, sizeof(struct com20020_dev),
 				    GFP_KERNEL);
 		if (!card) {
 			ret = -ENOMEM;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 
 		card->index = i;
@@ -256,29 +260,29 @@ static int com20020pci_probe(struct pci_dev *pdev,
 
 		ret = devm_led_classdev_register(&pdev->dev, &card->tx_led);
 		if (ret)
-			goto out_port;
+			goto err_free_arcdev;
 
 		ret = devm_led_classdev_register(&pdev->dev, &card->recon_led);
 		if (ret)
-			goto out_port;
+			goto err_free_arcdev;
 
 		dev_set_drvdata(&dev->dev, card);
 
 		ret = com20020_found(dev, IRQF_SHARED);
 		if (ret)
-			goto out_port;
+			goto err_free_arcdev;
 
 		devm_arcnet_led_init(dev, dev->dev_id, i);
 
 		list_add(&card->list, &priv->list_dev);
-	}
+		continue;
 
-	pci_set_drvdata(pdev, priv);
-
-	return 0;
-
-out_port:
-	com20020pci_remove(pdev);
+err_free_arcdev:
+		free_arcdev(dev);
+		break;
+	}
+	if (ret)
+		com20020pci_remove(pdev);
 	return ret;
 }
 
-- 
2.42.0



