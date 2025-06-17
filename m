Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8BC2EA161;
	Tue, 17 Jun 2025 16:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178177; cv=none; b=iS9EfUd9LMc17mVyAwwNvNk5kDCV3a7PB6QIeLL4SOWGi5luwruWGOSKB69etgs9j4/NmKT7gcV0fhO36A1zq40WZG87jNR4KNwC+TRjPR52e9SMLLGHna7pZ0WSBY/kxXUIopiC5QAA4lyHE739CZ2Qm+QFiK5nN4BYheFYc18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178177; c=relaxed/simple;
	bh=LdXTvprbEKpmZtsGvfqo+aY0+UON8pnucEklWlUj2g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqTY7w8Zb7CH7CGvbHWI9Zq0jsMii3ETgSu/YFr/WZmULpaY9WXb4xewss6JxZOlLYSjGJ+P07sSVJh7KlwUSzQvo9a8VRjwByZajvR7PZUCHl/WIaPzn5eA79iYS+4+9V4OshWUPO7UNbgikCyyHX6ZKSWsnHG8e45JIJQJMhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gfpjmx4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gfpjmx4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD884C4CEE7;
	Tue, 17 Jun 2025 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178177;
	bh=LdXTvprbEKpmZtsGvfqo+aY0+UON8pnucEklWlUj2g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gfpjmx4EIc92dhtcuAyuWBRnReR3RKk1Wl5qLMKwGCd5CSL9ezS8jwR2Oo9SKU5Oq
	 tOzC9Do+ZrMzmenwCslFGTVxXQfwF79AIrXrXh0DLwheNPfbXA+RDiWMZBj2Qu7uE2
	 lUbf/rT8KOluUVTnNOiEF2PyQeixDD9NqW9hi0X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 457/512] Bluetooth: hci_sync: Fix broadcast/PA when using an existing instance
Date: Tue, 17 Jun 2025 17:27:03 +0200
Message-ID: <20250617152438.089943160@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5725bc608252050ed8a4d47d59225b7dd73474c8 ]

When using and existing adv_info instance for broadcast source it
needs to be updated to periodic first before it can be reused, also in
case the existing instance already have data hci_set_adv_instance_data
cannot be used directly since it would overwrite the existing data so
this reappend the original data after the Broadcast ID, if one was
generated.

Example:

bluetoothctl># Add PBP to EA so it can be later referenced as the BIS ID
bluetoothctl> advertise.service 0x1856 0x00 0x00
bluetoothctl> advertise on
...
< HCI Command: LE Set Extended Advertising Data (0x08|0x0037) plen 13
        Handle: 0x01
        Operation: Complete extended advertising data (0x03)
        Fragment preference: Minimize fragmentation (0x01)
        Data length: 0x09
        Service Data: Public Broadcast Announcement (0x1856)
          Data[2]: 0000
        Flags: 0x06
          LE General Discoverable Mode
          BR/EDR Not Supported
...
bluetoothctl># Attempt to acquire Broadcast Source transport
bluetoothctl>transport.acquire /org/bluez/hci0/pac_bcast0/fd0
...
< HCI Command: LE Set Extended Advertising Data (0x08|0x0037) plen 255
        Handle: 0x01
        Operation: Complete extended advertising data (0x03)
        Fragment preference: Minimize fragmentation (0x01)
        Data length: 0x0e
        Service Data: Broadcast Audio Announcement (0x1852)
        Broadcast ID: 11371620 (0xad8464)
        Service Data: Public Broadcast Announcement (0x1856)
          Data[2]: 0000
        Flags: 0x06
          LE General Discoverable Mode
          BR/EDR Not Supported

Link: https://github.com/bluez/bluez/issues/1117
Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 59011f45906a1..3fb70b4ee8c8a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1559,7 +1559,8 @@ static int hci_enable_per_advertising_sync(struct hci_dev *hdev, u8 instance)
 static int hci_adv_bcast_annoucement(struct hci_dev *hdev, struct adv_info *adv)
 {
 	u8 bid[3];
-	u8 ad[4 + 3];
+	u8 ad[HCI_MAX_EXT_AD_LENGTH];
+	u8 len;
 
 	/* Skip if NULL adv as instance 0x00 is used for general purpose
 	 * advertising so it cannot used for the likes of Broadcast Announcement
@@ -1585,8 +1586,10 @@ static int hci_adv_bcast_annoucement(struct hci_dev *hdev, struct adv_info *adv)
 
 	/* Generate Broadcast ID */
 	get_random_bytes(bid, sizeof(bid));
-	eir_append_service_data(ad, 0, 0x1852, bid, sizeof(bid));
-	hci_set_adv_instance_data(hdev, adv->instance, sizeof(ad), ad, 0, NULL);
+	len = eir_append_service_data(ad, 0, 0x1852, bid, sizeof(bid));
+	memcpy(ad + len, adv->adv_data, adv->adv_data_len);
+	hci_set_adv_instance_data(hdev, adv->instance, len + adv->adv_data_len,
+				  ad, 0, NULL);
 
 	return hci_update_adv_data_sync(hdev, adv->instance);
 }
@@ -1603,8 +1606,15 @@ int hci_start_per_adv_sync(struct hci_dev *hdev, u8 instance, u8 data_len,
 
 	if (instance) {
 		adv = hci_find_adv_instance(hdev, instance);
-		/* Create an instance if that could not be found */
-		if (!adv) {
+		if (adv) {
+			/* Turn it into periodic advertising */
+			adv->periodic = true;
+			adv->per_adv_data_len = data_len;
+			if (data)
+				memcpy(adv->per_adv_data, data, data_len);
+			adv->flags = flags;
+		} else if (!adv) {
+			/* Create an instance if that could not be found */
 			adv = hci_add_per_instance(hdev, instance, flags,
 						   data_len, data,
 						   sync_interval,
-- 
2.39.5



