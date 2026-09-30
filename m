Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72903B71B6;
	Wed, 30 Sep 2026 18:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792003; cv=none; b=tkW2l0H9IQddLb14gFp757lC/1cZkY/FGkqc0Ou0wnFHzy+dDNIw9/YOpWrLjFX3De08sK3vRJ8u7YcecNpC88Afs1XC9BzQQFgkTwbxYIn8qGB+n7HMigzdo2ryh5ww0dpR9kZO4A7A+zlhvAXUa5cZ7GBs0wMhE8RRZZX3Cv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792003; c=relaxed/simple;
	bh=ujvlDiRx7u1B+iHf2caNqXtuIgMcB7B+K5w+QHetpvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwV+RAyrF1xuL1/PldhgXSLfhmmzyZc5C9ah7wvUSGueHotM/0en3M6SN3w6rRgEA3PFO/4f96oRSCabZAY6EKO555qSSZBJt7Ta4xJylLaiDBdshWN+E05DKLQs2ShrSIpUmJCZvYxhu9j4syQQD1gen9ajt1bRazNwNo9EYAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2XkAhjv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2XkAhjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BC51F000FF;
	Wed, 30 Sep 2026 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792001;
	bh=IJiryDKPAZnZQZWLx+RefIr6YM6sZsNnSc9PYbZ8vNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q2XkAhjvFx4cuvaj27G2jwXqmlsAecP4lrydv1f9LUZfO5XH8xh9baRSBmgcPlC/0
	 momNuqirDFVf9pVO1B0NkXdk8aExVD8mjTKGvksSDI3qiKDL5p/mnYhPvv5a2eCeiR
	 ZPzUo4T8wNsheOKmDUPCFK/tYwF3qKTz4RQiiiJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Davies <ben.davies@gresearch.co.uk>,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 464/752] IB/IPoIB: Avoid restoring OPER_UP after multicast flush
Date: Wed, 30 Sep 2026 17:25:34 +0200
Message-ID: <20260930152408.316689637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 9a141d3dc869d18b2eab35e999f4790a9b84e40f ]

ipoib_ib_dev_flush_light() temporarily clears IPOIB_FLAG_OPER_UP to
prevent multicast joins while ipoib_mcast_dev_flush() is running, and
restores the flag afterwards if it was previously set.

This restore races with ipoib_ib_dev_down(). If the interface is brought
down while the flush is in progress, ipoib_ib_dev_down() clears
IPOIB_FLAG_OPER_UP, but the flush path may set it again after the device
has already gone down.

Since commit 894021a75291 ("IB/ipoib: Make the carrier_on_task race
aware"), ipoib_mcast_carrier_on_task() relies on IPOIB_FLAG_OPER_UP
being cleared to terminate its rtnl_trylock() retry loop. If the flag is
left set after shutdown, the workqueue retries forever, causing teardown
to deadlock when ipoib_ndo_uninit() waits in destroy_workqueue() while
holding RTNL.

Instead of overloading IPOIB_FLAG_OPER_UP to block multicast joins
during a light flush, introduce a dedicated IPOIB_FLAG_MCAST_FLUSH flag.
Use it together with IPOIB_FLAG_OPER_UP to determine whether multicast
joins are allowed, avoiding the race with device shutdown.

Fixes: 344bacca8cd8 ("IB/ipoib: Don't allow MC joins during light MC flush")
Reported-by: Ben Davies <ben.davies@gresearch.co.uk>
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260902-avoid-rest-oper-up-v1-1-04fcd4916cae@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  7 +++++++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 12 +++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 16 ++++++++--------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 44d8d151ff904..e3d03b227ae09 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -87,6 +87,7 @@ enum {
 	IPOIB_FLAG_INITIALIZED	  = 1,
 	IPOIB_FLAG_ADMIN_UP	  = 2,
 	IPOIB_PKEY_ASSIGNED	  = 3,
+	IPOIB_FLAG_MCAST_FLUSH	  = 4,
 	IPOIB_FLAG_SUBINTERFACE	  = 5,
 	IPOIB_STOP_REAPER	  = 7,
 	IPOIB_FLAG_ADMIN_CM	  = 9,
@@ -416,6 +417,12 @@ struct ipoib_dev_priv {
 	const struct net_device_ops	*rn_ops;
 };
 
+static inline bool ipoib_mcast_allowed(struct ipoib_dev_priv *priv)
+{
+	return test_bit(IPOIB_FLAG_OPER_UP, &priv->flags) &&
+	       !test_bit(IPOIB_FLAG_MCAST_FLUSH, &priv->flags);
+}
+
 struct ipoib_ah {
 	struct net_device *dev;
 	struct ib_ah	  *ah;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index ceabfb0b0a83c..78cfb5e638bf9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -1212,17 +1212,19 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	}
 
 	if (level == IPOIB_FLUSH_LIGHT) {
-		int oper_up;
 		ipoib_mark_paths_invalid(dev);
-		/* Set IPoIB operation as down to prevent races between:
+		/* Set MCAST_FLUSH to prevent races between:
 		 * the flush flow which leaves MCG and on the fly joins
 		 * which can happen during that time. mcast restart task
 		 * should deal with join requests we missed.
+		 *
+		 * Do not clear OPER_UP for this; restoring it races with
+		 * ipoib_ib_dev_down() and can leave OPER_UP set after the
+		 * device is down.
 		 */
-		oper_up = test_and_clear_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
+		set_bit(IPOIB_FLAG_MCAST_FLUSH, &priv->flags);
 		ipoib_mcast_dev_flush(dev);
-		if (oper_up)
-			set_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
+		clear_bit(IPOIB_FLAG_MCAST_FLUSH, &priv->flags);
 		ipoib_reap_dead_ahs(priv);
 	}
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 319d4288eddde..9c00426227ed5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -74,7 +74,7 @@ static void __ipoib_mcast_schedule_join_thread(struct ipoib_dev_priv *priv,
 					       struct ipoib_mcast *mcast,
 					       bool delay)
 {
-	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+	if (!ipoib_mcast_allowed(priv))
 		return;
 
 	/*
@@ -470,7 +470,7 @@ static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 	int ret = 0;
 
 	if (!priv->broadcast ||
-	    !test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+	    !ipoib_mcast_allowed(priv))
 		return -EINVAL;
 
 	init_completion(&mcast->done);
@@ -556,7 +556,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	unsigned long delay_until = 0;
 	struct ipoib_mcast *mcast = NULL;
 
-	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+	if (!ipoib_mcast_allowed(priv))
 		return;
 
 	if (ib_query_port(priv->ca, priv->port, &port_attr)) {
@@ -578,7 +578,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	netif_addr_unlock_bh(dev);
 
 	spin_lock_irq(&priv->lock);
-	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+	if (!ipoib_mcast_allowed(priv))
 		goto out;
 
 	if (!priv->broadcast) {
@@ -750,7 +750,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)		||
+	if (!ipoib_mcast_allowed(priv)				||
 	    !priv->broadcast					||
 	    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &priv->broadcast->flags)) {
 		++dev->stats.tx_dropped;
@@ -872,7 +872,7 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 	LIST_HEAD(remove_list);
 	struct ib_sa_mcmember_rec rec;
 
-	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+	if (!ipoib_mcast_allowed(priv))
 		/*
 		 * shortcut...on shutdown flush is called next, just
 		 * let it do all the work
@@ -966,9 +966,9 @@ void ipoib_mcast_restart_task(struct work_struct *work)
 	ipoib_mcast_remove_list(&remove_list);
 
 	/*
-	 * Double check that we are still up
+	 * Double check that we are still up and not flushing
 	 */
-	if (test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)) {
+	if (ipoib_mcast_allowed(priv)) {
 		spin_lock_irq(&priv->lock);
 		__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
 		spin_unlock_irq(&priv->lock);
-- 
2.53.0



