Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87467266EFC;
	Tue,  8 Apr 2025 11:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111078; cv=none; b=q7Ibyjgrm9qGh3NEtMlH6OOLMwNs2+yWpoFUb+tFUEpnhVVMQO+98UEkP8x1K7Q2Wsb91vRY+bHM+IghWBZbbe4d1oztqAK7caPD3h9ryuLnmipY68Ak3c44+TSE/dmt+eXCxLdzwCsF1KCvLW7mvrYgF900ZF+1M4NtpPjEWrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111078; c=relaxed/simple;
	bh=fm4Bc2o+UrQK2hqduhR0hm1yUCWT8HhqK8C/ilHTyoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNqrsfIqMhmZZnafAL4wu1L1q9wHQOf4l6GHY/2khjdReXUmnw9SFM6ccNqLcLNcnJoRfOYm75aID9sGsu/leQlPh6eczIXMLshCelw71q3Qi+3qHdIMgUCJ7EZyPqxjxrDSQpKQCZ5JeYDH0MBTGgAzlwpowJjZrZDur+xZ/dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQDd4pZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQDd4pZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153BBC4CEE5;
	Tue,  8 Apr 2025 11:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111078;
	bh=fm4Bc2o+UrQK2hqduhR0hm1yUCWT8HhqK8C/ilHTyoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQDd4pZd6Uea8FeQ74e/qqSoWqbSBPLNZ7pwsaMg5BNVBo4ekx04HwdheOvb96FcU
	 vSB+CHBEXecCD+UbFONjoUxdmBj5hyn/4VnLV0cf9w1Ly6J1hocdfOUJIlF9Pu2Ean
	 J6kXKAcbEVzk/g/S5989KLiUAC7CxOjW+4HVCf5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 261/731] Bluetooth: hci_event: Fix handling of HCI_EV_LE_DIRECT_ADV_REPORT
Date: Tue,  8 Apr 2025 12:42:38 +0200
Message-ID: <20250408104920.354203545@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 3a7fdfb7d876910cfe734488f553dbbc938f8f16 ]

Some controllers seems to generate HCI_EV_LE_DIRECT_ADV_REPORT even when
scan_filter is not set to 0x02 or 0x03, which indicates that local
privacy is enabled, causing them to be ignored thus breaking
auto-connect logic:

< HCI Command: LE Set Scan Parameters (0x08|0x000b) plen 7
        Type: Passive (0x00)
        Interval: 60.000 msec (0x0060)
        Window: 30.000 msec (0x0030)
        Own address type: Public (0x00)
        Filter policy: Ignore not in accept list (0x01)
...
> HCI Event: LE Meta Event (0x3e) plen 18
      LE Direct Advertising Report (0x0b)
        Num reports: 1
        Event type: Connectable directed - ADV_DIRECT_IND (0x01)
        Address type: Random (0x01)
        Address: XX:XX:XX:XX:XX:XX (Static)
        Direct address type: Random (0x01)
        Direct address: XX:XX:XX:XX:XX:XX (Non-Resolvable)
        RSSI: -54 dBm (0xca)

So this attempts to mitigate the above problem by skipping checking of
direct_addr if local privacy is not enabled.

Link: https://github.com/bluez/bluez/issues/1138
Fixes: e209e5ccc5ac ("Bluetooth: MGMT: Mark LL Privacy as stable")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index dd86b7a242b72..e2bfbcee06a80 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6053,8 +6053,17 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 	 * a LE Direct Advertising Report event. In that case it is
 	 * important to see if the address is matching the local
 	 * controller address.
+	 *
+	 * If local privacy is not enable the controller shall not be
+	 * generating such event since according to its documentation it is only
+	 * valid for filter_policy 0x02 and 0x03, but the fact that it did
+	 * generate LE Direct Advertising Report means it is probably broken and
+	 * won't generate any other event which can potentially break
+	 * auto-connect logic so in case local privacy is not enable this
+	 * ignores the direct_addr so it works as a regular report.
 	 */
-	if (!hci_dev_test_flag(hdev, HCI_MESH) && direct_addr) {
+	if (!hci_dev_test_flag(hdev, HCI_MESH) && direct_addr &&
+	    hci_dev_test_flag(hdev, HCI_PRIVACY)) {
 		direct_addr_type = ev_bdaddr_type(hdev, direct_addr_type,
 						  &bdaddr_resolved);
 
@@ -6064,12 +6073,6 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 		if (!hci_bdaddr_is_rpa(direct_addr, direct_addr_type))
 			return;
 
-		/* If the controller is not using resolvable random
-		 * addresses, then this report can be ignored.
-		 */
-		if (!hci_dev_test_flag(hdev, HCI_PRIVACY))
-			return;
-
 		/* If the local IRK of the controller does not match
 		 * with the resolvable random address provided, then
 		 * this report can be ignored.
-- 
2.39.5



