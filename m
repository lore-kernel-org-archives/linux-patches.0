Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027584;
	b=pV1sTNJL9N5ELsPLx0OgP30tnBCeNIJ7B6j5fGNBp5OBP25IqBBwMtWCr+/RZKYuY0AP
	 GU+JI8Ri24Urs7n0wpx+20x0ysqHdpfajRH5QddyO0Ssysnz3jYU9e9MU81YYs6MHscy4
	 agEHwH6pBOFIYtTgndCyYer47w+J14IMPYXWpMSkrRyjdk5LGkDLe1teTMY+LMipsKvr5
	 FvFkMMeiqEHI2WE49w1LfrFoKNDjlODoC1wi68pTLigsN+3rsoH8gCYKXS8KgSn0ny0jc
	 wg2miR5j8BQkRto8Yd2iBbjLAGDYuoiEYZELQdQDaC5QSqo3ATOQ5nuyDrSDrtPVM3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AE7y+nm5mey4oktdDAMKXsldSb8nIthydUVtzEhVanM=;
	b=WuFUXdt0Wv9+Mp39DU9HPb1TXkzdEc2Eprw+qaf0TD3dO1h+cC5edQIbfWNm3dwZ2jvg
	 GCFSuyNqX5OOzUGmBAYBV7BDBV41c4VIWWmJcCLwkUyJblA8Cz7WSbvNxnMG2VkXfTrRk
	 +rceXXOEW6Uue3FIiLIkMb7RchqeRRQMZdkYPgQ9rLlC0K8Ecw1gaOLc5mwfJ4qJCV6mL
	 fFpYiZW/Zwm5ur7Gh5WAHxGzgiSoy4Umej8zdgNS5fwbYnZxLZfiWVYGOskYTLzF6kaM4
	 1OdaamLQ9n1RYjJGdWbIJ34IiWNwrq5gpwXvOMlA9hM9Q3Hu7RAsVHmHz+iZPynP5hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfWPgcr8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9186A60A2609;
	Wed, 18 Nov 2026 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfWPgcr8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C521F000C4;
	Wed, 18 Nov 2026 18:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027584;
	bh=AE7y+nm5mey4oktdDAMKXsldSb8nIthydUVtzEhVanM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfWPgcr8CpIT5BvaAPVFUlRWct0z4R1E3QRiLlURtGuLyekguZoAHCC5vgk6GUJci
	 YTyCyEqkWLXaf/NK3V5PK2ksMPrJ/XAUBEdXRobobojVxoNMPNemnQYLXpCq7eVWez
	 p1zl/kcL/wao2DB7+vQt0yrk4p4Ke2NflPUa+72w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1841/2151] ksmbd: fix listener task lifetime on netdev events
Date: Wed, 18 Nov 2026 15:59:36 +0100
Message-ID: <20261118150228.862216300@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit a506290f59e1c6ce9ac0a13158640bb8fee93471 ]

The listener thread exits when its listening socket is shutdown. The
netdevice notifier shuts down the socket before calling kthread_stop(), so
the task_struct can be freed before kthread_stop() gets its reference.

Create the listener in a stopped state and hold an extra task_struct
reference until kthread_stop_put() completes. Also stop and release
listeners before freeing their interface records during TCP teardown.

Fixes: 3316a8fc840d ("ksmbd: server: avoid busy polling in accept loop")
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: d34d38ab0c62 ("ksmbd: fix iface_list use-after-free during server reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 36 ++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index f876ba5d8ed7b..8fe04c03ce586 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -39,6 +39,7 @@ struct tcp_transport {
 static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops;
 
 static void tcp_stop_kthread(struct task_struct *kthread);
+static void ksmbd_tcp_stop_listener(struct interface *iface);
 static struct interface *alloc_iface(char *ifname);
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t);
 
@@ -321,13 +322,20 @@ static int ksmbd_tcp_run_kthread(struct interface *iface)
 	int rc;
 	struct task_struct *kthread;
 
-	kthread = kthread_run(ksmbd_kthread_fn, (void *)iface, "ksmbd-%s",
-			      iface->name);
+	kthread = kthread_create(ksmbd_kthread_fn, (void *)iface, "ksmbd-%s",
+				 iface->name);
 	if (IS_ERR(kthread)) {
 		rc = PTR_ERR(kthread);
 		return rc;
 	}
+
+	/*
+	 * The listener can exit after its socket is shutdown, so keep the
+	 * task_struct alive until the caller has stopped it.
+	 */
+	get_task_struct(kthread);
 	iface->ksmbd_kthread = kthread;
+	wake_up_process(kthread);
 
 	return 0;
 }
@@ -600,12 +608,7 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 		if (iface && iface->state == IFACE_STATE_CONFIGURED) {
 			ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
 					iface->name);
-			kernel_sock_shutdown(iface->ksmbd_socket, SHUT_RDWR);
-			tcp_stop_kthread(iface->ksmbd_kthread);
-			iface->ksmbd_kthread = NULL;
-			sock_release(iface->ksmbd_socket);
-			iface->ksmbd_socket = NULL;
-
+			ksmbd_tcp_stop_listener(iface);
 			iface->state = IFACE_STATE_DOWN;
 			break;
 		}
@@ -633,11 +636,25 @@ static void tcp_stop_kthread(struct task_struct *kthread)
 	if (!kthread)
 		return;
 
-	ret = kthread_stop(kthread);
+	ret = kthread_stop_put(kthread);
 	if (ret)
 		pr_err("failed to stop forker thread\n");
 }
 
+static void ksmbd_tcp_stop_listener(struct interface *iface)
+{
+	if (iface->ksmbd_socket)
+		kernel_sock_shutdown(iface->ksmbd_socket, SHUT_RDWR);
+
+	tcp_stop_kthread(iface->ksmbd_kthread);
+	iface->ksmbd_kthread = NULL;
+
+	if (iface->ksmbd_socket) {
+		sock_release(iface->ksmbd_socket);
+		iface->ksmbd_socket = NULL;
+	}
+}
+
 void ksmbd_tcp_destroy(void)
 {
 	struct interface *iface, *tmp;
@@ -645,6 +662,7 @@ void ksmbd_tcp_destroy(void)
 	unregister_netdevice_notifier(&ksmbd_netdev_notifier);
 
 	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
+		ksmbd_tcp_stop_listener(iface);
 		list_del(&iface->entry);
 		kfree(iface->name);
 		kfree(iface);
-- 
2.53.0



