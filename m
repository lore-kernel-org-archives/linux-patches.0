Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A30223DC6;
	Sat, 30 May 2026 18:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164735; cv=none; b=oDdj25738dd1uABZ5MLtgBLlX53dutqektKiWLZk5ZtPb61dJ6dfHiOPD24FLOg3oYG/HuxzoxupW0fQvgLyGTpdqy2e1deT02vB4mPiW0fNw4EIeHLy4s9rdXYxTGSjztVZ4u6l8ixDdTJoLxltx7s0wVB1Gsff8xO/fzz/nW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164735; c=relaxed/simple;
	bh=jnYLcPqIx3ilxE0Z22XADADlVD96uHQOgfO+ACN4q1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxMZyCctM+WLJnf0oorVw5eIb+B/O9JFNqlPWnJcgTKQ6SRqgpNe58qfrmzzXX/IkcORYVvJ431kSnOT1KEiEqwQZiRcNdqndRzVqchJd4aIffaYyJXALUy3ztd1Ypy9YzQau/Q7FgLyX1GKekxTiY+wIwdR1nXsjI7HvMukU5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zx2WMJn6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zx2WMJn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC6B1F00893;
	Sat, 30 May 2026 18:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164734;
	bh=8zmcrcAo/ggfJxiRlTQrZk7wednHot94QmLWw/HJPXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zx2WMJn6VtZDgO1DmK/rA+pKQ93TqF84KM1I0Ez4YgIJGdLjRMPthAgtlzjSLzpU1
	 XkfusZyOE7YMOdy3dpmtFgVI8iT8ITHpuNOONtgm/96RF7wSbHSAqYrxK2tRKrZPNF
	 M3oUFsJahx+s2WI5JYbijUsxYAIEUaQX79wSaZY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 643/776] SUNRPC: Do not dereference non-socket transports in sysfs
Date: Sat, 30 May 2026 18:05:57 +0200
Message-ID: <20260530160256.561305345@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 421ab1be43bd015ffe744f4ea25df4f19d1ce6fe ]

Do not cast the struct xprt to a sock_xprt unless we know it is a UDP or
TCP transport. Otherwise the call to lock the mutex will scribble over
whatever structure is actually there. This has been seen to cause hard
system lockups when the underlying transport was RDMA.

Fixes: b49ea673e119 ("SUNRPC: lock against ->sock changing during sysfs read")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xprt.h     |  3 ++
 include/linux/sunrpc/xprtsock.h |  1 -
 net/sunrpc/sysfs.c              | 55 ++++++++++++++++-----------------
 net/sunrpc/xprtsock.c           | 26 ++++++++++++++--
 4 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 955ea4d7af0b2..eef5e87c03b43 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -139,6 +139,9 @@ struct rpc_xprt_ops {
 	void		(*rpcbind)(struct rpc_task *task);
 	void		(*set_port)(struct rpc_xprt *xprt, unsigned short port);
 	void		(*connect)(struct rpc_xprt *xprt, struct rpc_task *task);
+	int		(*get_srcaddr)(struct rpc_xprt *xprt, char *buf,
+				       size_t buflen);
+	unsigned short	(*get_srcport)(struct rpc_xprt *xprt);
 	int		(*buf_alloc)(struct rpc_task *task);
 	void		(*buf_free)(struct rpc_task *task);
 	void		(*prepare_request)(struct rpc_rqst *req);
diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 3eb0079669c50..38284f25eddfd 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -10,7 +10,6 @@
 
 int		init_socket_xprt(void);
 void		cleanup_socket_xprt(void);
-unsigned short	get_srcport(struct rpc_xprt *);
 
 #define RPC_MIN_RESVPORT	(1U)
 #define RPC_MAX_RESVPORT	(65535U)
diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 33e8fb85ce4f4..e643dd8748a29 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -97,7 +97,7 @@ static ssize_t rpc_sysfs_xprt_dstaddr_show(struct kobject *kobj,
 		return 0;
 	ret = sprintf(buf, "%s\n", xprt->address_strings[RPC_DISPLAY_ADDR]);
 	xprt_put(xprt);
-	return ret + 1;
+	return ret;
 }
 
 static ssize_t rpc_sysfs_xprt_srcaddr_show(struct kobject *kobj,
@@ -105,33 +105,31 @@ static ssize_t rpc_sysfs_xprt_srcaddr_show(struct kobject *kobj,
 					   char *buf)
 {
 	struct rpc_xprt *xprt = rpc_sysfs_xprt_kobj_get_xprt(kobj);
-	struct sockaddr_storage saddr;
-	struct sock_xprt *sock;
-	ssize_t ret = -1;
+	size_t buflen = PAGE_SIZE;
+	ssize_t ret = -ENOTSOCK;
 
 	if (!xprt || !xprt_connected(xprt)) {
-		xprt_put(xprt);
-		return -ENOTCONN;
+		ret = -ENOTCONN;
+	} else if (xprt->ops->get_srcaddr) {
+		ret = xprt->ops->get_srcaddr(xprt, buf, buflen);
+		if (ret > 0) {
+			if (ret < buflen - 1) {
+				buf[ret] = '\n';
+				ret++;
+				buf[ret] = '\0';
+			}
+		}
 	}
-
-	sock = container_of(xprt, struct sock_xprt, xprt);
-	mutex_lock(&sock->recv_mutex);
-	if (sock->sock == NULL ||
-	    kernel_getsockname(sock->sock, (struct sockaddr *)&saddr) < 0)
-		goto out;
-
-	ret = sprintf(buf, "%pISc\n", &saddr);
-out:
-	mutex_unlock(&sock->recv_mutex);
 	xprt_put(xprt);
-	return ret + 1;
+	return ret;
 }
 
 static ssize_t rpc_sysfs_xprt_info_show(struct kobject *kobj,
-					struct kobj_attribute *attr,
-					char *buf)
+					struct kobj_attribute *attr, char *buf)
 {
 	struct rpc_xprt *xprt = rpc_sysfs_xprt_kobj_get_xprt(kobj);
+	unsigned short srcport = 0;
+	size_t buflen = PAGE_SIZE;
 	ssize_t ret;
 
 	if (!xprt || !xprt_connected(xprt)) {
@@ -139,7 +137,11 @@ static ssize_t rpc_sysfs_xprt_info_show(struct kobject *kobj,
 		return -ENOTCONN;
 	}
 
-	ret = sprintf(buf, "last_used=%lu\ncur_cong=%lu\ncong_win=%lu\n"
+	if (xprt->ops->get_srcport)
+		srcport = xprt->ops->get_srcport(xprt);
+
+	ret = snprintf(buf, buflen,
+		       "last_used=%lu\ncur_cong=%lu\ncong_win=%lu\n"
 		       "max_num_slots=%u\nmin_num_slots=%u\nnum_reqs=%u\n"
 		       "binding_q_len=%u\nsending_q_len=%u\npending_q_len=%u\n"
 		       "backlog_q_len=%u\nmain_xprt=%d\nsrc_port=%u\n"
@@ -147,14 +149,11 @@ static ssize_t rpc_sysfs_xprt_info_show(struct kobject *kobj,
 		       xprt->last_used, xprt->cong, xprt->cwnd, xprt->max_reqs,
 		       xprt->min_reqs, xprt->num_reqs, xprt->binding.qlen,
 		       xprt->sending.qlen, xprt->pending.qlen,
-		       xprt->backlog.qlen, xprt->main,
-		       (xprt->xprt_class->ident == XPRT_TRANSPORT_TCP) ?
-		       get_srcport(xprt) : 0,
+		       xprt->backlog.qlen, xprt->main, srcport,
 		       atomic_long_read(&xprt->queuelen),
-		       (xprt->xprt_class->ident == XPRT_TRANSPORT_TCP) ?
-				xprt->address_strings[RPC_DISPLAY_PORT] : "0");
+		       xprt->address_strings[RPC_DISPLAY_PORT]);
 	xprt_put(xprt);
-	return ret + 1;
+	return ret;
 }
 
 static ssize_t rpc_sysfs_xprt_state_show(struct kobject *kobj,
@@ -201,7 +200,7 @@ static ssize_t rpc_sysfs_xprt_state_show(struct kobject *kobj,
 	}
 
 	xprt_put(xprt);
-	return ret + 1;
+	return ret;
 }
 
 static ssize_t rpc_sysfs_xprt_switch_info_show(struct kobject *kobj,
@@ -220,7 +219,7 @@ static ssize_t rpc_sysfs_xprt_switch_info_show(struct kobject *kobj,
 		      xprt_switch->xps_nunique_destaddr_xprts,
 		      atomic_long_read(&xprt_switch->xps_queuelen));
 	xprt_switch_put(xprt_switch);
-	return ret + 1;
+	return ret;
 }
 
 static ssize_t rpc_sysfs_xprt_dstaddr_store(struct kobject *kobj,
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 07acc6845ce29..a829da4bbb09e 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1677,7 +1677,7 @@ static int xs_get_srcport(struct sock_xprt *transport)
 	return port;
 }
 
-unsigned short get_srcport(struct rpc_xprt *xprt)
+static unsigned short xs_sock_srcport(struct rpc_xprt *xprt)
 {
 	struct sock_xprt *sock = container_of(xprt, struct sock_xprt, xprt);
 	unsigned short ret = 0;
@@ -1687,7 +1687,25 @@ unsigned short get_srcport(struct rpc_xprt *xprt)
 	mutex_unlock(&sock->recv_mutex);
 	return ret;
 }
-EXPORT_SYMBOL(get_srcport);
+
+static int xs_sock_srcaddr(struct rpc_xprt *xprt, char *buf, size_t buflen)
+{
+	struct sock_xprt *sock = container_of(xprt, struct sock_xprt, xprt);
+	union {
+		struct sockaddr sa;
+		struct sockaddr_storage st;
+	} saddr;
+	int ret = -ENOTCONN;
+
+	mutex_lock(&sock->recv_mutex);
+	if (sock->sock) {
+		ret = kernel_getsockname(sock->sock, &saddr.sa);
+		if (ret >= 0)
+			ret = snprintf(buf, buflen, "%pISc", &saddr.sa);
+	}
+	mutex_unlock(&sock->recv_mutex);
+	return ret;
+}
 
 static unsigned short xs_next_srcport(struct sock_xprt *transport, unsigned short port)
 {
@@ -2678,6 +2696,8 @@ static const struct rpc_xprt_ops xs_udp_ops = {
 	.rpcbind		= rpcb_getport_async,
 	.set_port		= xs_set_port,
 	.connect		= xs_connect,
+	.get_srcaddr		= xs_sock_srcaddr,
+	.get_srcport		= xs_sock_srcport,
 	.buf_alloc		= rpc_malloc,
 	.buf_free		= rpc_free,
 	.send_request		= xs_udp_send_request,
@@ -2700,6 +2720,8 @@ static const struct rpc_xprt_ops xs_tcp_ops = {
 	.rpcbind		= rpcb_getport_async,
 	.set_port		= xs_set_port,
 	.connect		= xs_connect,
+	.get_srcaddr		= xs_sock_srcaddr,
+	.get_srcport		= xs_sock_srcport,
 	.buf_alloc		= rpc_malloc,
 	.buf_free		= rpc_free,
 	.prepare_request	= xs_stream_prepare_request,
-- 
2.53.0



