Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401FD156F40;
	Tue, 23 Jul 2024 18:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760258; cv=none; b=OcqcXLUuh/4spJkxAH3F2XJ6RGyVvcQKuXnzLpCfTvi4I5QqDOIVxu4rDGPlTIfdm0WWCPV2i5P1n4M/Keam/Oz7SIPu1DdPI4EEkOJGYIuSbM7nFZVXhGjxfhyjfJdgQJiU/xkbEOMoUsB/D1rMFlmWLo4thZccHaA8mx0xY9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760258; c=relaxed/simple;
	bh=QQOUU8KW2TReVsp6g+EsBamZRuspM4w6cOPWXT35Yic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqkqYlRsqEFqnEk2PEvAaCeqlkrckK9DEBneKfJThBvJunN6NwVr9FhdokAaSOAPTDXxrahLDieWgpo4rCZSiJ5vunglfT906QByU2vZU8fr2VcQsvUzR9B4tZF0MUNinPD/hdeP/vAhDyW87O99/mumInRmkYiS60yulL/1gX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+PBys72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+PBys72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8749C4AF09;
	Tue, 23 Jul 2024 18:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760258;
	bh=QQOUU8KW2TReVsp6g+EsBamZRuspM4w6cOPWXT35Yic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+PBys72H61rKQUI84Xw3XebJET8/OEGpc49zUN7EAVIx14LwICFayKBCGqbWhjj1
	 davEFVYeLVPpVzHna9sNO7rBIwSbrBu5JOgm+9j6oO1Fm5hpgMPLJ/DLV9cMfRDjrI
	 ZGLwgwzjh+q/wWPsyz4aAYpLoBAAxceI+T3eH+3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.9 155/163] Bluetooth: L2CAP: Fix deadlock
Date: Tue, 23 Jul 2024 20:24:44 +0200
Message-ID: <20240723180149.458126976@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit f1a8f402f13f94263cf349216c257b2985100927 upstream.

This fixes the following deadlock introduced by 39a92a55be13
("bluetooth/l2cap: sync sock recv cb and release")

============================================
WARNING: possible recursive locking detected
6.10.0-rc3-g4029dba6b6f1 #6823 Not tainted
--------------------------------------------
kworker/u5:0/35 is trying to acquire lock:
ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_sock_recv_cb+0x44/0x1e0

but task is already holding lock:
ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_get_chan_by_scid+0xaf/0xd0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&chan->lock#2/1);
  lock(&chan->lock#2/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/u5:0/35:
 #0: ffff888002b8a940 ((wq_completion)hci0#2){+.+.}-{0:0}, at:
process_one_work+0x750/0x930
 #1: ffff888002c67dd0 ((work_completion)(&hdev->rx_work)){+.+.}-{0:0},
at: process_one_work+0x44e/0x930
 #2: ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_get_chan_by_scid+0xaf/0xd0

To fix the original problem this introduces l2cap_chan_lock at
l2cap_conless_channel to ensure that l2cap_sock_recv_cb is called with
chan->lock held.

Fixes: 89e856e124f9 ("bluetooth/l2cap: sync sock recv cb and release")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_sync.h |    2 +
 net/bluetooth/hci_core.c         |   72 +++++++++------------------------------
 net/bluetooth/hci_sync.c         |   13 +++++++
 net/bluetooth/l2cap_core.c       |    3 +
 net/bluetooth/l2cap_sock.c       |   13 -------
 5 files changed, 37 insertions(+), 66 deletions(-)

--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -38,6 +38,8 @@ int __hci_cmd_sync_status(struct hci_dev
 int __hci_cmd_sync_status_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 			     const void *param, u8 event, u32 timeout,
 			     struct sock *sk);
+int hci_cmd_sync_status(struct hci_dev *hdev, u16 opcode, u32 plen,
+			const void *param, u32 timeout);
 
 void hci_cmd_sync_init(struct hci_dev *hdev);
 void hci_cmd_sync_clear(struct hci_dev *hdev);
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -63,50 +63,6 @@ DEFINE_MUTEX(hci_cb_list_lock);
 /* HCI ID Numbering */
 static DEFINE_IDA(hci_index_ida);
 
-static int hci_scan_req(struct hci_request *req, unsigned long opt)
-{
-	__u8 scan = opt;
-
-	BT_DBG("%s %x", req->hdev->name, scan);
-
-	/* Inquiry and Page scans */
-	hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
-	return 0;
-}
-
-static int hci_auth_req(struct hci_request *req, unsigned long opt)
-{
-	__u8 auth = opt;
-
-	BT_DBG("%s %x", req->hdev->name, auth);
-
-	/* Authentication */
-	hci_req_add(req, HCI_OP_WRITE_AUTH_ENABLE, 1, &auth);
-	return 0;
-}
-
-static int hci_encrypt_req(struct hci_request *req, unsigned long opt)
-{
-	__u8 encrypt = opt;
-
-	BT_DBG("%s %x", req->hdev->name, encrypt);
-
-	/* Encryption */
-	hci_req_add(req, HCI_OP_WRITE_ENCRYPT_MODE, 1, &encrypt);
-	return 0;
-}
-
-static int hci_linkpol_req(struct hci_request *req, unsigned long opt)
-{
-	__le16 policy = cpu_to_le16(opt);
-
-	BT_DBG("%s %x", req->hdev->name, policy);
-
-	/* Default link policy */
-	hci_req_add(req, HCI_OP_WRITE_DEF_LINK_POLICY, 2, &policy);
-	return 0;
-}
-
 /* Get HCI device by index.
  * Device is held on return. */
 struct hci_dev *hci_dev_get(int index)
@@ -728,6 +684,7 @@ int hci_dev_cmd(unsigned int cmd, void _
 {
 	struct hci_dev *hdev;
 	struct hci_dev_req dr;
+	__le16 policy;
 	int err = 0;
 
 	if (copy_from_user(&dr, arg, sizeof(dr)))
@@ -754,8 +711,8 @@ int hci_dev_cmd(unsigned int cmd, void _
 
 	switch (cmd) {
 	case HCISETAUTH:
-		err = hci_req_sync(hdev, hci_auth_req, dr.dev_opt,
-				   HCI_INIT_TIMEOUT, NULL);
+		err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_AUTH_ENABLE,
+					    1, &dr.dev_opt, HCI_CMD_TIMEOUT);
 		break;
 
 	case HCISETENCRYPT:
@@ -766,19 +723,23 @@ int hci_dev_cmd(unsigned int cmd, void _
 
 		if (!test_bit(HCI_AUTH, &hdev->flags)) {
 			/* Auth must be enabled first */
-			err = hci_req_sync(hdev, hci_auth_req, dr.dev_opt,
-					   HCI_INIT_TIMEOUT, NULL);
+			err = __hci_cmd_sync_status(hdev,
+						    HCI_OP_WRITE_AUTH_ENABLE,
+						    1, &dr.dev_opt,
+						    HCI_CMD_TIMEOUT);
 			if (err)
 				break;
 		}
 
-		err = hci_req_sync(hdev, hci_encrypt_req, dr.dev_opt,
-				   HCI_INIT_TIMEOUT, NULL);
+		err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_ENCRYPT_MODE,
+					    1, &dr.dev_opt,
+					    HCI_CMD_TIMEOUT);
 		break;
 
 	case HCISETSCAN:
-		err = hci_req_sync(hdev, hci_scan_req, dr.dev_opt,
-				   HCI_INIT_TIMEOUT, NULL);
+		err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_SCAN_ENABLE,
+					    1, &dr.dev_opt,
+					    HCI_CMD_TIMEOUT);
 
 		/* Ensure that the connectable and discoverable states
 		 * get correctly modified as this was a non-mgmt change.
@@ -788,8 +749,11 @@ int hci_dev_cmd(unsigned int cmd, void _
 		break;
 
 	case HCISETLINKPOL:
-		err = hci_req_sync(hdev, hci_linkpol_req, dr.dev_opt,
-				   HCI_INIT_TIMEOUT, NULL);
+		policy = cpu_to_le16(dr.dev_opt);
+
+		err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_DEF_LINK_POLICY,
+					    2, &policy,
+					    HCI_CMD_TIMEOUT);
 		break;
 
 	case HCISETLINKMODE:
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -280,6 +280,19 @@ int __hci_cmd_sync_status(struct hci_dev
 }
 EXPORT_SYMBOL(__hci_cmd_sync_status);
 
+int hci_cmd_sync_status(struct hci_dev *hdev, u16 opcode, u32 plen,
+			const void *param, u32 timeout)
+{
+	int err;
+
+	hci_req_sync_lock(hdev);
+	err = __hci_cmd_sync_status(hdev, opcode, plen, param, timeout);
+	hci_req_sync_unlock(hdev);
+
+	return err;
+}
+EXPORT_SYMBOL(hci_cmd_sync_status);
+
 static void hci_cmd_sync_work(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev, cmd_sync_work);
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6762,6 +6762,8 @@ static void l2cap_conless_channel(struct
 
 	BT_DBG("chan %p, len %d", chan, skb->len);
 
+	l2cap_chan_lock(chan);
+
 	if (chan->state != BT_BOUND && chan->state != BT_CONNECTED)
 		goto drop;
 
@@ -6778,6 +6780,7 @@ static void l2cap_conless_channel(struct
 	}
 
 drop:
+	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 free_skb:
 	kfree_skb(skb);
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1489,18 +1489,9 @@ static int l2cap_sock_recv_cb(struct l2c
 	struct l2cap_pinfo *pi;
 	int err;
 
-	/* To avoid race with sock_release, a chan lock needs to be added here
-	 * to synchronize the sock.
-	 */
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
 	sk = chan->data;
-
-	if (!sk) {
-		l2cap_chan_unlock(chan);
-		l2cap_chan_put(chan);
+	if (!sk)
 		return -ENXIO;
-	}
 
 	pi = l2cap_pi(sk);
 	lock_sock(sk);
@@ -1552,8 +1543,6 @@ static int l2cap_sock_recv_cb(struct l2c
 
 done:
 	release_sock(sk);
-	l2cap_chan_unlock(chan);
-	l2cap_chan_put(chan);
 
 	return err;
 }


