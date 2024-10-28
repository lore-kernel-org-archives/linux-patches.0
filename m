Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1A6152E1C;
	Mon, 28 Oct 2024 06:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096943; cv=none; b=YBJhFrIrxJJMNP/T7iNsBNFKgMjj4gyuw4EKPK28g0Mi9o4fNDKb69NCPJlqAN5z8R/jB4ueefWO8UIZOEAhiNe4+OkRfHs8YlYFYDljoqB0/TsfTS8VZrkH1RXE7p0VI8ZDnC9cdi1OYHiT6fvrrx8b/G6AQEf81e2TqU7OYNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096943; c=relaxed/simple;
	bh=PVIPg16dHLN4vu4mMY2wc1WGEg1xEHSwcidGEL2NpQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHsVOXT0Wb6rxhspZsUrPoUsPIWasLPtHJLIGAwWowrA75uNUtycf4mTiE8c4zWIqP5vR4AuwZkeRNLowUODdEx+f06IqCkQSFRFY7Grw02qshZWIxX73ILRQ3WobGSS5pRMa7OeOjRWyFs3gJErA38ipNz8/blILGgd1xwQfGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVf5+5Qk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVf5+5Qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE74EC4CEC3;
	Mon, 28 Oct 2024 06:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096943;
	bh=PVIPg16dHLN4vu4mMY2wc1WGEg1xEHSwcidGEL2NpQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVf5+5QkCw5sle2xUtm/bc4u4X5XcvZamQKcubpFj6tmKAM4FsAvln136d8VG+V+G
	 IBD2HFr9bcwFVfnyq+1kNEXubGYUD7MS54/ksO7r6ZsPAXA9N7SR3C0o2vnU+YPYuk
	 u0h6TMyLjyma+gGpkKdpaXGAaVxxj+X4J3+QI4NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 54/80] net/sun3_82586: fix potential memory leak in sun3_82586_send_packet()
Date: Mon, 28 Oct 2024 07:25:34 +0100
Message-ID: <20241028062254.117882374@linuxfoundation.org>
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
index 6c89aa7eaa222..95a6bbfa013e1 100644
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



