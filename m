Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993B1435A84;
	Mon, 31 Aug 2026 13:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184463; cv=none; b=DDKfWSk9qR8U55wjwgMknMKrIl6Ou/i0SH21m7h1NrYSZ37xhd9Q6jurGTdPkOyfi9MZHsCyWUHutGCRzWRQ0mhTnnRRogqTz1A0ErRGMEX51wv+ppib2p5PnMbDbGJ/2jA5AndRQ60PVmuznvm3GPmavdi5dZyjONchsNcpoEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184463; c=relaxed/simple;
	bh=Ua3XgKVETeNNm4tXRTC8rX4UW8/XSGemmpLE+ZWvFYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXZyMSaNGeWdhB1WlfdjkC1IK0uycK5KJfBHLFk5zRpPBs9gM++v+Ob21sznnsCUYzJHvYKFIbZRrf7GAHKCyxGCXBYve/Rp2KiO1McSQa6v6pTtEVggYn5cno6fNzyZc9JSA00DZG4eAEZqIszCwjPCma5UgYsAdryrGmjIQ4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7EiCdFK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7EiCdFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30DF1F000E9;
	Mon, 31 Aug 2026 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184462;
	bh=RyFXfufFk3zWCE8GOQjkcf/smf/TMAnftMLQN19SO70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7EiCdFK+lXB/UnFenykxpWTSXvwPa0Qmrr0eypjtKz5ICSoLHuLuq79iRkMZU4Im
	 sVgBjOIc5B0nH8nN/pLwM0oe8nOuXVMZpOKFzmXzbhBD8ccXVMRokboX/qDKN65rNf
	 KMkm1iSSfGNH9zHF4NhngSO2OPsdkJj3Bm08VggU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/91] can: j1939: add missing calls in NETDEV_UNREGISTER notification handler
Date: Mon, 31 Aug 2026 15:34:05 +0200
Message-ID: <20260831133400.463052741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 93a27b5891b8194a8c083c9a80d2141d4bf47ba8 ]

Currently NETDEV_UNREGISTER event handler is not calling
j1939_cancel_active_session() and j1939_sk_queue_drop_all().
This will result in these calls being skipped when j1939_sk_release() is
called. And I guess that the reason syzbot is still reporting

  unregister_netdevice: waiting for vcan0 to become free. Usage count = 2

is caused by lack of these calls.

Calling j1939_cancel_active_session(priv, sk) from j1939_sk_release() can
be covered by calling j1939_cancel_active_session(priv, NULL) from
j1939_netdev_notify().

Calling j1939_sk_queue_drop_all() from j1939_sk_release() can be covered
by calling j1939_sk_netdev_event_netdown() from j1939_netdev_notify().

Therefore, we can reuse j1939_cancel_active_session(priv, NULL) and
j1939_sk_netdev_event_netdown(priv) for NETDEV_UNREGISTER event handler.

Fixes: 7fcbe5b2c6a4 ("can: j1939: implement NETDEV_UNREGISTER notification handler")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/3ad3c7f8-5a74-4b07-a193-cb0725823558@I-love.SAKURA.ne.jp
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 6bbe75d2211d5..21186932f8f61 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -378,6 +378,8 @@ static int j1939_netdev_notify(struct notifier_block *nb,
 		j1939_ecu_unmap_all(priv);
 		break;
 	case NETDEV_UNREGISTER:
+		j1939_cancel_active_session(priv, NULL);
+		j1939_sk_netdev_event_netdown(priv);
 		j1939_sk_netdev_event_unregister(priv);
 		break;
 	}
-- 
2.53.0



