Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0324115B10D;
	Mon, 28 Oct 2024 06:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097766; cv=none; b=CowRQtAyKHs2KS5+v8wuLMx4kacUtTurFNJxZYzleE6OzcATLBtWntdvlr8lYxS52wuNalv2flEbjcJbzI9NqbcWuj9BxRNrooHP4XTo7FTlB+IzL1lmPk5wXcQg3hGtTRYcAlqF7iOEEDoSVYBPoMTOnX39H+cMcZtIvyzkkCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097766; c=relaxed/simple;
	bh=CtvkeXdPq1eoeh6xEKTH4BZ1E2rK4+9rsbbz7NN4if0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKkMGrGDJyXa3ITCA8RD9OQ4vxpD4gXQMq4AuxSntwoDqaeJaHQKA31JvamVc/i2K8jJ9Io07jpusRHwKK8TZJEi1P/lGFZTp+GVXbgj2sEVbW253ArDHCHkZwd3stFAWZUWaR2gW/i/RAyYvH38/enAqlWCYLh2gS+zs2Z2VCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEZ7S0nb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEZ7S0nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B47C4CEC3;
	Mon, 28 Oct 2024 06:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097765;
	bh=CtvkeXdPq1eoeh6xEKTH4BZ1E2rK4+9rsbbz7NN4if0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEZ7S0nbwXz0uaiERvCjbU3kuaTVpW9PsI5KPkahy+Znqv3pk/+q4jFdyc8cFqds5
	 iC2V+eLvfok+qWtdAkQlyDcTHpSK8DbjjwqAd0kxXgfbcYmPC65ADYkXSBYpPbl/0p
	 YPG0j3P2Je5gKK7BbY/v2lJuZvnGGXiobzpCgf14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/208] net/sun3_82586: fix potential memory leak in sun3_82586_send_packet()
Date: Mon, 28 Oct 2024 07:25:16 +0100
Message-ID: <20241028062309.987798292@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



