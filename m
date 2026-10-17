Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461E93A1E92;
	Sat, 17 Oct 2026 17:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259968; cv=none; b=J4FX6/e2vZO4Yj7fAyvE4SVOVjb15nr5a5stNfh4Lz55l5GRsZvdtpOmbr+0Rot+m2M2RWjVPJ0aN3dN2AXNwYs+VSz5HGm7ZsG5Hv2GR9s9snZS0yz2+oB1xG3Mr4NVmfqMQ4V+FsohWorbE1wxvTx6emltUvPxte4zROLsmaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259968; c=relaxed/simple;
	bh=hGaLwtEgDB28SPQzvnONIGjRCeTPXSNonzxvo2rsiuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YexDYhRB9ccwqw0NGrGyG4kzCq5fMiNGo1YvRM7fontyYnkhABWkwwEeBHunNM7xiJ6CzLradZfJPvIkJYI2q3wg3Bq2MqUSSxpKVCvELV7g+7NLPFmkuH7XrXpwMW93xbCEwmd3+wxMbozZzT0Gwcuh9yuaHdSeXqoOIpWEfS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+9mJaQo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+9mJaQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468BA1F000C4;
	Sat, 17 Oct 2026 17:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259966;
	bh=MMWwRH02X/5XLp8O8tsPp0viuTElIXzqZBtkKDKzhXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+9mJaQoR1B9YtieKxeSEEaUkM4LFNxUTlwDIJhnWeBcqoCjfbSi8mfUMuvPQLpVy
	 pgzCpNBz2clML8Po6v9LiPBof4Ff1sUsips6i6dtWHckzuQGsrRPf9dxO/xGOHxzKq
	 fUeQ9au6EPvsi6MvSE3jy9DMXjPVZpV6aM4mmluQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1b2c9c4a0f8708082678@syzkaller.appspotmail.com,
	Michal Luczaj <mhal@rbox.co>,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1389/1674] vsock: dont check the listeners sk_err in vsock_accept()
Date: Sat, 17 Oct 2026 18:01:01 +0200
Message-ID: <20261017160506.821807971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Dinh Phi <phind.uet@gmail.com>

[ Upstream commit b8c899cf5e7be29840a172c183dedd8d3e7a0287 ]

Syzbot reported an issue which can be reproduced with these steps:
	r0 = socket(AF_VSOCK, SOCK_STREAM, 0)
	bind(r0, {VMADDR_CID_ANY, PORT})
	connect(r0, {VMADDR_CID_LOCAL, PORT}) -> -1, EPROTO (self-connect)
	listen(r0, backlog)                   -> 0
	r1 = socket(AF_VSOCK, SOCK_STREAM, 0)
	connect(r1, {VMADDR_CID_LOCAL, PORT}) -> 0
	accept(r0)                            -> -1, EPROTO (stale sk_err)

Basically, it creates a socket (r0) and triggers a self-connect after
binding it. This self-connect fails with EPROTO because it loops back
to r0 while the socket is still in the TCP_SYN_SENT state, causing it
to be incorrectly dispatched to the connecting-client path. The
unexpected packet type encountered there sets sk_err to EPROTO.

After that, it invokes a listen() call on the same socket. This
listen() call succeeds because the kernel's listening path never
inspects or clears sk_err. Then, a new socket (r1) is created as a
normal client and connects to r0. However, vsock_accept() rejects this
incoming connection because the listener's sk_err still holds the
EPROTO error from the earlier failed self-connect.

This rejection causes the child socket created for r1's connection to
never be freed on virtio or hyperv transports; only the VMCI transport
implements pending_work to revisit and clean up a rejected socket.

For a non-blocking connect(), vsock_connect() may return -EINPROGRESS
immediately, and vsock_connect_timeout() can later set sk->sk_err
asynchronously.

Since no vsock transport ever sets sk_err on a socket while it is in
TCP_LISTEN state, checking it in vsock_accept() serves no purpose and
only carries forward errors left behind by earlier, unrelated
connection attempts on the same socket. Remove the checks so accept()
no longer rejects valid incoming connections because of a stale
error, which also avoids the resource leak described above.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reported-by: syzbot+1b2c9c4a0f8708082678@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1b2c9c4a0f8708082678
Suggested-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260813173024.2362935-2-phind.uet@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 1392fcde77764..6b7bdd6166c06 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1649,8 +1649,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 	timeout = sock_rcvtimeo(listener, flags & O_NONBLOCK);
 	prepare_to_wait(sk_sleep(listener), &wait, TASK_INTERRUPTIBLE);
 
-	while ((connected = vsock_dequeue_accept(listener)) == NULL &&
-	       listener->sk_err == 0) {
+	while ((connected = vsock_dequeue_accept(listener)) == NULL) {
 		release_sock(listener);
 		timeout = schedule_timeout(timeout);
 		finish_wait(sk_sleep(listener), &wait);
@@ -1668,9 +1667,6 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 	}
 	finish_wait(sk_sleep(listener), &wait);
 
-	if (listener->sk_err)
-		err = -listener->sk_err;
-
 	if (connected) {
 		sk_acceptq_removed(listener);
 
-- 
2.53.0



