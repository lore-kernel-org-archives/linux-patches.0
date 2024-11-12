Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2888519E992;
	Tue, 12 Nov 2024 10:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407524; cv=none; b=Ddl+2vtpupe0V3e0vf/1xXBBzZOaAotYnMW5B62OAf93m1WyA1hmDuI4MH/m+EAe5UXzJ6g6j8RAMo1uB/yZl6jmNMfvvG4bkAGCTEvDSrp9bGpMe2l2LrE1A3Mc8CXujsVRPHvOnejJ39/1WHWErXKGej0Y9Xp6fES78ZVTr7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407524; c=relaxed/simple;
	bh=thTQ3sPUSA+9QR6vxYA1SNzCiWMGogBLTnnooD9vU14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cxy0p5G1Dhd6A6EBr+YK0CjrUvJC73QxQ0SD1E8FqldBqk8bCPrS8bfZrqFPnDVJGKjiWPS6g3ilhtMCSCFqm2toDY56/FKjK2xSKqvMGAYdw3jJHz+rWMtqhjHI8/4FZPmR4cHQZtnC3O2oPrZs1iBOMO0V2730lm0yjlSWJKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StHi1IMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StHi1IMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAFCC4CECD;
	Tue, 12 Nov 2024 10:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407523;
	bh=thTQ3sPUSA+9QR6vxYA1SNzCiWMGogBLTnnooD9vU14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StHi1IMrk4J6aZUQd+UchDnHKx5J1F232Zur0JvUcQcQGUNbD3qkU3hx4vGSJG+Fe
	 nndFfBBE5PweyprvF4HjkSTz1w9d/L61RygfTnT5fKtEpzycmG3xU0sZQ2VTbyfx4F
	 lL0PKC1h/FzLF03ZsaKl8Op/c2EvB5warTNOR6ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Abdelkareem Abdelsaamad <kareemem@amazon.com>
Subject: [PATCH 6.1 78/98] net: do not delay dst_entries_add() in dst_release()
Date: Tue, 12 Nov 2024 11:21:33 +0100
Message-ID: <20241112101847.225273849@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit ac888d58869bb99753e7652be19a151df9ecb35d upstream.

dst_entries_add() uses per-cpu data that might be freed at netns
dismantle from ip6_route_net_exit() calling dst_entries_destroy()

Before ip6_route_net_exit() can be called, we release all
the dsts associated with this netns, via calls to dst_release(),
which waits an rcu grace period before calling dst_destroy()

dst_entries_add() use in dst_destroy() is racy, because
dst_entries_destroy() could have been called already.

Decrementing the number of dsts must happen sooner.

Notes:

1) in CONFIG_XFRM case, dst_destroy() can call
   dst_release_immediate(child), this might also cause UAF
   if the child does not have DST_NOCOUNT set.
   IPSEC maintainers might take a look and see how to address this.

2) There is also discussion about removing this count of dst,
   which might happen in future kernels.

Fixes: f88649721268 ("ipv4: fix dst race in sk_dst_get()")
Closes: https://lore.kernel.org/lkml/CANn89iLCCGsP7SFn9HKpvnKu96Td4KD08xf7aGtiYgZnkjaL=w@mail.gmail.com/T/
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20241008143110.1064899-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ resolved conflict due to bc9d3a9f2afc ("net: dst: Switch to rcuref_t
  reference counting") is not in the tree ]
Signed-off-by: Abdelkareem Abdelsaamad <kareemem@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dst.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -108,9 +108,6 @@ struct dst_entry *dst_destroy(struct dst
 		child = xdst->child;
 	}
 #endif
-	if (!(dst->flags & DST_NOCOUNT))
-		dst_entries_add(dst->ops, -1);
-
 	if (dst->ops->destroy)
 		dst->ops->destroy(dst);
 	netdev_put(dst->dev, &dst->dev_tracker);
@@ -160,6 +157,12 @@ void dst_dev_put(struct dst_entry *dst)
 }
 EXPORT_SYMBOL(dst_dev_put);
 
+static void dst_count_dec(struct dst_entry *dst)
+{
+	if (!(dst->flags & DST_NOCOUNT))
+		dst_entries_add(dst->ops, -1);
+}
+
 void dst_release(struct dst_entry *dst)
 {
 	if (dst) {
@@ -169,8 +172,10 @@ void dst_release(struct dst_entry *dst)
 		if (WARN_ONCE(newrefcnt < 0, "dst_release underflow"))
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
-		if (!newrefcnt)
+		if (!newrefcnt){
+			dst_count_dec(dst);
 			call_rcu(&dst->rcu_head, dst_destroy_rcu);
+		}
 	}
 }
 EXPORT_SYMBOL(dst_release);
@@ -184,8 +189,10 @@ void dst_release_immediate(struct dst_en
 		if (WARN_ONCE(newrefcnt < 0, "dst_release_immediate underflow"))
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
-		if (!newrefcnt)
+		if (!newrefcnt){
+			dst_count_dec(dst);
 			dst_destroy(dst);
+		}
 	}
 }
 EXPORT_SYMBOL(dst_release_immediate);


