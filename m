Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027579;
	b=lzpfFHq9Taro2WWpTSJ02kSNiVqqYScsSOl3p12a7p3Db8F5eZac5T5yroPO2vg3Qq4X
	 oZRGbsxcS7nRizhF8soCeR7LzmorArGHxBDYPBhaawBhpkO1qs5uNwK6nB98l9oIsViTM
	 rPmAXOXrmyynXhczZ8eRUKQ3NJzi6Q8+wpS9DM1GzAWmj5cNAVkeYtSAVtuSiI3VxMY62
	 xeB9TSgGA0s8Q4alet+xvALDeOmVnXnFnlUBCi3U8XO4uO3f4g7F3RLKTC8cXIHABJY3p
	 xFLD87GMwbxZsq2UdnIisY4oUdF4L1DUx+DuxyXG1GXZ/w6+hbDgk9U11Lej8iYCihQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4CaF2uZFH7SXCosT0EkRJ6qB4OGDGUNGMjT2uOLODnA=;
	b=UjzM+KfH3uuPnQu8/ztPLbKdlIisOo/DItAoa0JmsuvudpaiPsddLFxzQYDIw453kKG7
	 TCAwskN5BtD0bOOZAC2d7CGQphTllN0iylHd9/mOzTT+kVVmMw3nNnrYmnnKdTPE7vhu1
	 k0Kf4Zccso/WivzwMLFyUPUuHsuIYfVLN+HSgbNsQMfgM2If1p4zcMVc40vFz2nnOqVrl
	 6bIKnP62pUov/MQ4zD8/pfi+yP28FaDNa9yGinbhPiFmegxLjwy1uG5rJBRF4GLEPYzQt
	 xt9PtmE94TS26V4CwIGMkj2YfRqb0R/GTM8Z/Uoi33HzbDtVhFLranImNzUwYdVi2LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGjvDxhm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04508606A31C;
	Wed, 18 Nov 2026 18:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGjvDxhm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509EE1F000C4;
	Wed, 18 Nov 2026 18:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027578;
	bh=4CaF2uZFH7SXCosT0EkRJ6qB4OGDGUNGMjT2uOLODnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGjvDxhmrnrfkyc9n3G8aZsxW7yCTqpGgt0nXwhyjwL1/obiWEc4VAiUhJUO3K8ID
	 zSpxfPss9nqIsdguk5nwjUjW+1uQWAEAC9WLDkHRuKIwkMuRgGZ0g9JoIMfk3iRV0J
	 RNSBkZdg+6NEWmlnLjQh9n0/EzBd2Sgg+Yof/cBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1840/2151] ksmbd: server: avoid busy polling in accept loop
Date: Wed, 18 Nov 2026 15:59:35 +0100
Message-ID: <20261118150228.827146346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 3316a8fc840d82fad5efcf76ad0ea3f76fdca209 ]

The ksmbd listener thread was using busy waiting on a listening socket by
calling kernel_accept() with SOCK_NONBLOCK and retrying every 100ms on
-EAGAIN. Since this thread is dedicated to accepting new connections,
there is no need for non-blocking mode.

Switch to a blocking accept() call instead, allowing the thread to sleep
until a new connection arrives. This avoids unnecessary wakeups and CPU
usage. During teardown, call shutdown() on the listening socket so that
accept() returns -EINVAL and the thread exits cleanly.

The socket release mutex is redundant because kthread_stop() blocks until
the listener thread returns, guaranteeing safe teardown ordering.

Also remove sk_rcvtimeo and sk_sndtimeo assignments, which only caused
accept() to return -EAGAIN prematurely.

Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: d34d38ab0c62 ("ksmbd: fix iface_list use-after-free during server reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 41 +++++------------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index a25237f82cd76..f876ba5d8ed7b 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -22,7 +22,6 @@ struct interface {
 	struct socket		*ksmbd_socket;
 	struct list_head	entry;
 	char			*name;
-	struct mutex		sock_release_lock;
 	int			state;
 };
 
@@ -57,19 +56,6 @@ static inline void ksmbd_tcp_reuseaddr(struct socket *sock)
 	sock_set_reuseaddr(sock->sk);
 }
 
-static inline void ksmbd_tcp_rcv_timeout(struct socket *sock, s64 secs)
-{
-	if (secs && secs < MAX_SCHEDULE_TIMEOUT / HZ - 1)
-		WRITE_ONCE(sock->sk->sk_rcvtimeo, secs * HZ);
-	else
-		WRITE_ONCE(sock->sk->sk_rcvtimeo, MAX_SCHEDULE_TIMEOUT);
-}
-
-static inline void ksmbd_tcp_snd_timeout(struct socket *sock, s64 secs)
-{
-	sock_set_sndtimeo(sock->sk, secs);
-}
-
 static struct tcp_transport *alloc_transport(struct socket *client_sk)
 {
 	struct tcp_transport *t;
@@ -239,20 +225,14 @@ static int ksmbd_kthread_fn(void *p)
 	unsigned int max_ip_conns;
 
 	while (!kthread_should_stop()) {
-		mutex_lock(&iface->sock_release_lock);
 		if (!iface->ksmbd_socket) {
-			mutex_unlock(&iface->sock_release_lock);
 			break;
 		}
-		ret = kernel_accept(iface->ksmbd_socket, &client_sk,
-				    SOCK_NONBLOCK);
-		mutex_unlock(&iface->sock_release_lock);
-		if (ret) {
-			if (ret == -EAGAIN)
-				/* check for new connections every 100 msecs */
-				schedule_timeout_interruptible(HZ / 10);
+		ret = kernel_accept(iface->ksmbd_socket, &client_sk, 0);
+		if (ret == -EINVAL)
+			break;
+		if (ret)
 			continue;
-		}
 
 		if (!server_conf.max_ip_connections)
 			goto skip_max_ip_conns_limit;
@@ -472,10 +452,6 @@ static void tcp_destroy_socket(struct socket *ksmbd_socket)
 	if (!ksmbd_socket)
 		return;
 
-	/* set zero to timeout */
-	ksmbd_tcp_rcv_timeout(ksmbd_socket, 0);
-	ksmbd_tcp_snd_timeout(ksmbd_socket, 0);
-
 	ret = kernel_sock_shutdown(ksmbd_socket, SHUT_RDWR);
 	if (ret)
 		pr_err("Failed to shutdown socket: %d\n", ret);
@@ -546,9 +522,6 @@ static int create_socket(struct interface *iface)
 		goto out_error;
 	}
 
-	ksmbd_socket->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
-	ksmbd_socket->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
-
 	ret = kernel_listen(ksmbd_socket, KSMBD_SOCKET_BACKLOG);
 	if (ret) {
 		pr_err("Port listen() error: %d\n", ret);
@@ -627,12 +600,11 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 		if (iface && iface->state == IFACE_STATE_CONFIGURED) {
 			ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
 					iface->name);
+			kernel_sock_shutdown(iface->ksmbd_socket, SHUT_RDWR);
 			tcp_stop_kthread(iface->ksmbd_kthread);
 			iface->ksmbd_kthread = NULL;
-			mutex_lock(&iface->sock_release_lock);
-			tcp_destroy_socket(iface->ksmbd_socket);
+			sock_release(iface->ksmbd_socket);
 			iface->ksmbd_socket = NULL;
-			mutex_unlock(&iface->sock_release_lock);
 
 			iface->state = IFACE_STATE_DOWN;
 			break;
@@ -695,7 +667,6 @@ static struct interface *alloc_iface(char *ifname)
 	iface->name = ifname;
 	iface->state = IFACE_STATE_DOWN;
 	list_add(&iface->entry, &iface_list);
-	mutex_init(&iface->sock_release_lock);
 	return iface;
 }
 
-- 
2.53.0



