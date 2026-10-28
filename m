Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216572;
	b=LwOVdr+NWCM4qhLoEaVINxrIP4HBPAZYGqZhX33lFNc6NrWPymTtNoDIQZmd1fVTpDHZ
	 ZsH8JVwiKjyC0ESYRY77P0S20+0bzkAhoGKQTGJMhczdDNy3hMveIrFXcMGAYiqItCeQ3
	 fjyBd/S+4DBinYPHt2QW9cHfvcjR8uyilr/5Ub2AyRMMENtGY/B//Gi0V+qt96aS2/ewx
	 lRDUklxu1VQX0bzvcSL0INeCjv0gyvfz7Sr4fjsPsW1OyuLqY00I8yaIXc5pJSKEPCSQV
	 a1GOuBQzqlP/5hRuwXacDlPzxFBiY8HRDlOqQMQhdKZjJR8GlRPcJy5RNaW8ST5zrCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iMX4W4UvLnscO+ncbutMBygkyOghYO5icTGW/UXuJqM=;
	b=jaJCwcEd+Z5BLM/D2H0vu7Gafvpzn/NGMqCirb5VwEEsJlsiqYpe/Aasmdw3yZmzaI6d
	 YA4cFUcuhOYjEPXYm9KfEm934NfM1EqzU3gIeErwinoWYD5slS5qVl7mPYoW9LSrsoImV
	 7uPSeJVvUrtZ0bIkKXDrZfGVipUIWaUyjdCjcqj3Bh/5VYE6Zxenbuk5+EXxsFn8sSk60
	 Wm29usiEAEmPitqW+S0dsUTp/tFRBCYu3wKy2I857ze60EfosValPR2kKMb0OTr5e6ijv
	 6a7Yu58RS1mSeCJJwv+C3YVehRBrn/jaU0Z9ALlkBlAzCdMEEStkfSSIIolHeNiQaOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jE7DYPs9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F4E606A31A;
	Wed, 28 Oct 2026 19:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jE7DYPs9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AD91F01825;
	Wed, 28 Oct 2026 19:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216571;
	bh=iMX4W4UvLnscO+ncbutMBygkyOghYO5icTGW/UXuJqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jE7DYPs94fGmjCglUlttHE3JI8aixPqU8kQpVgWqdMUUhD60grtlrvE9U4fIRHW1O
	 yfZUhuuHcRgbu7rmUWKyeuBQSu9z1E6O4yUKCIfQ6oNIiyOEXsrhkvHlZe4hqtEa+/
	 SHd7i5MtLJlOHEPWYL74PEI1yhaAEWewhdOLzU1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1559/1887] fs: dlm: use listen sock as dlm running indicator
Date: Wed, 28 Oct 2026 18:00:55 +0100
Message-ID: <20261028170534.941039963@linuxfoundation.org>
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

[ Upstream commit 1037c2a94ab51997d8b1ef9e7f6ed697e6e17d84 ]

This patch will switch from dlm_allow_conn to check if dlm lowcomms is
running or not to if we actually have a listen socket set or not. The
list socket will be set and unset in lowcomms start and shutdown
functionality. To synchronize with data_ready() callback we will set the
socket callback to NULL while socket lock is held.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 33930840b5f0 ("sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/config.c   |  4 ++--
 fs/dlm/lowcomms.c | 17 ++++++-----------
 fs/dlm/lowcomms.h |  4 ++--
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index ac8b62106ce0e..20b60709eccf0 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -183,7 +183,7 @@ static int dlm_check_protocol_and_dlm_running(unsigned int x)
 		return -EINVAL;
 	}
 
-	if (dlm_allow_conn)
+	if (dlm_lowcomms_is_running())
 		return -EBUSY;
 
 	return 0;
@@ -194,7 +194,7 @@ static int dlm_check_zero_and_dlm_running(unsigned int x)
 	if (!x)
 		return -EINVAL;
 
-	if (dlm_allow_conn)
+	if (dlm_lowcomms_is_running())
 		return -EBUSY;
 
 	return 0;
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 51a641822d6c4..cefc930c2e429 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -176,7 +176,6 @@ static DEFINE_SPINLOCK(dlm_node_addrs_spin);
 static struct listen_connection listen_con;
 static struct sockaddr_storage dlm_local_addr[DLM_MAX_ADDR_COUNT];
 static int dlm_local_count;
-int dlm_allow_conn;
 
 /* Work queues */
 static struct workqueue_struct *recv_workqueue;
@@ -191,6 +190,11 @@ static const struct dlm_proto_ops *dlm_proto_ops;
 static void process_recv_sockets(struct work_struct *work);
 static void process_send_sockets(struct work_struct *work);
 
+bool dlm_lowcomms_is_running(void)
+{
+	return !!listen_con.sock;
+}
+
 static void writequeue_entry_ctor(void *data)
 {
 	struct writequeue_entry *entry = data;
@@ -514,9 +518,6 @@ static void lowcomms_data_ready(struct sock *sk)
 
 static void lowcomms_listen_data_ready(struct sock *sk)
 {
-	if (!dlm_allow_conn)
-		return;
-
 	queue_work(recv_workqueue, &listen_con.rwork);
 }
 
@@ -1676,10 +1677,7 @@ void dlm_lowcomms_shutdown(void)
 {
 	int idx;
 
-	/* Set all the flags to prevent any
-	 * socket activity.
-	 */
-	dlm_allow_conn = 0;
+	restore_callbacks(listen_con.sock);
 
 	if (recv_workqueue)
 		flush_workqueue(recv_workqueue);
@@ -1982,8 +1980,6 @@ int dlm_lowcomms_start(void)
 	if (error)
 		goto fail;
 
-	dlm_allow_conn = 1;
-
 	/* Start listening */
 	switch (dlm_config.ci_protocol) {
 	case DLM_PROTO_TCP:
@@ -2008,7 +2004,6 @@ int dlm_lowcomms_start(void)
 fail_listen:
 	dlm_proto_ops = NULL;
 fail_proto_ops:
-	dlm_allow_conn = 0;
 	work_stop();
 fail:
 	return error;
diff --git a/fs/dlm/lowcomms.h b/fs/dlm/lowcomms.h
index bbce7a18416dc..acaf1b0b3885b 100644
--- a/fs/dlm/lowcomms.h
+++ b/fs/dlm/lowcomms.h
@@ -29,8 +29,8 @@ static inline int nodeid_hash(int nodeid)
 	return nodeid & (CONN_HASH_SIZE-1);
 }
 
-/* switch to check if dlm is running */
-extern int dlm_allow_conn;
+/* check if dlm is running */
+bool dlm_lowcomms_is_running(void);
 
 int dlm_lowcomms_start(void);
 void dlm_lowcomms_shutdown(void);
-- 
2.53.0



