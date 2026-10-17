Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FCE35E93B;
	Sat, 17 Oct 2026 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256774; cv=none; b=d5bl8FkM6jGxRZRuEekMtaszo28ImXRIA6YJK1BRWbxDx4oEOW5PTXNQRpRsoAu2578aeGoXLZEr/DQN2cM4TboKlXGbAHvdYvl6fgtxoVV2hHHDi7byBUuUra6I5jGfBy6C35tDgc6vG+H4r3IIYEybD3SGaid1wT4BKw2UxEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256774; c=relaxed/simple;
	bh=NigKVBO9BCI6QuwQS4WV7ReETRtu/ZpJD3Urs7QpNyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2j3kjkkTLyZPK4eAeYQomaVNIhWLjQcW+ZlP/JRHoh61BR7wW00JeBDgvMe/IcFGYbHdJjJ4FJzOvaaBvvrquEdHFHqBVTMVflirWvYTYZ1ECsb7so1n/NFZtfgemuveWKcYHhv8GtkJ+vTH+21Su7TO3UhzZ0aHuy2hCFSfMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5K1aUPH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5K1aUPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5A61F000C4;
	Sat, 17 Oct 2026 17:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256773;
	bh=hTDnsc1z7ny4o6zp2CgOUlWkRet6PemJL3k8q10pkIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5K1aUPHWLbIEd7pXo56efpBOBqnTpCItcdTck2j6I9vYo33NX1JVqxGy5O9bhR9s
	 MAz2mpD8MoZtjJ9Gkf65ESfj3Rl6GEl23UGheu/dA5g++C+1/zRzznmAq5xeniMzMK
	 7wsCYqbpGmz4d+a7V/Sg+R+gXmvzbdDkKCq+8D1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0295/1674] Bluetooth: hci_sync: Fix inquiry cache use-after-free
Date: Sat, 17 Oct 2026 17:42:47 +0200
Message-ID: <20261017160438.691803055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 8ed67535fdff40ca652bcd4ac7da68d11d01bd34 upstream.

The sync command worker holds hdev->req_lock, but inquiry-cache updates
and flushes use hdev->lock. Both hci_acl_create_conn_sync() and
hci_stop_discovery_sync() look up entries and read their fields without
taking hdev->lock.

After either lookup returns, a concurrent HCIINQUIRY ioctl can acquire
hdev->lock and flush the cache, freeing the entry. The worker then reads
the freed entry while preparing a create-connection or remote-name-cancel
command. The list traversal also races with cache updates and removal.

KASAN reported these accesses:

  BUG: KASAN: slab-use-after-free in hci_acl_create_conn_sync+0x5f1/0x650
  Workqueue: hci0 hci_cmd_sync_work
  Call Trace:
   hci_acl_create_conn_sync+0x5f1/0x650
   hci_cmd_sync_work+0x13c/0x290

  Allocated by task 90:
   hci_inquiry_cache_update+0x3e6/0x7d0
   hci_inquiry_result_evt+0x3cb/0x560

  Freed by task 93:
   hci_inquiry_cache_flush+0x111/0x2b0
   hci_inquiry+0x2f2/0x780
   hci_sock_ioctl+0x269/0x5f0

  BUG: KASAN: slab-use-after-free in hci_stop_discovery_sync+0x3b1/0x3c0
  Workqueue: hci0 hci_cmd_sync_work
  Call Trace:
   hci_stop_discovery_sync+0x3b1/0x3c0
   hci_cmd_sync_work+0x173/0x300

  Allocated by task 86:
   hci_inquiry_cache_update+0x483/0x940
   hci_inquiry_result_evt+0x3cb/0x560

  Freed by task 91:
   hci_inquiry_cache_flush+0x13e/0x2f0
   hci_inquiry+0x2f2/0x780
   hci_sock_ioctl+0x269/0x5f0

Hold hdev->lock across each lookup and all reads from its result. Copy the
remote address before unlocking so discovery cancellation does not retain
a cache entry pointer. Release the lock before sending synchronous HCI
commands, since their completion handlers may need the same lock.

Fixes: cf75ad8b41d2 ("Bluetooth: hci_sync: Convert MGMT_SET_POWERED")
Fixes: 45340097ce6e ("Bluetooth: hci_conn: Only do ACL connections sequentially")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5562,6 +5562,7 @@ int hci_stop_discovery_sync(struct hci_d
 {
 	struct discovery_state *d = &hdev->discovery;
 	struct inquiry_entry *e;
+	bdaddr_t addr;
 	int err;
 
 	bt_dev_dbg(hdev, "state %u", hdev->discovery.state);
@@ -5598,15 +5599,21 @@ int hci_stop_discovery_sync(struct hci_d
 		return 0;
 
 	if (d->state == DISCOVERY_RESOLVING || d->state == DISCOVERY_STOPPING) {
+		hci_dev_lock(hdev);
 		e = hci_inquiry_cache_lookup_resolve(hdev, BDADDR_ANY,
 						     NAME_PENDING);
-		if (!e)
+		if (!e) {
+			hci_dev_unlock(hdev);
 			return 0;
+		}
+
+		bacpy(&addr, &e->data.bdaddr);
+		hci_dev_unlock(hdev);
 
 		/* Ignore cancel errors since it should interfere with stopping
 		 * of the discovery.
 		 */
-		hci_remote_name_cancel_sync(hdev, &e->data.bdaddr);
+		hci_remote_name_cancel_sync(hdev, &addr);
 	}
 
 	return 0;
@@ -7047,6 +7054,7 @@ static int hci_acl_create_conn_sync(stru
 	bacpy(&cp.bdaddr, &conn->dst);
 	cp.pscan_rep_mode = 0x02;
 
+	hci_dev_lock(hdev);
 	ie = hci_inquiry_cache_lookup(hdev, &conn->dst);
 	if (ie) {
 		if (inquiry_entry_age(ie) <= INQUIRY_ENTRY_AGE_MAX) {
@@ -7058,6 +7066,7 @@ static int hci_acl_create_conn_sync(stru
 
 		memcpy(conn->dev_class, ie->data.dev_class, 3);
 	}
+	hci_dev_unlock(hdev);
 
 	cp.pkt_type = cpu_to_le16(conn->pkt_type);
 	if (lmp_rswitch_capable(hdev) && !(hdev->link_mode & HCI_LM_MASTER))


