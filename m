Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B55537DEBE;
	Sat, 17 Oct 2026 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254771; cv=none; b=soD4dHZ58a1BQqmFOoOxt1d6z88dlmjG9yxofN5Yvo6CUm1XWIirfoa62M/nloLczAYG0EAPSK5leF20/tI66BGCVFtDUzNrElq0bEtVJ6wlplXXdn9mEi+hscutJYunMJdwiRseECSskes66cYglsVhJQSSD0D6icA+7Ci8ybM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254771; c=relaxed/simple;
	bh=YvlfDh8n2nzeHvWzwuYZsLE19FcGoiuaVrILTYzhPBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBkkIrW8AB3PMfQgb90USofosLOZ4SweuKby5JWcHe1+7c9U/JN53PwdD4kjyyzG/PK2wOyzemxTv6CEa1bIJyB7lL6yn5atYb3XcJwVMLRfZrJhZlrPD5NoiVClsSnfhzx1OHY5TJ46v0gL1O9Rc1W6XaYqnOo/6vt8UjdosDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeRdpzuj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeRdpzuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F711F000C4;
	Sat, 17 Oct 2026 16:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254770;
	bh=Kj8eUFTL0xF10htvpT27vPv20XHLwgMna+nvXps7qoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeRdpzujMEezX/ZnVCKn+4MrGZ4D+lQH/84eMhB/a94F2d+TxggaW3u0C+OLV/ZUV
	 X41OMwH5JJbU+I7D8HKj+dkoKy98BgWtRtBmQzISmIbsr3X1hUFQimfJX5A+ylwajk
	 zzD7PbqzpnZbjNJgubCPyq/q+QUn8nimgSEkuku8=
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
Subject: [PATCH 6.12 554/869] tipc: avoid busy looping in tipc_exit_net()
Date: Sat, 17 Oct 2026 17:56:35 +0200
Message-ID: <20261017160051.287849464@linuxfoundation.org>
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
index 311ebc6163855..17385de8bfcde 100644
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



