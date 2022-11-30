Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF40C79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BDFC433D6;
	Wed, 30 Nov 2022 18:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833404;
	bh=rB/LLxXBn3AcJDJmCbp0eYXzciCgP3OpmkAVWTTKrDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFUmTwpE2ckuijwDawZchFzq9m3e/9r11sQBqPJvZuD6il/izgFSzuQSZy++8Ym13
	 jDueK2ratq1DEkw588+NHj3hVBp7AAjeB2olknCll8h5+6A3MYh2lMdpXQKK1e99up
	 +mpaYj92v5jQx27zrivZ8jMhylLrDr7XzPtQeQsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/206] net: pch_gbe: fix pci device refcount leak while module exiting
Date: Wed, 30 Nov 2022 19:22:26 +0100
Message-Id: <20221130180535.419779674@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5619537284f1017e9f6c7500b02b859b3830a06d ]

As comment of pci_get_domain_bus_and_slot() says, it returns
a pci device with refcount increment, when finish using it,
the caller must decrement the reference count by calling
pci_dev_put().

In pch_gbe_probe(), pci_get_domain_bus_and_slot() is called,
so in error path in probe() and remove() function, pci_dev_put()
should be called to avoid refcount leak. Compile tested only.

Fixes: 1a0bdadb4e36 ("net/pch_gbe: supports eg20t ptp clock")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221117135148.301014-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 5a42ef6ca762..d555b4cc6049 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2465,6 +2465,7 @@ static void pch_gbe_remove(struct pci_dev *pdev)
 	unregister_netdev(netdev);
 
 	pch_gbe_phy_hw_reset(&adapter->hw);
+	pci_dev_put(adapter->ptp_pdev);
 
 	free_netdev(netdev);
 }
@@ -2540,7 +2541,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	/* setup the private structure */
 	ret = pch_gbe_sw_init(adapter);
 	if (ret)
-		goto err_free_netdev;
+		goto err_put_dev;
 
 	/* Initialize PHY */
 	ret = pch_gbe_init_phy(adapter);
@@ -2598,6 +2599,8 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 
 err_free_adapter:
 	pch_gbe_phy_hw_reset(&adapter->hw);
+err_put_dev:
+	pci_dev_put(adapter->ptp_pdev);
 err_free_netdev:
 	free_netdev(netdev);
 	return ret;
-- 
2.35.1



