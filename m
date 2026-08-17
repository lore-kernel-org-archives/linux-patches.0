Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB48113C9C4;
	Mon, 17 Aug 2026 14:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976449; cv=none; b=BZc+2bKKVS8bplBNZPLK5CP5cSl7QDJIHZUFgBQwnw3hY/xY1dsZfq0QsnYAJXCExIibZwqsX42PRz7TuP6TmJpgbZbkGK69e34osgf+rZMlQWXCBNgdgbqlAmyiCVwDbV5AxS7zFE5yU3RSgTFJ/XGd3BNhxUpGUj4XdEBSUAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976449; c=relaxed/simple;
	bh=ZmO2NWceW0IoAOkADp1a/VUBC+WC02vmubeOdxpJZeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHBE6RL79qp24oWN5dobHwtUjaZxGYoctg81FzkcvU6SudV6U26ZGzCvJYnoS40sHmdxP/ep2FOOcLoro6B9SL2lbbV6rDBKjzGNJ9sog1GN6b0KxjOMEbU2IYAf7Q9VPdWvgy+dlT7AWj1Hz+xNXACSa4IZ+rhYgdH9LXjDW4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iczg+8SS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iczg+8SS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D371F000E9;
	Mon, 17 Aug 2026 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976447;
	bh=OMfammhM3NUt3nP1oiOtJ/sFeCwkrathkTIvgnUEHK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iczg+8SSWiriiQ3jUJbytZUux10twH/HGqk+GRj1EARyEsaGue+Zm5dntD24dwaRd
	 tQEMNF4xJibBQHPtIZsRfdwVlCNU5jenP+hJLituB0bCwhO1fakYqqPTctb78j2lon
	 43CDu/DcCCFaxJVwK02iqeg5yt/iJ3U1BM9oLHo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 377/389] tipc: read le->link under the node lock in tipc_node_link_down()
Date: Mon, 17 Aug 2026 15:33:36 +0200
Message-ID: <20260817132553.396288588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Yang <junvyyang@tencent.com>

commit cba9ccb47e9fa4cc77692fb896cc5ab57a667882 upstream.

tipc_node_link_down() caches the link pointer before taking n->lock:

	struct tipc_link *l = le->link;		/* unlocked */

	if (!l)
		return;
	tipc_node_write_lock(n);
	if (!tipc_link_is_establishing(l)) {	/* deref l */
	...
		tipc_link_reset(l);		/* write into l */
	if (delete) {
		kfree(l);
		le->link = NULL;

The delete=true caller frees that very object under n->lock, so the lock
does not protect the cached pointer against it:

 - CPU A, delete=false: tipc_rcv() on TIPC_LINK_DOWN_EVT, or the link
   supervision timer via tipc_node_timeout(), reads l unlocked and then
   dereferences it under n->lock;
 - CPU B, delete=true: netlink TIPC_NL_BEARER_DISABLE -> bearer_disable()
   -> tipc_node_delete_links() -> tipc_node_link_down(n, bearer_id, true)
   -> kfree(l).

The link is freed with plain kfree(), not kfree_rcu(), and for UDP bearers
disable_media() only schedules the asynchronous cleanup_bearer() work, so
its synchronize_net() runs after the links are already gone.  An in-flight
CPU A that has read l therefore dereferences freed memory once B frees it:
a use-after-free read in tipc_link_is_establishing(), and a use-after-free
write via tipc_link_reset() on the establishing branch.

The following trace was captured on 7.2.0-rc5-00284-gaf39eb111ce6:

  BUG: KASAN: slab-use-after-free in tipc_link_is_establishing (net/tipc/link.c:285)
  Read of size 4 at addr ffff88802e2aa068 by task swapper/2/0
   tipc_link_is_establishing (net/tipc/link.c:285)
   tipc_node_link_down (net/tipc/node.c:1076)
   tipc_node_timeout (net/tipc/node.c:843)
  Allocated by task 9549:
   tipc_link_create (net/tipc/link.c:490)
   tipc_node_check_dest (net/tipc/node.c:1279)
   tipc_disc_rcv (net/tipc/discover.c:252)
   tipc_udp_recv (net/tipc/udp_media.c:389)
  Freed by task 9549:
   tipc_node_link_down (net/tipc/node.c:1084)
   tipc_node_delete_links (net/tipc/node.c:1320)
   bearer_disable (net/tipc/bearer.c:414)
   __tipc_nl_bearer_disable (net/tipc/bearer.c:992)

Move the le->link read inside tipc_node_write_lock(), so it is serialised
against the kfree() in the delete path.  A racing teardown now either has
not run yet, and we see a valid link, or has already run, and we see NULL.

Fixes: 73f646cec354 ("tipc: delay ESTABLISH state event when link is established")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Assisted-by: tencentos-corvus-ai:kimi-k3
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260810102147.48191-1-juny24602@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/node.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1036,18 +1036,23 @@ static void __tipc_node_link_down(struct
 
 static void tipc_node_link_down(struct tipc_node *n, int bearer_id, bool delete)
 {
-	struct tipc_link_entry *le = &n->links[bearer_id];
 	struct tipc_media_addr *maddr = NULL;
-	struct tipc_link *l = le->link;
 	int old_bearer_id = bearer_id;
+	struct tipc_link_entry *le;
 	struct sk_buff_head xmitq;
-
-	if (!l)
-		return;
+	struct tipc_link *l;
 
 	__skb_queue_head_init(&xmitq);
 
+	/* Synchronize the link lookup with bearer teardown. */
 	tipc_node_write_lock(n);
+	le = &n->links[bearer_id];
+	l = le->link;
+	if (!l) {
+		tipc_node_write_unlock_fast(n);
+		return;
+	}
+
 	if (!tipc_link_is_establishing(l)) {
 		__tipc_node_link_down(n, &bearer_id, &xmitq, &maddr);
 	} else {


