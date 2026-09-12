Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1633A4267;
	Sat, 12 Sep 2026 20:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243420; cv=none; b=ViuRHajyVTX+Bqaqev+hhhod3w5/Qx1f/+Uk0A85wSLKCMg+R9tf5tzO6qfP7Fg0V0NH52egMyOrrnVdeWnitmN/sMO60pixmcsxLjkHv978pA//V/5imGS6QwP70/HEay9dCIHY7y1hipqs/PzRwKqT70DVmZjYqZZdHP+l/Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243420; c=relaxed/simple;
	bh=nFYihuXsNwROkbjZtgXnuqaMyQwOs54N1aOprHTCYx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZRLVi6+KEqvD4VjpBpwZLeuRqRoE1j4yFR+Q4OgAS4LZtcoa09wMbpUhj76CCc3mYaL2Ntxp7sVwhTr/69+lBmoHO3fQklC9zokhBT4IlpMHmfCOhUtHoY1+Q85lwrJpGGNaAr/sE1FeLkcIoUoQA6w0ri1oTehw8A5tbHWK0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtoQGklR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtoQGklR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EB11F000FF;
	Sat, 12 Sep 2026 20:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243418;
	bh=7mDUa67XJPyQO+gWr8JEd/2NMaXDWz052HTCua+GXMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtoQGklR3GcoOhsvM5SmbQsxiFMVx3yKeYewijRMaamVBpVQbDZDTq5QRqtwfRTnt
	 xy2Kw5OIMV8KBliU3WhWuV//zsi7+EdXXC1Op4KjfQ4qYbxhsIni2Dx1IchVn34Vcr
	 GIb4jN01uDR8bfyGgRcaNyQGfr4N7Lc4ipe1xZD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 750/798] Bluetooth: 6lowpan: fix cyclic locking warning on netdev unregister
Date: Sat, 12 Sep 2026 09:06:18 +0200
Message-ID: <20260912065534.261262665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: d4bfa78fd679 ("Bluetooth: L2CAP: reject accept queue add unless BT_LISTEN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index a71855268d33f..9a9b1c13ca91f 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -787,13 +787,33 @@ static inline struct l2cap_chan *chan_new_conn_cb(struct l2cap_chan *pchan)
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
@@ -1271,6 +1291,7 @@ static void disconnect_devices(void)
 			break;
 
 		new_dev->netdev = entry->netdev;
+		new_dev->hdev = entry->hdev;
 		INIT_LIST_HEAD(&new_dev->list);
 
 		list_add_rcu(&new_dev->list, &devices);
@@ -1282,7 +1303,7 @@ static void disconnect_devices(void)
 		ifdown(entry->netdev);
 		BT_DBG("Unregistering netdev %s %p",
 		       entry->netdev->name, entry->netdev);
-		lowpan_unregister_netdev(entry->netdev);
+		unregister_dev(entry);
 		kfree(entry);
 	}
 }
-- 
2.53.0



