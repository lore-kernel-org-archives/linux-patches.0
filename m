Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211376;
	b=D1boKbrsQ3P5Gc0mW1oXDJT7oAFm4LaAglW20BwZ7iQyALHm6CcdPw4iRFjcWPYnDScK
	 6yCCQNuLzQZvi1uo5PFDZD/qjMvpjsOrhgqeIHQBodBi27xRN+5YqDDLfmdJO9HxENx9A
	 fm+tBO361Iq0oqQy1b5kaNCOsv8QfHUZkGzQW0tMyRJ/ntZVeLH6FF9r29o5dR+aoUBlt
	 B3kPytvhkRrNjjCmnQFOKfW0rNf5Gtc8FZbCHEgpRKZ1gokJLvCh1RSioiedo2oZCHDdE
	 zGL0RWPTk5ImJU67lZDwoRbASd9QITe8FMAsRNwD9YNCAfS3kppOOr2f61jbMHX/cAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tJKe0GIi2wRenpYIg16IMiHrj3vKhzQt4i49u4icBW4=;
	b=E/c9CuBIFspdLe/tefuLRuUs5mReoKCiWqr0opjuLBHWjcWLip617nemzUS8z/iDTAJh
	 fA35p21/T4lQL72InJDa6AHgcP3Tc0avfPrKBgOQndijZ+tgEXRMYLZx0J3EyF3kvb5zh
	 2mrrD7o4alHZAMSR5esBM5I+HE9sf3KeS5nfexYA2wxp8wJfpgACvosowh8dTmkJ1aDAF
	 d4+PWjot5lo+hjDSzbSGiGYN3nQdTzlPv0UNBD68dAiLAlhRZGcyqTXaoGpmklLYMUxnR
	 6GZiorY3zpftEc5xBt7MODipo//JrThyZbMGLwg+QZf8HeLSLU0S+ow1WXtnvoTiNbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X7Td0/GN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD22606A327;
	Wed, 28 Oct 2026 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7Td0/GN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5451F01825;
	Wed, 28 Oct 2026 18:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211376;
	bh=tJKe0GIi2wRenpYIg16IMiHrj3vKhzQt4i49u4icBW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7Td0/GNGhAg+dYjivc/HQ+njpQSVgaw3YlLni4BKyNi8CW+YIOHUBQGOp33eIR8Q
	 4KkOd0lt09Oh0+zaU/I9H/1GYMEq/4dHjw2190s3k6SPP90n5ReRTJTpCyNBSZw9Uo
	 8j9+YOE58dcOxL2WxxFx96KXQRoFtbUvEpgqriQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 355/571] tipc: hold a reference to nodes found by link name
Date: Wed, 28 Oct 2026 17:58:22 +0100
Message-ID: <20261028170016.441093745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 17e73bae400f6a434dc006e3bee92c94cf781954 upstream.

tipc_node_find_by_name() returns a node after dropping its RCU read lock
without taking a reference.  The LINK_SET, LINK_GET and LINK_RESET_STATS
handlers then lock and access the node, racing with timer-driven cleanup of
a down peer.  Generic netlink serialization does not exclude the node
timer.

The following interleaving can leave a handler using a freed node:

  CPU 0: find the node under RCU and release the node read lock
  CPU 1: tipc_node_timeout() clears the links and unlinks the down node
  CPU 1: drop the list and timer references, queuing tipc_node_free()
  CPU 0: leave the RCU read-side critical section
  CPU 1: complete the grace period and free the node
  CPU 0: acquire the node lock through the stale pointer

LINK_SET also uses the node's media address after releasing the node lock,
when passing queued packets to tipc_bearer_xmit().

KASAN on v7.3-rc5 reported:

  BUG: KASAN: slab-use-after-free in _raw_read_lock_bh
  Write of size 4 at addr ffff88807e06f008 by task poc/92
  Call Trace:
   _raw_read_lock_bh                 kernel/locking/spinlock.c:287
   tipc_nl_node_set_link             net/tipc/node.c:2475
   genl_family_rcv_msg_doit          net/netlink/genetlink.c:1114
   genl_rcv_msg                      net/netlink/genetlink.c:1209
   netlink_rcv_skb                   net/netlink/af_netlink.c:2575

  Allocated by task 0:
   tipc_node_create                  net/tipc/node.c:539
   tipc_node_check_dest              net/tipc/node.c:1196
   tipc_disc_rcv                     net/tipc/discover.c:252

  Freed by task 92:
   kfree                             mm/slub.c:6801
   rcu_core                          kernel/rcu/tree.c:2919

  Last potentially related work creation:
   __call_rcu_common.constprop.0     kernel/rcu/tree.c:3181
   tipc_node_timeout                 net/tipc/node.c:814

Acquire a reference to the selected node with kref_get_unless_zero() before
leaving RCU, returning NULL if the node has already been released.  Release
that reference on every caller exit after the last node access, including
transmission in LINK_SET.  Keep the existing link lookup order and locking
so concurrent link removal still takes the existing error paths.

Fixes: 6a939f365bdb ("tipc: Auto removal of peer down node instance")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Link: https://patch.msgid.link/20260928161246.1895273-1-nicoyip.dev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/node.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2421,8 +2421,11 @@ static struct tipc_node *tipc_node_find_
 			}
 		}
 		tipc_node_read_unlock(n);
-		if (found_node)
+		if (found_node) {
+			if (!kref_get_unless_zero(&found_node->kref))
+				found_node = NULL;
 			break;
+		}
 	}
 	rcu_read_unlock();
 
@@ -2507,6 +2510,7 @@ out:
 	tipc_node_read_unlock(node);
 	tipc_bearer_xmit(net, bearer_id, &xmitq, &node->links[bearer_id].maddr,
 			 NULL);
+	tipc_node_put(node);
 	return res;
 }
 
@@ -2558,12 +2562,14 @@ int tipc_nl_node_get_link(struct sk_buff
 		link = node->links[bearer_id].link;
 		if (!link) {
 			tipc_node_read_unlock(node);
+			tipc_node_put(node);
 			err = -EINVAL;
 			goto err_free;
 		}
 
 		err = __tipc_nl_add_link(net, &msg, link, 0);
 		tipc_node_read_unlock(node);
+		tipc_node_put(node);
 		if (err)
 			goto err_free;
 	}
@@ -2634,11 +2640,13 @@ int tipc_nl_node_reset_link_stats(struct
 	if (!link) {
 		spin_unlock_bh(&le->lock);
 		tipc_node_read_unlock(node);
+		tipc_node_put(node);
 		return -EINVAL;
 	}
 	tipc_link_reset_stats(link);
 	spin_unlock_bh(&le->lock);
 	tipc_node_read_unlock(node);
+	tipc_node_put(node);
 	return 0;
 }
 


