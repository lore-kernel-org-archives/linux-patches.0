Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0570E4399F8;
	Mon, 17 Aug 2026 14:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978274; cv=none; b=tgXVTK3t0LRNRG+9EYc6Ny1iHu1GXuTFVySq46GujCKO6DSvRxk0fQf5nK/AfZvC2VeTEary7KhGgF+Z+00dT7DurvcFhOf8ivt1z8PLABUZ8K/KMRZ0sLmOOtbFHmk1Yy8EBObIg4KREI26FljL4WRAsUPGnnN4kJ9KY0oDcS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978274; c=relaxed/simple;
	bh=uwovhu0b/sA/NSFhnKOVGJsmrd5uYCgm8syWV+3cM3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOkZB3qg20tGNBsuj3J6vSMcO1TRAuQy67nc2QYX058xVXNWXAe6bzeOAvajf4QamN1+y0fp0l5aacM64lXykTnmfE1bfvD1wWMSekJuqW8EHjNP/TznNXbNaA4laBaRxgOzpxFLHc9Ejkv2IsVb0NT4mqKwGV+SZb4g9nOPjLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiPMBQVY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiPMBQVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3751F00A3A;
	Mon, 17 Aug 2026 14:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978272;
	bh=1MhU8YqO+xTiyI6MbLbFrbs9cJ5jEZetRxA6wJ25CNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiPMBQVY/4Q54BbiHhR+5NZeIo4TJKWw0a5KyWZtmndiHWHdeJeHUoH309qQZnAao
	 mCUz5XV3KB/2W5lllrMfPHESJHVAiDtnc8fTueaBKKNO2QAQsl+70yQzonX/liuH9G
	 T0KIk2kEj5hln6C68A0SKhsJ19s80p/bJT5bynxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 159/181] tipc: read le->link under the node lock in tipc_node_link_down()
Date: Mon, 17 Aug 2026 15:34:13 +0200
Message-ID: <20260817132541.937194434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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
@@ -1061,18 +1061,23 @@ static void __tipc_node_link_down(struct
 
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


