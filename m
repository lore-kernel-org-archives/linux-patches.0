Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE38027BF9E;
	Tue,  8 Apr 2025 12:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116967; cv=none; b=ix76UJbaamNDjOiUHygq2G6Yfa3KTDHsM9KSvJFLipllu1VCvSMhyDL7FffKfdxRtSxBgUIy6nzmP0/MiOZIjRbI/yYCb+n3eVWFBkPPrv2s7+38Qyez1LTG+8gzOBYPhvdwJjXS+SY9eJ+pWDveQFSmPkBG/ibpnAS8gBDW+QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116967; c=relaxed/simple;
	bh=O+bvEeebAS80ZBoN4pHUsZTDbbJHc07eEb0hf/fv2as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0g6F2yNzMzJadjS4Lq9lIK8g8oRrGRPm2p0iMtHhSJ7U6YtlwxMUkXng+tZJatyn/nIrAdeXwP91mNH+U7zMrflaEanoWmUu0VMzhmhZ5ZSGT9tZv3YfciFzd00lDsuznLYM4yo1KP6uRPtFIRGr8weEnIwj2+oqobBLgOLHYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y59cOQZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y59cOQZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF38C4CEE5;
	Tue,  8 Apr 2025 12:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116967;
	bh=O+bvEeebAS80ZBoN4pHUsZTDbbJHc07eEb0hf/fv2as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y59cOQZz5AU+NOvza03FkPL5FV4TtIZuvrGegjL5WmNPxO6SOO9ParPHUpjty8qpe
	 q3KqpveTg2uIoL1hII3DXAgdKAxWXf0lcOXVYMJduKZuU33oiv5egy+SHcRSUcfeSM
	 A49hWyrDi75x5YEZV2RidVqac1YJWHThIli2QwII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/423] vsock: avoid timeout during connect() if the socket is closing
Date: Tue,  8 Apr 2025 12:51:00 +0200
Message-ID: <20250408104853.612507074@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit fccd2b711d9628c7ce0111d5e4938652101ee30a ]

When a peer attempts to establish a connection, vsock_connect() contains
a loop that waits for the state to be TCP_ESTABLISHED. However, the
other peer can be fast enough to accept the connection and close it
immediately, thus moving the state to TCP_CLOSING.

When this happens, the peer in the vsock_connect() is properly woken up,
but since the state is not TCP_ESTABLISHED, it goes back to sleep
until the timeout expires, returning -ETIMEDOUT.

If the socket state is TCP_CLOSING, waiting for the timeout is pointless.
vsock_connect() can return immediately without errors or delay since the
connection actually happened. The socket will be in a closing state,
but this is not an issue, and subsequent calls will fail as expected.

We discovered this issue while developing a test that accepts and
immediately closes connections to stress the transport switch between
two connect() calls, where the first one was interrupted by a signal
(see Closes link).

Reported-by: Luigi Leonardi <leonardi@redhat.com>
Closes: https://lore.kernel.org/virtualization/bq6hxrolno2vmtqwcvb5bljfpb7mvwb3kohrvaed6auz5vxrfv@ijmd2f3grobn/
Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Luigi Leonardi <leonardi@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://patch.msgid.link/20250328141528.420719-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index eb6ea26b390ee..d08f205b33dcc 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1551,7 +1551,11 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 	timeout = vsk->connect_timeout;
 	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 
-	while (sk->sk_state != TCP_ESTABLISHED && sk->sk_err == 0) {
+	/* If the socket is already closing or it is in an error state, there
+	 * is no point in waiting.
+	 */
+	while (sk->sk_state != TCP_ESTABLISHED &&
+	       sk->sk_state != TCP_CLOSING && sk->sk_err == 0) {
 		if (flags & O_NONBLOCK) {
 			/* If we're not going to block, we schedule a timeout
 			 * function to generate a timeout on the connection
-- 
2.39.5



