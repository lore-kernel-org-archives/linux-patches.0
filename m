Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4C728ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6943FC433F0;
	Mon, 12 Dec 2022 13:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853209;
	bh=AuOUX6Q8A6O4fglwPRxv5J01FYk//ZB99Zo1bht5BD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cEMSZ8U9lTmh5+isyjNOqBuBfDzN2NIcLGz2fU8f//s3DBCIjnOoYbxy5rejb6k6
	 fmBGMI1oWRbVGsJAk0ANJapSjKCtM0V12qrMVYF8BuO9uuZEVth7WNk08SycpTUlZ0
	 a/NV2qocQptcQtkGuFM8/0iD7/p8EPM1VBnklKqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/38] ethernet: aeroflex: fix potential skb leak in greth_init_rings()
Date: Mon, 12 Dec 2022 14:19:35 +0100
Message-Id: <20221212130913.811434529@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
References: <20221212130912.069170932@linuxfoundation.org>
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
index a20e95b39cf7..4df8da8f5e7e 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -262,6 +262,7 @@ static int greth_init_rings(struct greth_private *greth)
 			if (dma_mapping_error(greth->dev, dma_addr)) {
 				if (netif_msg_ifup(greth))
 					dev_err(greth->dev, "Could not create initial DMA mapping\n");
+				dev_kfree_skb(skb);
 				goto cleanup;
 			}
 			greth->rx_skbuff[i] = skb;
-- 
2.35.1



