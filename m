Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA609FBEC
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9BBC433EF;
	Mon, 15 May 2023 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169360;
	bh=rCR/umXWjr3fBettugLtcE2iJQTWkq6+wtzDClOh1uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAJlHfvsScBGhpfHLVbuv7DZ5BY0akG9ZHqAuwgHwD026rLO7ioK5+4hAgfYP8HZl
	 OHXDDBvV4NIpZCc/LK2Lxrahj73vM4+CqJxlV4BnqqSsRGi6E2CH5D/L7FVTJIVzwO
	 zOKLhVlj1HpOOVku3K6A5v1jGWjjvSbmnFK8km0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 034/246] net/ncsi: clear Tx enable mode when handling a Config required AEN
Date: Mon, 15 May 2023 18:24:06 +0200
Message-Id: <20230515161723.624006088@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cosmo Chou <chou.cosmo@gmail.com>

[ Upstream commit 6f75cd166a5a3c0bc50441faa8b8304f60522fdd ]

ncsi_channel_is_tx() determines whether a given channel should be
used for Tx or not. However, when reconfiguring the channel by
handling a Configuration Required AEN, there is a misjudgment that
the channel Tx has already been enabled, which results in the Enable
Channel Network Tx command not being sent.

Clear the channel Tx enable flag before reconfiguring the channel to
avoid the misjudgment.

Fixes: 8d951a75d022 ("net/ncsi: Configure multi-package, multi-channel modes with failover")
Signed-off-by: Cosmo Chou <chou.cosmo@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-aen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
index b635c194f0a85..62fb1031763d1 100644
--- a/net/ncsi/ncsi-aen.c
+++ b/net/ncsi/ncsi-aen.c
@@ -165,6 +165,7 @@ static int ncsi_aen_handler_cr(struct ncsi_dev_priv *ndp,
 	nc->state = NCSI_CHANNEL_INACTIVE;
 	list_add_tail_rcu(&nc->link, &ndp->channel_queue);
 	spin_unlock_irqrestore(&ndp->lock, flags);
+	nc->modes[NCSI_MODE_TX_ENABLE].enable = 0;
 
 	return ncsi_process_next_channel(ndp);
 }
-- 
2.39.2



