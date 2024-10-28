Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88A718CC1F;
	Mon, 28 Oct 2024 06:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096870; cv=none; b=M+hLGWwQ/DeBn63AJa0Ghb2ohw9De1CHEud4RhVy9Sz8/tmTMiqs+NnPtiwbUgjoU2suY9Dk7aHLwnaFqw4IuYcS3RAjFz0FuLW81w7N5W1xxP4otpEUQ8MGTFcr4ejIVh2+ynNbQTQBS5fkn1k/L2yEtf1ZyEMMCWfMQ7ha/tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096870; c=relaxed/simple;
	bh=OTg1FSPhUpvXbrU8mKBnPjOwidET5ae9dO129vDptyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCiv0D/oWH3M6KH+euWhLv1agyWqAbj1l3ZDz7Ixq57ZKjZo+APeo/2wqacmCxKkRgJ8pwFWcDEGLCynqRZRdFfPbOxeRv/72fC3ivlGXT5IfyyCpAYMP0YCo1BJITfmpwUADXETz1ITflgHp8W29EI95SUvhe3i3J+iXswwEQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqTcTMKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqTcTMKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFE9C4CEC3;
	Mon, 28 Oct 2024 06:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096870;
	bh=OTg1FSPhUpvXbrU8mKBnPjOwidET5ae9dO129vDptyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqTcTMKGlOJbmwsWoPLG+aaulYJSfzGMlAUGCOqgNqy57SPYVTMzMcvdThGSZue7D
	 ytARr77bO1J4HY0onQEqnoXHSOTreb86HALCoBKFM6TNgYWlm7a7Z+xOD3uzZ5p3DL
	 B9m71kF3zFg2LP0DdeKh5gqeBfA5bjvz6Cfdmr7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 22/80] net: systemport: fix potential memory leak in bcm_sysport_xmit()
Date: Mon, 28 Oct 2024 07:25:02 +0100
Message-ID: <20241028062253.244130316@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 93c965bcdb6cf..8962bd6349d4b 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1348,6 +1348,7 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 		netif_err(priv, tx_err, dev, "DMA map failed at %p (len=%d)\n",
 			  skb->data, skb_len);
 		ret = NETDEV_TX_OK;
+		dev_kfree_skb_any(skb);
 		goto out;
 	}
 
-- 
2.43.0



