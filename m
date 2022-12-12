Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E785528ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB0DC433EF;
	Mon, 12 Dec 2022 13:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851068;
	bh=ftSucFFSwFqVaXf8I0MrbiD2GKbtn5LQELj5EK/jDRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnXr/HijNCfHhp8QVwA7mDm1uYBWi3QfROoV6uJojTU3ai10GyLKk2Cs2crRphg9z
	 M/Egt+FMCbJ16PD3nsNE6XILvs3/ds5Ufvy+lCXdSQi0X08oukD1TraPqPEir1Dogl
	 fps6TQAVhRmqMCfvjpLn6TDmmt5TPgyjvr4niEeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/106] net: plip: dont call kfree_skb/dev_kfree_skb() under spin_lock_irq()
Date: Mon, 12 Dec 2022 14:10:45 +0100
Message-Id: <20221212130929.308221506@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

[ Upstream commit 7d8c19bfc8ff3f78e5337107ca9246327fcb6b45 ]

It is not allowed to call kfree_skb() or consume_skb() from
hardware interrupt context or with interrupts being disabled.
So replace kfree_skb/dev_kfree_skb() with dev_kfree_skb_irq()
and dev_consume_skb_irq() under spin_lock_irq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20221207015310.2984909-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/plip/plip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 5a0e5a8a8917..22f7db87ed21 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -444,12 +444,12 @@ plip_bh_timeout_error(struct net_device *dev, struct net_local *nl,
 	}
 	rcv->state = PLIP_PK_DONE;
 	if (rcv->skb) {
-		kfree_skb(rcv->skb);
+		dev_kfree_skb_irq(rcv->skb);
 		rcv->skb = NULL;
 	}
 	snd->state = PLIP_PK_DONE;
 	if (snd->skb) {
-		dev_kfree_skb(snd->skb);
+		dev_consume_skb_irq(snd->skb);
 		snd->skb = NULL;
 	}
 	spin_unlock_irq(&nl->lock);
-- 
2.35.1



