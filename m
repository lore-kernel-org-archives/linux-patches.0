Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B7817BED0;
	Sat, 17 Oct 2026 16:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253895; cv=none; b=Tf00/qVfEkGUu4RAcFzOlK3BsfZbTH7+ttD9eAgV5y+aI5tjMjiaqWMCu2Ig9+1JisA7TOdFvQzAZQ2YsQqHzus3dplP/SQ62T1udPHL8ftDwzLwz3XWeHFqzLKKOdI3nJGW7IYcoDQS/sYDAaZBbXrHdMFoKvfIIyFULvn68UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253895; c=relaxed/simple;
	bh=fAtl7tFLQRd0IUXGHrxw6x7RQ+/mFEeHnh1qZudXejU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkV6vMEvGV4i4UpP9LddVJJfvyPlHxmfhBOQwVGOo4jgPNpR+tKapGjAmYfV9usBuUPe4ndB5/MNL4Y12d6tPVCRTN1ecf1uGUymy0YtzaXb4VqS+lCnZ74JT9uYLZBJUFwZf6e5Q98CSRCibrVjui36ZImdn7tY1woRXS3Wv/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yl2bn19p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yl2bn19p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7AD1F000C4;
	Sat, 17 Oct 2026 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253894;
	bh=CLF7nwJ9A7Rptxvoqp5nweBQ6blFXTu1cGykZCXItwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yl2bn19pX+BnkaugJJtxGeTxDJo1lhl79Me2bDg0UOwnvIw5Ot653l+DVRdQ4HnAL
	 R7vmOLqRs+97GQ3MPVqqPyS5REdcQxA4YqCMui6A4Z4IEsObn0iIJoJNXGmdd2DHcb
	 dtGvwtFI9IoXMiDUafQfCBfyyZr5XHM5MtV8kgyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 268/869] rxrpc, afs: Fix missing error pointer check after rxrpc_kernel_lookup_peer()
Date: Sat, 17 Oct 2026 17:51:49 +0200
Message-ID: <20261017160043.937833938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 4245a79003adf30e67f8e9060915bd05cb31d142 ]

rxrpc_kernel_lookup_peer() can also return error pointers in addition to
NULL, so just checking for NULL is not sufficient.

Fix this by:

 (1) Changing rxrpc_kernel_lookup_peer() to return -ENOMEM rather than NULL
     on allocation failure.

 (2) Making the callers in afs use IS_ERR() and PTR_ERR() to pass on the
     error code returned.

Fixes: 72904d7b9bfb ("rxrpc, afs: Allow afs to pin rxrpc_peer objects")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/368272.1772713861@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/addr_list.c   | 8 ++++----
 net/rxrpc/af_rxrpc.c | 8 +++++---
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/afs/addr_list.c b/fs/afs/addr_list.c
index f2361a1351076..48d68f5aa7b43 100644
--- a/fs/afs/addr_list.c
+++ b/fs/afs/addr_list.c
@@ -298,8 +298,8 @@ int afs_merge_fs_addr4(struct afs_net *net, struct afs_addr_list *alist,
 	srx.transport.sin.sin_addr.s_addr = xdr;
 
 	peer = rxrpc_kernel_lookup_peer(net->socket, &srx, GFP_KERNEL);
-	if (!peer)
-		return -ENOMEM;
+	if (IS_ERR(peer))
+		return PTR_ERR(peer);
 
 	for (i = 0; i < alist->nr_ipv4; i++) {
 		if (peer == alist->addrs[i].peer) {
@@ -342,8 +342,8 @@ int afs_merge_fs_addr6(struct afs_net *net, struct afs_addr_list *alist,
 	memcpy(&srx.transport.sin6.sin6_addr, xdr, 16);
 
 	peer = rxrpc_kernel_lookup_peer(net->socket, &srx, GFP_KERNEL);
-	if (!peer)
-		return -ENOMEM;
+	if (IS_ERR(peer))
+		return PTR_ERR(peer);
 
 	for (i = alist->nr_ipv4; i < alist->nr_addrs; i++) {
 		if (peer == alist->addrs[i].peer) {
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index edb5a94110783..0d86c7c37754a 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -267,12 +267,13 @@ static int rxrpc_listen(struct socket *sock, int backlog)
  * Lookup or create a remote transport endpoint record for the specified
  * address.
  *
- * Return: The peer record found with a reference, %NULL if no record is found
- * or a negative error code if the address is invalid or unsupported.
+ * Return: The peer record found with a reference or a negative error code if
+ * the address is invalid or unsupported.
  */
 struct rxrpc_peer *rxrpc_kernel_lookup_peer(struct socket *sock,
 					    struct sockaddr_rxrpc *srx, gfp_t gfp)
 {
+	struct rxrpc_peer *peer;
 	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
 	int ret;
 
@@ -280,7 +281,8 @@ struct rxrpc_peer *rxrpc_kernel_lookup_peer(struct socket *sock,
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	return rxrpc_lookup_peer(rx->local, srx, gfp);
+	peer = rxrpc_lookup_peer(rx->local, srx, gfp);
+	return peer ?: ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(rxrpc_kernel_lookup_peer);
 
-- 
2.53.0



