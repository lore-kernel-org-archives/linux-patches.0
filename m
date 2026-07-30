Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FE443C7C5;
	Thu, 30 Jul 2026 15:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424177; cv=none; b=rr5yQin3ih1Ewcui5sZMlEicWTSX5n9nh+0Ra0M9/nThXt2qHDg4XMlIVKCox6mIKZ+P/SXX8azLgOojNdoTVnJCqoMoZNzKrwjuv6pZY1Gl57/ke7CMUMtySZcOCTI1qtKaLdPzwZn0kRcs0jVVJDzRuR2BMTkus1Hs9E/mDpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424177; c=relaxed/simple;
	bh=xhGPQouWBSidgn8QwHVeZZeyhfD2bX/a4/Fx7M+C8Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDI7S4491Uja38oaxSeNbLH0NXk8LKt1fFhCPgF5Wik9Cyua645cMCNqSEt0WQVWc2hOmHLXN1Tc0FesdbqT27fjQBk7Kol0UsUSRG/IoUFVEhUYH+mq4mA+ecs3ie69SjW8hKGRY42fBz3UYaijYg2n3s3Jmk9xqVuu4W0KgzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZNz3KM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZNz3KM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC701F000E9;
	Thu, 30 Jul 2026 15:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424176;
	bh=7qTcSRz98M+LLiIdqsjo70rsIbZS6N6ocqOY7IJgIyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZNz3KM0onIrurjUvVkoSqYgyS4e4zOLIU1anQnVMVI9bjOIy5xGMYnkx/jjV8rti
	 wcGELeoNUUb64HcjAan1fssBXH5cX3uRwEJ0e7Q5W2k4RQ80DLbgwhHNey2cj3ohJo
	 rbemP9F382VvFRF5bg8+sBX/QeoVJc73wzh2b/+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/675] raw: annotate lockless match fields in raw_v4_match()
Date: Thu, 30 Jul 2026 16:10:31 +0200
Message-ID: <20260730141451.519611401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 18f116931f52e3c3303ad4b15ff41eb89b0e4239 ]

raw_v4_match() is a lockless match helper under sk_for_each_rcu(). It
still reads inet->inet_daddr, inet->inet_rcv_saddr and
sk->sk_bound_dev_if with plain loads while bind, connect and
bind-to-device paths can update the same match fields concurrently.

Annotate only those mutable match fields in raw_v4_match(), and do so
at the point of use instead of hoisting the bound-device read before
the earlier short-circuit tests.

Also annotate the raw bind writer and the shared IPv4 datagram connect
writer used by raw sockets, so the address fields updated on bind and
connect match explicit WRITE_ONCE() updates.

This version intentionally leaves the shared disconnect-side IPv4
writers to follow-up cleanup and limits the writer changes here to the
raw bind path and the datagram connect path directly exercised by raw
sockets.

Fixes: 0daf07e52709 ("raw: convert raw sockets to RCU")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260716142958.3064224-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/datagram.c |  4 ++--
 net/ipv4/raw.c      | 23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index c2b2cda1a7e506..7861615b34fc68 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -63,12 +63,12 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	}
 
 	/* Update addresses before rehashing */
-	inet->inet_daddr = fl4->daddr;
+	WRITE_ONCE(inet->inet_daddr, fl4->daddr);
 	inet->inet_dport = usin->sin_port;
 	if (!inet->inet_saddr)
 		inet->inet_saddr = fl4->saddr;
 	if (!inet->inet_rcv_saddr) {
-		inet->inet_rcv_saddr = fl4->saddr;
+		WRITE_ONCE(inet->inet_rcv_saddr, fl4->saddr);
 		if (sk->sk_prot->rehash)
 			sk->sk_prot->rehash(sk);
 	}
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 26468a2ec63db1..c10cf41a365dc2 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -120,13 +120,21 @@ bool raw_v4_match(struct net *net, const struct sock *sk, unsigned short num,
 		  __be32 raddr, __be32 laddr, int dif, int sdif)
 {
 	const struct inet_sock *inet = inet_sk(sk);
+	__be32 daddr, rcv_saddr;
 
-	if (net_eq(sock_net(sk), net) && inet->inet_num == num	&&
-	    !(inet->inet_daddr && inet->inet_daddr != raddr) 	&&
-	    !(inet->inet_rcv_saddr && inet->inet_rcv_saddr != laddr) &&
-	    raw_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
-		return true;
-	return false;
+	if (!net_eq(sock_net(sk), net) || inet->inet_num != num)
+		return false;
+
+	daddr = READ_ONCE(inet->inet_daddr);
+	if (daddr && daddr != raddr)
+		return false;
+
+	rcv_saddr = READ_ONCE(inet->inet_rcv_saddr);
+	if (rcv_saddr && rcv_saddr != laddr)
+		return false;
+
+	return raw_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if),
+				   dif, sdif);
 }
 EXPORT_SYMBOL_GPL(raw_v4_match);
 
@@ -721,7 +729,8 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 					 chk_addr_ret))
 		goto out;
 
-	inet->inet_rcv_saddr = inet->inet_saddr = addr->sin_addr.s_addr;
+	inet->inet_saddr = addr->sin_addr.s_addr;
+	WRITE_ONCE(inet->inet_rcv_saddr, addr->sin_addr.s_addr);
 	if (chk_addr_ret == RTN_MULTICAST || chk_addr_ret == RTN_BROADCAST)
 		inet->inet_saddr = 0;  /* Use device */
 	sk_dst_reset(sk);
-- 
2.53.0



