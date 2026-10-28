Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215867;
	b=UKUFQ6b1Ndht/+jhhGCwt64xPO+OmfaeA8Vs2JjzeChU5i4ZQTemxz8zIyFcgpWwnDYc
	 yrjqI9aOHPGxynFqJ1Yta1Ht3MjNr07zzZ2S/P3+hXo41EGRLVKeLJkGHkgf54bFUR4zZ
	 OSEJ3ff3mpSBaRT6WwYXNIjb3byA9V7icOHV+TFF5l96HPWCt/gF8lnU3nhUvCWelj3yS
	 bp+kUZyyS9AXZ0GTuLhPrjW9PUvr5DlSfKEWbmnmHlvbaMoGEr/P07AzBpW7uacGVxoxZ
	 IE2yG4PmSTj7gIziY8iGJn4nnAzrJvABSYX3/dnbpRWMd35bBtKDq176vV0yqNvTMvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LZOQLijGouq+WOL6I18PvKnZg8wVjiuBs2qQ6cU/VIE=;
	b=jd928akGgQ/BMsMmjCIHnStNNmr6yE5PVnLLVeHJYRsQltglSNd9X8AoKij7y0GiUHAm
	 gr+RSLbkfwhZmUGUVJR738wBJrD+8vtf84UV0JKTI/JYv6swrEXVEoN7Te/uFDTKSn+NI
	 mle126yKmm8IiEWyG5Cvuf6IlWFWDRR/67eNr9pO8Ekf6CjFjxxmscj9x8j/sHGsDnLOI
	 TrwwLAdXiaOFV6WkHXqZ3SU8mXQDr3LCqU02aKFfB+Vru37e8ZqF0yn0ev7qBMwXFs5yw
	 g5qfOc8Odz78z+k+LdOMGAeITk60phWUP83p8lgE8+6jx7Ez0VTbi68CmnsnpdgPbiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNwwsEm9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DEF606A31E;
	Wed, 28 Oct 2026 19:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNwwsEm9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C868C1F01828;
	Wed, 28 Oct 2026 19:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215867;
	bh=LZOQLijGouq+WOL6I18PvKnZg8wVjiuBs2qQ6cU/VIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNwwsEm9FpH5akUhqYYqFdYPnUM0Gd9pJ769r2kmTq6VO0ZJAnbdrZQbewZmdzroI
	 a0XAwNNi0UW/jnvge0kUnbgKJJk4daCqgpLEZXSnfiC3z2q2MunXs4rdxDC8oy9OHg
	 h3Eqh7Hmv/ZoVOGGMYJfRBye5MAJP2keghGQyHRo=
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
Subject: [PATCH 6.1 1358/1887] tipc: avoid busy looping in tipc_exit_net()
Date: Wed, 28 Oct 2026 17:57:34 +0100
Message-ID: <20261028170530.346302772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dc067731ce2e0..479597a7267ce 100644
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
@@ -831,7 +832,8 @@ static void cleanup_bearer(struct work_struct *work)
 	synchronize_net();
 
 	dst_cache_destroy(&ub->rcast.dst_cache);
-	atomic_dec(&tn->wq_count);
+	if (atomic_dec_and_test(&tn->wq_count))
+		wake_up_var(&tn->wq_count);
 	kfree(ub);
 }
 
-- 
2.53.0



