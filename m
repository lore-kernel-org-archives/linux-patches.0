Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A113231354D;
	Tue,  2 Sep 2025 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819494; cv=none; b=H1cusEm/mX8vKesT4JAUgQaVos5UrbZtt0ILoKaI7Orpzc4dp9NJA0xhzsAVsMq4pG0goRtYjAtT26NuVpBhk5AuGF+ROOw4ummvNahAvgbZ+rjTLOwHKdZV31IdadksdIGUcLym30otrThz5WxpCUi2n9FdnmU8es3BqQLoRco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819494; c=relaxed/simple;
	bh=JTT4bpKGzeYTgYOTCC5JC6kusNie83r9YTUomF6XNGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSorLbI7/w7LrzhZ9T1Wol/3L/yo3vhXB+Ur28bMmsmUiUcGnohcmpVGFyouHBgwG3fmbpdJAQuutEok+KtmB7O4mUgcSm0FM6zPyYcEDoDIdcigFxyH7DR1HcNs6P/HgXQ4sGfbaPCWgWlNnloIjvqhEkzYWFFzJ4XXBv7MEJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzEy3j0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzEy3j0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0F3C4CEED;
	Tue,  2 Sep 2025 13:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819493;
	bh=JTT4bpKGzeYTgYOTCC5JC6kusNie83r9YTUomF6XNGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzEy3j0aMimRlUjXmkBPbTfvqEbPK8TJPH4h3bLddqi1UIjgjxKsjVN0ZCPgL7LbC
	 j+S+xwRj3hmbZUoJevRpe4a8eLLBXOV6L2LfhuwboMsl6N25l3rpnr/OyieO5aSoHN
	 ghZ1lDUCIqucD5x8FUKSeQm55KQuWhFC1yuB13iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 050/142] Bluetooth: hci_event: Disconnect device when BIG sync is lost
Date: Tue,  2 Sep 2025 15:19:12 +0200
Message-ID: <20250902131950.171028686@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.li@amlogic.com>

[ Upstream commit 55b9551fcdf6a2fe7f3422918d5697b56794da72 ]

When a BIG sync is lost, the device should be set to "disconnected".
This ensures symmetry with the ISO path setup, where the device is
marked as "connected" once the path is established. Without this
change, the device state remains inconsistent and may lead to a
memory leak.

Fixes: b2a5f2e1c127 ("Bluetooth: hci_event: Add support for handling LE BIG Sync Lost event")
Signed-off-by: Yang Li <yang.li@amlogic.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 5 +++++
 net/bluetooth/mgmt.c      | 4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 02b2ef9a75746..0ffdbe249f5d3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -7019,6 +7019,7 @@ static void hci_le_big_sync_lost_evt(struct hci_dev *hdev, void *data,
 {
 	struct hci_evt_le_big_sync_lost *ev = data;
 	struct hci_conn *bis, *conn;
+	bool mgmt_conn;
 
 	bt_dev_dbg(hdev, "big handle 0x%2.2x", ev->handle);
 
@@ -7037,6 +7038,10 @@ static void hci_le_big_sync_lost_evt(struct hci_dev *hdev, void *data,
 	while ((bis = hci_conn_hash_lookup_big_state(hdev, ev->handle,
 						     BT_CONNECTED,
 						     HCI_ROLE_SLAVE))) {
+		mgmt_conn = test_and_clear_bit(HCI_CONN_MGMT_CONNECTED, &bis->flags);
+		mgmt_device_disconnected(hdev, &bis->dst, bis->type, bis->dst_type,
+					 ev->reason, mgmt_conn);
+
 		clear_bit(HCI_CONN_BIG_SYNC, &bis->flags);
 		hci_disconn_cfm(bis, ev->reason);
 		hci_conn_del(bis);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 3166f5fb876b1..90e37ff2c85db 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9705,7 +9705,9 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	if (!mgmt_connected)
 		return;
 
-	if (link_type != ACL_LINK && link_type != LE_LINK)
+	if (link_type != ACL_LINK &&
+	    link_type != LE_LINK  &&
+	    link_type != BIS_LINK)
 		return;
 
 	bacpy(&ev.addr.bdaddr, bdaddr);
-- 
2.50.1



