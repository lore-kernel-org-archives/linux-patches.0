Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623982;
	b=XVwJ6StJF0TlbkzQIZLgsQxZ7+c/sCMioCJ55FropAqQ76SGT1JB59mxJSR4FLrTaTis
	 26CCUHPuX0mL0prjhsTdtgu2Yt4lCkfG9/WAhnEtp1WeJKdcgHDor3mS0ocRz5RcKFvRC
	 soPrVtkgmh/zGXoFiKyDK+Khb/Q8u74i/SCKDeMNHFDiPDQ52fYzc64vIKu/iVuSrAdaJ
	 Z8a4Waxz0uBSpRX7SOFvg4vC0YTz35va8m5uawItLFzDJbMNjG6oKezCnZ+ja86tqjd7h
	 K51qwiW8can6MHBV4nm+kh2LXJSxxyceNTC3mePDFDPQzxZnJIIY+HOjrYXqF7dLZFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ucEVLAGS/nSOhbWnqncvQ8nFhJBLg0Gy5ZewzivCkU=;
	b=3ClZwo74MxOFeW9A/swXJ+zTjHSROjfKK1SgL4lXWHq89Zv5ZQLTYAQ4Q/i80mtSdChd
	 8ULM4QhK+sghHCC0bXdap0aAqrEYJ28wmJPE/Af/40LlRTzntcwcBrkdnPMX377lz+DAk
	 Qf35mXOQy9F5uMm/Dy2k7/6ibdzQtyoPWs4uwxCxqBHd03R1BjmRKcCsZsnnGA3Le9SyH
	 TTPp5bvzFaAe0yPQcLsHPeC6u0N6ds4T2xZhCcbMYYCq427tUnVUdTAcYSpHV8iZMpZek
	 HgQLUUIcwJ3JS2zz+dprhCJzAp0ttufgE1gy04e4YiUdRJM5A63qFxLmDj9cPwjfUbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WFal1IpF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7936606A323;
	Wed, 25 Nov 2026 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WFal1IpF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A3B1F000C4;
	Wed, 25 Nov 2026 16:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623981;
	bh=0ucEVLAGS/nSOhbWnqncvQ8nFhJBLg0Gy5ZewzivCkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFal1IpFibaWSfKAQFk3RVfUSzEtfHE+GlUUCQq3ggKYqP2xq29ckCct1OrqBV+bo
	 32M42pQ3VPhyz0OOMEfV4Sp9sVImm6Ji6yA2eFqAwp/xyQbgvk0gKESYZkpPACLgRi
	 f2v64J/hnc6y88sVbHGOyF4SDNgkyRANtpUGbfw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/816] 9p: create a v9fs_context structure to hold parsed options
Date: Wed, 25 Nov 2026 15:26:37 +0100
Message-ID: <20261125143850.355620477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 075e8bd4127f007910fc302ad5c3c471d0be4799 ]

This patch creates a new v9fs_context structure which includes
new p9_session_opts and p9_client_opts structures, as well as
re-using the existing p9_fd_opts and p9_rdma_opts to store options
during parsing. The new structure will be used in the next
commit to pass all parsed options to the appropriate transports.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Message-ID: <20251010214222.1347785-4-sandeen@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Stable-dep-of: 37dce65a0b43 ("9p: use fc->net_ns for network namespace in RDMA and socket transports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/9p/client.h    | 90 ++++++++++++++++++++++++++++++++++++++
 include/net/9p/transport.h | 32 --------------
 2 files changed, 90 insertions(+), 32 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 2d46f8017bd57..cc18443f7d516 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -132,6 +132,96 @@ struct p9_client {
 	char name[__NEW_UTS_LEN + 1];
 };
 
+/**
+ * struct p9_fd_opts - holds client options during parsing
+ * @msize: maximum data size negotiated by protocol
+ * @prot-Oversion: 9P protocol version to use
+ * @trans_mod: module API instantiated with this client
+ *
+ * These parsed options get transferred into client in
+ * apply_client_options()
+ */
+struct p9_client_opts {
+	unsigned int msize;
+	unsigned char proto_version;
+	struct p9_trans_module *trans_mod;
+};
+
+/**
+ * struct p9_fd_opts - per-transport options for fd transport
+ * @rfd: file descriptor for reading (trans=fd)
+ * @wfd: file descriptor for writing (trans=fd)
+ * @port: port to connect to (trans=tcp)
+ * @privport: port is privileged
+ */
+struct p9_fd_opts {
+	int rfd;
+	int wfd;
+	u16 port;
+	bool privport;
+};
+
+/**
+ * struct p9_rdma_opts - Collection of mount options for rdma transport
+ * @port: port of connection
+ * @privport: Whether a privileged port may be used
+ * @sq_depth: The requested depth of the SQ. This really doesn't need
+ * to be any deeper than the number of threads used in the client
+ * @rq_depth: The depth of the RQ. Should be greater than or equal to SQ depth
+ * @timeout: Time to wait in msecs for CM events
+ */
+struct p9_rdma_opts {
+	short port;
+	bool privport;
+	int sq_depth;
+	int rq_depth;
+	long timeout;
+};
+
+/**
+ * struct p9_session_opts - holds parsed options for v9fs_session_info
+ * @flags: session options of type &p9_session_flags
+ * @nodev: set to 1 to disable device mapping
+ * @debug: debug level
+ * @afid: authentication handle
+ * @cache: cache mode of type &p9_cache_bits
+ * @cachetag: the tag of the cache associated with this session
+ * @uname: string user name to mount hierarchy as
+ * @aname: mount specifier for remote hierarchy
+ * @dfltuid: default numeric userid to mount hierarchy as
+ * @dfltgid: default numeric groupid to mount hierarchy as
+ * @uid: if %V9FS_ACCESS_SINGLE, the numeric uid which mounted the hierarchy
+ * @session_lock_timeout: retry interval for blocking locks
+ *
+ * This strucure holds options which are parsed and will be transferred
+ * to the v9fs_session_info structure when mounted, and therefore largely
+ * duplicates struct v9fs_session_info.
+ */
+struct p9_session_opts {
+	unsigned int flags;
+	unsigned char nodev;
+	unsigned short debug;
+	unsigned int afid;
+	unsigned int cache;
+#ifdef CONFIG_9P_FSCACHE
+	char *cachetag;
+#endif
+	char *uname;
+	char *aname;
+	kuid_t dfltuid;
+	kgid_t dfltgid;
+	kuid_t uid;
+	long session_lock_timeout;
+};
+
+/* Used by mount API to store parsed mount options */
+struct v9fs_context {
+	struct p9_client_opts	client_opts;
+	struct p9_fd_opts	fd_opts;
+	struct p9_rdma_opts	rdma_opts;
+	struct p9_session_opts	session_opts;
+};
+
 /**
  * struct p9_fid - file system entity handle
  * @clnt: back pointer to instantiating &p9_client
diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 88702953b1ef2..ebbb4b50ee205 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -21,38 +21,6 @@
 #define P9_RDMA_RQ_DEPTH	32
 #define P9_RDMA_TIMEOUT		30000		/* 30 seconds */
 
-/**
- * struct p9_fd_opts - per-transport options for fd transport
- * @rfd: file descriptor for reading (trans=fd)
- * @wfd: file descriptor for writing (trans=fd)
- * @port: port to connect to (trans=tcp)
- * @privport: port is privileged
- */
-
-struct p9_fd_opts {
-	int rfd;
-	int wfd;
-	u16 port;
-	bool privport;
-};
-
-/**
- * struct p9_rdma_opts - Collection of mount options for rdma transport
- * @port: port of connection
- * @privport: Whether a privileged port may be used
- * @sq_depth: The requested depth of the SQ. This really doesn't need
- * to be any deeper than the number of threads used in the client
- * @rq_depth: The depth of the RQ. Should be greater than or equal to SQ depth
- * @timeout: Time to wait in msecs for CM events
- */
-struct p9_rdma_opts {
-	short port;
-	bool privport;
-	int sq_depth;
-	int rq_depth;
-	long timeout;
-};
-
 /**
  * struct p9_trans_module - transport module interface
  * @list: used to maintain a list of currently available transports
-- 
2.53.0



