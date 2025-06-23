Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7065419049B;
	Mon, 23 Jun 2025 21:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715648; cv=none; b=pXjMsM7WtIJvuFyXxd1kyy/MoP4tQ7xCTmN4sxLLwUAfdohtpvZBfxUUOVRM3hjCPMNeIweprmgm+nnVvTlmzbE4G68nSVB1cXEShl/XJIkL/gHCg5Dm6nqPGQ3dJN+qgKcZAMeHrO/Anf5iqv3wlV+BX2CWrqPeGFxgm4K6y8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715648; c=relaxed/simple;
	bh=StpRzpAWNiOXPF3+UsKuVi70LFMH7IWf9FQOImF0+2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AisTSs0tnoXh7KUV9LeB8CvaX9Y0fCjGvyXbPhJ/QZaoHBM0yprbCrJUZAn0nOYdOHLFhqVL/bIbXEBwDV8qHenNKb5tppuAnpMoG2/y49kcVb6Q/IYmTVUmmQlUrKcq7j+d2SzyDEV42qTRI+tRzDKDghxB3bYGoX8a9vxd8sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RUQ0O/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RUQ0O/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096C4C4CEEA;
	Mon, 23 Jun 2025 21:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715648;
	bh=StpRzpAWNiOXPF3+UsKuVi70LFMH7IWf9FQOImF0+2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RUQ0O/wWCxuaEmArq4Yb5YMdN4wgWvdDiawj62zHAUpGKvW163xty9cHB+iGjRhC
	 b6ZUViA64zvD+4IWjpze1jXb8PYi3ykumtiJBYFu7ZhspUbq6cIIkruHXSqEjO5e6g
	 m3Iyc/3t2cYndsZTUmc+aSPle+hvMydwZtb1+pjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 253/508] Bluetooth: hci_sync: Fix broadcast/PA when using an existing instance
Date: Mon, 23 Jun 2025 15:04:58 +0200
Message-ID: <20250623130651.477938332@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c6108e68f5a91..bb4420cbc096b 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1539,7 +1539,8 @@ static int hci_enable_per_advertising_sync(struct hci_dev *hdev, u8 instance)
 static int hci_adv_bcast_annoucement(struct hci_dev *hdev, struct adv_info *adv)
 {
 	u8 bid[3];
-	u8 ad[4 + 3];
+	u8 ad[HCI_MAX_EXT_AD_LENGTH];
+	u8 len;
 
 	/* Skip if NULL adv as instance 0x00 is used for general purpose
 	 * advertising so it cannot used for the likes of Broadcast Announcement
@@ -1565,8 +1566,10 @@ static int hci_adv_bcast_annoucement(struct hci_dev *hdev, struct adv_info *adv)
 
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
@@ -1583,8 +1586,15 @@ int hci_start_per_adv_sync(struct hci_dev *hdev, u8 instance, u8 data_len,
 
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



