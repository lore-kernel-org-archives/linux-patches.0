Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D0F1A2389;
	Thu, 15 Jan 2026 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498784; cv=none; b=UMQc76icpeIsXG7sdXdAW3HRmx4wWbYFvJbEbPphCFrcJruomoXJpOo+7xXGzOPSVdLctlEB67E1dMUz5kQCGR6Qx4TzuCSe7yU34wVAM0g3wAQ9Eu+gCOxAspDS0dGMlJUj1Xx5ilBp+B3kcE9g3kQjSr6ejmd7ZLJVaTyEqC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498784; c=relaxed/simple;
	bh=Avx/NaUz4y6i5EBxgC8/CrVhAx5sQRSolcDx90vuVpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kh4Y/XVV0a7qGVIG8KWCawlRBfdvEJXhRd3AZEBtbyEs5yhB5oHqyCRRdZRBxcnlb9KQ4aAXUMXzEa7qs2Ur7H+XaXEuUmNpDN/OEeBoYMrLwG1NRzwLkWXtDj9+tNbjF2UhsnI2pAa/8X9nrbU7hbHXj7g1JBrYEcChQ4TLzMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzuRVd/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzuRVd/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540D3C116D0;
	Thu, 15 Jan 2026 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498783;
	bh=Avx/NaUz4y6i5EBxgC8/CrVhAx5sQRSolcDx90vuVpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzuRVd/1GxV9qKQw6XLsnVElapABkFAbWgPLjv/RV7bm62gvHGg8Jd7MZfII56qRc
	 ztbpQkSLkehKxPaVvqrfAvjP+055AM3pQPyFYx16SfqR+rs9wCRPv2DtUY2EJc7tie
	 6mGEWxi8IkVeTuCjm5LoW522PO1p2j+niH6czbdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 552/554] can: j1939: make j1939_session_activate() fail if device is no longer registered
Date: Thu, 15 Jan 2026 17:50:18 +0100
Message-ID: <20260115164306.309540401@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 5d5602236f5db19e8b337a2cd87a90ace5ea776d ]

syzbot is still reporting

  unregister_netdevice: waiting for vcan0 to become free. Usage count = 2

even after commit 93a27b5891b8 ("can: j1939: add missing calls in
NETDEV_UNREGISTER notification handler") was added. A debug printk() patch
found that j1939_session_activate() can succeed even after
j1939_cancel_active_session() from j1939_netdev_notify(NETDEV_UNREGISTER)
has completed.

Since j1939_cancel_active_session() is processed with the session list lock
held, checking ndev->reg_state in j1939_session_activate() with the session
list lock held can reliably close the race window.

Reported-by: syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=881d65229ca4f9ae8c84
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/b9653191-d479-4c8b-8536-1326d028db5c@I-love.SAKURA.ne.jp
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 76d625c668e05..0522c223570c7 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1571,6 +1571,8 @@ int j1939_session_activate(struct j1939_session *session)
 	if (active) {
 		j1939_session_put(active);
 		ret = -EAGAIN;
+	} else if (priv->ndev->reg_state != NETREG_REGISTERED) {
+		ret = -ENODEV;
 	} else {
 		WARN_ON_ONCE(session->state != J1939_SESSION_NEW);
 		list_add_tail(&session->active_session_list_entry,
-- 
2.51.0



