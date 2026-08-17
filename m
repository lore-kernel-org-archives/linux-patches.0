Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D9A43B3C2;
	Mon, 17 Aug 2026 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976240; cv=none; b=XfaCBn6JBeNfmq+Uvqp7GUImp+jNSDXAXdteru9XEFhwHIk6p6LhsJxX1tfKGW9BdYqO4EJiAGmkvo81b8D09R3eqZvVUmboliM9Btj53SHXAzM3rQYbGaepPQYfIqtLvs4EoL+Hpl1bAPJ8s6I7pr5A+MYY2JhpPcJFbk4FmlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976240; c=relaxed/simple;
	bh=U0QfaTLnK73zbYWUVuhqCd9a+IgK11G56YnuXJnLqes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1SRHpNu5xsF24kB3Uvu00k+BNLeVO7k3ktYvISkCdflPquILqh74ZuSXiZ9BH0gENK9KME3RfbkdYB66g25La/PtFmOS+aNpd7tNmmXBTav2lsUb4285g0k3U9mxSFi/A4CFv2rjRpjD/THnYootGYe+hd+0sKPT0LCXkP6wfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAGGgZMZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAGGgZMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A9C1F000E9;
	Mon, 17 Aug 2026 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976239;
	bh=zm8hok6wOBtXumxooVREXAQ+f6w08sKEfx8mSvKxHpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAGGgZMZR0wd3bZEcvvt0FfIkZshoKHjsvpumMvVwhfQNz8Dys0r0HwvvpuiTHvfN
	 65ZA+bgf+ZvxteCmKBCo0PMCjiDDwAyWtl67I/s9tDJM4fzJOn4hwoiSr4cxcoAVTZ
	 WOcop0+08kLYKTABYSO52z1hqdrUrZImvULNfdQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.10 305/389] Bluetooth: SCO: Fix use-after-free in sco_recv_frame() due to missing sock_hold
Date: Mon, 17 Aug 2026 15:32:24 +0200
Message-ID: <20260817132550.934267721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
Signed-off-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 2fbd9c93440ce..b49b2d6bb778e 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -312,7 +312,7 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 	struct sock *sk;
 
 	sco_conn_lock(conn);
-	sk = conn->sk;
+	sk = sco_sock_hold(conn);
 	sco_conn_unlock(conn);
 
 	if (!sk)
@@ -321,11 +321,15 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 	BT_DBG("sk %p len %d", sk, skb->len);
 
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
2.53.0



