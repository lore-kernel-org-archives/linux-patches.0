Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914E5446070;
	Thu, 30 Jul 2026 16:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428017; cv=none; b=qTSLLSIgikx/WpYUOJIyBE+1kEPnXu4Uc09ny3PWUyb8mTT63a8SmEWizaJvaPu6sxOuduHxxLOS/Z9MjgKRHWPiwes3Rhx2clt7nKgTeQ+g+veXrEqb+vh6SiXveojBoefIO5ccvSUAs4rWdyQriERbq73Zsu8vo4yT0s4kxzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428017; c=relaxed/simple;
	bh=KM2hmP2ATcHUsAx/KtUv5cSxasq//SCmHMNvKh70iX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCSkyXEMFmXlRnD8nUaEqlUuJGO0jPv+FwZlavdAxbA1BDyvqx4cPPk5UcC1pucMEBAikJuaHd4mcLit+rOULIj8paKSQqKb1rNpUegs5bK88x+yl0X5pvYgqXeHtQRutYZyr1DoLemqO7BMj1Phh1UtIdewHEGvKUUhC20Pm4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fh7+F2he; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fh7+F2he"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2A41F000E9;
	Thu, 30 Jul 2026 16:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428016;
	bh=+37RkWGZRiMXp2tguI6P9mfUvcgJu2yvcVbIsXcvDus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fh7+F2heDZ/SWgd7bf+zMwVOguiCg918uHopToBTDUmZhGyfx/AZMLIGwUqGXzZyM
	 b/st5TGgE3MW/AOn7JHui7vQa98pHj40Myr4YfY8OPOj7ox0EzKHhkgsz1wC+Ia5pG
	 qajjAc/UC8QFBRU5NxSmpItGfCykOLVmtctL+Pyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 330/484] mac802154: hold an interface reference across the scan worker
Date: Thu, 30 Jul 2026 16:13:47 +0200
Message-ID: <20260730141430.655621208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Ibrahim Hashimov <security@auditcode.ai>

commit 234e5e898b713bc0b3a631b6f002897f43d046c8 upstream.

mac802154_scan_worker() captures the scanning sub-interface under RCU
and then keeps dereferencing sdata->dev after rcu_read_unlock() and
outside the rtnl -- in the failure traces, in
mac802154_transmit_beacon_req() (skb->dev = sdata->dev), and in the
end_scan cleanup. Nothing keeps that netdev alive across the worker
iteration.

A concurrent DEL_INTERFACE or PHY removal can unregister the interface
once the worker drops the rtnl between its two drv_set_channel()
sections. unregister_netdevice() frees the netdev asynchronously from
netdev_run_todo() with the rtnl already dropped, so neither holding the
rtnl nor the per-PHY IEEE802154_IS_SCANNING flag prevents a stale worker
iteration from dereferencing the freed netdev -- a KASAN
slab-use-after-free, reachable by racing TRIGGER_SCAN against
DEL_INTERFACE (both CAP_NET_ADMIN).

Pin the netdev with netdev_hold() while the RCU read lock is still held,
and release it at every worker exit.

Fixes: 57588c71177f ("mac802154: Handle passive scanning")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Link: https://patch.msgid.link/20260721211228.34578-1-security@auditcode.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/scan.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -179,6 +179,7 @@ void mac802154_scan_worker(struct work_s
 	enum nl802154_scan_types scan_req_type;
 	struct ieee802154_sub_if_data *sdata;
 	unsigned int scan_duration = 0;
+	netdevice_tracker dev_tracker;
 	struct wpan_phy *wpan_phy;
 	u8 scan_req_duration;
 	u8 page, channel;
@@ -209,6 +210,14 @@ void mac802154_scan_worker(struct work_s
 		return;
 	}
 
+	/*
+	 * sdata->dev is dereferenced below after rcu_read_unlock() and outside
+	 * the rtnl, and a concurrent DEL_INTERFACE / PHY teardown can free it
+	 * asynchronously from netdev_run_todo(). Pin it with a reference taken
+	 * while the RCU read lock is still held, and drop it at every exit.
+	 */
+	netdev_hold(sdata->dev, &dev_tracker, GFP_ATOMIC);
+
 	wpan_phy = scan_req->wpan_phy;
 	scan_req_type = scan_req->type;
 	scan_req_duration = scan_req->duration;
@@ -262,12 +271,14 @@ void mac802154_scan_worker(struct work_s
 		"Scan page %u channel %u for %ums\n",
 		page, channel, jiffies_to_msecs(scan_duration));
 	queue_delayed_work(local->mac_wq, &local->scan_work, scan_duration);
+	netdev_put(sdata->dev, &dev_tracker);
 	return;
 
 end_scan:
 	rtnl_lock();
 	mac802154_scan_cleanup_locked(local, sdata, false);
 	rtnl_unlock();
+	netdev_put(sdata->dev, &dev_tracker);
 }
 
 int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,


