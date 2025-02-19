Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C7D1C4A06;
	Wed, 19 Feb 2025 09:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956867; cv=none; b=Kyo5AMzc49G+oJuiqEgkpuUKAJzPjutxqkEE983sTZMSE4UAANTs/ii/q7jUBjCIiZ1BxK/KM2NJ2OgHUlQAXnDQ0DyrgPXL8hWHbtNgUkyrBkK7HSes1fKB+RI0+U+niYk6E35G1yXERVjt+rXY5iTNRkF092DsJFUuDPYtFS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956867; c=relaxed/simple;
	bh=oWqvqsFlmIdUuQryL2Nm3QKTvyWe+uM7qhDQxjy24Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XP85um0MvMOyr0oI27kHS0DBTlWUmnGtJjlTlNHpvRoOHr5hGJ4CjLkvzJpSpBWVDKrsVMo/4MEYGJMrp2Bi9yKOsVqgJhzSduySS5ETOzue+Mdu7ZnUrAGuwgXq49AnPQ3xXxL2xIFv6F4+4oh+pjp80dTZVDF+Z2Ex8E8/kP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Azke/7Ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Azke/7Ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD84C4CEE7;
	Wed, 19 Feb 2025 09:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956867;
	bh=oWqvqsFlmIdUuQryL2Nm3QKTvyWe+uM7qhDQxjy24Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Azke/7EwxMVlYtwJ7bMQywRw5pPr9d7YURImljeLc6Yo2XgRXewoFSIkeYRGLdLfV
	 bmrA1uVB4O4MB3BwOmIXnEAs1j/87pJbEmQ4h8yUqKPuaxAGou4ThhvxHwKZI5NxHu
	 pWYyKt7UqJnPYY905zAzV8k3Y7B+0mAuOO43Vlbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7ff41b5215f0c534534e@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 328/578] net: rose: lock the socket in rose_bind()
Date: Wed, 19 Feb 2025 09:25:32 +0100
Message-ID: <20250219082705.912740666@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
index 8b0f249c94570..b21c2ce401928 100644
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



