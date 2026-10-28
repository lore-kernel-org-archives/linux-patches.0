Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207468;
	b=nBbsPM6/r49xJwz2LmnXX03oHZ0L8mLEh5mUKn8E4GmA5vFQzwRYxF433hV3DFNf5NRu
	 HvLNED198FtYIDK4KLADVtmzKmiD0KYttukptysqFfs11m00LIk3RgFgJ9T0iKXKaJayJ
	 ABNC93zQks+5jKKPISW5+9+FnnQ1tY4g+H0u76EMp9AiQ7bCGD8mUrBD4g+URMaCmzImz
	 +fQrW7QPSqx1moLb/OMuVxFToI4HRFJmvzzfrw5bav07qgKF4He97nlFvOuvB2pz1UYaK
	 feE/v1hsBI6TXBb6Jkh2N5hSOZ0N6D7R4LSWOeG8qWfFO/XYALjh8FyjZ3VwTieoybA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EgRHyO7UfRpgtIzAaAMzgZaVhiRqDhwbiSJz5GelBz4=;
	b=rFKO6aE5pLexp9i4bp3JRusxrTurLEl5CjcyqIlS5hrGPEoK2rPrFn+HfvmJNrHq7+Uh
	 dYC+zvK48R0VuSj2TMlgBxE8OQdS2iRgGmhzIj8bgFuG0WvGJNRZji8VRLAiMM1Rn9V8W
	 5F1VXjPbpK3uvj6ThzvJD2Eh6N1wcNiB7+FD99TWZLRBtDO6g/CU9bPLObq/DszCxaPRo
	 SwVCluRFjaGPRwxSnt4thzskZlYegkzWNg22mSZIjgtc92Rzl4FqFAzXSL/Ta+uqpCRx4
	 bqBbyfVVPiWAqLo9zHTSh0+G1nfbIdCi8KPpZTz44v/DA+0X6jCBHnPbhyxI9DBRAMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sPB0pO1P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD42606A31E;
	Wed, 28 Oct 2026 17:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sPB0pO1P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E371F01828;
	Wed, 28 Oct 2026 17:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207468;
	bh=EgRHyO7UfRpgtIzAaAMzgZaVhiRqDhwbiSJz5GelBz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPB0pO1PmTeZxAB++IESXzOb4x0ioSkQvbSh5TOd6jcnS/hMq0hp9omfQp6NPdqAX
	 DcMZL8RTTXP4oV8+6PQlCPSowy9JCS8l8WSOYrkTV2DIgL/NIk4YJGgoabPS2dmoOV
	 hz6TNaLJY7mr2l3jhzUliQSs3cHyq+7zK5iwtpd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/247] vsock: treat TCP_CLOSING as once-established
Date: Wed, 28 Oct 2026 17:57:10 +0100
Message-ID: <20261028165948.010771340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 4f6ac74fa594a918d41255c941256e1d51592d3b ]

Handle the TCP_ESTABLISHED -> TCP_CLOSING transition on OP_RST, which can
race with the connect loop. Immediately break and return 0 on
ESTABLISHED/CLOSING. The return value of connect() should reflect what
happened up to the point the connection was established or failed. Events
that occur afterwards must not affect it. E.g. even if OP_RW has already
set sk_err, connect() should still return 0, not ENOBUFS because of it.
Adapt the inaccurate comment above signal_pending().

Resetting a socket that is still present in connected_table can lead to
memory corruption. The reporter noted lost transports for in-flight skbs,
and I have reproduced crashes caused by re-insertion into connected_table.

  list_add double add: new=, prev=, next=.
  kernel BUG at lib/list_debug.c:35!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  Workqueue: vsock-loopback vsock_loopback_work
  RIP: 0010:__list_add_valid_or_report+0x11f/0x130
  Call Trace:
   vsock_insert_connected.cold+0xe/0x13
   virtio_transport_recv_pkt+0x10e9/0x1460
   vsock_loopback_work+0x305/0x480
   process_one_work+0xe4c/0x1560
   worker_thread+0x4f1/0xd60
   kthread+0x36e/0x470
   ret_from_fork+0x47b/0x6b0
   ret_from_fork_asm+0x1a/0x30

This fix is supplementary to commit 002541ef650b ("vsock: Ignore
signal/timeout on connect() if already established"). Details under Link.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/netdev/anzT1fREOSyHT99k@v4bel/
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20261005-vsock-connect-reset-closing-v4-1-15d41cfda3ed@rbox.co
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 1fa4dd2ca405b..228e45bf2d769 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1633,23 +1633,22 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 		timeout = schedule_timeout(timeout);
 		lock_sock(sk);
 
-		/* Connection established. Whatever happens to socket once we
-		 * release it, that's not connect()'s concern. No need to go
+		/* Connection was established. Whatever happens to socket once
+		 * we release it, that's not connect()'s concern. No need to go
 		 * into signal and timeout handling. Call it a day.
 		 *
 		 * Note that allowing to "reset" an already established socket
 		 * here is racy and insecure.
 		 */
-		if (sk->sk_state == TCP_ESTABLISHED)
-			break;
+		if (sk->sk_state == TCP_ESTABLISHED ||
+		    sk->sk_state == TCP_CLOSING) {
+			err = 0;
+			goto out_wait;
+		}
 
 		/* If connection was _not_ established and a signal/timeout came
 		 * to be, we want the socket's state reset. User space may want
-		 * to retry.
-		 *
-		 * sk_state != TCP_ESTABLISHED implies that socket is not on
-		 * vsock_connected_table. We keep the binding and the transport
-		 * assigned.
+		 * to retry, so we keep the binding and the transport assigned.
 		 */
 		if (signal_pending(current) || timeout == 0) {
 			err = timeout == 0 ? -ETIMEDOUT : sock_intr_errno(timeout);
-- 
2.53.0



