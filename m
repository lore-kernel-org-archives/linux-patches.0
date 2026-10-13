Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A008B3C3F55;
	Tue, 13 Oct 2026 11:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892050; cv=none; b=axYsFjAz2U46lzuRZJvpOghQ95wVyQPVbmpXHagVQ5v+umT39PHIu1/sghKmskBslfovhQDSi1zfLzF9F0JfPpaaWI0vPF+Z8Q1dQ4IIQwkS7hHZOhxlOwFQ6oXzyegbEm0tkpbgChY0Ak3PFx1lhZ30jeEFXYeEXgqgUdfgzfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892050; c=relaxed/simple;
	bh=CPx37gsjd8Nvm1m3lUHyWrGVRkYw0YGd0XdGbNLK+tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVma86GHQfptr+euVkgI06epgn/SVYzcWt1EiulVH/GtnFo9UnFYSGXdpfm1wkCayLIbJXu9MNaynunGefiPW+EX7zfZGfl8FouAMYKMtPzksZDdaOFVfm5aTvQ+Ed0SlgAi6EAY2qNtHSsDRcrG4YHUj30K0TMandT9tDjv6rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pS1g+rL4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pS1g+rL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFBF1F000FF;
	Tue, 13 Oct 2026 11:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892048;
	bh=T2CFBQsGG0Wckndj8HEVPTyTg/847SJDUGwBWwzMWLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pS1g+rL4UklbjdyBkMAJkyGCnSamgFzckHEZKWvS7o3usXAIcHGNMJI0jlWmbRKnj
	 Pw7Ju6Lhz0DlHSS5KJn5W2ZFKvnKaO6SawQNVLxUIJXAX1xKdmrwny8b2VA9YXvVeZ
	 83z/uAje8hlLezDCAiR8rJTeStfjQx/+HkVMcdo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 044/281] tipc: hold a reference to nodes found by link name
Date: Tue, 13 Oct 2026 13:36:00 +0200
Message-ID: <20261013112856.123136157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2419,8 +2419,11 @@ static struct tipc_node *tipc_node_find_
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
 
@@ -2505,6 +2508,7 @@ out:
 	tipc_node_read_unlock(node);
 	tipc_bearer_xmit(net, bearer_id, &xmitq, &node->links[bearer_id].maddr,
 			 NULL);
+	tipc_node_put(node);
 	return res;
 }
 
@@ -2556,12 +2560,14 @@ int tipc_nl_node_get_link(struct sk_buff
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
@@ -2632,11 +2638,13 @@ int tipc_nl_node_reset_link_stats(struct
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
 


