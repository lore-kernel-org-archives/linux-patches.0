Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105853911DC;
	Mon, 17 Aug 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977723; cv=none; b=QCNQOKQwvonVYUnczjDFxd8SnJ2BMn5BjErSthL7IBKA2w4jQuNxImNcp80z+l+CtzPDiVQKmZRWY0qGhpgevGbaLSRIhZTmtpGm59zWv90IyM1LCn0GUuujTD+bKgxoWOxOhtd9CRpIk34CsDdvAvRnuh9fQQplMMxz93hG55c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977723; c=relaxed/simple;
	bh=xq4qxsDL6/bSqNwHezwDTuYK2T/9MSEbRH//eRWvtto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAYJTpmRkxikzcGGDB//pAYBOOE4uwTAbIc5CIdr0/VDL9h/b55YGpJm+GmZ2bhCOOrCwXRvh/GzTEPoVGuA5D1i1VugYATNbQb/64dVSWkp0O5VlM6xuE+/nYEBL1jjk5lvYL1iUnIAGMmn3HeJwE1R301qMnWC6XPzZaRXzDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Brbj4eyI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Brbj4eyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E741F000E9;
	Mon, 17 Aug 2026 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977722;
	bh=iGff3zOqaG2buLw1l0gMyn22ezQxx5Qrpn6Y8KrGMQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Brbj4eyIjQgpOn9t4644W4wga1o+ZJWv9HadFlwGwkzdQAEI04/7vVIMPOejGjdQE
	 7KIwVH4+HGEad+3E8aRP0sci1NhaOXMkFCU19zBimxB+ssAi2iIGxquavtjgK/l+xV
	 CR2zDijHRzTVhBXwtWtdBjrQTvGYmoGWgqxY6Pug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 426/456] ipv4: fix use-after-free in fib_nhc_update_mtu()
Date: Mon, 17 Aug 2026 15:33:36 +0200
Message-ID: <20260817132555.834654241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit bc5bde9ce3cc36502839dfe98e068f7303a50982 upstream.

fib_nhc_update_mtu() walks the nexthop exception table under RTNL, but
RTNL does not serialize this walk with PMTU exception updates. The walk
uses rcu_dereference_protected() with a constant true condition without
holding fnhe_lock.

The following interleaving can therefore occur:

  CPU 0                              CPU 1
  fib_nhc_update_mtu()               update_or_create_fnhe()
    load fnhe                          spin_lock_bh(&fnhe_lock)
                                       fnhe_remove_oldest()
                                         unlink fnhe
                                         kfree_rcu(fnhe, rcu)
    <quiescent state>
    access fnhe after grace period

KASAN reported:

  BUG: KASAN: slab-use-after-free in fib_nhc_update_mtu+0x3df/0x410
  Read of size 8 at addr ffff888107d49000 by task poc/90
  Call Trace:
   fib_nhc_update_mtu+0x3df/0x410
   fib_sync_mtu+0x7a/0xd0
   fib_netdev_event+0x229/0x3f0
   netif_set_mtu_ext+0x33a/0x570
   dev_set_mtu+0x88/0x120

The same walk updates fnhe_pmtu and fnhe_mtu_locked. These fields form a
pair and other writers serialize them with fnhe_lock. RCU alone prevents
reclamation, but would still allow concurrent writers to leave a mixed
pair.

Walk the table under RCU and acquire fnhe_lock only while updating each
exception. RCU keeps the current entry alive while the short critical
section serializes its paired PMTU fields. This avoids holding the global
lock while scanning all 2048 buckets for every nexthop.

Fixes: af7d6cce5369 ("net: ipv4: update fnhe_pmtu when first hop's MTU changes")
Cc: stable@vger.kernel.org
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260807181710.1178747-1-nicoyip.dev@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/route.h      |    2 ++
 net/ipv4/fib_semantics.c |   34 +++++++++++-----------------------
 net/ipv4/route.c         |   29 +++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 23 deletions(-)

--- a/include/net/route.h
+++ b/include/net/route.h
@@ -240,6 +240,8 @@ int fib_dump_info_fnhe(struct sk_buff *s
 		       u32 table_id, struct fib_info *fi,
 		       int *fa_index, int fa_start, unsigned int flags);
 
+void fnhe_update_pmtu(struct fib_nh_exception *fnhe, u32 new, u32 orig);
+
 static inline void ip_rt_put(struct rtable *rt)
 {
 	/* dst_release() accepts a NULL parameter.
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1975,42 +1975,30 @@ static int call_fib_nh_notifiers(struct
 	return NOTIFY_DONE;
 }
 
-/* Update the PMTU of exceptions when:
- * - the new MTU of the first hop becomes smaller than the PMTU
- * - the old MTU was the same as the PMTU, and it limited discovery of
- *   larger MTUs on the path. With that limit raised, we can now
- *   discover larger MTUs
- * A special case is locked exceptions, for which the PMTU is smaller
- * than the minimal accepted PMTU:
- * - if the new MTU is greater than the PMTU, don't make any change
- * - otherwise, unlock and set PMTU
+/* Walk the exceptions of a nexthop after its first hop MTU changed. The
+ * chain is RCU protected here, while fnhe_update_pmtu() takes fnhe_lock
+ * for the update of each entry.
  */
 void fib_nhc_update_mtu(struct fib_nh_common *nhc, u32 new, u32 orig)
 {
 	struct fnhe_hash_bucket *bucket;
 	int i;
 
-	bucket = rcu_dereference_protected(nhc->nhc_exceptions, 1);
+	rcu_read_lock();
+	bucket = rcu_dereference(nhc->nhc_exceptions);
 	if (!bucket)
-		return;
+		goto out;
 
 	for (i = 0; i < FNHE_HASH_SIZE; i++) {
 		struct fib_nh_exception *fnhe;
 
-		for (fnhe = rcu_dereference_protected(bucket[i].chain, 1);
+		for (fnhe = rcu_dereference(bucket[i].chain);
 		     fnhe;
-		     fnhe = rcu_dereference_protected(fnhe->fnhe_next, 1)) {
-			if (fnhe->fnhe_mtu_locked) {
-				if (new <= fnhe->fnhe_pmtu) {
-					fnhe->fnhe_pmtu = new;
-					fnhe->fnhe_mtu_locked = false;
-				}
-			} else if (new < fnhe->fnhe_pmtu ||
-				   orig == fnhe->fnhe_pmtu) {
-				fnhe->fnhe_pmtu = new;
-			}
-		}
+		     fnhe = rcu_dereference(fnhe->fnhe_next))
+			fnhe_update_pmtu(fnhe, new, orig);
 	}
+out:
+	rcu_read_unlock();
 }
 
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -758,6 +758,35 @@ out_unlock:
 	spin_unlock_bh(&fnhe_lock);
 }
 
+/* Update the PMTU of an exception when:
+ * - the new MTU of the first hop becomes smaller than the PMTU
+ * - the old MTU was the same as the PMTU, and it limited discovery of
+ *   larger MTUs on the path. With that limit raised, we can now
+ *   discover larger MTUs
+ * A special case is locked exceptions, for which the PMTU is smaller
+ * than the minimal accepted PMTU:
+ * - if the new MTU is greater than the PMTU, don't make any change
+ * - otherwise, unlock and set PMTU
+ *
+ * fnhe_lock keeps fnhe_pmtu and fnhe_mtu_locked consistent against
+ * update_or_create_fnhe(), which sets both under the same lock.
+ */
+void fnhe_update_pmtu(struct fib_nh_exception *fnhe, u32 new, u32 orig)
+{
+	spin_lock_bh(&fnhe_lock);
+
+	if (fnhe->fnhe_mtu_locked) {
+		if (new <= fnhe->fnhe_pmtu) {
+			fnhe->fnhe_pmtu = new;
+			fnhe->fnhe_mtu_locked = false;
+		}
+	} else if (new < fnhe->fnhe_pmtu || orig == fnhe->fnhe_pmtu) {
+		fnhe->fnhe_pmtu = new;
+	}
+
+	spin_unlock_bh(&fnhe_lock);
+}
+
 static void __ip_do_redirect(struct rtable *rt, struct sk_buff *skb, struct flowi4 *fl4,
 			     bool kill_route)
 {


