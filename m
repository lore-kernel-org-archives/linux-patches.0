Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679E88837;
	Mon, 28 Oct 2024 06:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098088; cv=none; b=NbLMN64gGmLXgI4ub/kgLZbpburu7PQaJB7+rgEDwZuJIRTXnv6RmN94vaMMUeqlmcxGUnw+oOfokC48BnfKaMrbERARR2WMUMRtZD9UAtWXloz6DCmdUixNM0umy1Y5Lz217j+EN60thxUf0Qnob8yno2UGE8LLFK6ywq4hrbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098088; c=relaxed/simple;
	bh=GPRObE+YDOw4xCFhA34PpQttYKPlrTDNzFGW1EY9NiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orTJlLYhZu4AiwrNB5Pqq0ijDFU525w2mZlbXvyMfXudHwVcc9V8mxXqFzJKCq/aS0BLABHTkkuah+hOMTwYTjLyKdI1caTvRzMXntToPJw2pperz4mdIy+rMTamOorOJbApLd+crH1P4pgjdzCBiKcA3AJoupoZLzDX7XtZaUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVOXEZo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVOXEZo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05351C4CEC3;
	Mon, 28 Oct 2024 06:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098088;
	bh=GPRObE+YDOw4xCFhA34PpQttYKPlrTDNzFGW1EY9NiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVOXEZo1zxZ8eISepCbBt6wlc38vabOflKMWEfL3t6RBcaRoIQf5Jkg/bi8rvK8pQ
	 Ct1bmNQClsfkpI9gFFS4BL/54YMvxRlk2GdZxBeE4LHO0lhsyG/2p958fX3blnWT33
	 8RaaGuedRXAlafc8Q6inTUPm2c57QNX5gCseMCP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 072/261] net: systemport: fix potential memory leak in bcm_sysport_xmit()
Date: Mon, 28 Oct 2024 07:23:34 +0100
Message-ID: <20241028062313.835299825@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c9faa85408593..0a68b526e4a82 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1359,6 +1359,7 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 		netif_err(priv, tx_err, dev, "DMA map failed at %p (len=%d)\n",
 			  skb->data, skb_len);
 		ret = NETDEV_TX_OK;
+		dev_kfree_skb_any(skb);
 		goto out;
 	}
 
-- 
2.43.0



