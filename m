Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B712D97BB;
	Tue, 31 Mar 2026 17:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976417; cv=none; b=jJJwdKqP3HUXHnuzpPEEAIrlAheLgz1cHQHuS5b8ylooZjUsChGDIcddr5xJggnVoMM9xuuI+O2Zuxfy9zb6oHPBu9L5zy9MhWDQJ7zraragTTeg+BvSoNynNIiajEFQUOjLDyWYXKv0Pvz2IYzjmnUeN68t9/BKxskEMwOqfO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976417; c=relaxed/simple;
	bh=IbsVwWuGvSVoWhqLo30njb9MBK6ZVqNRuz6qElaS8uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5EQ1iFNXbzJ0Drs2GYTrVwFafepSKu6kSNu5gBjkktaFvDj4liwkgJayRoTgbv6IevYPj5WZRw30PayGWqlzCaFgRckHrbZBnezLN7EbYR6Fnw9r1FkGohMW7wge9lWBZfnevuwzKCA/IRRrIpKRNn0Eslf4T6WOWWf430aw8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nU/Ocq0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nU/Ocq0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B284C2BCB1;
	Tue, 31 Mar 2026 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976417;
	bh=IbsVwWuGvSVoWhqLo30njb9MBK6ZVqNRuz6qElaS8uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nU/Ocq0yAd4F2m50x8IEO+cGT5MkDtwtce5/HWl2wY6t8FqBouwL9Caz35bH1qT2k
	 gubt+qgWm7XTpYdxqZKKTn4atVhB+eIGyR/x8H+C93EXfjlTKYmdv8Dsnfb2FUTFo5
	 9kB4L9elO0ko1l2nXFt142GMx4+apxqVX4SY+6Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/309] Bluetooth: SCO: Fix use-after-free in sco_recv_frame() due to missing sock_hold
Date: Tue, 31 Mar 2026 18:19:47 +0200
Message-ID: <20260331161756.576741497@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 598dbba9919c5e36c54fe1709b557d64120cb94b ]

sco_recv_frame() reads conn->sk under sco_conn_lock() but immediately
releases the lock without holding a reference to the socket. A concurrent
close() can free the socket between the lock release and the subsequent
sk->sk_state access, resulting in a use-after-free.

Other functions in the same file (sco_sock_timeout(), sco_conn_del())
correctly use sco_sock_hold() to safely hold a reference under the lock.

Fix by using sco_sock_hold() to take a reference before releasing the
lock, and adding sock_put() on all exit paths.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 49a47eaa674da..f7b50cc730476 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -401,7 +401,7 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 	struct sock *sk;
 
 	sco_conn_lock(conn);
-	sk = conn->sk;
+	sk = sco_sock_hold(conn);
 	sco_conn_unlock(conn);
 
 	if (!sk)
@@ -410,11 +410,15 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 	BT_DBG("sk %p len %u", sk, skb->len);
 
 	if (sk->sk_state != BT_CONNECTED)
-		goto drop;
+		goto drop_put;
 
-	if (!sock_queue_rcv_skb(sk, skb))
+	if (!sock_queue_rcv_skb(sk, skb)) {
+		sock_put(sk);
 		return;
+	}
 
+drop_put:
+	sock_put(sk);
 drop:
 	kfree_skb(skb);
 }
-- 
2.51.0



