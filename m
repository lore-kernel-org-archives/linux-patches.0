Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932ED1F3D56;
	Tue, 21 Jul 2026 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653780; cv=none; b=HG+Au86keYc1rpOcLn8xvoe0BuZLd7uE4p3pNjZLJ1cTbKKH2alQeBmp9z7YUvR6k8DS86Vw3YrNJ0kTZ9OQw5PObbEBdHuZEXRyrdfOqCNLvn9alZ6Vhc1ojf7Fx3BxRyeqFA6gdGj/TplFd6JzSiTIJCP0UwzFQs1wPSyCMjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653780; c=relaxed/simple;
	bh=QlhPLwZvIyv2oevUBN3Zgb7G4lg7he3YptToKXWtS1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ3Yx4fKfF4pFtgefe/CmUZcEnFsms8xp/yz0u6jCLtKRuu6dV9AQLXHxB5al6N06LW08IvJiPZktr2r3kUadqEUAglXOqyuM38Gces3QsoSU9BWV8jCfl51XEpfi/ccUAd+LySfahCMoKzphQ0etYJmJXuE6arQ3EbsZSq+Mzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W19C/OGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W19C/OGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6A41F000E9;
	Tue, 21 Jul 2026 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653779;
	bh=psqmEIsT2A7FoBKlInxgJ8jAuyXg/JhKafRgJC2TpiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W19C/OGvXKgN0CuIvxKQnT+/YYlxZAy4VplwhBm8pmc9ffT/zlOBCoUUWydwADCqI
	 2VjQlLVB3ZRj5uNNbk6HJqZ4+KT0DfyBk5wVYLw6HT8aFN3Mkjj6iHQET1Mwj4Ldx2
	 KYmGt4IfylP/RLtiaOnzam4QpbCfSNsoMnyWfZoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1456/2077] Bluetooth: 6lowpan: hold L2CAP conn across debugfs control
Date: Tue, 21 Jul 2026 17:18:49 +0200
Message-ID: <20260721152627.142751333@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 518aa9505fa10ea5662349e5d2efd8c9e32a820b ]

get_l2cap_conn() looks up an LE hci_conn under hdev protection, but
then drops that protection before reading hcon->l2cap_data and before
lowpan_control_write() later dereferences conn->hcon.  A disconnect or
device close can tear down the same L2CAP connection in that window.

The buggy scenario involves two paths, with each column showing the order
within that path:

6LoWPAN control write:              HCI disconnect/device close:
  1. get_l2cap_conn() finds hcon      1. hci_disconn_cfm() dispatches
     and hcon->l2cap_data.               the L2CAP disconnect callback.
  2. get_l2cap_conn() drops hdev      2. l2cap_conn_del() clears
     protection and returns conn.        hcon->l2cap_data and drops the
                                         L2CAP connection reference.
  3. lowpan_control_write() reads     3. hci_conn_del() removes and drops
     conn->hcon.                         the HCI connection.

Take a reference to the L2CAP connection with
l2cap_conn_hold_unless_zero() while hdev is still locked, and drop that
reference after the debugfs command's last use of conn.  This mirrors the
existing L2CAP ACL receive-side handoff and keeps the connection
dereferenceable after leaving hdev protection.  Export the existing helper
so the bluetooth_6lowpan module can use the same lifetime primitive.

Validation reproduced this kernel report:
BUG: KASAN: slab-use-after-free in lowpan_control_write+0x374/0x520
The buggy address belongs to the object at ffff888111b9d000 which belongs
to the cache kmalloc-1k of size 1024
The buggy address is located 0 bytes inside of freed 1024-byte region
[ffff888111b9d000, ffff888111b9d400)
Read of size 8
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x5f0
  lowpan_control_write+0x374/0x520 (net/bluetooth/6lowpan.c:1131)
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x19f/0x330
  kasan_report+0xe0/0x110
  __debugfs_file_get+0xf7/0x400
  full_proxy_write+0x9e/0xd0
  vfs_write+0x1b0/0x810
  ksys_write+0xd2/0x170
  dnotify_flush+0x32/0x220
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Allocated by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x17/0x60
  __kasan_kmalloc+0xaa/0xb0
  l2cap_conn_add+0x45/0x520
  l2cap_chan_connect+0xac6/0xd90
  l2cap_sock_connect+0x216/0x350
  __sys_connect+0x101/0x130
  __x64_sys_connect+0x40/0x50
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Freed by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x17/0x60
  kasan_save_free_info+0x3b/0x60
  __kasan_slab_free+0x5f/0x80
  kfree+0x313/0x590
  hci_conn_hash_flush+0xc0/0x140
  hci_dev_close_sync+0x41a/0xb00
  hci_dev_close+0x12f/0x160
  hci_sock_ioctl+0x157/0x570
  sock_do_ioctl+0xf7/0x210
  sock_ioctl+0x32f/0x490
  __x64_sys_ioctl+0xc7/0x110
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  kasan_record_aux_stack+0xa7/0xc0
  insert_work+0x32/0x100
  __queue_work+0x262/0xa60
  queue_work_on+0xad/0xb0
  l2cap_connect_cfm+0x4ef/0x670
  hci_le_remote_feat_complete_evt+0x247/0x430
  hci_event_packet+0x360/0x6f0
  hci_rx_work+0x2ae/0x7a0
  process_one_work+0x4fd/0xbc0
  worker_thread+0x2d8/0x570
  kthread+0x1ad/0x1f0
  ret_from_fork+0x3c9/0x540
  ret_from_fork_asm+0x1a/0x30

Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c    | 21 +++++++++++++++------
 net/bluetooth/l2cap_core.c |  1 +
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 88f896401d7e09..e0a47b855928d2 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -997,16 +997,19 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 
 	hci_dev_lock(hdev);
 	hcon = hci_conn_hash_lookup_le(hdev, addr, le_addr_type);
-	hci_dev_unlock(hdev);
-	hci_dev_put(hdev);
-
-	if (!hcon)
+	if (!hcon) {
+		hci_dev_unlock(hdev);
+		hci_dev_put(hdev);
 		return -ENOENT;
+	}
 
-	*conn = (struct l2cap_conn *)hcon->l2cap_data;
+	*conn = l2cap_conn_hold_unless_zero(hcon->l2cap_data);
 
 	BT_DBG("conn %p dst %pMR type %u", *conn, &hcon->dst, hcon->dst_type);
 
+	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
+
 	return 0;
 }
 
@@ -1134,18 +1137,22 @@ static ssize_t lowpan_control_write(struct file *fp,
 		if (conn) {
 			struct lowpan_peer *peer;
 
-			if (!is_bt_6lowpan(conn->hcon))
+			if (!is_bt_6lowpan(conn->hcon)) {
+				l2cap_conn_put(conn);
 				return -EINVAL;
+			}
 
 			peer = lookup_peer(conn);
 			if (peer) {
 				BT_DBG("6LoWPAN connection already exists");
+				l2cap_conn_put(conn);
 				return -EALREADY;
 			}
 
 			BT_DBG("conn %p dst %pMR type %d user %u", conn,
 			       &conn->hcon->dst, conn->hcon->dst_type,
 			       addr_type);
+			l2cap_conn_put(conn);
 		}
 
 		ret = bt_6lowpan_connect(&addr, addr_type);
@@ -1161,6 +1168,8 @@ static ssize_t lowpan_control_write(struct file *fp,
 			return ret;
 
 		ret = bt_6lowpan_disconnect(conn, addr_type);
+		if (conn)
+			l2cap_conn_put(conn);
 		if (ret < 0)
 			return ret;
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 32f0c8b73b17f2..4b8246b2971135 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7714,6 +7714,7 @@ struct l2cap_conn *l2cap_conn_hold_unless_zero(struct l2cap_conn *c)
 
 	return c;
 }
+EXPORT_SYMBOL(l2cap_conn_hold_unless_zero);
 
 int l2cap_recv_acldata(struct hci_dev *hdev, u16 handle,
 		       struct sk_buff *skb, u16 flags)
-- 
2.53.0



