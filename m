Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6881D2D5A10;
	Tue, 12 Aug 2025 19:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026817; cv=none; b=B0mIsw+W4M/YLjvmM3HEb31R1IhotumWdNC1aIS5SlEPmr+vsgbD0W9r3Y2d9VyFv5HeCKl9Edd6iVP5EkQ6BnhyH7fKbEPD1KX9v4JRFq2+aWgCTkyPoeip2Qn4mNETkHFV8cQTakyJUXevtasGPhmq/AGRJ2P/SaSswTnELvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026817; c=relaxed/simple;
	bh=AsQ0CgWHU88KDoeH+en1trZQynVjVfxmR/31+O52mPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iy4cJ5xjqJwLQro7suhdpJ7bKUwZUwYmbBSBZKBmabPSEk5j8IgzvcS/4vt7wDNT3BQ/OKkOYdUqRyK89Mxx9aZy+35ddCvUr2UlNuIg3R5N9PQl+opgjKOFMNOH3JMwdhG0s5w/jHWxGTQQ4m7wH+C0qFBlK42E7/K4JFYpoSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrb1gPhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrb1gPhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837DEC4CEF0;
	Tue, 12 Aug 2025 19:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026817;
	bh=AsQ0CgWHU88KDoeH+en1trZQynVjVfxmR/31+O52mPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrb1gPhm2xOnlxc068soQ5VOkhMk6sE7WLeHJ6dR2iKID2v6reYMSZdJqRNuEwb0i
	 F6dDl7Qk3yqjvqxIfKFjfV43+tTCl1fTQP+D7aYxpvfxBMqHzwBpv9ssxlEpptXVV5
	 xH/CJqMXmtu7+NOSqzGAkKOHzS2jUJbwLPH6nqOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tianshuo han <hantianshuo233@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 450/480] ksmbd: limit repeated connections from clients with the same IP
Date: Tue, 12 Aug 2025 19:50:58 +0200
Message-ID: <20250812174415.961701062@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit e6bb9193974059ddbb0ce7763fa3882bd60d4dc3 upstream.

Repeated connections from clients with the same IP address may exhaust
the max connections and prevent other normal client connections.
This patch limit repeated connections from clients with the same IP.

Reported-by: tianshuo han <hantianshuo233@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.h    |    1 +
 fs/smb/server/transport_tcp.c |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -46,6 +46,7 @@ struct ksmbd_conn {
 	struct mutex			srv_mutex;
 	int				status;
 	unsigned int			cli_cap;
+	__be32				inet_addr;
 	char				*request_buf;
 	struct ksmbd_transport		*transport;
 	struct nls_table		*local_nls;
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -87,6 +87,7 @@ static struct tcp_transport *alloc_trans
 		return NULL;
 	}
 
+	conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
 	conn->transport = KSMBD_TRANS(t);
 	KSMBD_TRANS(t)->conn = conn;
 	KSMBD_TRANS(t)->ops = &ksmbd_tcp_transport_ops;
@@ -230,6 +231,8 @@ static int ksmbd_kthread_fn(void *p)
 {
 	struct socket *client_sk = NULL;
 	struct interface *iface = (struct interface *)p;
+	struct inet_sock *csk_inet;
+	struct ksmbd_conn *conn;
 	int ret;
 
 	while (!kthread_should_stop()) {
@@ -248,6 +251,20 @@ static int ksmbd_kthread_fn(void *p)
 			continue;
 		}
 
+		/*
+		 * Limits repeated connections from clients with the same IP.
+		 */
+		csk_inet = inet_sk(client_sk->sk);
+		down_read(&conn_list_lock);
+		list_for_each_entry(conn, &conn_list, conns_list)
+			if (csk_inet->inet_daddr == conn->inet_addr) {
+				ret = -EAGAIN;
+				break;
+			}
+		up_read(&conn_list_lock);
+		if (ret == -EAGAIN)
+			continue;
+
 		if (server_conf.max_connections &&
 		    atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
 			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",


