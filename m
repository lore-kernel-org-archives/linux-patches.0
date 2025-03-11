Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3623625EF91;
	Tue, 11 Mar 2025 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706404; cv=none; b=PC7oMxDBg66DwYtF1/TJFezQAydR/1NPDwwgH2QIlC0qSooVNUwaTufz7Mj5okOw2PY4q6XitWIc3dzsis0efODFHKQHHoh0H2pEzzIGzOTh3A4BD5y8havZQhXuYjj+3Zmke1/w73XxhERB3Q0SaSD+UpWDVQGgmUJ956Othdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706404; c=relaxed/simple;
	bh=Wg2GSm5YA7A/rWEb0hB+sC4CVKV0pi6jcvlYply/GEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hh8eor+KuFrGsUlOPkiFZdCJ+f0JGGrKkugUDq72gm9mBXATe0bH4YOwndLYHwVueLGEfoT/mf7Di1RrZuU1qX4KwvWPknvLqIY7eI8U/fHHaFvRM0A05YTVp5gA/KK3zrX+mC/KyoHoObrCT23eT8U4J02EVjQcxfgy5bXlgck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtVwrtmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtVwrtmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79846C4CEE9;
	Tue, 11 Mar 2025 15:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706404;
	bh=Wg2GSm5YA7A/rWEb0hB+sC4CVKV0pi6jcvlYply/GEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtVwrtmU2ayu7gyVVVIhvBSXJOVXXi+SrgVQnk1gQvYsj6Otu3uPcYpkyw+OckWvg
	 2/5sPRqHnAmZi+dLoJhVJ/VDcIkYqtzGgHlgi0opjyoItEJ53CFMoDw012QAF1Sbzs
	 n0LB6OqUmokyFdxmgB/6a5vGE2ibiS9zhO/UV+YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/462] net/smc: fix data error when recvmsg with MSG_PEEK flag
Date: Tue, 11 Mar 2025 15:55:02 +0100
Message-ID: <20250311145759.780494201@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit a4b6539038c1aa1ae871aacf6e41b566c3613993 ]

When recvmsg with MSG_PEEK flag, the data will be copied to
user's buffer without advancing consume cursor and without
reducing the length of rx available data. Once the expected
peek length is larger than the value of bytes_to_rcv, in the
loop of do while in smc_rx_recvmsg, the first loop will copy
bytes_to_rcv bytes of data from the position local_tx_ctrl.cons,
the second loop will copy the min(bytes_to_rcv, read_remaining)
bytes from the position local_tx_ctrl.cons again because of the
lacking of process with advancing consume cursor and reducing
the length of available data. So do the subsequent loops. The
data copied in the second loop and the subsequent loops will
result in data error, as it should not be copied if no more data
arrives and it should be copied from the position advancing
bytes_to_rcv bytes from the local_tx_ctrl.cons if more data arrives.

This issue can be reproduce by the following python script:
server.py:
import socket
import time
server_ip = '0.0.0.0'
server_port = 12346
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((server_ip, server_port))
server_socket.listen(1)
print('Server is running and listening for connections...')
conn, addr = server_socket.accept()
print('Connected by', addr)
while True:
    data = conn.recv(1024)
    if not data:
        break
    print('Received request:', data.decode())
    conn.sendall(b'Hello, client!\n')
    time.sleep(5)
    conn.sendall(b'Hello, again!\n')
conn.close()

client.py:
import socket
server_ip = '<server ip>'
server_port = 12346
resp=b'Hello, client!\nHello, again!\n'
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((server_ip, server_port))
request = 'Hello, server!'
client_socket.sendall(request.encode())
peek_data = client_socket.recv(len(resp),
    socket.MSG_PEEK | socket.MSG_WAITALL)
print('Peeked data:', peek_data.decode())
client_socket.close()

Fixes: 952310ccf2d8 ("smc: receive data from RMBE")
Reported-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Link: https://patch.msgid.link/20250104143201.35529-1-guangguan.wang@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c |  2 +-
 net/smc/smc_rx.c | 37 +++++++++++++++++++++----------------
 net/smc/smc_rx.h |  8 ++++----
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0e0a12f4bb61f..d64cfd651c7a1 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1968,7 +1968,7 @@ static int smc_accept(struct socket *sock, struct socket *new_sock,
 			release_sock(clcsk);
 		} else if (!atomic_read(&smc_sk(nsk)->conn.bytes_to_rcv)) {
 			lock_sock(nsk);
-			smc_rx_wait(smc_sk(nsk), &timeo, smc_rx_data_available);
+			smc_rx_wait(smc_sk(nsk), &timeo, 0, smc_rx_data_available);
 			release_sock(nsk);
 		}
 	}
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 3757aff6c2f00..5f20538cbf990 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -174,22 +174,23 @@ static int smc_rx_splice(struct pipe_inode_info *pipe, char *src, size_t len,
 	return bytes;
 }
 
-static int smc_rx_data_available_and_no_splice_pend(struct smc_connection *conn)
+static int smc_rx_data_available_and_no_splice_pend(struct smc_connection *conn, size_t peeked)
 {
-	return atomic_read(&conn->bytes_to_rcv) &&
+	return smc_rx_data_available(conn, peeked) &&
 	       !atomic_read(&conn->splice_pending);
 }
 
 /* blocks rcvbuf consumer until >=len bytes available or timeout or interrupted
  *   @smc    smc socket
  *   @timeo  pointer to max seconds to wait, pointer to value 0 for no timeout
+ *   @peeked  number of bytes already peeked
  *   @fcrit  add'l criterion to evaluate as function pointer
  * Returns:
  * 1 if at least 1 byte available in rcvbuf or if socket error/shutdown.
  * 0 otherwise (nothing in rcvbuf nor timeout, e.g. interrupted).
  */
-int smc_rx_wait(struct smc_sock *smc, long *timeo,
-		int (*fcrit)(struct smc_connection *conn))
+int smc_rx_wait(struct smc_sock *smc, long *timeo, size_t peeked,
+		int (*fcrit)(struct smc_connection *conn, size_t baseline))
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct smc_connection *conn = &smc->conn;
@@ -198,7 +199,7 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo,
 	struct sock *sk = &smc->sk;
 	int rc;
 
-	if (fcrit(conn))
+	if (fcrit(conn, peeked))
 		return 1;
 	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 	add_wait_queue(sk_sleep(sk), &wait);
@@ -207,7 +208,7 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo,
 			   cflags->peer_conn_abort ||
 			   READ_ONCE(sk->sk_shutdown) & RCV_SHUTDOWN ||
 			   conn->killed ||
-			   fcrit(conn),
+			   fcrit(conn, peeked),
 			   &wait);
 	remove_wait_queue(sk_sleep(sk), &wait);
 	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
@@ -257,11 +258,11 @@ static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
 	return -EAGAIN;
 }
 
-static bool smc_rx_recvmsg_data_available(struct smc_sock *smc)
+static bool smc_rx_recvmsg_data_available(struct smc_sock *smc, size_t peeked)
 {
 	struct smc_connection *conn = &smc->conn;
 
-	if (smc_rx_data_available(conn))
+	if (smc_rx_data_available(conn, peeked))
 		return true;
 	else if (conn->urg_state == SMC_URG_VALID)
 		/* we received a single urgent Byte - skip */
@@ -279,10 +280,10 @@ static bool smc_rx_recvmsg_data_available(struct smc_sock *smc)
 int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 		   struct pipe_inode_info *pipe, size_t len, int flags)
 {
-	size_t copylen, read_done = 0, read_remaining = len;
+	size_t copylen, read_done = 0, read_remaining = len, peeked_bytes = 0;
 	size_t chunk_len, chunk_off, chunk_len_sum;
 	struct smc_connection *conn = &smc->conn;
-	int (*func)(struct smc_connection *conn);
+	int (*func)(struct smc_connection *conn, size_t baseline);
 	union smc_host_cursor cons;
 	int readable, chunk;
 	char *rcvbuf_base;
@@ -313,14 +314,14 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 		if (conn->killed)
 			break;
 
-		if (smc_rx_recvmsg_data_available(smc))
+		if (smc_rx_recvmsg_data_available(smc, peeked_bytes))
 			goto copy;
 
 		if (sk->sk_shutdown & RCV_SHUTDOWN) {
 			/* smc_cdc_msg_recv_action() could have run after
 			 * above smc_rx_recvmsg_data_available()
 			 */
-			if (smc_rx_recvmsg_data_available(smc))
+			if (smc_rx_recvmsg_data_available(smc, peeked_bytes))
 				goto copy;
 			break;
 		}
@@ -354,26 +355,28 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 			}
 		}
 
-		if (!smc_rx_data_available(conn)) {
-			smc_rx_wait(smc, &timeo, smc_rx_data_available);
+		if (!smc_rx_data_available(conn, peeked_bytes)) {
+			smc_rx_wait(smc, &timeo, peeked_bytes, smc_rx_data_available);
 			continue;
 		}
 
 copy:
 		/* initialize variables for 1st iteration of subsequent loop */
 		/* could be just 1 byte, even after waiting on data above */
-		readable = atomic_read(&conn->bytes_to_rcv);
+		readable = smc_rx_data_available(conn, peeked_bytes);
 		splbytes = atomic_read(&conn->splice_pending);
 		if (!readable || (msg && splbytes)) {
 			if (splbytes)
 				func = smc_rx_data_available_and_no_splice_pend;
 			else
 				func = smc_rx_data_available;
-			smc_rx_wait(smc, &timeo, func);
+			smc_rx_wait(smc, &timeo, peeked_bytes, func);
 			continue;
 		}
 
 		smc_curs_copy(&cons, &conn->local_tx_ctrl.cons, conn);
+		if ((flags & MSG_PEEK) && peeked_bytes)
+			smc_curs_add(conn->rmb_desc->len, &cons, peeked_bytes);
 		/* subsequent splice() calls pick up where previous left */
 		if (splbytes)
 			smc_curs_add(conn->rmb_desc->len, &cons, splbytes);
@@ -410,6 +413,8 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 			}
 			read_remaining -= chunk_len;
 			read_done += chunk_len;
+			if (flags & MSG_PEEK)
+				peeked_bytes += chunk_len;
 
 			if (chunk_len_sum == copylen)
 				break; /* either on 1st or 2nd iteration */
diff --git a/net/smc/smc_rx.h b/net/smc/smc_rx.h
index db823c97d824e..994f5e42d1ba2 100644
--- a/net/smc/smc_rx.h
+++ b/net/smc/smc_rx.h
@@ -21,11 +21,11 @@ void smc_rx_init(struct smc_sock *smc);
 
 int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 		   struct pipe_inode_info *pipe, size_t len, int flags);
-int smc_rx_wait(struct smc_sock *smc, long *timeo,
-		int (*fcrit)(struct smc_connection *conn));
-static inline int smc_rx_data_available(struct smc_connection *conn)
+int smc_rx_wait(struct smc_sock *smc, long *timeo, size_t peeked,
+		int (*fcrit)(struct smc_connection *conn, size_t baseline));
+static inline int smc_rx_data_available(struct smc_connection *conn, size_t peeked)
 {
-	return atomic_read(&conn->bytes_to_rcv);
+	return atomic_read(&conn->bytes_to_rcv) - peeked;
 }
 
 #endif /* SMC_RX_H */
-- 
2.39.5



