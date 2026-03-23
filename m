Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5613BAD8F;
	Mon, 23 Mar 2026 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282299; cv=none; b=lO5hq1D48KxYAI1FWYj2m+pW0b7f2CNo01gwkOEIyO+HKdaf/gbEJW1VkmZjhDIfU7QvRNheb1jwmXrmAxW4sb2t+ucCC9nMZYP+Y1WstRqHNCUY1H9uQOx+x8cplDGyPi74Ke/ke5WqFXNQDb9EPnWRcSN/NdWpV4M+MXW/OkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282299; c=relaxed/simple;
	bh=iI7JdT9yroKPYRUyKHysubcmQOXPBab5n0RMyNyxL+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqEGNB/PK0T308FCOfnmCI0iC4xg4e0zC/5EZzbGuIsDcASCegDI+yIIucZwAez9GmYt4FtyqXSUT6YCYTmurh+s+KVjH55hB8W+KbI2RgEKNEd1bCLGgGy5/90ExKiIT4rp23rY+QGDDI5K7REFKUoSc9r8d0WpL+bslTNFQGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWWkN3AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWWkN3AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EB8C4CEF7;
	Mon, 23 Mar 2026 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282299;
	bh=iI7JdT9yroKPYRUyKHysubcmQOXPBab5n0RMyNyxL+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWWkN3ATnPwmKnZqaNLSSTO+TXXWVnrLCGwMIpiw2nQvbkZTtnee8Q9dhBuQjpQhd
	 kzNSGsuiTJ/vezsKo+yyIQhKdmC5cJeSbRPXtb13Sekw5nToKVAZA6Wkn1aQW3WXdB
	 InqGr9ER3bE3aQqZUcSiijCtrEno+RvVhwroz+LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5b11eccc403dd1cea9f8@syzkaller.appspotmail.com,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/481] can: bcm: fix locking for bcm_op runtime updates
Date: Mon, 23 Mar 2026 14:41:28 +0100
Message-ID: <20260323134527.868486722@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit c35636e91e392e1540949bbc67932167cb48bc3a ]

Commit c2aba69d0c36 ("can: bcm: add locking for bcm_op runtime updates")
added a locking for some variables that can be modified at runtime when
updating the sending bcm_op with a new TX_SETUP command in bcm_tx_setup().

Usually the RX_SETUP only handles and filters incoming traffic with one
exception: When the RX_RTR_FRAME flag is set a predefined CAN frame is
sent when a specific RTR frame is received. Therefore the rx bcm_op uses
bcm_can_tx() which uses the bcm_tx_lock that was only initialized in
bcm_tx_setup(). Add the missing spin_lock_init() when allocating the
bcm_op in bcm_rx_setup() to handle the RTR case properly.

Fixes: c2aba69d0c36 ("can: bcm: add locking for bcm_op runtime updates")
Reported-by: syzbot+5b11eccc403dd1cea9f8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-can/699466e4.a70a0220.2c38d7.00ff.GAE@google.com/
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260218-bcm_spin_lock_init-v1-1-592634c8a5b5@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/bcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 4fb5cfaf74f3f..050c755ff5fbd 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1128,6 +1128,7 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		if (!op)
 			return -ENOMEM;
 
+		spin_lock_init(&op->bcm_tx_lock);
 		op->can_id = msg_head->can_id;
 		op->nframes = msg_head->nframes;
 		op->cfsiz = CFSIZ(msg_head->flags);
-- 
2.51.0



