Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BBB1F946
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06430C433C8;
	Fri, 21 Jul 2023 16:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956674;
	bh=5fMyyvR4f6mVhUVlxE24QxLtOQymFrVb2ooCE/JJ1Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9sl2zGdn6Ve3tToEJy5+dPheNVYWwtBV02tyNtAZtPGemESzpY94P7ICSOj3r89K
	 cGeZb4xdUPSxZexrLt+A6WAVU0TgA8/lVInkXfqOF/LqsX7UUEfUAl9yJDGxgM37cT
	 tK86ueyKaOaE1spI0n7EWm4EcOHuT7g9OdFOU1oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 259/292] mptcp: do not rely on implicit state check in mptcp_listen()
Date: Fri, 21 Jul 2023 18:06:08 +0200
Message-ID: <20230721160540.064247839@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

commit 0226436acf2495cde4b93e7400e5a87305c26054 upstream.

Since the blamed commit, closing the first subflow resets the first
subflow socket state to SS_UNCONNECTED.

The current mptcp listen implementation relies only on such
state to prevent touching not-fully-disconnected sockets.

Incoming mptcp fastclose (or paired endpoint removal) unconditionally
closes the first subflow.

All the above allows an incoming fastclose followed by a listen() call
to successfully race with a blocking recvmsg(), potentially causing the
latter to hit a divide by zero bug in cleanup_rbuf/__tcp_select_window().

Address the issue explicitly checking the msk socket state in
mptcp_listen(). An alternative solution would be moving the first
subflow socket state update into mptcp_disconnect(), but in the long
term the first subflow socket should be removed: better avoid relaying
on it for internal consistency check.

Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/414
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3697,6 +3697,11 @@ static int mptcp_listen(struct socket *s
 	pr_debug("msk=%p", msk);
 
 	lock_sock(sk);
+
+	err = -EINVAL;
+	if (sock->state != SS_UNCONNECTED || sock->type != SOCK_STREAM)
+		goto unlock;
+
 	ssock = __mptcp_nmpc_socket(msk);
 	if (IS_ERR(ssock)) {
 		err = PTR_ERR(ssock);


