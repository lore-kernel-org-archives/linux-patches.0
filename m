Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAED26F288;
	Thu, 12 Mar 2026 20:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347177; cv=none; b=p8JrCKU2FBe1AKksX2QGfctM+0b9uCtLyVws1rFuCZCyIhQISnZuOQn6Z69Jlv/oPuWdbEoJRCiBXt8kngxEFKfZwBfQpB7OHUMrYM4leDrtPFLOLjJJQGEU5Nwhw96AST4CYjyaPkkZ3LxyCFjnRJtcp9eC1I2XaMNxLycrrcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347177; c=relaxed/simple;
	bh=Wq0Io8D9ZJ+mviQgywNciIx9Nb/Ft2zS+JHu7+xTu9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5ok95JRsvHjQlF3V4kDaC7KisleklzOf5M1SGuNzQRJcFvx5/QuV1R1iyYi3RdDvEsrUDbInvpbfAl7kiBBCAFewh6tLBt4H2hZ9EiRcI2+E7JEx0SWfpLueB514gGFUeBj0+XFYPXbT2xhvJLaB0iTUg0MgU2C6eG5KNt0cUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LR5sGOk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LR5sGOk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB85C4CEF7;
	Thu, 12 Mar 2026 20:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347177;
	bh=Wq0Io8D9ZJ+mviQgywNciIx9Nb/Ft2zS+JHu7+xTu9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LR5sGOk25APhfGr7myLCV65+E+44/kgoEgvLbmGTOKwseuTlN6duBVTlGGqEWA9fv
	 l15LPyyCEbK4uao9tEt11lT0M5Dx1yVGtKcAwD9ODNyPycZKI53yAGFd3gBZUSSvbT
	 cyPGs0/yNMVOpKWYHr3fyHFKWTiG0dNaeq/DAhGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5b11eccc403dd1cea9f8@syzkaller.appspotmail.com,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/265] can: bcm: fix locking for bcm_op runtime updates
Date: Thu, 12 Mar 2026 21:09:40 +0100
Message-ID: <20260312201025.286473061@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e33ff2a5b20cc..152cc29e87d7a 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1170,6 +1170,7 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		if (!op)
 			return -ENOMEM;
 
+		spin_lock_init(&op->bcm_tx_lock);
 		op->can_id = msg_head->can_id;
 		op->nframes = msg_head->nframes;
 		op->cfsiz = CFSIZ(msg_head->flags);
-- 
2.51.0



