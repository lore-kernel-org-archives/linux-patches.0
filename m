Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056863;
	b=UPTQ9no1KSMJDozJQXl/Y7xMnmgxHXAHGljtNa/wgRD/M6fGIgTC6otcscHo82OleV9+
	 CqoAYZ7KMXVeMKz31iVo7pxOISVnEQyFSLhDXB96Y/feSbM9/yj8JYu+cYmLWmCPVOmvO
	 0PiG7WOrN/BC3gygghhV5UWbvxY+3j/dr9J2WYzrkN2k/wd8i2wLrH/KjerAiGXtx1U3a
	 qtUGRiC4G6bu/8ba5BgPoDfdVO57Eve/BtyoDAzNQv07xx3RTuHUFYMrmzVzPfMkGbMeN
	 zB1D9ESTHppWj9iHLyRmUCnDK16FFcOPn7Etq/n+IrlVFFGM7fd2S/8dkTbvtlMO2rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hiSLFvUzXuHwOc5RPBydT65RTDdp/Bmb1bOUMWSvHho=;
	b=T9HuSF9OF7504ovHnaG9j8jhqZIFEX6MbqrWb7XwVtZblnce4L3a8kG/fdzq6PPdI/pW
	 JgoXnUKHuqh2LMulE5G3HQYjBBNamZ7jBmE8eCet90RlBsm7KkQUmhwy1B17XCl5/dseH
	 9VJltsmr6OvpLYUgPsLc4uGr6GGNOkDEhmwn2FEM3WuTeAAva84xh4Xbz6k1CtXJx1zF/
	 bCAQ7/qsSq1C5Uvnp9g6b8C59TOPpI8fwlf6gBhYSDce8gPieer0d++G5ZaeTB5iczU9g
	 qPN2lITpiUEqVmXMc7+Ngij8Qz1zfuALZd4vA5ygOWMMfN8bPfb39CyFUDJSspotBPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdhJjX4W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8E2606A32A;
	Thu, 19 Nov 2026 02:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdhJjX4W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2F21F000C4;
	Thu, 19 Nov 2026 02:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056863;
	bh=hiSLFvUzXuHwOc5RPBydT65RTDdp/Bmb1bOUMWSvHho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdhJjX4WbMX28kMdFlAXWYSr+POYNS3kOeCWs0wWDM1m63D86aRtxTW/xIO7AwP4M
	 +RiipTq7CUp7ljmJHxpKN9WCArreBfPC36SUuYoqFpSs9xvSmPD1yiELVC8aoWMEBV
	 pgNq2nTr0tfILckaqEYTXwEkl/Q3ZlHkDWJHPtHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2140/2214] net/rds: do not initialize transports after rds_init() failed
Date: Wed, 18 Nov 2026 16:03:36 +0100
Message-ID: <20261118150136.115858830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 00f6d3d6e242f..fdb153e61bdb5 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -922,8 +922,11 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
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
@@ -944,6 +947,16 @@ module_exit(rds_exit);
 
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
@@ -980,6 +993,7 @@ static int __init rds_init(void)
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
index ce5af872e2b1c..97ff5073491a7 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -1009,6 +1009,7 @@ extern unsigned int  rds_sysctl_trace_level;
 int rds_threads_init(void);
 void rds_threads_exit(void);
 extern struct workqueue_struct *rds_wq;
+bool rds_is_initialized(void);
 void rds_queue_reconnect(struct rds_conn_path *cp);
 void rds_connect_worker(struct work_struct *);
 void rds_shutdown_worker(struct work_struct *);
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 4f5d2e8a90c34..d59259bb79363 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -775,6 +775,9 @@ static int __init rds_tcp_init(void)
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



