Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB925FEE0;
	Tue, 13 Feb 2024 17:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845086; cv=none; b=HR97rEsbJibGXX6H9CL9PCv8XQwvA5k2tdQFgHwAMy6ORPmIyqLRUGWOiwkFQFbPS9W4fQiFNOyso78BKLgLQO6dzUbsaTqEqkL/lCAVOYQf2LKjxw9j01MJVHTVg4L/T8v++xJbau7QEZ3iSQyzfxihgSh4Wp8aBTT+rHIT88g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845086; c=relaxed/simple;
	bh=nzU3qD00r6cFrlBgO/9U9nxYU8cEUmdpEIzw/2SzK7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/cqgWflu+NIz2TF6m4Xh3rDucZ6qbT0+vE00JFGOoB3iB2ZXAth1mTw3UKiakTBVMNE/OghfmacLO+IwmP3S8AIf64m4dw+V1Lk7FfmiObNHaQSRYsv3gaStHZvlYYtjbO12OhN/PXiQZcgGAXijqSJOSUreOVACi8Bbt8adPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMHWPced; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMHWPced"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105A9C433C7;
	Tue, 13 Feb 2024 17:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845085;
	bh=nzU3qD00r6cFrlBgO/9U9nxYU8cEUmdpEIzw/2SzK7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMHWPcedshQlrW709H71DP+7SVJXLjcbPMHs3Wz01rXawI5L0MzjkZbzxHKekVPi7
	 Td+JgOoJuh+rCoOeIVw3aGvXuGy05vuM6XPvc8QdzJXqryZLZLPtSA9t+Cwqzc6TEu
	 6a+MKmmGB97s85EeRFpnw3lSc6SuPg6PNdiwL5Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/64] fs: dlm: dont put dlm_local_addrs on heap
Date: Tue, 13 Feb 2024 18:21:29 +0100
Message-ID: <20240213171846.101403878@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit c51c9cd8addcfbdc097dbefd59f022402183644b ]

This patch removes to allocate the dlm_local_addr[] pointers on the
heap. Instead we directly store the type of "struct sockaddr_storage".
This removes function deinit_local() because it was freeing memory only.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 72f34f96d015..2c797eb519da 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -174,7 +174,7 @@ static LIST_HEAD(dlm_node_addrs);
 static DEFINE_SPINLOCK(dlm_node_addrs_spin);
 
 static struct listen_connection listen_con;
-static struct sockaddr_storage *dlm_local_addr[DLM_MAX_ADDR_COUNT];
+static struct sockaddr_storage dlm_local_addr[DLM_MAX_ADDR_COUNT];
 static int dlm_local_count;
 int dlm_allow_conn;
 
@@ -398,7 +398,7 @@ static int nodeid_to_addr(int nodeid, struct sockaddr_storage *sas_out,
 	if (!sa_out)
 		return 0;
 
-	if (dlm_local_addr[0]->ss_family == AF_INET) {
+	if (dlm_local_addr[0].ss_family == AF_INET) {
 		struct sockaddr_in *in4  = (struct sockaddr_in *) &sas;
 		struct sockaddr_in *ret4 = (struct sockaddr_in *) sa_out;
 		ret4->sin_addr.s_addr = in4->sin_addr.s_addr;
@@ -727,7 +727,7 @@ static void add_sock(struct socket *sock, struct connection *con)
 static void make_sockaddr(struct sockaddr_storage *saddr, uint16_t port,
 			  int *addr_len)
 {
-	saddr->ss_family =  dlm_local_addr[0]->ss_family;
+	saddr->ss_family =  dlm_local_addr[0].ss_family;
 	if (saddr->ss_family == AF_INET) {
 		struct sockaddr_in *in4_addr = (struct sockaddr_in *)saddr;
 		in4_addr->sin_port = cpu_to_be16(port);
@@ -1167,7 +1167,7 @@ static int sctp_bind_addrs(struct socket *sock, uint16_t port)
 	int i, addr_len, result = 0;
 
 	for (i = 0; i < dlm_local_count; i++) {
-		memcpy(&localaddr, dlm_local_addr[i], sizeof(localaddr));
+		memcpy(&localaddr, &dlm_local_addr[i], sizeof(localaddr));
 		make_sockaddr(&localaddr, port, &addr_len);
 
 		if (!i)
@@ -1187,7 +1187,7 @@ static int sctp_bind_addrs(struct socket *sock, uint16_t port)
 /* Get local addresses */
 static void init_local(void)
 {
-	struct sockaddr_storage sas, *addr;
+	struct sockaddr_storage sas;
 	int i;
 
 	dlm_local_count = 0;
@@ -1195,21 +1195,10 @@ static void init_local(void)
 		if (dlm_our_addr(&sas, i))
 			break;
 
-		addr = kmemdup(&sas, sizeof(*addr), GFP_NOFS);
-		if (!addr)
-			break;
-		dlm_local_addr[dlm_local_count++] = addr;
+		memcpy(&dlm_local_addr[dlm_local_count++], &sas, sizeof(sas));
 	}
 }
 
-static void deinit_local(void)
-{
-	int i;
-
-	for (i = 0; i < dlm_local_count; i++)
-		kfree(dlm_local_addr[i]);
-}
-
 static struct writequeue_entry *new_writequeue_entry(struct connection *con)
 {
 	struct writequeue_entry *entry;
@@ -1575,7 +1564,7 @@ static void dlm_connect(struct connection *con)
 	}
 
 	/* Create a socket to communicate with */
-	result = sock_create_kern(&init_net, dlm_local_addr[0]->ss_family,
+	result = sock_create_kern(&init_net, dlm_local_addr[0].ss_family,
 				  SOCK_STREAM, dlm_proto_ops->proto, &sock);
 	if (result < 0)
 		goto socket_err;
@@ -1786,7 +1775,6 @@ void dlm_lowcomms_stop(void)
 	foreach_conn(free_conn);
 	srcu_read_unlock(&connections_srcu, idx);
 	work_stop();
-	deinit_local();
 
 	dlm_proto_ops = NULL;
 }
@@ -1803,7 +1791,7 @@ static int dlm_listen_for_all(void)
 	if (result < 0)
 		return result;
 
-	result = sock_create_kern(&init_net, dlm_local_addr[0]->ss_family,
+	result = sock_create_kern(&init_net, dlm_local_addr[0].ss_family,
 				  SOCK_STREAM, dlm_proto_ops->proto, &sock);
 	if (result < 0) {
 		log_print("Can't create comms socket: %d", result);
@@ -1842,7 +1830,7 @@ static int dlm_tcp_bind(struct socket *sock)
 	/* Bind to our cluster-known address connecting to avoid
 	 * routing problems.
 	 */
-	memcpy(&src_addr, dlm_local_addr[0], sizeof(src_addr));
+	memcpy(&src_addr, &dlm_local_addr[0], sizeof(src_addr));
 	make_sockaddr(&src_addr, 0, &addr_len);
 
 	result = kernel_bind(sock, (struct sockaddr *)&src_addr,
@@ -1899,9 +1887,9 @@ static int dlm_tcp_listen_bind(struct socket *sock)
 	int addr_len;
 
 	/* Bind to our port */
-	make_sockaddr(dlm_local_addr[0], dlm_config.ci_tcp_port, &addr_len);
+	make_sockaddr(&dlm_local_addr[0], dlm_config.ci_tcp_port, &addr_len);
 	return kernel_bind(sock, (struct sockaddr *)&dlm_local_addr[0],
-			   addr_len);
+		           addr_len);
 }
 
 static const struct dlm_proto_ops dlm_tcp_ops = {
@@ -1992,7 +1980,7 @@ int dlm_lowcomms_start(void)
 
 	error = work_start();
 	if (error)
-		goto fail_local;
+		goto fail;
 
 	dlm_allow_conn = 1;
 
@@ -2022,8 +2010,6 @@ int dlm_lowcomms_start(void)
 fail_proto_ops:
 	dlm_allow_conn = 0;
 	work_stop();
-fail_local:
-	deinit_local();
 fail:
 	return error;
 }
-- 
2.43.0



