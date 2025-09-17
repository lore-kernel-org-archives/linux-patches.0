Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0C8335948;
	Wed, 17 Sep 2025 12:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113968; cv=none; b=MoM/32rKKZJcHPzKJ3eqG8Sfj3ta+zcrK7rikKyDwqt5dHFp1kPc+f3IFp8sbwqZlSj99DcN1x5U3QY04JgyYZWi/SALJEOMxn+YH+jka4EdspfGfuO3Kz4CF0XB60R6ErnlCCEuiEK61kHzf7e7e1J1ARsrWUQfnRy6UyUtin0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113968; c=relaxed/simple;
	bh=HLK2ksj5szmBqNzsshsdbOdViKhRFH/we8GWFFZt6gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaiZE7LMiDC9lyzmXmKSlS3jtg9Chpwvvh6pbY+JjcSGfb4KlPNTE6VLZUp/mL0FCI4+VF0XVYFnmt31umfmXJhNdgCKFfKwbzrC/xfL7j+EQosWCUoiNxIHSxc4eVyXb/e1rcnwOvLxkj3T+AblsSAx74481nX5lve625Yjehg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoeP5rck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoeP5rck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BDFC4CEF5;
	Wed, 17 Sep 2025 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113968;
	bh=HLK2ksj5szmBqNzsshsdbOdViKhRFH/we8GWFFZt6gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoeP5rckPbV9NgIe9j7ZFYKQy2jBy+E+/DhHNEWpYa7Rnh7Is+cG8nwkysDkuvkn+
	 BO+sdudOY0DCfp3kXloNMgrEbReVBA44RDVkT3zbD82gnBsNYw2HpZ+urNRjxSzEW3
	 oD6aH9v39Zv4I3Zuiq1n9enrlV+GhbUAxzAjuJKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/101] can: j1939: j1939_sk_bind(): call j1939_priv_put() immediately when j1939_local_ecu_get() failed
Date: Wed, 17 Sep 2025 14:34:57 +0200
Message-ID: <20250917123338.626349286@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cf9a12d8da6f9..7bf4d4fb96735 100644
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



