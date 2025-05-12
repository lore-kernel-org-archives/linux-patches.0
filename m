Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6D8296D37;
	Mon, 12 May 2025 17:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071064; cv=none; b=k3OAtubmY5tpI5QyWz+I2zdgbXfn9soUOe/+T5gTM+V4eoUYqAf2XwN7MjgmdPl3dlSexA6HOxa+qkbe8oUZT81caHIBBfFwDRzXGB3yi8nCGSoWd2HaB5dUwLOKSR830HCmO/pDnm6kcz9L/b+5OiNinlVdYhQmlS/f/viZo2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071064; c=relaxed/simple;
	bh=+HetUBcEfTRv1+LxZtu6Z9tO9oKCG9LWMz9/wfxtLjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMgg9ccaagOzUZ97rR5H+JKdbgDd3dk/dDiEped97Sbajfj+TZAB9jIW455/IR9nqHUiL1Y4+2371hViLZ3DxM3QE1QsIgiD6u8KZeQfMzLiM+e+Vzqn9ygeB/dIPJsRB/X6TDxtxTtb6zIN2HnaP7ldfz5oMHVjoFKx3MXYMck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+jJoX11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+jJoX11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F88C4CEE9;
	Mon, 12 May 2025 17:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071063;
	bh=+HetUBcEfTRv1+LxZtu6Z9tO9oKCG9LWMz9/wfxtLjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+jJoX11mmxuLdmBB99rxsYz1pXisaIGOBqsz83OvQJd6/I+E0suwi513oVxhjNa9
	 w+388NWXDQASXqx78F/XZFvfhrDJ8RMq0ICd3quaRYq/meXi15SCNI4q3O7Ip3j3JH
	 bCF8Z1BNlNl+0+5SpJD7pecDu7VArOAgDePbFSJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/54] can: gw: use call_rcu() instead of costly synchronize_rcu()
Date: Mon, 12 May 2025 19:29:17 +0200
Message-ID: <20250512172015.862204116@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 181d4447905d551cc664f1e7e796b482c1eec992 ]

Commit fb8696ab14ad ("can: gw: synchronize rcu operations
before removing gw job entry") added three synchronize_rcu() calls
to make sure one rcu grace period was observed before freeing
a "struct cgw_job" (which are tiny objects).

This should be converted to call_rcu() to avoid adding delays
in device / network dismantles.

Use the rcu_head that was already in struct cgw_job,
not yet used.

Link: https://lore.kernel.org/all/20220207190706.1499190-1-eric.dumazet@gmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 511e64e13d8c ("can: gw: fix RCU/BH usage in cgw_create_job()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/gw.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/can/gw.c b/net/can/gw.c
index d8861e862f157..20e74fe7d0906 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -577,6 +577,13 @@ static inline void cgw_unregister_filter(struct net *net, struct cgw_job *gwj)
 			  gwj->ccgw.filter.can_mask, can_can_gw_rcv, gwj);
 }
 
+static void cgw_job_free_rcu(struct rcu_head *rcu_head)
+{
+	struct cgw_job *gwj = container_of(rcu_head, struct cgw_job, rcu);
+
+	kmem_cache_free(cgw_cache, gwj);
+}
+
 static int cgw_notifier(struct notifier_block *nb,
 			unsigned long msg, void *ptr)
 {
@@ -596,8 +603,7 @@ static int cgw_notifier(struct notifier_block *nb,
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
 				cgw_unregister_filter(net, gwj);
-				synchronize_rcu();
-				kmem_cache_free(cgw_cache, gwj);
+				call_rcu(&gwj->rcu, cgw_job_free_rcu);
 			}
 		}
 	}
@@ -1155,8 +1161,7 @@ static void cgw_remove_all_jobs(struct net *net)
 	hlist_for_each_entry_safe(gwj, nx, &net->can.cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(net, gwj);
-		synchronize_rcu();
-		kmem_cache_free(cgw_cache, gwj);
+		call_rcu(&gwj->rcu, cgw_job_free_rcu);
 	}
 }
 
@@ -1224,8 +1229,7 @@ static int cgw_remove_job(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(net, gwj);
-		synchronize_rcu();
-		kmem_cache_free(cgw_cache, gwj);
+		call_rcu(&gwj->rcu, cgw_job_free_rcu);
 		err = 0;
 		break;
 	}
-- 
2.39.5



