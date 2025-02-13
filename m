Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DA21CEEBB;
	Thu, 13 Feb 2025 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458974; cv=none; b=oxQqX4lfji3Vm3J7HVML1oHDEnuw/6gPK16Y/wg9oM1AfmMSYvPXdWmNUUMeOhFdWvxecVeEsF/6hDPN+AEVTBD2Dv5cEXMriSkRrgpoUW3zFUjNX1+1Xy7wA/x114TEMPYEsyHCWgS44iwD6JXAL2rkczn6p/jGdeNZXx82xK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458974; c=relaxed/simple;
	bh=XOEBUNzwtpYfWyLPb7lbst0pJd5gZMrGXmJ8seLJ0Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3n+r6G3HiBUXS36gxTilbgWwoIBzNziK8AC09SzORJgqrUBUoELuACMs25wNEj92/oaACRpU9VH0kzOL8sxxCZbB7/lGKnwE/fQ6sBCJ4dJ96+xGU/Sje+SRO5wM23BZF7JJo7OfG8c5jn0odyQVbRzquzru2okce9jltYi2AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnYRa4Q4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnYRa4Q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25217C4CED1;
	Thu, 13 Feb 2025 15:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458974;
	bh=XOEBUNzwtpYfWyLPb7lbst0pJd5gZMrGXmJ8seLJ0Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnYRa4Q4ceOQLShxVCN31fTxVpG+Mc08ILw9uG5o2faOAD/wnd5JWMLefEbAa6/cO
	 vGiw0VcEM3T5ekQsQRYrrr0BpNBMf/dxVy3Ef44hChJa5rGtHkfB7XA3kOWdcMDN6F
	 3nJi7s+ZUBZpmX+EtFH4G/8z6+nb/MsrMuvL8pzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7ff41b5215f0c534534e@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 130/443] net: rose: lock the socket in rose_bind()
Date: Thu, 13 Feb 2025 15:24:55 +0100
Message-ID: <20250213142445.624950628@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a1300691aed9ee852b0a9192e29e2bdc2411a7e6 ]

syzbot reported a soft lockup in rose_loopback_timer(),
with a repro calling bind() from multiple threads.

rose_bind() must lock the socket to avoid this issue.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+7ff41b5215f0c534534e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/67a0f78d.050a0220.d7c5a.00a0.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/20250203170838.3521361-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 72c65d938a150..a4a668b88a8f2 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -701,11 +701,9 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	struct net_device *dev;
 	ax25_address *source;
 	ax25_uid_assoc *user;
+	int err = -EINVAL;
 	int n;
 
-	if (!sock_flag(sk, SOCK_ZAPPED))
-		return -EINVAL;
-
 	if (addr_len != sizeof(struct sockaddr_rose) && addr_len != sizeof(struct full_sockaddr_rose))
 		return -EINVAL;
 
@@ -718,8 +716,15 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if ((unsigned int) addr->srose_ndigis > ROSE_MAX_DIGIS)
 		return -EINVAL;
 
-	if ((dev = rose_dev_get(&addr->srose_addr)) == NULL)
-		return -EADDRNOTAVAIL;
+	lock_sock(sk);
+
+	if (!sock_flag(sk, SOCK_ZAPPED))
+		goto out_release;
+
+	err = -EADDRNOTAVAIL;
+	dev = rose_dev_get(&addr->srose_addr);
+	if (!dev)
+		goto out_release;
 
 	source = &addr->srose_call;
 
@@ -730,7 +735,8 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	} else {
 		if (ax25_uid_policy && !capable(CAP_NET_BIND_SERVICE)) {
 			dev_put(dev);
-			return -EACCES;
+			err = -EACCES;
+			goto out_release;
 		}
 		rose->source_call   = *source;
 	}
@@ -753,8 +759,10 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	rose_insert_socket(sk);
 
 	sock_reset_flag(sk, SOCK_ZAPPED);
-
-	return 0;
+	err = 0;
+out_release:
+	release_sock(sk);
+	return err;
 }
 
 static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_len, int flags)
-- 
2.39.5



