Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174A1481B3;
	Mon, 14 Oct 2024 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917196; cv=none; b=ppc3csAXSCevCfQdLVbePJTwwYcIQ4/6Ai7P2lfIppE0V/0tZBEenwaPrgDIf+z9JlnErSPw5FHPFCjOgMwvpDa61SZKg3CS5aaITUHNJdmwWDfPzIPpJKom5vGMU1p4sUZ3QtF4gAMY+I7jMjhnFNL844gNY/cjLGzBr6heV9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917196; c=relaxed/simple;
	bh=DloLLRpy2KqGfWXZxc677I7z0Ompid/BKy3WAnPXz1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNvu9+Ze1QWXwHKKnqCGyPLKzII1ld1I8f5vRJA2QhcGfpAZZSZxoVQPVjVVRl9S0qTbXhgsFBECsFjST30GPwcZCB1f2tlNvbHNaR4/Jm90RP+sneAvzW7nQN93EnhRqT939d7NtaaJq15Bc493qjuQvdbnRYGRfXidKXYSmRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7rGOg7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7rGOg7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B068C4CEC3;
	Mon, 14 Oct 2024 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917195;
	bh=DloLLRpy2KqGfWXZxc677I7z0Ompid/BKy3WAnPXz1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7rGOg7WxI6au9js68V+ScqKajSM9Vn9YNq0HFtmoWXZLdSlGdx8/gRYvpVv25stj
	 hqIxMewTLqJATFevR4VvnU5E2ylcARuvZ2JxW+YbGqVRupOXVz4CpnYj8j+HxE29pV
	 hBZDB6uqsMpWWdpIHMhZ3PBV7X6+5sKF9zXnoLBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/213] sctp: ensure sk_state is set to CLOSED if hashing fails in sctp_listen_start
Date: Mon, 14 Oct 2024 16:20:54 +0200
Message-ID: <20241014141048.744510052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 4d5c70e6155d5eae198bade4afeab3c1b15073b6 ]

If hashing fails in sctp_listen_start(), the socket remains in the
LISTENING state, even though it was not added to the hash table.
This can lead to a scenario where a socket appears to be listening
without actually being accessible.

This patch ensures that if the hashing operation fails, the sk_state
is set back to CLOSED before returning an error.

Note that there is no need to undo the autobind operation if hashing
fails, as the bind port can still be used for next listen() call on
the same socket.

Fixes: 76c6d988aeb3 ("sctp: add sock_reuseport for the sock in __sctp_hash_endpoint")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4a1ebe46d045d..108a0745c0c3c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8525,6 +8525,7 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 	struct sctp_endpoint *ep = sp->ep;
 	struct crypto_shash *tfm = NULL;
 	char alg[32];
+	int err;
 
 	/* Allocate HMAC for generating cookie. */
 	if (!sp->hmac && sp->sctp_hmac_alg) {
@@ -8552,18 +8553,25 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 	inet_sk_set_state(sk, SCTP_SS_LISTENING);
 	if (!ep->base.bind_addr.port) {
 		if (sctp_autobind(sk)) {
-			inet_sk_set_state(sk, SCTP_SS_CLOSED);
-			return -EAGAIN;
+			err = -EAGAIN;
+			goto err;
 		}
 	} else {
 		if (sctp_get_port(sk, inet_sk(sk)->inet_num)) {
-			inet_sk_set_state(sk, SCTP_SS_CLOSED);
-			return -EADDRINUSE;
+			err = -EADDRINUSE;
+			goto err;
 		}
 	}
 
 	WRITE_ONCE(sk->sk_max_ack_backlog, backlog);
-	return sctp_hash_endpoint(ep);
+	err = sctp_hash_endpoint(ep);
+	if (err)
+		goto err;
+
+	return 0;
+err:
+	inet_sk_set_state(sk, SCTP_SS_CLOSED);
+	return err;
 }
 
 /*
-- 
2.43.0



