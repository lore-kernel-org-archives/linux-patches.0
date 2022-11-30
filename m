Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767036FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07FBC433D6;
	Wed, 30 Nov 2022 18:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832836;
	bh=B3rfd3xcXndiTqRvdlzdDQi1fgoG8fp0imflrxHa57w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ioH/bYcK9NR9MlIy/JGXg8aGjY+PWCqf7jnmLTRyOnmIm420GKuDdk826MIKDUGNb
	 S12WrO81plytmqFMA9pab1FAFJLp5mDiRjmYkgzeeohVU1rQxJt1nljJZlHo2/n73n
	 am4i1au8Kx8lWEPuyFdXPgPuboDvhMh5SXOHQMoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/162] net/qla3xxx: fix potential memleak in ql3xxx_send()
Date: Wed, 30 Nov 2022 19:22:19 +0100
Message-Id: <20221130180530.082269302@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 62a7311fb96c61d281da9852dbee4712fc8c3277 ]

The ql3xxx_send() returns NETDEV_TX_OK without freeing skb in error
handling case, add dev_kfree_skb_any() to fix it.

Fixes: bd36b0ac5d06 ("qla3xxx: Add support for Qlogic 4032 chip.")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1668675039-21138-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 2219e4c59ae6..99fd35a8ca75 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2475,6 +2475,7 @@ static netdev_tx_t ql3xxx_send(struct sk_buff *skb,
 					     skb_shinfo(skb)->nr_frags);
 	if (tx_cb->seg_count == -1) {
 		netdev_err(ndev, "%s: invalid segment count!\n", __func__);
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.35.1



