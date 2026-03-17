Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B793D6698;
	Tue, 17 Mar 2026 16:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765615; cv=none; b=rORvgoXTQhVMvLY7ucSfyng4hvuqAG/KopBqj2csCHnCt3YZc+U0y65vxOh+khtj3XGCBeCCy3lmszbaUAjl+7wcVzoW2pndKEenNdNQpV+BOGcw31Vqb672GFO3/57HpNVCRdaOVWXN7UA/GTVgBpF3DDK0UInb5DNgdYvzc2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765615; c=relaxed/simple;
	bh=0vCDZJTmItuhq7qwMs8TX+Aa7UtqqAdIIbGgdtiAljY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZY6FVn7GBuL6thY2nbvPRAM79nBEGDtDYtRlEspNQO20YKkAPSWpMQa0sYgugRDOM+vNoBVP5fgZaXX8zmVe7/xIgkPZgkGCzL7Z4ClD84OvFWUGggSZ/okLHE6QFX7hx/4jjZXPex5xFsCGKKSNfLz0K+qMNSS1MHGazm08uiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kS0S0dAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kS0S0dAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D89C4CEF7;
	Tue, 17 Mar 2026 16:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765614;
	bh=0vCDZJTmItuhq7qwMs8TX+Aa7UtqqAdIIbGgdtiAljY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kS0S0dArYlhrPXGYs+l+6KojMhA9jd6FAcOFairewxacKIP0QTNwwuBop2Y0JZ8Os
	 Ea4kvimMSaIddDfsRo77XPkdPpbK7B1l7yt4HAdTWwoeZERX44tY1rxaHTTxLgiFIv
	 hIGcMicHzwy4fYTrFEW+8xZYdmo1AoAWjKxE350g=
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
Subject: [PATCH 6.19 050/378] rxrpc, afs: Fix missing error pointer check after rxrpc_kernel_lookup_peer()
Date: Tue, 17 Mar 2026 17:30:07 +0100
Message-ID: <20260317163008.831026651@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index e941da5b6dd92..b1704de3d95f5 100644
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
index 0c2c68c4b07e4..0f90272ac254b 100644
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
2.51.0



