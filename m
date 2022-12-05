Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2776F15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970A1C433C1;
	Mon,  5 Dec 2022 19:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267908;
	bh=rXqCxueh6dv6KZxea7OU0G+BteEUkDxHnwihzDQQqWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWqlmnpRO9j7CTAfg1fJDdpOCK2iP+hIvFiwfWi2k23hgZrzUEnfkFGxzOqQ+aa+j
	 AKCe7NbEUx3XVZRW101Frr8ncWCWDoSImO5O87xbEl/6pca6YeP2ZaCmAyggvxvUzZ
	 2Sb7qPr19JpQfNOROretcuToWS+vFpyf8OXnKCFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/105] net/qla3xxx: fix potential memleak in ql3xxx_send()
Date: Mon,  5 Dec 2022 20:08:50 +0100
Message-Id: <20221205190803.759477717@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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
index 51e17a635d4b..7a65a1534e41 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2477,6 +2477,7 @@ static netdev_tx_t ql3xxx_send(struct sk_buff *skb,
 					     skb_shinfo(skb)->nr_frags);
 	if (tx_cb->seg_count == -1) {
 		netdev_err(ndev, "%s: invalid segment count!\n", __func__);
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.35.1



