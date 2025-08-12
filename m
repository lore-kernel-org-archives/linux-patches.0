Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04232F7449;
	Tue, 12 Aug 2025 17:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021379; cv=none; b=kTSRI8SBQ/1Q1KcIbZcVWNFT3yhrEaOUFyU9p0jDqWpwXulJSR/NIz//StE8jP3UOwhR2tx8zYDuAVgUsJ6UCSpFkvPjCINE4bC8iwNsGIb5jaLsqVB2ulWrUPmQx1t3J/nr0qOPDWdbCJ3avvmiMx/XA844tg/32rsm5fZcvR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021379; c=relaxed/simple;
	bh=HEYn81TXKMwdc8ujPBrjJmuqMPEhF/k+0c5Gh5dC2LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6Z8yw7tyjowReUxuzpIgxkLs2qwI3unMFX/JDrK219AWKds9+VjTX37J7CscmGBMpb2CeJGgMPZSW7KllAWrum2Yh+NMi0foqImhtIlA18ww8h1f0Tqa/WaYptHejfrOZW4IUVvtp2U+f1mi0uFRgjHVdnc6/oFtK3nl9Ogkz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJqtJYCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJqtJYCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06C9C4CEF0;
	Tue, 12 Aug 2025 17:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021379;
	bh=HEYn81TXKMwdc8ujPBrjJmuqMPEhF/k+0c5Gh5dC2LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJqtJYCvBfIVjMdYQ8Yide4Tbkw2IWOyzAhkynCXrMP4hVoXiOddFzx+GJEzoJnzU
	 vrBJqiDjGbcjLeZP4QSDMYKQhS42Q0GdKccKSfxc1AicMRgvK0jcAolZwaTewRWGqO
	 WmofslzztDT9w1nJChBRZgElBbhUenroj2Fz3oHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tianshuo han <hantianshuo233@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 242/253] ksmbd: limit repeated connections from clients with the same IP
Date: Tue, 12 Aug 2025 19:30:30 +0200
Message-ID: <20250812172959.151334099@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -45,6 +45,7 @@ struct ksmbd_conn {
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
@@ -226,6 +227,8 @@ static int ksmbd_kthread_fn(void *p)
 {
 	struct socket *client_sk = NULL;
 	struct interface *iface = (struct interface *)p;
+	struct inet_sock *csk_inet;
+	struct ksmbd_conn *conn;
 	int ret;
 
 	while (!kthread_should_stop()) {
@@ -244,6 +247,20 @@ static int ksmbd_kthread_fn(void *p)
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


