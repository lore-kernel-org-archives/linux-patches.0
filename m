Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDDB18E34F;
	Mon, 28 Oct 2024 06:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097341; cv=none; b=MLLVubjzFgbz3k6r/tf5IJ9fPwzS4EIoIUliNP/rlOo6HLrZJYDT2c072KV6A9tP7mIZh8SzlbGzv8ldTSSsl/caAFen8TDBF2+DPM4hiSf0fM/sqLz3i0axNPIuWr3Jdk1OkseQhScT+kpRKYtXJxInfVmqpouykHQ9RFnxoJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097341; c=relaxed/simple;
	bh=4V3+6i/GAgxmXZmD4f8ZhnPCfe75uFpd+qoyeBis4bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mc7BHlQ7rDLU5mH3oAxurkH+2+mIH0ZjzIurruIfEDrej6Ugqp8w1DMju9qC/7Dxlzo8BHDqw717km9hvx1H5I+fPkTyHeVKo5rmOt6G1p5TRSon06Wq1SJo3xQoUYI4sVx2yIfXNeZsfrvLkIryxoeJ9wncSYQu0hFFuOGudIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z735+V+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z735+V+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEBDC4CEC3;
	Mon, 28 Oct 2024 06:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097341;
	bh=4V3+6i/GAgxmXZmD4f8ZhnPCfe75uFpd+qoyeBis4bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z735+V+GmvusFUme7LaXTgAUrogtzFyyX8Y/QOCaqKRzBMzY0diGOtvILmf4A5LOM
	 EfoEHiOWfe9HGCci0YKbXtGAqG260epqDOzJjaA3n42mSYvehZv3x8A0+YyDM7dkAT
	 fVlg4JaHfxc/r8w54tc1Ol+NhfLbwAJEY5Hkmukw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/137] net/sun3_82586: fix potential memory leak in sun3_82586_send_packet()
Date: Mon, 28 Oct 2024 07:25:25 +0100
Message-ID: <20241028062301.184393139@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 72d3b5328ebb4..54c83e66bf78b 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -1011,6 +1011,7 @@ sun3_82586_send_packet(struct sk_buff *skb, struct net_device *dev)
 	if(skb->len > XMIT_BUFF_SIZE)
 	{
 		printk("%s: Sorry, max. framelength is %d bytes. The length of your frame is %d bytes.\n",dev->name,XMIT_BUFF_SIZE,skb->len);
+		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.43.0



