Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B4A223708;
	Tue, 21 Jul 2026 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653860; cv=none; b=JFh1w6sD8OscKN+UBBmIoQUQdBh10rJ5WNfnBNMBw4rIyXfI4tM0uHxl5D+tVuaCtp2xcS78fYEjLEqNYIAmfV3nasjNcey2dX5A9vA4/HV9MRaaz/E5S1++ypkYKND7aJFkCCNU40YCKW/i6klFnD4ef1dYxrdlL6xtMPgNpHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653860; c=relaxed/simple;
	bh=409mL9xy9UcvgBZTS5psNTQrimbLkg7lWofmr8S4DUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bc/onnMpuDy5dyPZLU445fiO+92nrsY31Ge/13O0dXvboZ3NZOXvYH/BYF+KVOtjiirP7aciVArFdlRwCRHimfyNnZj17kHiQAsh6BhLt60K3E49wRiWp02Rbyl6vcQipN6URg3/3w311WWDxveig31Mjv5jMT/WP6T+JTtuwjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tK5lWqrF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tK5lWqrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1AC1F00ACA;
	Tue, 21 Jul 2026 17:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653859;
	bh=NuNLkCeyUA3pjHJR1D5GTnTpWxuaiBiU+zDAnhnrikY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tK5lWqrF/Z5RiKGKSkrOKTExSiL05VDwM5p+Vz9tPn98r+kr4uuH4ni8Pu67GPdVT
	 W5RBbrfkT+nQaOs+srR9ju/DCcbDVapRfEQ3aQaQgdlv136Rf25mWSaT5cp9WsjpEj
	 7SmasmelbAFF7j1sSUUeyKT7LgGavrcMErKRAsyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1487/2077] ipv6: mcast: Fix potential UAF in MLD delayed work
Date: Tue, 21 Jul 2026 17:19:20 +0200
Message-ID: <20260721152627.870706417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9b26518b6896a16b809b1e42986f4ebac7bccc1e ]

A race condition exists between device teardown and incoming MLD query
processing, leading to a Use-After-Free in the MLD delayed work.

During device destruction, the primary reference to inet6_dev is dropped,
which can drop its refcount to 0. The actual freeing of inet6_dev memory
is deferred via RCU.

Concurrently, the packet receive path runs under RCU read lock and obtains
the inet6_dev pointer. Because the memory is RCU-protected, CPU-0 can
safely dereference inet6_dev even if its refcount has hit 0.

However, if CPU-0 calls igmp6_event_query() and schedules delayed work, it
attempts to acquire a reference using in6_dev_hold(). This increments the
refcount from 0 to 1, triggering a "refcount_t: addition on 0" warning.
Since the inet6_dev memory is still scheduled to be freed after the RCU
grace period, the device is freed while the work is still scheduled.
When the work runs, it accesses the freed memory, causing a kernel panic.

Fix this by using refcount_inc_not_zero() (via a new helper
in6_dev_hold_safe()) to prevent acquiring a reference if the device is
already being destroyed. If the refcount is 0, we do not schedule the work.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260705181756.963063-3-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/addrconf.h |  5 +++++
 net/ipv6/mcast.c       | 40 ++++++++++++++++++++++++++++------------
 2 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 539bbbe54b14e8..8ced27a8229b6e 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -446,6 +446,11 @@ static inline void in6_dev_hold(struct inet6_dev *idev)
 	refcount_inc(&idev->refcnt);
 }
 
+static inline bool in6_dev_hold_safe(struct inet6_dev *idev)
+{
+	return refcount_inc_not_zero(&idev->refcnt);
+}
+
 /* called with rcu_read_lock held */
 static inline bool ip6_ignore_linkdown(const struct net_device *dev)
 {
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index d9b855d5191bf6..2a5e76a38002ad 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1080,8 +1080,10 @@ static void mld_gq_start_work(struct inet6_dev *idev)
 	mc_assert_locked(idev);
 
 	idev->mc_gq_running = 1;
-	if (!mod_delayed_work(mld_wq, &idev->mc_gq_work, tv + 2))
-		in6_dev_hold(idev);
+	if (in6_dev_hold_safe(idev)) {
+		if (mod_delayed_work(mld_wq, &idev->mc_gq_work, tv + 2))
+			in6_dev_put(idev);
+	}
 }
 
 static void mld_gq_stop_work(struct inet6_dev *idev)
@@ -1099,8 +1101,10 @@ static void mld_ifc_start_work(struct inet6_dev *idev, unsigned long delay)
 
 	mc_assert_locked(idev);
 
-	if (!mod_delayed_work(mld_wq, &idev->mc_ifc_work, tv + 2))
-		in6_dev_hold(idev);
+	if (in6_dev_hold_safe(idev)) {
+		if (mod_delayed_work(mld_wq, &idev->mc_ifc_work, tv + 2))
+			in6_dev_put(idev);
+	}
 }
 
 static void mld_ifc_stop_work(struct inet6_dev *idev)
@@ -1118,8 +1122,10 @@ static void mld_dad_start_work(struct inet6_dev *idev, unsigned long delay)
 
 	mc_assert_locked(idev);
 
-	if (!mod_delayed_work(mld_wq, &idev->mc_dad_work, tv + 2))
-		in6_dev_hold(idev);
+	if (in6_dev_hold_safe(idev)) {
+		if (mod_delayed_work(mld_wq, &idev->mc_dad_work, tv + 2))
+			in6_dev_put(idev);
+	}
 }
 
 static void mld_dad_stop_work(struct inet6_dev *idev)
@@ -1405,18 +1411,23 @@ static void mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
 void igmp6_event_query(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
+	bool put = false;
 
 	if (!idev || idev->dead)
 		goto out;
 
 	spin_lock_bh(&idev->mc_query_lock);
-	if (skb_queue_len(&idev->mc_query_queue) < MLD_MAX_SKBS) {
+	if (skb_queue_len(&idev->mc_query_queue) < MLD_MAX_SKBS &&
+	    in6_dev_hold_safe(idev)) {
 		__skb_queue_tail(&idev->mc_query_queue, skb);
-		if (!mod_delayed_work(mld_wq, &idev->mc_query_work, 0))
-			in6_dev_hold(idev);
+		if (mod_delayed_work(mld_wq, &idev->mc_query_work, 0))
+			put = true;
 		skb = NULL;
 	}
 	spin_unlock_bh(&idev->mc_query_lock);
+
+	if (put)
+		in6_dev_put(idev);
 out:
 	kfree_skb(skb);
 }
@@ -1573,18 +1584,23 @@ static void mld_query_work(struct work_struct *work)
 void igmp6_event_report(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
+	bool put = false;
 
 	if (!idev || idev->dead)
 		goto out;
 
 	spin_lock_bh(&idev->mc_report_lock);
-	if (skb_queue_len(&idev->mc_report_queue) < MLD_MAX_SKBS) {
+	if (skb_queue_len(&idev->mc_report_queue) < MLD_MAX_SKBS &&
+	    in6_dev_hold_safe(idev)) {
 		__skb_queue_tail(&idev->mc_report_queue, skb);
-		if (!mod_delayed_work(mld_wq, &idev->mc_report_work, 0))
-			in6_dev_hold(idev);
+		if (mod_delayed_work(mld_wq, &idev->mc_report_work, 0))
+			put = true;
 		skb = NULL;
 	}
 	spin_unlock_bh(&idev->mc_report_lock);
+
+	if (put)
+		in6_dev_put(idev);
 out:
 	kfree_skb(skb);
 }
-- 
2.53.0



