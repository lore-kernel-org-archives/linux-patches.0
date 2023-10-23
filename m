Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3D71429B
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bi2BMB83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA3FC433C8;
	Mon, 23 Oct 2023 11:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059901;
	bh=TtHWGZzOk2E2xiU+loZ9zw124WVZ7pVrv7IHUaaLGxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bi2BMB83WwTLIGhRZ3+koQFAjJTyWJnksv/R/zSRnXmHHdlaUHax6xETqu2/36nlt
	 4FyPW1kwPeH0THovxJwPx0ucmEnoiMaTRPkoVBA3nVzC+lKd2H+ipf7bevluLupQlh
	 RLDyvwDnM/60CFR651y0I4JgW0GvpRwDG7pIh+Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 64/98] libceph: fix unaligned accesses in ceph_entity_addr handling
Date: Mon, 23 Oct 2023 12:56:53 +0200
Message-ID: <20231023104815.859060272@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit cede185b1ba3118e1912385db4812a37d9e9b205 ]

GCC9 is throwing a lot of warnings about unaligned access. This patch
fixes some of them by changing most of the sockaddr handling functions
to take a pointer to struct ceph_entity_addr instead of struct
sockaddr_storage.  The lower functions can then make copies or do
unaligned accesses as needed.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 7563cf17dce0 ("libceph: use kernel_connect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/messenger.c | 77 +++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 40 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 21bd37ec5511c..53ab8fc713a3e 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -462,7 +462,7 @@ static void set_sock_callbacks(struct socket *sock,
  */
 static int ceph_tcp_connect(struct ceph_connection *con)
 {
-	struct sockaddr_storage *paddr = &con->peer_addr.in_addr;
+	struct sockaddr_storage ss = con->peer_addr.in_addr; /* align */
 	struct socket *sock;
 	unsigned int noio_flag;
 	int ret;
@@ -471,7 +471,7 @@ static int ceph_tcp_connect(struct ceph_connection *con)
 
 	/* sock_create_kern() allocates with GFP_KERNEL */
 	noio_flag = memalloc_noio_save();
-	ret = sock_create_kern(read_pnet(&con->msgr->net), paddr->ss_family,
+	ret = sock_create_kern(read_pnet(&con->msgr->net), ss.ss_family,
 			       SOCK_STREAM, IPPROTO_TCP, &sock);
 	memalloc_noio_restore(noio_flag);
 	if (ret)
@@ -487,7 +487,7 @@ static int ceph_tcp_connect(struct ceph_connection *con)
 	dout("connect %s\n", ceph_pr_addr(&con->peer_addr.in_addr));
 
 	con_sock_state_connecting(con);
-	ret = sock->ops->connect(sock, (struct sockaddr *)paddr, sizeof(*paddr),
+	ret = sock->ops->connect(sock, (struct sockaddr *)&ss, sizeof(ss),
 				 O_NONBLOCK);
 	if (ret == -EINPROGRESS) {
 		dout("connect %s EINPROGRESS sk_state = %u\n",
@@ -1824,14 +1824,15 @@ static int verify_hello(struct ceph_connection *con)
 	return 0;
 }
 
-static bool addr_is_blank(struct sockaddr_storage *ss)
+static bool addr_is_blank(struct ceph_entity_addr *addr)
 {
-	struct in_addr *addr = &((struct sockaddr_in *)ss)->sin_addr;
-	struct in6_addr *addr6 = &((struct sockaddr_in6 *)ss)->sin6_addr;
+	struct sockaddr_storage ss = addr->in_addr; /* align */
+	struct in_addr *addr4 = &((struct sockaddr_in *)&ss)->sin_addr;
+	struct in6_addr *addr6 = &((struct sockaddr_in6 *)&ss)->sin6_addr;
 
-	switch (ss->ss_family) {
+	switch (ss.ss_family) {
 	case AF_INET:
-		return addr->s_addr == htonl(INADDR_ANY);
+		return addr4->s_addr == htonl(INADDR_ANY);
 	case AF_INET6:
 		return ipv6_addr_any(addr6);
 	default:
@@ -1839,25 +1840,25 @@ static bool addr_is_blank(struct sockaddr_storage *ss)
 	}
 }
 
-static int addr_port(struct sockaddr_storage *ss)
+static int addr_port(struct ceph_entity_addr *addr)
 {
-	switch (ss->ss_family) {
+	switch (get_unaligned(&addr->in_addr.ss_family)) {
 	case AF_INET:
-		return ntohs(((struct sockaddr_in *)ss)->sin_port);
+		return ntohs(get_unaligned(&((struct sockaddr_in *)&addr->in_addr)->sin_port));
 	case AF_INET6:
-		return ntohs(((struct sockaddr_in6 *)ss)->sin6_port);
+		return ntohs(get_unaligned(&((struct sockaddr_in6 *)&addr->in_addr)->sin6_port));
 	}
 	return 0;
 }
 
-static void addr_set_port(struct sockaddr_storage *ss, int p)
+static void addr_set_port(struct ceph_entity_addr *addr, int p)
 {
-	switch (ss->ss_family) {
+	switch (get_unaligned(&addr->in_addr.ss_family)) {
 	case AF_INET:
-		((struct sockaddr_in *)ss)->sin_port = htons(p);
+		put_unaligned(htons(p), &((struct sockaddr_in *)&addr->in_addr)->sin_port);
 		break;
 	case AF_INET6:
-		((struct sockaddr_in6 *)ss)->sin6_port = htons(p);
+		put_unaligned(htons(p), &((struct sockaddr_in6 *)&addr->in_addr)->sin6_port);
 		break;
 	}
 }
@@ -1865,21 +1866,18 @@ static void addr_set_port(struct sockaddr_storage *ss, int p)
 /*
  * Unlike other *_pton function semantics, zero indicates success.
  */
-static int ceph_pton(const char *str, size_t len, struct sockaddr_storage *ss,
+static int ceph_pton(const char *str, size_t len, struct ceph_entity_addr *addr,
 		char delim, const char **ipend)
 {
-	struct sockaddr_in *in4 = (struct sockaddr_in *) ss;
-	struct sockaddr_in6 *in6 = (struct sockaddr_in6 *) ss;
-
-	memset(ss, 0, sizeof(*ss));
+	memset(&addr->in_addr, 0, sizeof(addr->in_addr));
 
-	if (in4_pton(str, len, (u8 *)&in4->sin_addr.s_addr, delim, ipend)) {
-		ss->ss_family = AF_INET;
+	if (in4_pton(str, len, (u8 *)&((struct sockaddr_in *)&addr->in_addr)->sin_addr.s_addr, delim, ipend)) {
+		put_unaligned(AF_INET, &addr->in_addr.ss_family);
 		return 0;
 	}
 
-	if (in6_pton(str, len, (u8 *)&in6->sin6_addr.s6_addr, delim, ipend)) {
-		ss->ss_family = AF_INET6;
+	if (in6_pton(str, len, (u8 *)&((struct sockaddr_in6 *)&addr->in_addr)->sin6_addr.s6_addr, delim, ipend)) {
+		put_unaligned(AF_INET6, &addr->in_addr.ss_family);
 		return 0;
 	}
 
@@ -1891,7 +1889,7 @@ static int ceph_pton(const char *str, size_t len, struct sockaddr_storage *ss,
  */
 #ifdef CONFIG_CEPH_LIB_USE_DNS_RESOLVER
 static int ceph_dns_resolve_name(const char *name, size_t namelen,
-		struct sockaddr_storage *ss, char delim, const char **ipend)
+		struct ceph_entity_addr *addr, char delim, const char **ipend)
 {
 	const char *end, *delim_p;
 	char *colon_p, *ip_addr = NULL;
@@ -1920,7 +1918,7 @@ static int ceph_dns_resolve_name(const char *name, size_t namelen,
 	/* do dns_resolve upcall */
 	ip_len = dns_query(NULL, name, end - name, NULL, &ip_addr, NULL);
 	if (ip_len > 0)
-		ret = ceph_pton(ip_addr, ip_len, ss, -1, NULL);
+		ret = ceph_pton(ip_addr, ip_len, addr, -1, NULL);
 	else
 		ret = -ESRCH;
 
@@ -1929,13 +1927,13 @@ static int ceph_dns_resolve_name(const char *name, size_t namelen,
 	*ipend = end;
 
 	pr_info("resolve '%.*s' (ret=%d): %s\n", (int)(end - name), name,
-			ret, ret ? "failed" : ceph_pr_addr(ss));
+			ret, ret ? "failed" : ceph_pr_addr(&addr->in_addr));
 
 	return ret;
 }
 #else
 static inline int ceph_dns_resolve_name(const char *name, size_t namelen,
-		struct sockaddr_storage *ss, char delim, const char **ipend)
+		struct ceph_entity_addr *addr, char delim, const char **ipend)
 {
 	return -EINVAL;
 }
@@ -1946,13 +1944,13 @@ static inline int ceph_dns_resolve_name(const char *name, size_t namelen,
  * then try to extract a hostname to resolve using userspace DNS upcall.
  */
 static int ceph_parse_server_name(const char *name, size_t namelen,
-			struct sockaddr_storage *ss, char delim, const char **ipend)
+		struct ceph_entity_addr *addr, char delim, const char **ipend)
 {
 	int ret;
 
-	ret = ceph_pton(name, namelen, ss, delim, ipend);
+	ret = ceph_pton(name, namelen, addr, delim, ipend);
 	if (ret)
-		ret = ceph_dns_resolve_name(name, namelen, ss, delim, ipend);
+		ret = ceph_dns_resolve_name(name, namelen, addr, delim, ipend);
 
 	return ret;
 }
@@ -1971,7 +1969,6 @@ int ceph_parse_ips(const char *c, const char *end,
 	dout("parse_ips on '%.*s'\n", (int)(end-c), c);
 	for (i = 0; i < max_count; i++) {
 		const char *ipend;
-		struct sockaddr_storage *ss = &addr[i].in_addr;
 		int port;
 		char delim = ',';
 
@@ -1980,7 +1977,7 @@ int ceph_parse_ips(const char *c, const char *end,
 			p++;
 		}
 
-		ret = ceph_parse_server_name(p, end - p, ss, delim, &ipend);
+		ret = ceph_parse_server_name(p, end - p, &addr[i], delim, &ipend);
 		if (ret)
 			goto bad;
 		ret = -EINVAL;
@@ -2011,9 +2008,9 @@ int ceph_parse_ips(const char *c, const char *end,
 			port = CEPH_MON_PORT;
 		}
 
-		addr_set_port(ss, port);
+		addr_set_port(&addr[i], port);
 
-		dout("parse_ips got %s\n", ceph_pr_addr(ss));
+		dout("parse_ips got %s\n", ceph_pr_addr(&addr[i].in_addr));
 
 		if (p == end)
 			break;
@@ -2052,7 +2049,7 @@ static int process_banner(struct ceph_connection *con)
 	 */
 	if (memcmp(&con->peer_addr, &con->actual_peer_addr,
 		   sizeof(con->peer_addr)) != 0 &&
-	    !(addr_is_blank(&con->actual_peer_addr.in_addr) &&
+	    !(addr_is_blank(&con->actual_peer_addr) &&
 	      con->actual_peer_addr.nonce == con->peer_addr.nonce)) {
 		pr_warn("wrong peer, want %s/%d, got %s/%d\n",
 			ceph_pr_addr(&con->peer_addr.in_addr),
@@ -2066,13 +2063,13 @@ static int process_banner(struct ceph_connection *con)
 	/*
 	 * did we learn our address?
 	 */
-	if (addr_is_blank(&con->msgr->inst.addr.in_addr)) {
-		int port = addr_port(&con->msgr->inst.addr.in_addr);
+	if (addr_is_blank(&con->msgr->inst.addr)) {
+		int port = addr_port(&con->msgr->inst.addr);
 
 		memcpy(&con->msgr->inst.addr.in_addr,
 		       &con->peer_addr_for_me.in_addr,
 		       sizeof(con->peer_addr_for_me.in_addr));
-		addr_set_port(&con->msgr->inst.addr.in_addr, port);
+		addr_set_port(&con->msgr->inst.addr, port);
 		encode_my_addr(con->msgr);
 		dout("process_banner learned my addr is %s\n",
 		     ceph_pr_addr(&con->msgr->inst.addr.in_addr));
-- 
2.40.1



