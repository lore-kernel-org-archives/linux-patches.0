Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037883;
	b=Q//92fiUIPNNCtTo04jvbpj5Ns3z4Ax7at5Ro9tLAY0oJ3NbCC2ZK1EY0LyeW5x9f934
	 PKzH56n5xR8qRXzpp2I4pbChmW+xrqYLoJ6zFNZnz2/oc/AviAGZ+DpVJ7IUFV6yuPjN9
	 NlOwoHqCqZUPi3n622Xb2boi30oS7m6Cd8vMl7NsMUB0pky8RIIxWmlXHOaYq3VJwp13V
	 vbrbi/nvhGTMeikzyFPOt98BWdc8OiSgzhAIK0KhyX3BjiLEX4+36viJygqQvmQjQ8WAJ
	 opmM52wSpKQ8QM8bYHIAdD5Tawh9Ax2g85BIKKBGsxbaSwlIAo2gMVRf+lCtPdifWoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q6P4F0u7JOqIKPalY7aIGFVU2dCySkHPQW6BokwBmRI=;
	b=iEYTMVbXit3WoHcZZXMn3cYaziNA6BVfs8rJ52bcIPIKaO214kWnKzFj+6mwLG3BRa5S
	 5oAw6pNde0CTskK1JKwem2kW6n2WDpXgDU11Mn1v6FrZHzD0orHTKbhDdO/2xjrsDK9Nm
	 BLcpo0OnDQItLFab/4sYS7wtmpEM1PmGkJ/Xa050ZEiLXuq5R6Kjg9+4muCvk8XUaGI1a
	 ndTdHRjVC2sVTVt5c7MVVvTAR4sGfNP9nJyfip9+admq2GuClHh1LKLVixaBoPk4NHOAF
	 /JR6kk/QDYKgpATuS9Dbjw11TMNh1d6oAOn6Ro7h+GMt7uBaXqFvGIhBr0xHC7lVGGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvYazLAU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D156B606A320;
	Wed, 18 Nov 2026 21:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvYazLAU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61D91F000C4;
	Wed, 18 Nov 2026 21:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037883;
	bh=Q6P4F0u7JOqIKPalY7aIGFVU2dCySkHPQW6BokwBmRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvYazLAUMz5Acu0XJqKUmDUd2zo/0ugjIVJasBi7qaNh3xbs7z4dYClSkkWC2Lo7J
	 WpcOwzHAoIGPw6t4YEUKBPGomwI1hXqx4N9bakxtBQIwOJYkfPk7Rr18KpX1DiNq/E
	 6kWUvwjp27RvLeZbXBS1UjIaX5cdsS2OnArUIdrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dust Li <dust.li@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1550/3318] net/smc: dont spin in smc_rx_recvmsg() while a pipe holds spliced data
Date: Wed, 18 Nov 2026 15:36:12 +0100
Message-ID: <20261118150407.505529539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 8288ba942cfd20621c05e16978b7c3da91513ae1 ]

While bytes spliced off the RMB are still in a pipe, recvmsg() waits
for the pipe to release them before it copies the data behind them.
The path to that wait skips the timeout and signal checks, and
smc_rx_wait() returns at once on RCV_SHUTDOWN. With a signal pending,
after SHUT_RD, or once the peer closes or shuts down writing,
recvmsg() spins on a CPU until the pipe is drained, and SIGKILL cannot
stop it. MSG_DONTWAIT and an expired SO_RCVTIMEO wait there too
instead of returning -EAGAIN.

Check the timeout and signals before that wait, and end it when the
pipe releases the data or the connection is killed, not on RCV_SHUTDOWN.
A zero-length read returns 0 without waiting for the pipe; a
non-blocking one returns -EAGAIN while poll() still reports the socket
readable (splice() can still take those bytes). The wait sets
SOCKWQ_ASYNC_WAITDATA like smc_rx_wait(), so a byte arriving behind
the pipe raises no SIGIO on a reader already asleep for it, and a full
barrier orders its wait queue entry before its read of splice_pending,
so no wake is lost.

Fixes: 9014db202cb7 ("smc: add support for splice()")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_rx.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 374886f332287..06680e9016fd0 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -286,6 +286,27 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo, size_t peeked,
 	return rc;
 }
 
+/* Wait for the pipe to release the spliced data. Unlike smc_rx_wait()
+ * it does not end on shutdown or sk_err, the data is already in the
+ * RMB; smc_conn_kill() wakes it and the caller checks conn->killed.
+ */
+static void smc_rx_wait_splice(struct smc_sock *smc, long *timeo)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	struct smc_connection *conn = &smc->conn;
+	struct sock *sk = &smc->sk;
+
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	add_wait_queue(sk_sleep(sk), &wait);
+	/* pairs with the smp_mb() in wq_has_sleeper(): the release drops
+	 * splice_pending, then looks for a sleeper
+	 */
+	smp_mb();
+	sk_wait_event(sk, timeo, !atomic_read(&conn->splice_pending), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+}
+
 static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
 			   int flags)
 {
@@ -443,7 +464,23 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 		/* could be just 1 byte, even after waiting on data above */
 		readable = smc_rx_data_available(conn, peeked_bytes);
 		splbytes = atomic_read(&conn->splice_pending);
-		if (!readable || (msg && splbytes)) {
+		if (msg && splbytes) {
+			/* a pipe holds bytes ahead of these; the copy path
+			 * skips the timeout and signal checks
+			 */
+			if (!read_remaining)
+				break;
+			if (!timeo || signal_pending(current)) {
+				if (!read_done)
+					read_done = timeo ?
+						    sock_intr_errno(timeo) :
+						    -EAGAIN;
+				break;
+			}
+			smc_rx_wait_splice(smc, &timeo);
+			continue;
+		}
+		if (!readable) {
 			if (splbytes)
 				func = smc_rx_data_available_and_no_splice_pend;
 			else
-- 
2.53.0



