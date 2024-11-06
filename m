Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814061DF73E;
	Wed,  6 Nov 2024 12:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895712; cv=none; b=Xb8zmwcp6+y9KCXiJP8RRdh4rF89xCQh1hFqzIBXRx5JOi9949LFw8BcL31RrNm/n9oroOuvAGB7b47OuYSOS/bpTMMl4KCUc/mMCMYhrpXjq1BuKD4V1nXS8w4fOgw9+9S6d21Uf8Ti/PFoc71qTpbWNovP+1PbHcGuenLqOrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895712; c=relaxed/simple;
	bh=WnZPTphLgA3JfmQGxIFIBmg4LEfLorAeE55R6/p92q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpN5V0ifhg5gB4vmSgFUwoVZ740SZ+L6dq5bapPb7d8KY/MMTDwaSA6HJvnm3QPUimI68s10lX5x/W2QMOO9f9rWrHwjPqw87jy/OV/NNXVTh53++dTLUAuOZNz3yM+NxJ8E3fdCuZZl6dSK0Qws1wtCifh7H8kk2yyu2HIOg0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/3ppQvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/3ppQvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC71C4CECD;
	Wed,  6 Nov 2024 12:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895712;
	bh=WnZPTphLgA3JfmQGxIFIBmg4LEfLorAeE55R6/p92q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/3ppQvxejndPhPRr8G9O9kiZ9VPvVeC8zz3avYunOP9sbkV1Hp2vj9Aq4M1i3t2z
	 7FrITGSNGcz5ltxVEOo+mVPgChkVQ187kW27yB1CYBMnEk6mLxEx0IAFOu9RFFO91u
	 ExC8+xX6IcKjfwrADNLH8KyFy98kU63gi56s180Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 310/350] net/sun3_82586: fix potential memory leak in sun3_82586_send_packet()
Date: Wed,  6 Nov 2024 13:03:58 +0100
Message-ID: <20241106120328.433066224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 2cb3f56e827abb22c4168ad0c1bbbf401bb2f3b8 ]

The sun3_82586_send_packet() returns NETDEV_TX_OK without freeing skb
in case of skb->len being too long, add dev_kfree_skb() to fix it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Message-ID: <20241015144148.7918-1-wanghai38@huawei.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/i825xx/sun3_82586.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
index e0c9fee4e1e65..7948d59b96282 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -1015,6 +1015,7 @@ sun3_82586_send_packet(struct sk_buff *skb, struct net_device *dev)
 	if(skb->len > XMIT_BUFF_SIZE)
 	{
 		printk("%s: Sorry, max. framelength is %d bytes. The length of your frame is %d bytes.\n",dev->name,XMIT_BUFF_SIZE,skb->len);
+		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.43.0



