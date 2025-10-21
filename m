Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6E3277CBD;
	Tue, 21 Oct 2025 20:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077316; cv=none; b=NuK4QakHhviAhkg97Dhn6ixws9TkDJr05sYLWUsqggd9fbQFGGQyjwZpXpeSFzvu2Yc4bzCoQbc3kaiB1bL2GFAEKZDN4HNOzEwtyTQ2gge2PvxEYiunIIBIflmgnfKCH38psE4g5mZiTP6J1gQQRbJWBPMJ/KEN6CjSL0LxfMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077316; c=relaxed/simple;
	bh=OFHX1upHckR4H+g4NIg6jztsHRqcdXoMk5b5b2/4Ydc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZoM4OcI9xU6maaZqO3jMaa4YSaQZSXk7l3yAJxs6UZQi6gCBYh/VhECqrZ/fTD0dPmJftJGn6GH1Kpia4EO9mXiGokBGXIQ0DjK6jTcNyswrJJ++Sdnj/TVCpJgv2oJrxpp1wnlVldRq1Ve4GJLF3NeD3dSmmVLESOzYn7gRyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipT6QeyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipT6QeyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F858C4CEF7;
	Tue, 21 Oct 2025 20:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077316;
	bh=OFHX1upHckR4H+g4NIg6jztsHRqcdXoMk5b5b2/4Ydc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipT6QeyUYfYaPlN8AHHwM5L00+fLUAm2Lp1B70hFu0m7xV9ts24+ufyHX/kqjY4Ll
	 REBqSZ+U2l6gmY3CEZ3h+wDSnR0BKkITlIZcd+L+Car9HO3pg5+XmJsXsg1hBDii6w
	 BnvVO4ZDG0aavIdA9leFu0Xd2ZzklOSsvRshG4FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 067/159] can: j1939: add missing calls in NETDEV_UNREGISTER notification handler
Date: Tue, 21 Oct 2025 21:50:44 +0200
Message-ID: <20251021195044.820167519@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 3706a872ecafd..a93af55df5fd5 100644
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
2.51.0



