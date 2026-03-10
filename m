Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9EA386454;
	Tue, 10 Mar 2026 11:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141217; cv=none; b=hZ1j/hQmSSUMzVEo4PafruJqmT6fzMhpk2Do3uAZkCb/W5wgYeCChM8L2bkaxWAWnppzBPlsGyT8HeK6o47KEBPdEhYhkZqQSsRcTH7lxeXUz0UMNI3lm/oruDlgTsF/JSlFJLKZGHhwtbs8gMTqW8vRU4gCVc0JhrCaApPdG0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141217; c=relaxed/simple;
	bh=uLVIJ0JRVxC+IfDIZEWFPB+RAixw+Is4Oef7aTBQpmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD6IvGf3Juin/tXXNtvaj5M1XATgr7S9GKLFffodlHhu4rssehTR4IzK+uKBNkZm0vOqU9uLx/sm36EaFVj0kdXmB/VtO3hFBgYMQKsuXbw4xWaFell9KDSvtD1wUlakXO62zqEOeOpZZP0/Qlnq+fethAF2bG6HbFJ4RPKna3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITQK74mV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITQK74mV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729A5C2BC9E;
	Tue, 10 Mar 2026 11:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141217;
	bh=uLVIJ0JRVxC+IfDIZEWFPB+RAixw+Is4Oef7aTBQpmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITQK74mVLF6xL/sRtMFp+Gcgx7yAmsTXnOjf2n/9SSfaivuFjYL6s98k/OUXaOhU0
	 GuB74Z1SsKIZW60MEQsfSFLVY+d2Dicr4RGzZRkvmT2+D67lWisfM1mPgXrG3LMFwN
	 tvWal65aw/hyKXknroYqvjPG5EcrlDllGssPXOH4cy+985UVGndnII8m7ps2L2cD86
	 eIapau5TaZjqWOS38cedsalp7f402j/HoADSK+k3re+7JGdanOueKmD9/O9KsNcbCx
	 1xeq7gbAIMFybRWNpH6O+i4upEnc6odkR8dK9gTwgD7Y5wmJKD1+6P2lzXlEYEvQe/
	 vWU/Z4d5ebvCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	syzbot+5b11eccc403dd1cea9f8@syzkaller.appspotmail.com,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 218/311] can: bcm: fix locking for bcm_op runtime updates
Date: Tue, 10 Mar 2026 07:04:25 -0400
Message-ID: <45cf0074111bdb37164d6cb641f6120861f1a88e.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 7eba8ae01a5b1..ba65e6e8a923a 100644
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

