Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038318;
	b=qZjh4FkIUGdU4pPZifWrUpzjHzy5FD8mdcYbsDudRll9XodNaTb2TRqh1hQF4ldYhwcF
	 kKObLfStcvtKcf48MTfeH7YPfGxBVa+WNqBF/We8rPnKWMAxaU3clsvPz+KQbTgKpdbve
	 MKIjdaY/sDD/Rbih7vHqhiW1Bl3RRrOD97Q5+pzSWPoL+eMeMR4cmNT6Sj/5jHnKUO0ZK
	 WZ4NivlYqtMEajl6FgMSj5iwbxxog+vVs05ALMwVU5MqRhUNWOpJwAGtx9CU1XDB0bsrT
	 YJ2StZPGTX3KZXNjvK/Y4RlpzjtwE7VQXCAJSKQI2r72UB3pmgcslw+Pqer10mG9wkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nUIKwfeXtgYnMLipjcyyDuLnP6hiAVgrU8uZ8lQ9qdk=;
	b=GXZjzlokLh+rY56Gv8yMvn23EnBaLzmvtGAcuTWdDbYr7zaw8ZbJK3yccsLSr9Z1HAZ/
	 f8BZWUC4ah7B/vl8G1BOpje1sgX6bimB+23f6WlnTu736edB2iwRxctyQogUH0l/bJXsC
	 SCucjudfX5fRle/ko8O3WP0RZEigBOSfuchR8N/QHLARxFPngtc4KAZ7v1aodAN3aaivx
	 xmpTHuJD83GK79+v+GhxcEJ7WQWDDiGGeIJfeO6yRNDQIMPZ7BPpBd1ewJ5EVp7m4koZr
	 qe8//URRK2MuhpOb9heH39Y1bf51a58JViArDDmWNyMgQSqQe+c8tpLT4Tvq5ZtnjeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gN7UzmdJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563FA606A32C;
	Wed, 18 Nov 2026 21:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gN7UzmdJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8D61F000C4;
	Wed, 18 Nov 2026 21:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038318;
	bh=nUIKwfeXtgYnMLipjcyyDuLnP6hiAVgrU8uZ8lQ9qdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gN7UzmdJ9/y369VxdAwzic5QEDt1PTsw6jTQKUjnmq2WOvsfIDyIf9QkFu6ho+Vvl
	 gbTW/auHlEVmjprQrTGsuLGA5iZClIWBUvNqKO7m6+mrZ6OGyWGPZD3DvEiH0XLpDL
	 HfNWba8xP5+hNNg6ti/WI/xWtkU5y2v3DMRcWAbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1703/3318] mailbox: altera: shut down RX polling timer on channel teardown
Date: Wed, 18 Nov 2026 15:38:45 +0100
Message-ID: <20261118150412.944186502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 0cf10e65639cba32d05994f85e6a8f08dd0ffe08 ]

The RX polling callback unconditionally rearms the timer after it
processes mailbox data.  altera_mbox_shutdown() uses
timer_delete_sync(), which waits for a running callback but does not
prevent that callback from rearming the timer after the deletion.

Use timer_shutdown_sync() for the final polling teardown so the timer
cannot be queued again while the mailbox channel is being released.
The timer is reinitialized with timer_setup() on a later channel startup,
so polling mode remains reusable.

Fixes: f62092f6d77d ("mailbox: Add Altera mailbox driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
[ sashal: adapted the timer replacement to del_timer_sync() instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-altera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-altera.c b/drivers/mailbox/mailbox-altera.c
index afb320e9d69ce..e81c8bac651af 100644
--- a/drivers/mailbox/mailbox-altera.c
+++ b/drivers/mailbox/mailbox-altera.c
@@ -270,7 +270,7 @@ static void altera_mbox_shutdown(struct mbox_chan *chan)
 		writel_relaxed(~0, mbox->mbox_base + MAILBOX_INTMASK_REG);
 		free_irq(mbox->irq, chan);
 	} else if (!mbox->is_sender) {
-		del_timer_sync(&mbox->rxpoll_timer);
+		timer_shutdown_sync(&mbox->rxpoll_timer);
 	}
 }
 
-- 
2.53.0



