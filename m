Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E21C59C967;
	Mon, 31 Aug 2026 13:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184308; cv=none; b=uMmMx/7rHgUnqPeN6/+COIHzins/dz3B7XylZe55Sgz6Vu35cFTZk8ofy8JAHT6TGFPi4p8otFFiBtjfbA7qx+Bz9cH1Gs2OnTsSLhoz/CBscvER8sws82scO/dF3g53sPksDSib1rgK48h1wSNIU/ivIRBp0lj2Q75ENQor8w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184308; c=relaxed/simple;
	bh=V5xONX1gn0lAIYOBTx9OCT+AWtO7PgejkgS1uWRUGKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXJxcK918XyARayW3WIWJP+8IIxcCXCz56DBU1uDUfYrimwwGi4DG7LTMB5omwjd/haBbSIRY1TUlG4tFKvgFpDDWihOw9XQ55fqX+hjaGfyLa9BFYzUqkeBVyXExy6twR7TN+/EeXlbxsdQO7lnjLvY08kd4Lkcn+HSBXtEaD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0etcrr8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0etcrr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C061F000E9;
	Mon, 31 Aug 2026 13:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184306;
	bh=B0vopn4ttnoIhYvmuxy3mLOXrL4Cmgh0T19xftoRh8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x0etcrr87/7/nIaTKNSLBgE1HLX05g69TFbo04jwDvcMooA1YlevHc6YuIz8Wrxb7
	 gU88l/z/DA9jAKOfgbgxaPDDBvkkWLypOOPGw7UcO9ceGkoUEB5GslWeKORtYUMEv2
	 Y2h3n4qA5a8Cb4FngcmHOMM8E3QhHONXO7P1cd+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 24/99] can: j1939: add missing calls in NETDEV_UNREGISTER notification handler
Date: Mon, 31 Aug 2026 15:33:53 +0200
Message-ID: <20260831133401.137532805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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



