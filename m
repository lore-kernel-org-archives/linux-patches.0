Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB011395AD8;
	Sat, 12 Sep 2026 19:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240281; cv=none; b=KuwwJ6DaW5/VADecpq9aJ9FPGnbUngTFuld4TAsCNxUCCXMlaMWhamN7KfjZxw2jRYimsJTptdP1BN5ctLUlS+oPBKolbiDxUJSqpt+MiBbhUOpP5Xu7WBsm6D0GbV5ty8CJmm8S8Xt/zdoSkI6sy75tC3DMBaDpylVmZHLvJgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240281; c=relaxed/simple;
	bh=HBNbBptw7YJAxmiL6xTp86jwCS5yIXOFQtSMU2H98q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHzZJCLFBApnaXWBE7OZFKQYpxrxoruptbGyEUjfXRSd6q/QVH4mLgXFSmIGm9kjTPiXvniZ0ZPfZg27lm4Zifu7oxk3DhmKFyUw400f/7jVO2YX99/iCpRJg64O8/qXZs5pDOtl+E25WHlpIfF+57icWtfN/WOab2bxKwcpl7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qofyip2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qofyip2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73731F000FF;
	Sat, 12 Sep 2026 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240279;
	bh=wQy+9ihzvofyDcTFnhj/9uC7W1t2BoU1qNCgsCV54II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qofyip2vjNKv3dwPLzFBr+sP1z0FfZWq5BBKZAHahCZ4vwDWDcHrkQbqCnvkjPKLC
	 13WIcTlitD5trclbOLljWBMugBWOnlojyCKBODTBg6R7Naer8QJSnMhilP0FQQjY3w
	 MdjhLh8LxjwgJdFd1KbMAfpqEVufP8hS7JDZ5t84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tianshuo han <hantianshuo233@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 836/935] ksmbd: limit repeated connections from clients with the same IP
Date: Sat, 12 Sep 2026 09:04:26 +0200
Message-ID: <20260912065545.998510042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e6bb9193974059ddbb0ce7763fa3882bd60d4dc3 ]

Repeated connections from clients with the same IP address may exhaust
the max connections and prevent other normal client connections.
This patch limit repeated connections from clients with the same IP.

Reported-by: tianshuo han <hantianshuo233@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 39f203209671 ("smb/server: fix tree connection leak in smb2_tree_connect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/connection.h    |  1 +
 fs/ksmbd/transport_tcp.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 2d675ab5b7156..9af95be54b22e 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -45,6 +45,7 @@ struct ksmbd_conn {
 	struct mutex			srv_mutex;
 	int				status;
 	unsigned int			cli_cap;
+	__be32				inet_addr;
 	char				*request_buf;
 	struct ksmbd_transport		*transport;
 	struct nls_table		*local_nls;
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 28dc86dfb0301..7d03a68819b36 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -88,6 +88,7 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
 		return NULL;
 	}
 
+	conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
 	conn->transport = KSMBD_TRANS(t);
 	KSMBD_TRANS(t)->conn = conn;
 	KSMBD_TRANS(t)->ops = &ksmbd_tcp_transport_ops;
@@ -229,6 +230,8 @@ static int ksmbd_kthread_fn(void *p)
 {
 	struct socket *client_sk = NULL;
 	struct interface *iface = (struct interface *)p;
+	struct inet_sock *csk_inet;
+	struct ksmbd_conn *conn;
 	int ret;
 
 	while (!kthread_should_stop()) {
@@ -247,6 +250,20 @@ static int ksmbd_kthread_fn(void *p)
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
 		    atomic_inc_return(&active_num_conn) > server_conf.max_connections) {
 			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",
-- 
2.53.0



