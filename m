Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E0E47F2FA;
	Mon, 31 Aug 2026 13:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184757; cv=none; b=twicCu25wUKVfLppq1W8NrjBLht0sRIO4tI6OHHs9cQjHmPxTzzyLkuh34EVTTxQKtlZzzIRmFa6DqSaoOpJpWZg0QmfjeLBeZpfaFl8rp96VQf6JMpkxR3+rhyP+bBy8CLVZzl5mCKVC7ell7oOuPnWUsqDTMZE1Ysr/0jrdvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184757; c=relaxed/simple;
	bh=CC6CR4uQRhUK3aooqfWTq/jSkIJKQaW68q2+t5ABsgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R83QcNW0i5Xh4N3PV/jYisXAqKWPX8wGyQwGL/et7yvcnSW2gtaKyh8i2T1p8TaoSAbv7CwnkolsGOMVfzXu2zZ6ZpcToYwWh1LQ6jw8arMUhRPpcwXqhqDFouPeJ7ci77Pg6COI7BR+pi9n7XLO2GbgWOnVsO6c6rqIsZ7sGXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqcNa49g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqcNa49g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3581F000E9;
	Mon, 31 Aug 2026 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184756;
	bh=vLtZDB0J1xxr1ygrO7eygqw7C2Mm7LuCCB5leXCVh2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqcNa49gaZVabRntVEfRoufaD9YJrSzVDbLfwlRibAJh5VgdQLb+YKRJzWxAPz1sY
	 t486YlHj5nKhQFWs/bjI+rmG62cB4L0iVYs8ZZ40TjYXujPzNwz5WMgnrpFNNHknJX
	 Eb9ZorZYljILY8yHOdsR1HNoSohyfqicJVIE5N5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/92] can: j1939: make j1939_sk_bind() fail if device is no longer registered
Date: Mon, 31 Aug 2026 15:34:18 +0200
Message-ID: <20260831133400.630348322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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
index 2c15614ea7dde..1b0086198ba36 100644
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



