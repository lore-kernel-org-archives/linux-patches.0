Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83C9330B0D;
	Mon, 29 Dec 2025 16:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025092; cv=none; b=ZUZIKqwsCqXI9d03fKMLWZ1dnzpiD1fH+qDcWITa0f0cwWyTX6qcB7WA6MfQ3kN0avzd2h1QQ5sXhf1H2QKRMbQ/1B4m/bUrZVuX8/MrAoBid5mgx3Bdq+LMoSxfzGfH5yBq9bz6j+u8EAeSvJb9z867nos3oGdUmi9SBlQcUtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025092; c=relaxed/simple;
	bh=+kA2ZdGg7iDLakVqlnMutKxFjzE7DxzTorz27cmHYbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozb7An7c7YfMVf3Jz5ri87AAlpZMvCN2W3E+GWLI2pKgqm01Z80YF4ri3ZWy6kJfqVUZD7OkghEpWxHj7kYeSDyvpsnn3i8arOePgQKrBY4uvEMOg9fM6anqH11UbMlFm/8hRyaexdn2+iLAKeRTBV8LbqzYNA5yFZ6eErJeHnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0KlzfU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0KlzfU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4205CC19422;
	Mon, 29 Dec 2025 16:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025092;
	bh=+kA2ZdGg7iDLakVqlnMutKxFjzE7DxzTorz27cmHYbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0KlzfU5AcoaRgZ0mE4cy4YjMDfC7xJvrXp+mXBma/ZjYboRrjQpbsV/02UGcqZMC
	 N4fQGGkuDXyYjCQUS3oUY+oveS/IvCtsgsTAKLqtVPRXkTC/YvEx4lLcKI7LMZ1Ftu
	 g8IfneIIVT63IBzlpLIo4V1+R+WGirY+q5xx6530=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/430] can: j1939: make j1939_sk_bind() fail if device is no longer registered
Date: Mon, 29 Dec 2025 17:08:12 +0100
Message-ID: <20251229160727.673799049@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 88e7160d42489..e3ba2e9fc0e9b 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -482,6 +482,12 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
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
2.51.0



