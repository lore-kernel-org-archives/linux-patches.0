Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CC71F76AD;
	Tue,  3 Dec 2024 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241282; cv=none; b=Cu0k/j6UyvAcDC4NmyEo03S6uAT1zTYt8u3FBmTwGap+1es70vtLR4wizkZG15WEZID7mqkYbYYgvXI5MIcXojV/Uzhl8owj9dCfGb2/MKnc4Sgd1WvQsAzLssZgbOYYi2f3h7jgEl+0lZn8yOERJoodnmT71ZJ+3ZozLDRnEss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241282; c=relaxed/simple;
	bh=WC8qtgfB8uURfYV+fNvhxXsb1X4bXig9iKFNzxSfYEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QISioiSWUx5hdc8bDe40I2boIBLuKtzvWahyS7nFbqROrjB0IixL/Yl9fx0eekSwNaZcN3qKAsp8xaDuI/Qbo4hXGqwLxzt5haeNW1416ugliTGjM+G2c1/SRlFPZk0w7so02+Z0Kii6snkXILy1bdHEDlEfHHu52tU8JegPSoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cr8bZSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cr8bZSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082C3C4CED8;
	Tue,  3 Dec 2024 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241282;
	bh=WC8qtgfB8uURfYV+fNvhxXsb1X4bXig9iKFNzxSfYEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cr8bZSOtnMABy5lfxG8j765xtW5plkbJe0pKh/5OxFPB9sNsxIDejDotXH5dHYSk
	 nFSTyz0UyHoULAnD4rRvbb2w9IC8lLH2uBmw3xznD7TGpaqUGEcKxmrxfZPCifEx1z
	 YzkeBTIAya6TNz/y9rQmoazgsJHTv7qd8F/nURUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 344/826] Bluetooth: ISO: Send BIG Create Sync via hci_sync
Date: Tue,  3 Dec 2024 15:41:11 +0100
Message-ID: <20241203144757.179462275@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 07a9342b94a91b306ed1cf6aa8254aea210764c9 ]

Before issuing the LE BIG Create Sync command, an available BIG handle
is chosen by iterating through the conn_hash list and finding the first
unused value.

If a BIG is terminated, the associated hcons are removed from the list
and the LE BIG Terminate Sync command is sent via hci_sync queue.
However, a new LE BIG Create sync command might be issued via
hci_send_cmd, before the previous BIG sync was terminated. This
can cause the same BIG handle to be reused and the LE BIG Create Sync
to fail with Command Disallowed.

< HCI Command: LE Broadcast Isochronous Group Create Sync (0x08|0x006b)
        BIG Handle: 0x00
        BIG Sync Handle: 0x0002
        Encryption: Unencrypted (0x00)
        Broadcast Code[16]: 00000000000000000000000000000000
        Maximum Number Subevents: 0x00
        Timeout: 20000 ms (0x07d0)
        Number of BIS: 1
        BIS ID: 0x01
> HCI Event: Command Status (0x0f) plen 4
      LE Broadcast Isochronous Group Create Sync (0x08|0x006b) ncmd 1
        Status: Command Disallowed (0x0c)
< HCI Command: LE Broadcast Isochronous Group Terminate Sync (0x08|0x006c)
        BIG Handle: 0x00

This commit fixes the ordering of the LE BIG Create Sync/LE BIG Terminate
Sync commands, to make sure that either the previous BIG sync is
terminated before reusing the handle, or that a new handle is chosen
for a new sync.

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 17 ++++++++++++++++-
 net/bluetooth/iso.c      |  9 +++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 1ff62bf9d41b4..6354cdf9c2b37 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2188,7 +2188,15 @@ static bool hci_conn_check_create_big_sync(struct hci_conn *conn)
 	return true;
 }
 
-int hci_le_big_create_sync_pending(struct hci_dev *hdev)
+static void big_create_sync_complete(struct hci_dev *hdev, void *data, int err)
+{
+	bt_dev_dbg(hdev, "");
+
+	if (err)
+		bt_dev_err(hdev, "Unable to create BIG sync: %d", err);
+}
+
+static int big_create_sync(struct hci_dev *hdev, void *data)
 {
 	DEFINE_FLEX(struct hci_cp_le_big_create_sync, pdu, bis, num_bis, 0x11);
 	struct hci_conn *conn;
@@ -2245,6 +2253,13 @@ int hci_le_big_create_sync_pending(struct hci_dev *hdev)
 			    struct_size(pdu, bis, pdu->num_bis), pdu);
 }
 
+int hci_le_big_create_sync_pending(struct hci_dev *hdev)
+{
+	/* Queue big_create_sync */
+	return hci_cmd_sync_queue_once(hdev, big_create_sync,
+				       NULL, big_create_sync_complete);
+}
+
 int hci_le_big_create_sync(struct hci_dev *hdev, struct hci_conn *hcon,
 			   struct bt_iso_qos *qos,
 			   __u16 sync_handle, __u8 num_bis, __u8 bis[])
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 463c61712b249..5e2d9758bd3c1 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1392,6 +1392,13 @@ static void iso_conn_big_sync(struct sock *sk)
 	if (!hdev)
 		return;
 
+	/* hci_le_big_create_sync requires hdev lock to be held, since
+	 * it enqueues the HCI LE BIG Create Sync command via
+	 * hci_cmd_sync_queue_once, which checks hdev flags that might
+	 * change.
+	 */
+	hci_dev_lock(hdev);
+
 	if (!test_and_set_bit(BT_SK_BIG_SYNC, &iso_pi(sk)->flags)) {
 		err = hci_le_big_create_sync(hdev, iso_pi(sk)->conn->hcon,
 					     &iso_pi(sk)->qos,
@@ -1402,6 +1409,8 @@ static void iso_conn_big_sync(struct sock *sk)
 			bt_dev_err(hdev, "hci_le_big_create_sync: %d",
 				   err);
 	}
+
+	hci_dev_unlock(hdev);
 }
 
 static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
-- 
2.43.0



