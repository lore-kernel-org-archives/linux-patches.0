Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021894;
	b=hC4mWsAxfrmwdnQT143m1gZB4aVs+pUEMRSP9KRNXAVRrg/tU36UlAraz0fMLg8+oUGF
	 1q/+QFXhr93YVtX9U5aSWBSJb/YLNdl+FG21nZ7S460hlYGiIHPUPm45jEjgb3dagzYp2
	 eTWY8VXPRjuEtV7ueoL0i+Y3eGIF3sTzrfHFhQaqKpAjHVCJZXo3qtP+lSFlYipVen9xf
	 AqfZzctMS1RbKgpbQCSmLdlJFfru4edpSxb127yR3Sf3qQ4e8wzOhIcaob/4h8jSV6WPq
	 zUCBO1QMeCLO10olxGw916td7PMAuQ0mwAQ1QwFJED+vbPxqG4FTgHcmgpbooJ4ZrXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xmLBIhMCSN+j7DU08TdGUzwhCvcIqEsnrCGcrCMxMdU=;
	b=aljDLAeClGkZ4oKj9xBzcVGgB0bANlGBZO8FjkaY/UHIMxSOceDFhY3BAxrnu7al+Q+B
	 8j2n1nSdYPCaMn664mTtavu7k9iBovoR40sBBaDWX7Lb2jMil/uwZQAmDkBlADbKlLEBw
	 WNly/EqYli0GN+Jd8o6/RczKN7lv6zLHdsveQYC0u1VHVHaxYNlyi0cPIF+Y5pDBgPYB+
	 foIaSD2aEZouoTEk6oINccFim+v04UG6by13LGLIYTQzEURAAjdT5+BUPZklT8ZPfMUJ3
	 b/HiAIRlN82QXmPj7zzxAlb1ASCwxRL83GHvXMHNzhBb2tfAYW0ESjJmI6YyqsON+pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBFpa2yU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8326F606A320;
	Wed, 18 Nov 2026 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBFpa2yU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E731F000C4;
	Wed, 18 Nov 2026 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021894;
	bh=xmLBIhMCSN+j7DU08TdGUzwhCvcIqEsnrCGcrCMxMdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBFpa2yUmNIW/4GUO5/8d61f3t2EExdjbbJR6wTr6loQNMY8vkOUIIhIYjui6nYqu
	 W31/Qp+i20BOtyE5EJSsTV+c9qhe48ibapVRtVLopEtjIjXtf2mKzio1S8gVMatJKW
	 4xtv0HRbW3GAeMkOVJHKRd7Vy2EfrQHDhcVnSSy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2469/2651] net/rds: do not initialize transports after rds_init() failed
Date: Wed, 18 Nov 2026 16:01:49 +0100
Message-ID: <20261118150413.886650959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit ffbbc315b8b883a1c0e131fb3186b9428d2812aa ]

rds, rds_rdma and rds_tcp each have their own module_init().  When they
are built in, those run in link order, so rds_init() goes first, but
do_initcalls() does not stop when it fails.  The transports then
initialize against a core that has already been torn down: rds_wq has
been destroyed, yet rds_ib_dev_put(), rds_ib_unregister_client() and
rds_tcp_accept_work() still queue onto or flush it, and
rds_trans_register() hands the transports to a core whose socket
family may never have been registered.

This was seen with CONFIG_SYSCTL=n, where rds_sysctl_init() failed and
rds_ib_init()'s error path then flushed the freed rds_wq [1], but any
rds_init() failure after rds_threads_init() has the same effect.

Record whether rds_init() succeeded and have rds_rdma_init() and
rds_tcp_init() bail out with -ENODEV otherwise.  Modular builds are
unaffected: the transports need symbols exported by rds.ko, so they
cannot be loaded unless rds_init() succeeded.

[1] https://lore.kernel.org/oe-lkp/202610190310.9737b2e3-lkp@intel.com
Fixes: 55b7ed0b582f ("RDS: Common RDMA transport code")
Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20261021195837.142802-3-achender@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/af_rds.c         | 14 ++++++++++++++
 net/rds/rdma_transport.c |  3 +++
 net/rds/rds.h            |  1 +
 net/rds/tcp.c            |  3 +++
 4 files changed, 21 insertions(+)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index e84d00bbe9a15..fb6b8ddb2d111 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -925,8 +925,11 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
 }
 #endif
 
+static bool rds_initialized;
+
 static void rds_exit(void)
 {
+	rds_initialized = false;
 	sock_unregister(rds_family_ops.family);
 	proto_unregister(&rds_proto);
 	rds_conn_exit();
@@ -947,6 +950,16 @@ module_exit(rds_exit);
 
 u32 rds_gen_num;
 
+/* When RDS is built in, a failed rds_init() does not stop the rds_rdma
+ * and rds_tcp initcalls from running against a core that has already
+ * been torn down (rds_wq in particular).  Let them bail out early.
+ */
+bool rds_is_initialized(void)
+{
+	return rds_initialized;
+}
+EXPORT_SYMBOL_GPL(rds_is_initialized);
+
 static int __init rds_init(void)
 {
 	int ret;
@@ -983,6 +996,7 @@ static int __init rds_init(void)
 	rds_info_register_func(RDS6_INFO_SOCKETS, rds6_sock_info);
 	rds_info_register_func(RDS6_INFO_RECV_MESSAGES, rds6_sock_inc_info);
 #endif
+	rds_initialized = true;
 
 	goto out;
 
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 7be38be1228ec..cc6a7d29791ae 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -325,6 +325,9 @@ static int __init rds_rdma_init(void)
 {
 	int ret;
 
+	if (!rds_is_initialized())
+		return -ENODEV;
+
 	ret = rds_ib_init();
 	if (ret)
 		goto out;
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 9b1ffc49c0a61..e3937c1ff3a1a 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -1042,6 +1042,7 @@ extern unsigned int  rds_sysctl_trace_level;
 int rds_threads_init(void);
 void rds_threads_exit(void);
 extern struct workqueue_struct *rds_wq;
+bool rds_is_initialized(void);
 void rds_queue_reconnect(struct rds_conn_path *cp);
 void rds_connect_worker(struct work_struct *);
 void rds_shutdown_worker(struct work_struct *);
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 34815b4f658ba..c1ad37505417d 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -815,6 +815,9 @@ static int __init rds_tcp_init(void)
 {
 	int ret;
 
+	if (!rds_is_initialized())
+		return -ENODEV;
+
 	rds_tcp_conn_slab = KMEM_CACHE(rds_tcp_connection, 0);
 	if (!rds_tcp_conn_slab) {
 		ret = -ENOMEM;
-- 
2.53.0



