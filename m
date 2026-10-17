Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979FC3939B1;
	Sat, 17 Oct 2026 17:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259542; cv=none; b=E9trpV9eSWElgyQFl/LJBb+mldGc/Yb2Zrx7nJ+0rB5jOUG0oVtTDZxwiHkxg4NwUQgAczqB+eKaMM2dn3TTLTm3ZSWSqQJ9jS6rkpVcIVlbHk/VClbrMgGh4zMfB94rUqzU1nLgjs6t1dXKan0MtTIUQERanhL+MKsaagB7T4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259542; c=relaxed/simple;
	bh=Z+ZzDsv6lKz6HU8t7QeU26A6j9FFbZq9uLJ674w+2Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGJoGRA3P4rEbTLBRvpnatOtgg+4BKcaczanjVRAeQaLu5wBx9r9ooH8vIeVeW0tN9kAnrcU1f/NPQjID4UY/PWxV9ZJ6H89RfAHvO8Zd8N+hG2qkwQfJHzUIfT69vpWHDuZ0Nps1vuuwuBKMxOKCMUiRHmK6hXFua5EaWkP2qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlVUoTNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlVUoTNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11621F000C4;
	Sat, 17 Oct 2026 17:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259539;
	bh=SginIlNxddKr7Dpe2oAmAMBkBO394Xk7+EQiU0DzsLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlVUoTNCx5P+Rvp+2FFeJ2MTDqLAXsNBWjxwDQ95UPSYnRiY2j5DnF/sJ2lqbe0lY
	 QABNuLIRLG9aWNZ1dJqcxzqKZ19qTueHQWlW3U8qNiMnyYPCNFu/O4PRsEIxwdyPi6
	 ITTLbQfL8IJTlbqx32TnO58q5quLhHHH7theLBXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jon Maloy <jmaloy@redhat.com>,
	tipc-discussion@lists.sourceforge.net,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1249/1674] tipc: avoid busy looping in tipc_exit_net()
Date: Sat, 17 Oct 2026 17:58:41 +0200
Message-ID: <20261017160503.196974251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c1481c94e74c955e0448ddf46b8615a44d840c1e ]

Blamed commit introduced a busy-wait loop in tipc_exit_net()
to wait for pending UDP bearer cleanup works to complete:

       while (atomic_read(&tn->wq_count))
               cond_resched();

This loop can busy-wait for a long time if cond_resched() is a NOP. This
typically happens if the netns exit is executed by a high priority task,
or under kernels configured without preemption (CONFIG_PREEMPT_NONE). In
such cases, it wastes CPU cycles and can lead to soft lockups.

Fix this by replacing the busy loop with wait_var_event(), allowing the
thread to sleep properly until the work queue count reaches zero.

Accordingly, update cleanup_bearer() to use atomic_dec_and_test() and
wake_up_var() to wake up the waiter when the count drops to zero.

This uses the global wait queue hash table, avoiding the need to bloat
struct tipc_net with a wait_queue_head_t. The atomic_dec_and_test()
provides the necessary memory barrier to ensure the wakeup is not missed.

Fixes: 04c26faa51d1 ("tipc: wait and exit until all work queues are done")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: tipc-discussion@lists.sourceforge.net
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260623173030.2925059-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/core.c      | 4 ++--
 net/tipc/udp_media.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 1ddecea1df6e9..315975c3be818 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -45,6 +45,7 @@
 #include "crypto.h"
 
 #include <linux/module.h>
+#include <linux/wait_bit.h>
 
 /* configurable TIPC parameters */
 unsigned int tipc_net_id __read_mostly;
@@ -118,8 +119,7 @@ static void __net_exit tipc_exit_net(struct net *net)
 #ifdef CONFIG_TIPC_CRYPTO
 	tipc_crypto_stop(&tipc_net(net)->crypto_tx);
 #endif
-	while (atomic_read(&tn->wq_count))
-		cond_resched();
+	wait_var_event(&tn->wq_count, atomic_read(&tn->wq_count) == 0);
 }
 
 static void __net_exit tipc_pernet_pre_exit(struct net *net)
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index bdcc2e2648539..8af3349e154d4 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -40,6 +40,7 @@
 #include <linux/igmp.h>
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
+#include <linux/wait_bit.h>
 #include <linux/list.h>
 #include <net/sock.h>
 #include <net/ip.h>
@@ -827,7 +828,8 @@ static void cleanup_bearer(struct work_struct *work)
 	synchronize_net();
 
 	dst_cache_destroy(&ub->rcast.dst_cache);
-	atomic_dec(&tn->wq_count);
+	if (atomic_dec_and_test(&tn->wq_count))
+		wake_up_var(&tn->wq_count);
 	kfree(ub);
 }
 
-- 
2.53.0



