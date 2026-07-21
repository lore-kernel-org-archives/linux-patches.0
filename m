Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23195438FEE;
	Tue, 21 Jul 2026 20:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666991; cv=none; b=BKsq8VxtnXqwuHHc1Jfqwwbz8QV8n4vrYT5BhDRnbD6MISB+9efUgGtJ4rD+/kOieu46875ijx/GjP4SMiLgR6HZI3cw0YE5INeQPDXKZAt70O1uirMCJT40kCFDn0O0j+lzZpFEZ9sk71kwlCODoBGBPRbVq6aStH6BUW2eepw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666991; c=relaxed/simple;
	bh=87W5635drAYvlSu6idzfN/6ZTVz5oE6QPN6XpGn/7KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgLuCIIqfFYLQ5+KeMXH080Fj9nR9171/So2v6LRWTdTJKTYjy4vqgMIYiFkF/4/O4PGmjM1FUDtQTv2fS8hBIa+t4VEo/TgJXXEUgTSXImvTpU+bk0iDhi+PWzvxoHCvlFErNeANit13kW8TjNiQCskG2kThAPpKCDtu2bv9yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rk9J7zZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rk9J7zZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43621F000E9;
	Tue, 21 Jul 2026 20:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666988;
	bh=712fqERhXApFuf+HMV3TD8q4yOlaD7td5zylN5dZnC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rk9J7zZnN8nhFKgAjfSE0TRA0eN0wCfk0IkfmT89JlCOTamk8mQ9dSoP4uCCBt2GR
	 rjjNY+/pzjtRPD8mP0zHteyNbJLFri5bG66f1E6FABl1pYhH7FrikGkfFWXdOzn+C7
	 c/6A0VNchC3SlZTgdGctR/eTVHBAzQ6FboCaBnq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0874/1266] ipv6: mcast: Fix potential UAF in MLD delayed work
Date: Tue, 21 Jul 2026 17:21:51 +0200
Message-ID: <20260721152501.407269298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index e596f57f680dc1..0a9b055a8ee114 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -411,6 +411,11 @@ static inline void in6_dev_hold(struct inet6_dev *idev)
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
index ddc2453a14b365..dacd9e32e96eff 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1060,8 +1060,10 @@ static void mld_gq_start_work(struct inet6_dev *idev)
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
@@ -1079,8 +1081,10 @@ static void mld_ifc_start_work(struct inet6_dev *idev, unsigned long delay)
 
 	mc_assert_locked(idev);
 
-	if (!mod_delayed_work(mld_wq, &idev->mc_ifc_work, tv + 2))
-		in6_dev_hold(idev);
+	if (in6_dev_hold_safe(idev)) {
+		if (mod_delayed_work(mld_wq, &idev->mc_ifc_work, tv + 2))
+			in6_dev_put(idev);
+	}
 }
 
 static void mld_ifc_stop_work(struct inet6_dev *idev)
@@ -1098,8 +1102,10 @@ static void mld_dad_start_work(struct inet6_dev *idev, unsigned long delay)
 
 	mc_assert_locked(idev);
 
-	if (!mod_delayed_work(mld_wq, &idev->mc_dad_work, tv + 2))
-		in6_dev_hold(idev);
+	if (in6_dev_hold_safe(idev)) {
+		if (mod_delayed_work(mld_wq, &idev->mc_dad_work, tv + 2))
+			in6_dev_put(idev);
+	}
 }
 
 static void mld_dad_stop_work(struct inet6_dev *idev)
@@ -1385,18 +1391,23 @@ static void mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
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
@@ -1553,18 +1564,23 @@ static void mld_query_work(struct work_struct *work)
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



