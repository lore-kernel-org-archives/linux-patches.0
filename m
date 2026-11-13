Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585824;
	b=bxkNj/gSZZNohpX8vIA9AAHdariJqjDPyZbodStOTP3DpqlvdC9pEfJO3/gd16+7dykb
	 kTVfvzlD18R9RtPgQ3RotaOeki70t+WR3L56R2G/YInRkrmC6wyCUXyvGLvzj8gk4HRCW
	 a7FCzdAsmWxZamowyYUKhrrPWrULxTfJFE6YT/OVqvHG+noT3fZDoRQ4fdcmBXeA0tV3J
	 9m87hF6au6Ka1rSlQYj0lSm99zwY6I5Q59toumSy9Cs4KA/fvZnHYHFioqOKmI+aLMdnr
	 wsqiBTj8sUQxocbsGMqxUz31XJo1w+3tIUtKu5py0/4W/KWaGlUYeNkCq+kbUfQt5xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Re5y8sHSHj1oguEG3k3xgwkRgk6LQPEQRX5YtHHEpIs=;
	b=IWMXHss8QoB0Yv/wjksJabwSog50TCy5DGh3wyqYGoNZhNy5E7YJr1YDenS2eIZONRIH
	 ndH44ZmrgQuqGsCxsCB1Ijgamdq1/Vc69PDgYjFMmIerF3RKWehSqU0NYsSGlVdqqXkRZ
	 mXJiw1vIA76U15wTNeljXasSzA7Nk6JUjj5V+qpNw7iZXiHDv0fawXa+HtGyr4kGsmK4D
	 gKbLrUbdNaf8T05ArhxDaTCZy0WUVqiFf/tBBl3jYuSRjBjVpMmj3kWJuAo4+qEb9q1VO
	 48BTh2KbqDF1TiQZh7MpzHlKJxsvGCCzxJMLHFktvUiyZNXf/3C1D0+dJkACTGtC/tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oq4vrH5q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2D6606C56D;
	Fri, 13 Nov 2026 16:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oq4vrH5q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD551F000C5;
	Fri, 13 Nov 2026 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585824;
	bh=Re5y8sHSHj1oguEG3k3xgwkRgk6LQPEQRX5YtHHEpIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oq4vrH5qcsyR2B5v5zaZChbdiBWmL1oHbJLiRXDGCTp3zZ6CTCQjFn0lhhuj4wh5h
	 7BVHGcjL7YqGl5JxkWJT184DIMtT5Wr6HzAjvFZRzIdJiafM2GE1et1++AEglvI/Of
	 PbceTky9a6Ks+R6BTyV4/8n0PlSUjKEEX7eROquY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dust Li <dust.li@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 404/507] net/smc: dont spin in smc_rx_recvmsg() while a pipe holds spliced data
Date: Fri, 13 Nov 2026 10:51:48 -0500
Message-ID: <20261113153810.434037193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 197fddc6271f0..63c178c10bf1a 100644
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



