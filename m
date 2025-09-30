Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A7A1AB6F1;
	Tue, 30 Sep 2025 14:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244137; cv=none; b=GbHX74d4NuJaVBO94u49r4UytBVHGzEI4Lxmwp3GcjiyJmoDiLj1w/SfyvQKt0E50AJXcBVlhsfKz1Rvq3aSt6FI5wIOUBsUC5egYFjl4HcVpXmCzY2C8g/h9ptdHiBD+VEncYkfhGQbL2DHUNFJZnBIHFuWoeecmDS1aSvmeIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244137; c=relaxed/simple;
	bh=LmAgm3xMg4Qo72IJPbjVOKm7IFjIrRsYwDX0n8bkvfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNLOACxnIYFDsybg8JM8W7ugg8eGzn76CH7mndkkpz+V4CYsknTa2yoRMAu4fzgLFJRQzjJtYfRThDCX+Q+ZE8FOxv6usYOWeOJ8dRWqRkWPR9b/XJE+fld+pfJv3D31mTcuwwkDEHFEvOd1nyU0ysEehf+OKiT2gPncK9T5U80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i66yUgvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i66yUgvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCA8C113D0;
	Tue, 30 Sep 2025 14:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244137;
	bh=LmAgm3xMg4Qo72IJPbjVOKm7IFjIrRsYwDX0n8bkvfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i66yUgvutByTPM2ZwV1tDdXDWGm210gecLE1ZTgcShSQgiChCrOLorFoN36t7ElOc
	 DIcmIh1O3OSF5rVnuitgBZnvu9fhndnzxndNG+11v2j0HxiwBd7Z/8Sd3QpesuxEsO
	 eg1muwjJIf/Jv26YK7Tx47IbHNrFr4+/PJu9fg5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/122] can: j1939: j1939_sk_bind(): call j1939_priv_put() immediately when j1939_local_ecu_get() failed
Date: Tue, 30 Sep 2025 16:46:09 +0200
Message-ID: <20250930143824.563772952@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 45ae7a235dbff..34cd4792d5d41 100644
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



