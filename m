Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9C54582CE;
	Tue, 21 Jul 2026 21:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667795; cv=none; b=CxHpPmV7Ykc7qSwfufZ/TX0JBwwEIQhttfIz8O26bp/OBznVMReIhT8pD78qXXMlYT+MGQD/3DGBkjlvBIBGis3UeOismH/zhF7DRF1HJaWIyMejTX4lLoeMpu5Tpf9WLGJPA44Yg8uMd04m2iHG1UfOd1hSgh9Xx6OcTAVfRQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667795; c=relaxed/simple;
	bh=eztsUGIeLJX1zf8tjkp+caA3o4FBjALd5ytLUjpgqtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1KbEc30O+SH6mTefQ32XMbbeUczxy2MXtxJwe3eUxdq8fvQVTUCsW2mex/z2Pj2FnzlpNy+DEORL8bacYC5pnKYXJixfIq6BLJognlEL4ZrryfNm+nNuiZJg6AD+zNjSHCR5x677X7Gjbu9qJ31vMYLgvpdvBO1Jt+vuY24urE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cdv29jdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cdv29jdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B7B1F00A3A;
	Tue, 21 Jul 2026 21:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667792;
	bh=uSox84SpKmuZvIBioCkH3f8hBY50+27/CyWU5HGMDs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cdv29jdwAICF7Yp5WDPVTc/5645KmTB9l/QtzIT0iOGbcKGivcqjW7sKgZwuPpFLB
	 CgkxVtOXZk0jeEJjfU/BGa8kx1H6HMZaGa+IB7Lxv4rrOniyezNjkFPWr2Oy4Ggre+
	 snXfiE/gsZHA3twg1KXxlAHkH9L7wzvUEGL5E0u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1193/1266] Bluetooth: 6lowpan: fix cyclic locking warning on netdev unregister
Date: Tue, 21 Jul 2026 17:27:10 +0200
Message-ID: <20260721152508.492574505@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 9707a015fe8f3ba8ec7c270f3b2b8efb38823d6b ]

6lowpan.c has theoretically conflicting lock orderings, which lockdep
complains about:

    a) rtnl_lock > hdev->workqueue

    from 6lowpan.c:delete_netdev -> rtnl_lock -> device_del
    -> put_device(parent) -> hci_release_dev -> destroy_workqueue

    b) hdev->workqueue > l2cap_conn->lock > chan->lock > rtnl_lock

    from hci_rx_work -> 6lowpan.c:chan_ready_cb
    -> lowpan_register_netdev, ifup -> rtnl_lock

Actual deadlock appears not possible, as hci_rx_work is disabled and
l2cap_conn flushed already on hdev unregister. Hence, do minimal thing
to make lockdep happy by breaking chain a) by holding hdev refcount
until after netdev put in 6lowpan.c.

Fixes the lockdep complaint:
WARNING: possible circular locking dependency detected.
kworker/0:1/11 is trying to acquire lock:
ffff8880023b3940 ((wq_completion)hci0#2){+.+.}-{0:0}, at: touch_wq_lockdep_map+0x8b/0x130
but task is already holding lock:
ffffffff95e4f9c0 (rtnl_mutex){+.+.}-{4:4}, at: lowpan_unregister_netdev+0xd/0x30
Workqueue: events delete_netdev

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 6fef032af009 ("Bluetooth: L2CAP: Fix use-after-free in l2cap_sock_new_connection_cb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/6lowpan.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -759,13 +759,33 @@ static inline struct l2cap_chan *chan_ne
 	return chan;
 }
 
+static void unregister_dev(struct lowpan_btle_dev *dev)
+{
+	struct hci_dev *hdev = READ_ONCE(dev->hdev);
+
+	/* If netdev holds last reference to hci_dev (its parent device), this
+	 * leads to theoretical cyclic locking on lowpan_unregister_netdev:
+	 *
+	 * rtnl_lock -> put_device(parent) -> hci_release_dev ->
+	 * destroy_workqueue -> hci_rx_work -> l2cap_recv_acldata ->
+	 * chan_ready_cb -> ifup -> rtnl_lock
+	 *
+	 * However, hci_rx_work is disabled in hci_unregister_dev, so this
+	 * should not occur. Make lockdep happy by postponing hdev release after
+	 * netdev put.
+	 */
+	hci_dev_hold(hdev);
+	lowpan_unregister_netdev(dev->netdev);
+	hci_dev_put(hdev);
+}
+
 static void delete_netdev(struct work_struct *work)
 {
 	struct lowpan_btle_dev *entry = container_of(work,
 						     struct lowpan_btle_dev,
 						     delete_netdev);
 
-	lowpan_unregister_netdev(entry->netdev);
+	unregister_dev(entry);
 
 	/* The entry pointer is deleted by the netdev destructor. */
 }
@@ -1254,6 +1274,7 @@ static void disconnect_devices(void)
 			break;
 
 		new_dev->netdev = entry->netdev;
+		new_dev->hdev = entry->hdev;
 		INIT_LIST_HEAD(&new_dev->list);
 
 		list_add_rcu(&new_dev->list, &devices);
@@ -1265,7 +1286,7 @@ static void disconnect_devices(void)
 		ifdown(entry->netdev);
 		BT_DBG("Unregistering netdev %s %p",
 		       entry->netdev->name, entry->netdev);
-		lowpan_unregister_netdev(entry->netdev);
+		unregister_dev(entry);
 		kfree(entry);
 	}
 }


