Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916EF3806BD;
	Thu, 30 Jul 2026 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426582; cv=none; b=BtTUDhavFtUKW306aZ/S+8ykblRWeTV1aKr9n4D2LcXTuryHXuxAvnibSbwD71TrlAyiwu9xE5n/TnX/rKc2GbL93j70wMPUxlbb17U+cZxRp0Ba9O02zF1HYJ9q7o2MuTRdKbMGey6eQGXCdqWzenw7jqzf+mj/qtvtzg1nlMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426582; c=relaxed/simple;
	bh=9ZOp4aC0PswJ0DbbHOdSeaAg53m4Upcn2LsO8coaDsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjhK2KcmlFXsqg2LIvbhALTi2WJ1CNt2rwZF0CIt6Jm10o3Vl1tgp5h/dtaUpS9nND0nZnQEkaWcLngufdU1DX460PcWz+LILL83uDe8dAPIwK+wSqgHz6eGkIA46seAMvNV0dWoZJ/DXhBM8/l+V6wIMN0kwKVxa072wG/TYu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdqKW6EE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdqKW6EE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7B61F000E9;
	Thu, 30 Jul 2026 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426581;
	bh=OhV+UOZ6n1BynsGIy7mECTfNwYCLjA8hwgSJyUo6bMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdqKW6EEPg8J5OxrRgWqgDUFtC6PcofQeF6m5wR9k0MquAeFQ5GoglS9CrvjqzbOn
	 pja7KAdZE0vb/o1pIjkeJt/AlrgUHzWM0aCzeLeRCU8i/v0EJ3xK53mjEy6v6TkJ36
	 GIXMCLlQU1NFa2X+VbpNuJ3VVeNNBlQ7MgPO4eFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 425/602] mac802154: hold an interface reference across the scan worker
Date: Thu, 30 Jul 2026 16:13:37 +0200
Message-ID: <20260730141444.895767654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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


