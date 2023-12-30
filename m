Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD7A8473;
	Sat, 30 Dec 2023 12:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKTc4hb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E09C433C9;
	Sat, 30 Dec 2023 12:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938220;
	bh=qGCdGBPVvz7/vrwD9pdQbyKfPGBCZGPEuYc8oX0Cz9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKTc4hb3euYWe2AqCtTN/jD3z01PHdAZG8+l9fO8meykD29e369FXNyDDhBCjRO0D
	 +cnDzmIrGAc1Gc2cz98Or+lvVwzBzwPz8O3jLsOPcTmtK9g3AKg0jwwwcGgzSz2Otb
	 HPsWLxIA9w9dEZsauElWhOJ90Z0yJajnDwKdA9JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 072/112] Bluetooth: af_bluetooth: Fix Use-After-Free in bt_sock_recvmsg
Date: Sat, 30 Dec 2023 11:59:45 +0000
Message-ID: <20231230115809.045659707@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <v4bel@theori.io>

commit 2e07e8348ea454615e268222ae3fc240421be768 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/af_bluetooth.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -264,11 +264,14 @@ int bt_sock_recvmsg(struct socket *sock,
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
+	lock_sock(sk);
+
 	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
-			return 0;
+			err = 0;
 
+		release_sock(sk);
 		return err;
 	}
 
@@ -294,6 +297,8 @@ int bt_sock_recvmsg(struct socket *sock,
 
 	skb_free_datagram(sk, skb);
 
+	release_sock(sk);
+
 	if (flags & MSG_TRUNC)
 		copied = skblen;
 


