Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B8830CB49;
	Wed, 17 Sep 2025 13:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114138; cv=none; b=Z82Mmd/17ELwxvlGJV7PlyN6w00/FnNNmzi93WMELJcNcz/sMaLwoCGTp2EhCgBqNurHZWOvyurhCDWMy3IIKKEnhGm6flFZ6uZB+5BxC9IlOOYnk/0qrWC4Fozixo29nc5tGQhpbis0spdOj7I1ktvK4ObRjkYpon7GKX19pIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114138; c=relaxed/simple;
	bh=4IKqLTbRjyz0E60MS15vQNlLAFOFn8xCrWWXScqjEOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixKnSAOzNjc6LzCF/Myp6992hogiRYBPWVSuqPL2Rgnkq6f5vhpP8bReUWbCrJ8jMQB36AfgL5Pg7byabwkMtRyM9dDJtkU9lyxBNFsbIRYAtCRwtaLNwh4OKIG/WA27fdTQAhU2wML+Xju7MrVXN3DO1AfGZAnK2ry3zdKRoEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=au7tME8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="au7tME8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF0EC4CEF0;
	Wed, 17 Sep 2025 13:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114136;
	bh=4IKqLTbRjyz0E60MS15vQNlLAFOFn8xCrWWXScqjEOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=au7tME8On1r4Y2StzSiSV5yjmq9tbaUgk57Xjp0Axy8u7v/PeyjqkjtdHUlqayBjm
	 pVFd1odoR7vrUpV9BgoeuSmsNE84qVDFQZ/n0bW/jWb9+UwustppXtU9VWNb47BnKl
	 bRrd0auO96UWxOWqZ9v6eSBOTpB4t/OTSJj4n70U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 56/78] can: j1939: j1939_sk_bind(): call j1939_priv_put() immediately when j1939_local_ecu_get() failed
Date: Wed, 17 Sep 2025 14:35:17 +0200
Message-ID: <20250917123330.937621360@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit f214744c8a27c3c1da6b538c232da22cd027530e ]

Commit 25fe97cb7620 ("can: j1939: move j1939_priv_put() into sk_destruct
callback") expects that a call to j1939_priv_put() can be unconditionally
delayed until j1939_sk_sock_destruct() is called. But a refcount leak will
happen when j1939_sk_bind() is called again after j1939_local_ecu_get()
 from previous j1939_sk_bind() call returned an error. We need to call
j1939_priv_put() before j1939_sk_bind() returns an error.

Fixes: 25fe97cb7620 ("can: j1939: move j1939_priv_put() into sk_destruct callback")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/4f49a1bc-a528-42ad-86c0-187268ab6535@I-love.SAKURA.ne.jp
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 0a4267a24263b..502975fd5f97e 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -520,6 +520,9 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	ret = j1939_local_ecu_get(priv, jsk->addr.src_name, jsk->addr.sa);
 	if (ret) {
 		j1939_netdev_stop(priv);
+		jsk->priv = NULL;
+		synchronize_rcu();
+		j1939_priv_put(priv);
 		goto out_release_sock;
 	}
 
-- 
2.51.0



