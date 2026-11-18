Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042504;
	b=rWDd21NFvkYmho2vmtn+4ubsTz6jfBRfWW+hyW2WmhfrfotvBgBQloBvFMEnCbNQ3YBY
	 kM41SJrAUM6116EXM8EWetgRWNBrHm0mo8WntsU32NggHHnGY7pdQ9rLCV/ihXGbu9juB
	 VIrnPMB5Dx701ERVn8OYsenRXFrI0qtRfhR9kOXZfYQuFy0Zo1d0vVdgtZU2b8gdRE6j1
	 Mr2Qi6JdsdzZA5i6QRt1SxCWWl2Yg++yDAOxykFl1xi5kzOH03ZVhaCztqWaVYAlzSzEq
	 GQYOYQVf+StBCDuk68vHbkBQfBTySOGMoqQjymkzdR2nGmTcY6QrnziPqau05hQ/nXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jA5N/mG6mt67bkQ6CROrM33bOllBWKyud00XrGFV684=;
	b=x0kX5TxNkJEQ/AUmPOcvAhQ7ULqATYoyYt0ongjpW18tFMty+MAN42VxCz7zZxFPSDNf
	 96o+Od8M0Xqg2sKgjDfdqNhTvnM7yhaiswHLgkcu+seJlBOfvrrOAEerj08MjFIcK3D2L
	 6cGnMb0GGyuwYijB21JNCVsmFUIFVMSL5qWJy2F6ncIJ3CFDHtY5uq4XP8uKcS2B7jcwh
	 KjXyX1Mqe4Br8G4L2XrjCiWIC0AYv9c5K/Ks4BtHvI2C0/PiHAJa4/4O/+oNbR4ZWoTPl
	 1xqdtWVt5TQom5rbqVcfPp2q394/njbgBn6FI7aHUaEuu+50AABK4ICAgrN/udTaTww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nin2IK2N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59574606A31C;
	Wed, 18 Nov 2026 22:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nin2IK2N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AB71F000C4;
	Wed, 18 Nov 2026 22:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042504;
	bh=jA5N/mG6mt67bkQ6CROrM33bOllBWKyud00XrGFV684=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nin2IK2NXHNR7jri4AvulQGGAJvVAASJtBXvBq1DKY77M7BBHFQcTl3wl1t44zvsU
	 t4HHlNHt/QkPam3uU7OuuWUr1+4gpLA/7zitPxxcmJhiV81+r6bgAqKxewmh2UUxX/
	 8+ncarNs7Sd/PM8Dknx6qo6lBj0R3IaL/KmEI8Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3193/3318] net/rds: do not initialize transports after rds_init() failed
Date: Wed, 18 Nov 2026 16:03:35 +0100
Message-ID: <20261118150455.567471590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 63b6d6e6b035d..942ee11c67a9f 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -921,8 +921,11 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
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
@@ -943,6 +946,16 @@ module_exit(rds_exit);
 
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
@@ -979,6 +992,7 @@ static int __init rds_init(void)
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
index 5a1789ace8fbf..9396eda4c3ff7 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -1008,6 +1008,7 @@ extern unsigned int  rds_sysctl_trace_level;
 int rds_threads_init(void);
 void rds_threads_exit(void);
 extern struct workqueue_struct *rds_wq;
+bool rds_is_initialized(void);
 void rds_queue_reconnect(struct rds_conn_path *cp);
 void rds_connect_worker(struct work_struct *);
 void rds_shutdown_worker(struct work_struct *);
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index fb6234748c582..80d0e4c5b6aaf 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -820,6 +820,9 @@ static int __init rds_tcp_init(void)
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



