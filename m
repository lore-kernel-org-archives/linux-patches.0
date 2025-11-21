Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE3C348468;
	Fri, 21 Nov 2025 13:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731008; cv=none; b=oCxPfIoGG7ejdgw7c02KhXV95gwiRmO3GC5PWnJAzlhzXfZZwYzcas9BiV9sXpcbpQPJSEmdzojTn0uqyhl4RWjpSgYHzDKHggF0uv5sxARwJumwgAUAOoO2FVvXAZJPq0ag/YL8EEIWU91+0l65xZBayW0lbbWgVwhWiLR5Bjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731008; c=relaxed/simple;
	bh=/C94JiCETdRSw/Ow+UQVwin75mzNOX/lqTuYSU/mPUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8BEdtOt1a2iHnsxjlhMRBMUsahdufnC3ZBlTaMi43dGCsp6eaMCxlpn4RzNDjcA59At6RDJVou+64xqCp61p0uLuir8IrQe3WZeQPoryWhGoIYdCVnXluXGo9UR7hxue2kx+DiFxbM51AVRELWMXAJoD51rnwUFrXX8Y85iM7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqVSYdYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqVSYdYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FD3C4CEF1;
	Fri, 21 Nov 2025 13:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731008;
	bh=/C94JiCETdRSw/Ow+UQVwin75mzNOX/lqTuYSU/mPUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqVSYdYkW3u7jE/0dgSkj/dmr+4ZVKoQepvyyO3zYnou7N24YUFMPfdGozLTYxGZ7
	 RY1ZlmbwbUp8sUNqVtUVV4MCzoeRbiv/s857ceMqJfUJi7bkPfrm/poS0IFzCZqvhJ
	 I0w1Z5e9m6eeTAVawFCQJir3tXlOzVa4ihOS1bG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 059/247] Bluetooth: 6lowpan: Dont hold spin lock over sleeping functions
Date: Fri, 21 Nov 2025 14:10:06 +0100
Message-ID: <20251121130156.722254985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0d8c2e2e9a6cf..588d7e94e6069 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -53,6 +53,11 @@ static bool enable_6lowpan;
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
@@ -61,6 +66,8 @@ struct lowpan_peer {
 	/* peer addresses in various formats */
 	unsigned char lladdr[ETH_ALEN];
 	struct in6_addr peer_addr;
+
+	DECLARE_BITMAP(flags, LOWPAN_PEER_MAXBITS);
 };
 
 struct lowpan_btle_dev {
@@ -1014,41 +1021,52 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
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



