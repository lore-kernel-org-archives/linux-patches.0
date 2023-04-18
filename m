Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867EB2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7ADC433D2;
	Tue, 18 Apr 2023 12:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822085;
	bh=4W3YW/6YXbIjFW1mncF+GkSRi3En8StVLKgiFgm1tz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tofVC1UZO701ixDxhmZM0fV63zPqhE9Ey3xHCiSBe+HydoCUl6zyjwHT6VDJtQ21k
	 k4kDZg9MyL2+P/1bycVdhEzKMLS3ZB/4b0xR4UP2Z70Us8IzsSXRvQISVDfAicRMW+
	 vJ41IdtFT2anT32taBlPup9B/1MWE5b4NIwidOdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.2 017/139] Bluetooth: hci_conn: Fix possible UAF
Date: Tue, 18 Apr 2023 14:21:22 +0200
Message-Id: <20230418120314.312711588@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 5dc7d23e167e2882ef118456ceccd57873e876d8 upstream.

This fixes the following trace:

==================================================================
BUG: KASAN: slab-use-after-free in hci_conn_del+0xba/0x3a0
Write of size 8 at addr ffff88800208e9c8 by task iso-tester/31

CPU: 0 PID: 31 Comm: iso-tester Not tainted 6.3.0-rc2-g991aa4a69a47
 #4716
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.1-2.fc36
04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x1d/0x70
 print_report+0xce/0x610
 ? __virt_addr_valid+0xd4/0x150
 ? hci_conn_del+0xba/0x3a0
 kasan_report+0xdd/0x110
 ? hci_conn_del+0xba/0x3a0
 hci_conn_del+0xba/0x3a0
 hci_conn_hash_flush+0xf2/0x120
 hci_dev_close_sync+0x388/0x920
 hci_unregister_dev+0x122/0x260
 vhci_release+0x4f/0x90
 __fput+0x102/0x430
 task_work_run+0xf1/0x160
 ? __pfx_task_work_run+0x10/0x10
 ? mark_held_locks+0x24/0x90
 exit_to_user_mode_prepare+0x170/0x180
 syscall_exit_to_user_mode+0x19/0x50
 do_syscall_64+0x4e/0x90
 entry_SYSCALL_64_after_hwframe+0x70/0xda

Fixes: 0f00cd322d22 ("Bluetooth: Free potentially unfreed SCO connection")
Link: https://syzkaller.appspot.com/bug?extid=8bb72f86fc823817bc5d
Cc: <stable@vger.kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1049,6 +1049,17 @@ struct hci_conn *hci_conn_add(struct hci
 	return conn;
 }
 
+static bool hci_conn_unlink(struct hci_conn *conn)
+{
+	if (!conn->link)
+		return false;
+
+	conn->link->link = NULL;
+	conn->link = NULL;
+
+	return true;
+}
+
 int hci_conn_del(struct hci_conn *conn)
 {
 	struct hci_dev *hdev = conn->hdev;
@@ -1060,15 +1071,16 @@ int hci_conn_del(struct hci_conn *conn)
 	cancel_delayed_work_sync(&conn->idle_work);
 
 	if (conn->type == ACL_LINK) {
-		struct hci_conn *sco = conn->link;
-		if (sco) {
-			sco->link = NULL;
+		struct hci_conn *link = conn->link;
+
+		if (link) {
+			hci_conn_unlink(conn);
 			/* Due to race, SCO connection might be not established
 			 * yet at this point. Delete it now, otherwise it is
 			 * possible for it to be stuck and can't be deleted.
 			 */
-			if (sco->handle == HCI_CONN_HANDLE_UNSET)
-				hci_conn_del(sco);
+			if (link->handle == HCI_CONN_HANDLE_UNSET)
+				hci_conn_del(link);
 		}
 
 		/* Unacked frames */
@@ -1084,7 +1096,7 @@ int hci_conn_del(struct hci_conn *conn)
 		struct hci_conn *acl = conn->link;
 
 		if (acl) {
-			acl->link = NULL;
+			hci_conn_unlink(conn);
 			hci_conn_drop(acl);
 		}
 
@@ -2436,6 +2448,12 @@ void hci_conn_hash_flush(struct hci_dev
 		c->state = BT_CLOSED;
 
 		hci_disconn_cfm(c, HCI_ERROR_LOCAL_HOST_TERM);
+
+		/* Unlink before deleting otherwise it is possible that
+		 * hci_conn_del removes the link which may cause the list to
+		 * contain items already freed.
+		 */
+		hci_conn_unlink(c);
 		hci_conn_del(c);
 	}
 }


