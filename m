Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591248;
	b=lkqEToFFJGGv8L/19JUb+lsEE9dHtCQCXzWdEjoAObHsPGNRMF0VxrgjlqI1c1qYY+8j
	 Le9iH+/eT2vdDKJUXyoR+huoB4qhEc8uXn9IUtrtLp9o8LCEzd5InfknXGHg2p9Cf636N
	 A6n2+Y3MZMGAM1M7XBBzOguCD0RRYCDltgf9O1SAHo6ppKqJOKi59iOp8EzOE1yRJFD86
	 uZrgovJNq8jEJ9cLoTeqQoAyCWCsKAYj37dT8G4OoL3OjsoZPMwczXs5CQBzsoLIvaULN
	 BoLCOET2ogfShBI5QjUVDNHif6BqhbveCPPIVjmhfNiqxTNWsmjzYu289/0+ZlI/jmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GcevMOpDO1/+IVXztLycelhWdgQY5TqoxC/lSsT3yQo=;
	b=BAzm2X0eVZ3QpgJ2+/ROKkXe9x3l4rnGZ7X7jdQwkI1SoKWu/jmPM3JvJPctd0gm+rGh
	 M+2y3nuSElQVe+5BPfxWap+AqtK0gQsmZaAwrlyI6K6P+G6zpXUef3h46k2rrnTKXAiu4
	 zW/Kit+txA9S7k3hxA7XDB0vAw02K45/vlXDn46AmUHOclNfX+btXwCm8mvKGG7t0kIAQ
	 OiQlcM2tzrn6sFScK/x58VGNyhA8RcETsDmijrJDW9S9iP4UiSqmZwnuQCgUWKID9vAi/
	 BJ85oMh1RuaJ4EGwKeD0pMYo80i8fGYfWPtGrTzN0CpJhJ4vCNJu/5TPtYdi8Bgyqig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kw3LQEoc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D37E60A262A;
	Fri, 13 Nov 2026 17:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kw3LQEoc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5871F000C4;
	Fri, 13 Nov 2026 17:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591248;
	bh=GcevMOpDO1/+IVXztLycelhWdgQY5TqoxC/lSsT3yQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kw3LQEocxDLXQ9TdMfaNZQzdIwJM6DxWZzyHMdTzurI/2QKn9MuaTwILkE//zGuaN
	 0PLt00zLrdmz5pt0yprolsV8FTtrZCJfquafvUcM54lsP8D2rlsosQUjqefxOMDjpF
	 gJvC4wt+xZ1nCO30ocXgKX6/EMf0Tg/lfcnghUIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dust Li <dust.li@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 373/670] net/smc: dont spin in smc_rx_recvmsg() while a pipe holds spliced data
Date: Fri, 13 Nov 2026 10:48:57 -0500
Message-ID: <20261113153824.434266201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 56dc3175f0473..947ac2e1b16b7 100644
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



