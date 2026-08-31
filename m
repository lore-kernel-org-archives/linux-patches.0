Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9611C4772AA;
	Mon, 31 Aug 2026 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184466; cv=none; b=kgwUWj5OYRzYuSz40d3jn700gL7N/7vfab+rqh4g9caSxZ0E/TH15mLX9wZRfeVOo4cz9tF1QoCjEKExzZDw34kJNaVNEpL5he0/ac5Fr80KI5swRNpewqXm1sBiMbt1AHM5IQTMx1HhQccptP68sHXTj4OkZzgCVuhhOo6tyQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184466; c=relaxed/simple;
	bh=Gcmicjc9h+2aLhwlcQGOwY9IEXhXoYzhloc/ke5lvLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1aysxIr+X9n1qqKn4YpsLjy9TOA93avR+yTJ0/vBKbO7wQdyiBI7ncL5xVIPo/Utdzz91hnRRrnHiw/Lf7Py0Pu/jAkFCEofpm02dHeD8CMmnKDIRUewqEkluLt4jBNC5bqvmrn7kUI7/vKQW8Oc58kC2XVHcSbvRjwiXKsL0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1acECMHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1acECMHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32C01F000E9;
	Mon, 31 Aug 2026 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184465;
	bh=lMqTUr3BJ9jzI+hcxnwYFQYSohnsSTb42CRudN75dlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1acECMHI9cXjGGcwNu0NcqDn1fXVgzaV23u04rjvZKiSOOy0cA7fOOUpayJg2LNat
	 ugaOsyDpCZFHkdknxf6KLpws9VI2M+A64f5caZJu7gmlP/cn69vCkQDNqXW4TflrTF
	 dIsEZIxV8aN/tEuZaiJQoXBX0FNApMZVI1uDVNCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 18/91] can: j1939: make j1939_sk_bind() fail if device is no longer registered
Date: Mon, 31 Aug 2026 15:34:06 +0200
Message-ID: <20260831133400.536487361@linuxfoundation.org>
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
index eeff9b84fba81..4841aae2fcaad 100644
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



