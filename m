Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC8728ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0E9C433EF;
	Mon, 12 Dec 2022 13:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853344;
	bh=Yz4IWoaD/1jrYD70qwoW9jTUOnjMMgh4ekG5lLvdXmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q01kt6VQsZlcFt+9gpsXhsKD5qoWgWEYL0D7qS9Q2tMGVrDZJXHc1ubwi5TDGVxH+
	 dVjdtG4A7QFOvyKz76nU8DUpKJ/u8AFFbtUSYZuk+jmfCrRM+qDf5E1NqgLMMmy8//
	 pBiDyfqMiWWjJm+hEj4HDx7u2orZ3DB4m45vWlrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 28/31] ethernet: aeroflex: fix potential skb leak in greth_init_rings()
Date: Mon, 12 Dec 2022 14:19:46 +0100
Message-Id: <20221212130911.538099670@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
References: <20221212130909.943483205@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 063a932b64db3317ec020c94466fe52923a15f60 ]

The greth_init_rings() function won't free the newly allocated skb when
dma_mapping_error() returns error, so add dev_kfree_skb() to fix it.

Compile tested only.

Fixes: d4c41139df6e ("net: Add Aeroflex Gaisler 10/100/1G Ethernet MAC driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/1670134149-29516-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aeroflex/greth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 31e02ca56572..aa2d1b088df6 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -261,6 +261,7 @@ static int greth_init_rings(struct greth_private *greth)
 			if (dma_mapping_error(greth->dev, dma_addr)) {
 				if (netif_msg_ifup(greth))
 					dev_err(greth->dev, "Could not create initial DMA mapping\n");
+				dev_kfree_skb(skb);
 				goto cleanup;
 			}
 			greth->rx_skbuff[i] = skb;
-- 
2.35.1



