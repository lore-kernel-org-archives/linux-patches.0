Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1D01487F4;
	Tue, 30 Sep 2025 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245029; cv=none; b=gSd4LGXEiBEkQ2NHVp/ZxxZYQxa2LOAGiTqVIsNtawlmIMAvKXdUvqV4spfBxzwuS/K0heg90FmxXG7VaiKbyTv5cF4xqFPSbU+EUhmlVqtmuNkEYEqQzVreZ58TzFGYKIDvsQgP25pJ42uOBGrISOFPVrZCQgWZBt08Bt2aPjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245029; c=relaxed/simple;
	bh=wRphZvcWM2ZcidinElB5jADy4TDcGNIC6+ffz5v+IS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlPKoiQp4fx/4ljMoMFjQ8HdLmN9wQT6y2UfNLwUHOr1H83ZuOfRTVhr6Z/gIMeI9YIo6bSA6a5l5rgow0s2j6BuY29DqI7DTGsnD0rk9lqjJXYxix92+ec1RIs28LqwCh11zOVfAXxKzMlWmHypfJkE07UideRFiYjf+MTRltg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KRCSeEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KRCSeEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DA6C4CEF0;
	Tue, 30 Sep 2025 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245029;
	bh=wRphZvcWM2ZcidinElB5jADy4TDcGNIC6+ffz5v+IS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KRCSeEPhQQXn0ihypxlp0tZW531hDjPY7Pwi3zzXxcooehS0hQV00Lt/p1dl6lQc
	 LXdZdDqiSTyd/le1x1XwAhC4HZ//MsLRGZX6KQun6Vm9SrCYVhCsfMQ+L+VjnolS7K
	 oDCvnSkIKI3A4DU1m2Zkld2fjvUWa3QSj+hf8N3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/151] can: j1939: j1939_sk_bind(): call j1939_priv_put() immediately when j1939_local_ecu_get() failed
Date: Tue, 30 Sep 2025 16:46:14 +0200
Message-ID: <20250930143829.362580511@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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
index d8ba84828f234..ec2927566cf3e 100644
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



