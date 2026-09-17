Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA740509F18;
	Thu, 17 Sep 2026 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658975; cv=none; b=I3Lhwi4EpxTCzXwvFOsa2PaxfKnS83etycp+JqN7pUe7O5u4mPhXKn7dNwHuNhLlkhmYYnJlfi1+Lbaz49oVhFRWd8/uTHwfRg3782tMz7+P32CbD5oiIUZWHX90gtXPf2T25iOjaOhqxpXkOu96nxIhGYYNSGin3wqIp1T7qvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658975; c=relaxed/simple;
	bh=3hSh4I8mRpLlfyF6qh80rHv+M7WcI7JbyAbBR462GvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdvKzY9QuXO8rA8reXbrR3yW+uyv0urVUfFdGY9Psj/gnpg+bPU6DM7w0c1G7ST3CRnCVaPNlABmYMQdsPn8zNufodd+h6GS21oe3h3NGf9jfx9uxuqVaQieHPgq481/w1flGpPHDdyVZNbPCrOKcykdy4Yk3TdWGX9NI6hUsP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ns2J6rcX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ns2J6rcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E70B1F000FF;
	Thu, 17 Sep 2026 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658968;
	bh=CukmoZDiXoA6elN3nqQ+yqfBgs78Wp86bl4JMZMJruM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ns2J6rcXYDc+HP2zDT+NbAZJ52K9l2+YkBXf/Izz96nttyZqbLIDMnjSsu0hv00K+
	 4Md9dchKJmMNOewCyjEswTL2P/lwYqtTMINe5+xspYvksxkZKMxPqPkkTBlZdCDk0f
	 3rcGyO4gZyrjGM/96TajxUgvuYxpqdJaoMvSPhf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 099/733] ksmbd: fix listener task lifetime on netdev events
Date: Thu, 17 Sep 2026 16:06:47 +0100
Message-ID: <20260917151353.416559774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 36 ++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 990b14e5d3ea2..668fc333c5be3 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -39,6 +39,7 @@ struct tcp_transport {
 static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops;
 
 static void tcp_stop_kthread(struct task_struct *kthread);
+static void ksmbd_tcp_stop_listener(struct interface *iface);
 static struct interface *alloc_iface(char *ifname);
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t);
 
@@ -315,13 +316,20 @@ static int ksmbd_tcp_run_kthread(struct interface *iface)
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
@@ -585,12 +593,7 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
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
@@ -618,11 +621,25 @@ static void tcp_stop_kthread(struct task_struct *kthread)
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
@@ -630,6 +647,7 @@ void ksmbd_tcp_destroy(void)
 	unregister_netdevice_notifier(&ksmbd_netdev_notifier);
 
 	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
+		ksmbd_tcp_stop_listener(iface);
 		list_del(&iface->entry);
 		kfree(iface->name);
 		kfree(iface);
-- 
2.53.0



