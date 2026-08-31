Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F6D488213;
	Mon, 31 Aug 2026 14:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185034; cv=none; b=r/cJ/llmIQTAtYd3s5SBpPrifWlzKo2oUdwWK6r49aAxKlKl2P+dSMmG9/42V+UdUhONNnFLJBcujET2FFJn1QPQFzW+dgNfF/jYiUR0z8g3dVf7LR5nTcIBg/EvGMqy/0xZ+JorKbQb51AtHUt3WeAZS1AjDNCy7dR/Cbx2YcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185034; c=relaxed/simple;
	bh=9f58SuWDPt6rB1JcD2Q67VRa11pj1vcHQZimAx8lwi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dtw4C6ZHLoCdDB/JIs3TQ12JgsiU7HVO0i6mPD41cdgeUEodN0MD9gRmQ2vR+qROuVH7G7ZaMEP5ej7jj+XfnNnsIg0KqeGXl7JcM20IAaX03iKSesjzAhWmkL9oueKCOQOk9yPORGSh/VbB47+0fQO4VlLQVk0WUrosYlqKLcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dZIkfUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dZIkfUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02081F00A3E;
	Mon, 31 Aug 2026 14:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185033;
	bh=ULzsiv3xb/iyqYUfOXjmQj+LqsNhjOhfxCYvXs5/mIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2dZIkfUpW6tnWr4kFdZnjxc7hecEUAM2oWz8aGSQIzRHIQsHE58qKnUBIiLqjCIW2
	 +uC3VE+ri06NJ70ODUJeQ1EobfcxJC6o6HvPcZPSkvy2q7aeN/sjiLIKKBj8hXX2TB
	 bkU0rbEn0x0yWyf2b3mQl3/0lSikS50+Xzx5kGaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/69] can: j1939: add missing calls in NETDEV_UNREGISTER notification handler
Date: Mon, 31 Aug 2026 15:34:42 +0200
Message-ID: <20260831133358.997619488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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
index 21528d7ff83db..503d344fe628b 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -374,6 +374,8 @@ static int j1939_netdev_notify(struct notifier_block *nb,
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



