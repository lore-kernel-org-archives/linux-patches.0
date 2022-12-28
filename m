Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38DE1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44745C433D2;
	Wed, 28 Dec 2022 16:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243906;
	bh=5iqSBlOnwynat1aGwPMl3fxEZQdgGlLXUiz1C0BZWC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJAAMXHeGenPpI6Vrk3YQztqXoKUJ0TfaW3IMIlyMi46+JONnajNVuHLaHITVH0i6
	 h5Jd0lmfpiDeMZj2OMh8zJhZqOnqZutknl00zu+n66DBECzBuJ3vM431mpLdBVdqI0
	 cn1snX/CoQ4w6p2eKdZnvsxf7l7LyG+31IqB88zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0538/1146] net: apple: mace: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Wed, 28 Dec 2022 15:34:37 +0100
Message-Id: <20221228144344.786791794@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 3dfe3486c1cd4f82b466b7d307f23777137b8acc ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In this case, dev_kfree_skb() is called in mace_tx_timeout() to drop
the SKB, when tx timeout, so replace it with dev_kfree_skb_irq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apple/mace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/mace.c b/drivers/net/ethernet/apple/mace.c
index d0a771b65e88..fd1b008b7208 100644
--- a/drivers/net/ethernet/apple/mace.c
+++ b/drivers/net/ethernet/apple/mace.c
@@ -846,7 +846,7 @@ static void mace_tx_timeout(struct timer_list *t)
     if (mp->tx_bad_runt) {
 	mp->tx_bad_runt = 0;
     } else if (i != mp->tx_fill) {
-	dev_kfree_skb(mp->tx_bufs[i]);
+	dev_kfree_skb_irq(mp->tx_bufs[i]);
 	if (++i >= N_TX_RING)
 	    i = 0;
 	mp->tx_empty = i;
-- 
2.35.1



