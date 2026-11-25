Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620911;
	b=2lNNafswsULe2geGFBohWKm7sa/CC18v9b7lqwbPugqZqiC9ZDnShYzYjwaDE6/MHWQm
	 VAxyfT6DtvGj+zFgfmpHlLCh6+cOc9dQNZ9p5Ka6u6loy9DWXOIVLXlyU4LYWihQ7zg7h
	 sHME9XZOk0fjN7UJIx1Ye0qWc15q93pw48GiaStSdA1spC+hG4ZWmmCi+JFpHYC/gsaNS
	 PdQd3n5WON0VerBLYCCfaqQF73OcBIielBwQi84hA5UIoZW8yZmnneSnK5+LDb/JRbCyt
	 ++FIz0kAQucbG17ElmArAk8BZMYsJkmzWpvapHW/qkXq2EBzRf0xsapouCPWiK1ou+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0OSegVzH04E6leHpSRR0s6ETw/Aa31Rq0SQF2RcNWug=;
	b=S1qfO7nPydG/CY2BvQwhZU30DbT1dCYIuneCmgdf4GZqtl3HbJGI1+Yc3SAEJYsS84Ru
	 QYhLBiSrWKo5pNGqph1dCQkZllteS23G+Qhw2S3/pdUos0pP91v/RxNiKlr8Xz1W+BLyk
	 rHzcIwQXvBklomY/44ED/hn4wOkoXoKjhYOELch0uUJ+rPQYUpgvRsFxaK/Qb0+TupJK3
	 9T5W/tgDjsLH8FskECsBvE7nF9/Q/NONdlLu9Di8sqHJy96GY+K6eAYoiord4qvadZVv7
	 Yts6u2HtMNBCTk0aSayrDAQGREcNfQO0IJdn02ygz5ddINQJ5KPebx0okY3je2ASfHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1MJtJ1H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2BF606A321;
	Wed, 25 Nov 2026 15:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1MJtJ1H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A4E1F000C6;
	Wed, 25 Nov 2026 15:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620911;
	bh=0OSegVzH04E6leHpSRR0s6ETw/Aa31Rq0SQF2RcNWug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1MJtJ1HVm3TXBtAZWV6RKNSrTIl60u/5YapXZ+kLLjAfthHdNGjLCttHcGehB6dM
	 cTVX1ODNFLK7Ry0g0jn/y333LuWWkx5ytOC0vs7h2ngNB3KUksSvSyVUFHBeCiV2pL
	 nj5d7NUFJsO9YS81Xfa3csRGllt+qu5leBFvVDps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/990] 9p: create a v9fs_context structure to hold parsed options
Date: Wed, 25 Nov 2026 15:23:47 +0100
Message-ID: <20261125143823.491438410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



