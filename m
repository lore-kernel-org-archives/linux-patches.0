Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B7F1BDFD;
	Wed,  3 Jan 2024 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuJMNfBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1ECC433C7;
	Wed,  3 Jan 2024 17:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301647;
	bh=DoZWHpHLXisL7cstHWcY6Uji471Zq7STr4gQ9i2ENrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuJMNfBSBgauXIFg+k955wdiD71/4pyivPnBy7+XS9kgtVbJ2h6fCts9vTVEIgMX0
	 kzTJ2RGGwfTqMMJXQy6fPuAlEYeFeZY11sP8pu2jb/cGdWUKRg+sZReH5HIxGb4poB
	 RTk+UHK5T77AxeoxrG7jtckDzt866Lku/VoWqLek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 85/95] Bluetooth: af_bluetooth: Fix Use-After-Free in bt_sock_recvmsg
Date: Wed,  3 Jan 2024 17:55:33 +0100
Message-ID: <20240103164906.813368557@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit 2e07e8348ea454615e268222ae3fc240421be768 ]

This can cause a race with bt_sock_ioctl() because
bt_sock_recvmsg() gets the skb from sk->sk_receive_queue
and then frees it without holding lock_sock.
A use-after-free for a skb occurs with the following flow.
```
bt_sock_recvmsg() -> skb_recv_datagram() -> skb_free_datagram()
bt_sock_ioctl() -> skb_peek()
```
Add lock_sock to bt_sock_recvmsg() to fix this issue.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/af_bluetooth.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index ce744b14d1a98..b7498e890f0b0 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -263,11 +263,14 @@ int bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
+	lock_sock(sk);
+
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
-			return 0;
+			err = 0;
 
+		release_sock(sk);
 		return err;
 	}
 
@@ -293,6 +296,8 @@ int bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	skb_free_datagram(sk, skb);
 
+	release_sock(sk);
+
 	if (flags & MSG_TRUNC)
 		copied = skblen;
 
-- 
2.43.0



