Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECB94756AA;
	Mon, 31 Aug 2026 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184311; cv=none; b=InrjQ7gR19g2X4sw5eT9+RCUq8+9WYG9DV5xsAQXQc9qnY0qJ6sfbhfukF4q8fpheytKHPxJPQqYX61vFHBzMmwuv+/bJyF8zQBgBqyz2D7WhbwtRMYaUzC2CB/PvvQI42t5en8jvrxW9lP5oUzWck0fGcyixBCB3cKSPVoSdMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184311; c=relaxed/simple;
	bh=HbektlA1W7s7/EDMBKXgmMo5ftoybdqfHS2BEQhYSAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOi1WwoKpIETeCTK0au1HWGtRloY0tK7hECT3ww/z3Yd9stj1SN6BKTcssSmxyfWaPegYURl7uCi5ewUPS4ad4Fd0U95LaTYtcGzeQ9Y85uE71Teb7Kh+2MtFf5Li1AkSNyR3SAnna/lHCp7PfOJ2P6KIMc5+hllTa1w0QTomb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOGclAiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOGclAiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9926E1F000E9;
	Mon, 31 Aug 2026 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184309;
	bh=WTfs1ZKCH1fGfxaLfbM72zkvhhXBfP6yJxN/X8Oh7OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOGclAiM4voto/dnDjPx+G09KZIRWpN4eUWqgAk1hVLhDRO7MgM+kkGUBhENOtNB1
	 jx0Hnj07ET94L7dSORoLIt97LrXvhHhO2QUmPsfX/dWIvU8UBYkQ0OK/WbogFQ6tKM
	 W/UyggKtTtNHSJ8YoA/v3NPzjplrm6N8tADUO85g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 25/99] can: j1939: make j1939_sk_bind() fail if device is no longer registered
Date: Mon, 31 Aug 2026 15:33:54 +0200
Message-ID: <20260831133401.186911502@linuxfoundation.org>
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

[ Upstream commit 46cea215dc9444ec32a76b1b6a9cb809e17b64d5 ]

There is a theoretical race window in j1939_sk_netdev_event_unregister()
where two j1939_sk_bind() calls jump in between read_unlock_bh() and
lock_sock().

The assumption jsk->priv == priv can fail if the first j1939_sk_bind()
call once made jsk->priv == NULL due to failed j1939_local_ecu_get() call
and the second j1939_sk_bind() call again made jsk->priv != NULL due to
successful j1939_local_ecu_get() call.

Since the socket lock is held by both j1939_sk_netdev_event_unregister()
and j1939_sk_bind(), checking ndev->reg_state with the socket lock held can
reliably make the second j1939_sk_bind() call fail (and close this race
window).

Fixes: 7fcbe5b2c6a4 ("can: j1939: implement NETDEV_UNREGISTER notification handler")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/5732921e-247e-4957-a364-da74bd7031d7@I-love.SAKURA.ne.jp
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/socket.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 48b60f6cfa8fe..8a61fb3b1d7f1 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -481,6 +481,12 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 			goto out_release_sock;
 		}
 
+		if (ndev->reg_state != NETREG_REGISTERED) {
+			dev_put(ndev);
+			ret = -ENODEV;
+			goto out_release_sock;
+		}
+
 		can_ml = can_get_ml_priv(ndev);
 		if (!can_ml) {
 			dev_put(ndev);
-- 
2.53.0



