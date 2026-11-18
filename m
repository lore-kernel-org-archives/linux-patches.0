Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046503;
	b=MfvdvTczs/u5uA4vimwIdzhOaVhWcjnoSe6vpFOoyyOHOrC/DCNpKVhGTwXQzATezO/7
	 2fAxlW4UEbJjq+jEk1G0j2cOOINnhZza3AxQ8tKeDG5AQBHd5IO9mTiOrNeow6d6/wIef
	 XK4NsUKi044QkC1gKTJgqQmvSVZ5e3bPtkk7lEXLsJlDRHNHZuJDFAzirqkA/PFTrBEQA
	 Z+ssFc7HIP1hzCi9gi+uCmc0L+j6O/M6OEWXAJKVs22sfUiWeVr/O4//MyeHybSeyUIj2
	 AxORhHs3hYuuiBT3LYJIMalr+q/orawjOUjh4T53PuJWm4LyXfalajQRlaoCWEtjA3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YZ9Rh2JVFbawNlGfvlZWWzkjeBZnuOz2+Dp/Amgpk2k=;
	b=TngR47rb5W05nyZ94xAm6cnNRox68ey3L6ZxIfRXCWSPxYOFsa91ZsPuQgFlvtu/MHFI
	 AmacrsHyDUVqBj+VCQxGbXjRUj0NvfqBQ4XiTTwmDtkM/MVtI0yUuogWX9sGL0FEzIMOu
	 0UtTbaj2x0TO/zA3pAhhG4qXw60dV5DfJlO8OmZIfmP8Yd/W/HBRJvoMLrEarTqaeeHt9
	 MZWRVrwuLEwOVJlUg3uaAN9zkbz93XCLGB60nvrGFmQvpOvc3dPtz9Ainh8lIth/+FmgO
	 fWZSv1x2bjOI03Ftj1QPhdeMsSneEbjMljRMHYOT//I4jhqutu6kqA3DuF/aFpoF/zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fClewrnt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE17606A31C;
	Thu, 19 Nov 2026 00:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fClewrnt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764B31F000C4;
	Thu, 19 Nov 2026 00:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046503;
	bh=YZ9Rh2JVFbawNlGfvlZWWzkjeBZnuOz2+Dp/Amgpk2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fClewrntx1alhW/aaU9FF07MszCF/6aLz4LA3Z59Pe1MJweWFMFsykPeGMKrGP1hk
	 rf1T+kWdpOuhp7QDX8Dathu55Y5I0lsOxAJEh0J0Eon0brrCXdjK8MI9XWkJ1zhl/c
	 Q/WCDInrKzA3+3vP95LHh4FdInwjNrT7QsiSUpsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dust Li <dust.li@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1305/2857] net/smc: dont spin in smc_rx_recvmsg() while a pipe holds spliced data
Date: Wed, 18 Nov 2026 15:38:59 +0100
Message-ID: <20261118150248.460209804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 958a569eeca0e..97bb99979d6e9 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -282,6 +282,27 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo, size_t peeked,
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
@@ -439,7 +460,23 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
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



