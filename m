Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE82C4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DDDC433D6;
	Mon, 14 Nov 2022 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431205;
	bh=r1AEeOc2vhYyxOawqbiSE9gC+rtW6aTqa4JrE+XWZRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2ETNNYrGAQvP5eJHGieNernbuSCP+2+cBxrwfeOOFk6wcXjw47J1HQSdTIQejmve
	 ex36tD6GiNeVlLi3SGTLXoalIH/NSmb4KMNAYfggS8flY8z+zUCIxqnOtVZIBK9c1E
	 LKsykXqoSR7hnjNKcwaxTR1f6bHXZ1WiiXDfcPI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 109/190] ethernet: tundra: free irq when alloc ring failed in tsi108_open()
Date: Mon, 14 Nov 2022 13:45:33 +0100
Message-Id: <20221114124503.447470593@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit acce40037041f97baad18142bb253064491ebde3 ]

When alloc tx/rx ring failed in tsi108_open(), it doesn't free irq. Fix
it.

Fixes: 5e123b844a1c ("[PATCH] Add tsi108/9 On Chip Ethernet device driver support")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109044016.126866-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/tundra/tsi108_eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 5251fc324221..a2fe0534c769 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1303,12 +1303,15 @@ static int tsi108_open(struct net_device *dev)
 
 	data->rxring = dma_alloc_coherent(&data->pdev->dev, rxring_size,
 					  &data->rxdma, GFP_KERNEL);
-	if (!data->rxring)
+	if (!data->rxring) {
+		free_irq(data->irq_num, dev);
 		return -ENOMEM;
+	}
 
 	data->txring = dma_alloc_coherent(&data->pdev->dev, txring_size,
 					  &data->txdma, GFP_KERNEL);
 	if (!data->txring) {
+		free_irq(data->irq_num, dev);
 		dma_free_coherent(&data->pdev->dev, rxring_size, data->rxring,
 				    data->rxdma);
 		return -ENOMEM;
-- 
2.35.1



