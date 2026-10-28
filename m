Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216449;
	b=W6NJ26+EIKeosoHDKFq1yQJzyLv6gp15g4IOaaOsFEYqbMQiCuLFXZa8ILNHuUcBhi1v
	 7p4TF49JMVMoyJc13351jdUXMnXZ8zJFNUNRqlupa3PN5gj7Txu0yx44+2DN6GIBhVR6I
	 5DCJLV0QqHoHNHmloZbJxrc3QYelEgHQg/oXQNqeFN/QQmwqrNzfKfTsrGJeauaUNj9zb
	 0l7AAMtKPHMSDAmlPNWsdnRk6MhfDmAc0Jv28OVCkjCK0s2IlC+9g//nlN97rncpC8q8A
	 FjCyz5LkNVUnqCXDmmCwe3EUR9eWVErNpC4lBjFkCp/jOPybLcdqTnl5oyxrrmG30Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6NqoIw7TgNZHeyQrCef89GiRmwJHeA7NJK9O2XbQMhU=;
	b=LH+MFbKjRki02B15VHXlhDqYziczJ8O+pRaJKTeY0ggW8h//zDk75bd957IMooOZ2mpQ
	 dhNLJwJfJRMxy+TA6f56qI9p2GB9GHClyCME26uDFZViMIimi5NSmXOP9IqbW+hbP/yxW
	 ubwI96mZ0tYoXpOYEwnep8P289Vze7wr0k3QmBdSBIAamknGFvlGMkfaIIUS9eB/wIIJY
	 aZz6W42nwbs6sLqMwbCObMdQw/DvGBIAe5+iq8Z7J5l+1mF+UGGVVD4YleKy+gX6tzXEm
	 VbNNCdY/UI8ILloeGwLbsxeTeVV+9vFVb7jfLHdrGHSsnFWNyn7uf0ZBn6cGNJtZDUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rbGCLLus;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E91360A2626;
	Wed, 28 Oct 2026 19:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rbGCLLus
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFB21F031E1;
	Wed, 28 Oct 2026 19:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216449;
	bh=6NqoIw7TgNZHeyQrCef89GiRmwJHeA7NJK9O2XbQMhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rbGCLLusNYLvK1fHbQEeV3fFp2t+R2/WqU/dpCVyV5aekXmbT9METE5W4ueX/SUCy
	 zIwviFPcysbbchUMO+EXmPJGSbmCwCyLlIP51kXwMDoMXawyUzLaz5z4ogD8GSaG3h
	 /aXEHK9VJxhnpdg2r/TLMW+tDE72WGuED4ZKQdxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1561/1887] fs: dlm: cleanup listen sock handling
Date: Wed, 28 Oct 2026 18:00:57 +0100
Message-ID: <20261028170534.986755978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit c3d88dfd15835f42c79467eee2c40db3095e5271 ]

This patch removes save_listen_callbacks() and add_listen_sock() as they
are only used once in lowcomms functionality. For shutdown lowcomms it's
not necessary to whole flush the workqueues to synchronize with
restoring the old sk_data_ready() callback. Only the listen con receive
work need to be cancelled. For each individual node shutdown we should be
sure that last ack was been transmitted which is done by flushing per
connection swork worker.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 33930840b5f0 ("sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 51 ++++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 34 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 2151579094255..3248fc147442f 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -650,17 +650,6 @@ static void lowcomms_error_report(struct sock *sk)
 		orig_report(sk);
 }
 
-/* Note: sk_callback_lock must be locked before calling this function. */
-static void save_listen_callbacks(struct socket *sock)
-{
-	struct sock *sk = sock->sk;
-
-	listen_sock.sk_data_ready = sk->sk_data_ready;
-	listen_sock.sk_state_change = sk->sk_state_change;
-	listen_sock.sk_write_space = sk->sk_write_space;
-	listen_sock.sk_error_report = sk->sk_error_report;
-}
-
 static void restore_callbacks(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -674,21 +663,6 @@ static void restore_callbacks(struct socket *sock)
 	release_sock(sk);
 }
 
-static void add_listen_sock(struct socket *sock, struct listen_connection *con)
-{
-	struct sock *sk = sock->sk;
-
-	lock_sock(sk);
-	save_listen_callbacks(sock);
-	con->sock = sock;
-
-	sk->sk_user_data = con;
-	sk->sk_allocation = GFP_NOFS;
-	/* Install a data_ready callback */
-	sk->sk_data_ready = lowcomms_listen_data_ready;
-	release_sock(sk);
-}
-
 /* Make a socket active */
 static void add_sock(struct socket *sock, struct connection *con)
 {
@@ -1580,13 +1554,12 @@ static int work_start(void)
 
 void dlm_lowcomms_shutdown(void)
 {
-	restore_callbacks(listen_con.sock);
-
-	if (recv_workqueue)
-		flush_workqueue(recv_workqueue);
-	if (send_workqueue)
-		flush_workqueue(send_workqueue);
+	/* stop lowcomms_listen_data_ready calls */
+	lock_sock(listen_con.sock->sk);
+	listen_con.sock->sk->sk_data_ready = listen_sock.sk_data_ready;
+	release_sock(listen_con.sock->sk);
 
+	cancel_work_sync(&listen_con.rwork);
 	dlm_close_sock(&listen_con.sock);
 }
 
@@ -1602,6 +1575,7 @@ void dlm_lowcomms_shutdown_node(int nodeid, bool force)
 		return;
 	}
 
+	flush_work(&con->swork);
 	WARN_ON_ONCE(!force && !list_empty(&con->writequeue));
 	clean_one_writequeue(con);
 	if (con->othercon)
@@ -1722,8 +1696,17 @@ static int dlm_listen_for_all(void)
 	if (result < 0)
 		goto out;
 
-	save_listen_callbacks(sock);
-	add_listen_sock(sock, &listen_con);
+	lock_sock(sock->sk);
+	listen_sock.sk_data_ready = sock->sk->sk_data_ready;
+	listen_sock.sk_write_space = sock->sk->sk_write_space;
+	listen_sock.sk_error_report = sock->sk->sk_error_report;
+	listen_sock.sk_state_change = sock->sk->sk_state_change;
+
+	listen_con.sock = sock;
+
+	sock->sk->sk_allocation = GFP_NOFS;
+	sock->sk->sk_data_ready = lowcomms_listen_data_ready;
+	release_sock(sock->sk);
 
 	INIT_WORK(&listen_con.rwork, process_listen_recv_socket);
 	result = sock->ops->listen(sock, 5);
-- 
2.53.0



