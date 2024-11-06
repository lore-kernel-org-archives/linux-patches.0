Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C231E0096;
	Wed,  6 Nov 2024 12:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896604; cv=none; b=cl5NZ0woko+Q0OZpuqyJPY0/cuvUiRoPneUFE7byGDFWGVYJOH4KRJZ55GI7hhb4x2nU4zhv5mmmCeLlmuao0swPiIUxzk89PbrOS1iyVC5FEry2UZhmzCcnZIJQE+agRfCCWRlAnYuKxdW7zWqNbEA9aJSLWG/1NmlMnGBjsVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896604; c=relaxed/simple;
	bh=BKFWdbU3IDY78AN+sCSoUm3zasgw852+HBuCjowMnvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BH3jnLfW2RSwOhU1Fdl+AKXahKuJbTAcj/YQIM/fMLy3gfNTDTbPrPsu+tZ2mRdgq5bJ5MN6ADZQf+1ZRrAvnZPgSnVSmwkYufNlzqeJeu5rObOgzBf55wQ2/VUKwmX/OdbicQlsglUEYMPP2FzSyuXmUHDCYNh5EplU09JfM98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7lXJjej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7lXJjej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12D4C4CED5;
	Wed,  6 Nov 2024 12:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896604;
	bh=BKFWdbU3IDY78AN+sCSoUm3zasgw852+HBuCjowMnvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7lXJjejkEGgBOlbjYmVWVimCRvn4cOm8E/nnf8k3DmPasjLOnstPADGF672bu72q
	 RTNmZh6O0PBIHokUMQuRn+2YDdqOl0qMQR3W3Cs6siU/s3nGrT7Jt/27bt2d12QH2z
	 5pKmE0isEFw9wEYLR/L33OJJwMSmgFgDikG3lzv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/110] net: systemport: fix potential memory leak in bcm_sysport_xmit()
Date: Wed,  6 Nov 2024 13:03:38 +0100
Message-ID: <20241106120303.494246649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit c401ed1c709948e57945485088413e1bb5e94bd1 ]

The bcm_sysport_xmit() returns NETDEV_TX_OK without freeing skb
in case of dma_map_single() fails, add dev_kfree_skb() to fix it.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://patch.msgid.link/20241014145115.44977-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 82d369d9f7a50..ae1cf2ead9a96 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1343,6 +1343,7 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 		netif_err(priv, tx_err, dev, "DMA map failed at %p (len=%d)\n",
 			  skb->data, skb_len);
 		ret = NETDEV_TX_OK;
+		dev_kfree_skb_any(skb);
 		goto out;
 	}
 
-- 
2.43.0



