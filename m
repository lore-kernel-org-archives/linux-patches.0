Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F4E2FD1C5;
	Wed,  3 Dec 2025 16:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779874; cv=none; b=BdwMkRzygMRHlnYE6ceV2FmlxpU7hfnp946M1mGaLBGmvV6Jw12Q3KSYuU4nt1Or8vtOIwGSKPLp73wf1j9QFH0H0X+JFi0P64YjsS5P0e2LD0P16VERxlpnd2UL51G9vWv0iefe5t3RCyPg40XaiVwWIiGEFFIuZypNbToiO5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779874; c=relaxed/simple;
	bh=r4HpFm75BJZo4a4l53u3KdMNPzFVzBxoPFj1FsER2+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLGE/AsIQuM49BDNbl2u8YtDaIg8YvmYlv1Bvwnehp2Oq8WoZlujoBIKWpIXszuIK93vHjbHQ1016wgVUSGjnK2AL94tvfjQe627gO6E0Fgn4dqJvAFcZ0E2evZYRCdLdw+9HNsOvQzCgbooiMvEGuu7gW0kNjQ1VmV7idcBQnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l31KXwh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l31KXwh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04407C4CEF5;
	Wed,  3 Dec 2025 16:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779874;
	bh=r4HpFm75BJZo4a4l53u3KdMNPzFVzBxoPFj1FsER2+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l31KXwh0qM9BX2e+XR3vAlvcSRRqRQY+a29CSDZQZrwHHQMFn4pofcGDtUJUhgMkI
	 h9p97/mX2cd8v4Jx1q/lAvPEVJgYbt84FRtvmPqpUDcMdapx5rS0ZUabz64uzL8RV2
	 ttwxGZByOP7Iaatg+cNrImgjJCLCphM0XockW7XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 355/568] Bluetooth: 6lowpan: Dont hold spin lock over sleeping functions
Date: Wed,  3 Dec 2025 16:25:57 +0100
Message-ID: <20251203152453.706528734@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 98454bc812f3611551e4b1f81732da4aa7b9597e ]

disconnect_all_peers() calls sleeping function (l2cap_chan_close) under
spinlock.  Holding the lock doesn't actually do any good -- we work on a
local copy of the list, and the lock doesn't protect against peer->chan
having already been freed.

Fix by taking refcounts of peer->chan instead.  Clean up the code and
old comments a bit.

Take devices_lock instead of RCU, because the kfree_rcu();
l2cap_chan_put(); construct in chan_close_cb() does not guarantee
peer->chan is necessarily valid in RCU.

Also take l2cap_chan_lock() which is required for l2cap_chan_close().

Log: (bluez 6lowpan-tester Client Connect - Disable)
------
BUG: sleeping function called from invalid context at kernel/locking/mutex.c:575
...
<TASK>
...
l2cap_send_disconn_req (net/bluetooth/l2cap_core.c:938 net/bluetooth/l2cap_core.c:1495)
...
? __pfx_l2cap_chan_close (net/bluetooth/l2cap_core.c:809)
do_enable_set (net/bluetooth/6lowpan.c:1048 net/bluetooth/6lowpan.c:1068)
------

Fixes: 90305829635d ("Bluetooth: 6lowpan: Converting rwlocks to use RCU")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 68 ++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 25 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 57553abde4180..347361ff0cc87 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -52,6 +52,11 @@ static bool enable_6lowpan;
 static struct l2cap_chan *listen_chan;
 static DEFINE_MUTEX(set_lock);
 
+enum {
+	LOWPAN_PEER_CLOSING,
+	LOWPAN_PEER_MAXBITS
+};
+
 struct lowpan_peer {
 	struct list_head list;
 	struct rcu_head rcu;
@@ -60,6 +65,8 @@ struct lowpan_peer {
 	/* peer addresses in various formats */
 	unsigned char lladdr[ETH_ALEN];
 	struct in6_addr peer_addr;
+
+	DECLARE_BITMAP(flags, LOWPAN_PEER_MAXBITS);
 };
 
 struct lowpan_btle_dev {
@@ -1013,41 +1020,52 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 static void disconnect_all_peers(void)
 {
 	struct lowpan_btle_dev *entry;
-	struct lowpan_peer *peer, *tmp_peer, *new_peer;
-	struct list_head peers;
-
-	INIT_LIST_HEAD(&peers);
+	struct lowpan_peer *peer;
+	int nchans;
 
-	/* We make a separate list of peers as the close_cb() will
-	 * modify the device peers list so it is better not to mess
-	 * with the same list at the same time.
+	/* l2cap_chan_close() cannot be called from RCU, and lock ordering
+	 * chan->lock > devices_lock prevents taking write side lock, so copy
+	 * then close.
 	 */
 
 	rcu_read_lock();
+	list_for_each_entry_rcu(entry, &bt_6lowpan_devices, list)
+		list_for_each_entry_rcu(peer, &entry->peers, list)
+			clear_bit(LOWPAN_PEER_CLOSING, peer->flags);
+	rcu_read_unlock();
 
-	list_for_each_entry_rcu(entry, &bt_6lowpan_devices, list) {
-		list_for_each_entry_rcu(peer, &entry->peers, list) {
-			new_peer = kmalloc(sizeof(*new_peer), GFP_ATOMIC);
-			if (!new_peer)
-				break;
+	do {
+		struct l2cap_chan *chans[32];
+		int i;
 
-			new_peer->chan = peer->chan;
-			INIT_LIST_HEAD(&new_peer->list);
+		nchans = 0;
 
-			list_add(&new_peer->list, &peers);
-		}
-	}
+		spin_lock(&devices_lock);
 
-	rcu_read_unlock();
+		list_for_each_entry_rcu(entry, &bt_6lowpan_devices, list) {
+			list_for_each_entry_rcu(peer, &entry->peers, list) {
+				if (test_and_set_bit(LOWPAN_PEER_CLOSING,
+						     peer->flags))
+					continue;
 
-	spin_lock(&devices_lock);
-	list_for_each_entry_safe(peer, tmp_peer, &peers, list) {
-		l2cap_chan_close(peer->chan, ENOENT);
+				l2cap_chan_hold(peer->chan);
+				chans[nchans++] = peer->chan;
 
-		list_del_rcu(&peer->list);
-		kfree_rcu(peer, rcu);
-	}
-	spin_unlock(&devices_lock);
+				if (nchans >= ARRAY_SIZE(chans))
+					goto done;
+			}
+		}
+
+done:
+		spin_unlock(&devices_lock);
+
+		for (i = 0; i < nchans; ++i) {
+			l2cap_chan_lock(chans[i]);
+			l2cap_chan_close(chans[i], ENOENT);
+			l2cap_chan_unlock(chans[i]);
+			l2cap_chan_put(chans[i]);
+		}
+	} while (nchans);
 }
 
 struct set_enable {
-- 
2.51.0



