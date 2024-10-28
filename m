Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134C518EFEC;
	Mon, 28 Oct 2024 06:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098254; cv=none; b=D5dM76Krn+PtQ/B4AUTwORQyLtCm+s4Lj8JM13evYaO1qRhtBWZBV3L5C6Rbiwqz7dPBhoxDKbXWpTAwoPwYUPXU3FHVr0MLS6pa2sqvWY1zroPxMdnK9GIU4QZRWctBJ+0Y6lN8wmVtwNQzmm5qQOg3PFJ0lsJu6thuVVxqYec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098254; c=relaxed/simple;
	bh=81/kuFcW90zjrmf73X7NLyzrlis0FOrl4hXBk+v3tc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmQMXTAbPVVtGFc+xZK9F8y3nd2G72JWRhvUAcTpf2b5DBIgGWnq1FeWt0NcJXQr/RSQ8D1c+7X/6+yCDQM7iqthskH2lihVCrFTRPvfg2vX14j/QcRB/0ZylL28tSVhsml8wv6JomGHMG1amZEBLldpktsJ5lOVNCF6osV9lyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbcPrLge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbcPrLge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7037C4CEC3;
	Mon, 28 Oct 2024 06:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098253;
	bh=81/kuFcW90zjrmf73X7NLyzrlis0FOrl4hXBk+v3tc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbcPrLgexZ0nDU5xebckxZBd7yGVBCwJg5mri5gvaJDhl0PKOSwWCfzEG0wnLrPXX
	 pgzGw5t5U5GBRud6ib7XEfUGqtgauLWuwPYqjIk88H1IScvdpG3APucmtr4pxJQzTd
	 npQmJvITUFp0eBddtExGPHWctU7itbjo+d/0xzoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 146/261] net/sun3_82586: fix potential memory leak in sun3_82586_send_packet()
Date: Mon, 28 Oct 2024 07:24:48 +0100
Message-ID: <20241028062315.702074351@linuxfoundation.org>
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
index f2d4669c81cf2..58a3d28d938c3 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -1012,6 +1012,7 @@ sun3_82586_send_packet(struct sk_buff *skb, struct net_device *dev)
 	if(skb->len > XMIT_BUFF_SIZE)
 	{
 		printk("%s: Sorry, max. framelength is %d bytes. The length of your frame is %d bytes.\n",dev->name,XMIT_BUFF_SIZE,skb->len);
+		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.43.0



