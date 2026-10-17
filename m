Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840363B8BD1;
	Sat, 17 Oct 2026 17:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257128; cv=none; b=UZ+dUsB+S709/Nc3xVXgJSEnfI+LC0itdUlhKRcv1Ees7ZIJ3g99fvoFQrt4eTiWXo5lMLN9Q/Ga3Padz/dp/bZfc1yvwF0AKXgtsh+uMuHbURm+Z+ESwF3OP3UOXB1zDpvA4FwvXOmCyf+NloL3aOKusUS4743+8CvPm6LTKAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257128; c=relaxed/simple;
	bh=vIpANn7cTA1kGRb3MmR1aDxkw1Qca1URIqFPjOFcwAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJT8bxoRnmz4oACgG0JA3jrfHUgkdlpRCM2F1xU4QAohAG3yYKvDRZDzm/5RtH1ngzkq6MHZ1v9eiKz0fhdVFXoGYuSmS5t804PgV7WTJxao0EZbMPldDHjFqpS++8E0R4MDjMoe4wTgpARoT6f+SjUWYgxNd82PBeRkAzJsw5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0G/uBSv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0G/uBSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFCE1F000CB;
	Sat, 17 Oct 2026 17:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257127;
	bh=DndQczsfH5zk/ayP5o4ED20vGP+SOk601/InpYfr7jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0G/uBSvpN2pt2OzUDhg5BA5Lh3fq43WAaLptPZimQtm74oTLLCO/B12tZHEdiDDf
	 t0G0GilJGghWmXsnw98FhjO7FrD0FyV4XxZtZypzLdZGJJJoayqC4jzLkm2S55u9mB
	 iBqppSPXjZFpNaoQp6MVTMphk4TLK9Vqv77/YK1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Iaroslav Voitovych <yaroslav.voytovych@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0460/1674] Bluetooth: hci_event: fix simultaneous discovery stuck in FINDING
Date: Sat, 17 Oct 2026 17:45:32 +0200
Message-ID: <20261017160442.925836474@linuxfoundation.org>
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

From: Jiajia Liu <liujiajia@kylinos.cn>

[ Upstream commit 96d006ae6445679436b945593950fd465eba7e76 ]

When hci_inquiry_complete_evt is called between le_scan_disable and
le_set_scan_enable_complete and no remote name needs to be resolved,
the interleaved discovery with SIMULTANEOUS quirk gets stuck in
DISCOVERY_FINDING. le_set_scan_enable_complete does not check inquiry
state. No one sets DISCOVERY_STOPPED in this process.

Add state check in le_set_scan_enable_complete and change state if
the state is DISCOVERY_FINDING. Tested with AX201 (8087:0026) in Dell
Vostro 13. Discovering disabled MGMT Event below is reported when
running into the above condition.

 @ MGMT Command: Start Discovery (0x0023)    {0x0001} [hci0] 10885.970873
         Address type: 0x07
           BR/EDR
           LE Public
           LE Random
 ...
 < HCI Command: LE Set Extended Scan Enable    #38205 [hci0] 10886.131438
         Extended scan: Enabled (0x01)
         Filter duplicates: Enabled (0x01)
         Duration: 0 msec (0x0000)
         Period: 0.00 sec (0x0000)
 > HCI Event: Command Complete (0x0e) plen 4   #38206 [hci0] 10886.133295
       LE Set Extended Scan Enable (0x08|0x0042) ncmd 2
         Status: Success (0x00)
 @ MGMT Event: Discovering (0x0013) plen 2   {0x0001} [hci0] 10886.133414
         Address type: 0x07
           BR/EDR
           LE Public
           LE Random
         Discovery: Enabled (0x01)
 < HCI Command: Inquiry (0x01|0x0001) plen 5   #38207 [hci0] 10886.133528
         Access code: 0x9e8b33 (General Inquiry)
         Length: 10.24s (0x08)
         Num responses: 0
 > HCI Event: Command Status (0x0f) plen 4     #38208 [hci0] 10886.141333
       Inquiry (0x01|0x0001) ncmd 2
         Status: Success (0x00)
 ...
 < HCI Command: LE Set Extended Scan Enable    #38242 [hci0] 10896.381802
         Extended scan: Disabled (0x00)
         Filter duplicates: Disabled (0x00)
         Duration: 0 msec (0x0000)
         Period: 0.00 sec (0x0000)
 > HCI Event: Inquiry Complete (0x01) plen 1   #38243 [hci0] 10896.383419
         Status: Success (0x00)
 > HCI Event: Command Complete (0x0e) plen 4   #38244 [hci0] 10896.394378
       LE Set Extended Scan Enable (0x08|0x0042) ncmd 2
         Status: Success (0x00)
 @ MGMT Event: Device Found (0x0012) plen 22 {0x0001} [hci0] 10896.394497
         LE Address: 88:12:AC:92:43:69
         RSSI: -101 dBm (0x9b)
         Flags: 0x00000004
           Not Connectable
         Data length: 8
         Company: Xiaomi Inc. (911)
           Data[0]:
         16-bit Service UUIDs (complete): 1 entry
           Xiaomi Inc. (0xfdaa)
 @ MGMT Event: Discovering (0x0013) plen 2   {0x0001} [hci0] 10896.394506
         Address type: 0x07
           BR/EDR
           LE Public
           LE Random
         Discovery: Disabled (0x00)

Fixes: 8ffde2a73f2c ("Bluetooth: Convert le_scan_disable timeout to hci_sync")
Signed-off-by: Jiajia Liu <liujiajia@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Iaroslav: test the quirk with test_bit() on hdev->quirks, as
  this branch does elsewhere; hci_test_quirk() does not exist here ]
Signed-off-by: Iaroslav Voitovych <yaroslav.voytovych@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 1a6fb75f2c1ea..d5f2be8783902 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1754,6 +1754,13 @@ static void le_set_scan_enable_complete(struct hci_dev *hdev, u8 enable)
 
 		hci_dev_clear_flag(hdev, HCI_LE_SCAN);
 
+		if (hdev->discovery.type == DISCOV_TYPE_INTERLEAVED &&
+		    test_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks) &&
+		    !test_bit(HCI_INQUIRY, &hdev->flags) &&
+		    hdev->discovery.state == DISCOVERY_FINDING) {
+			hci_discovery_set_state(hdev, DISCOVERY_STOPPED);
+		}
+
 		/* The HCI_LE_SCAN_INTERRUPTED flag indicates that we
 		 * interrupted scanning due to a connect request. Mark
 		 * therefore discovery as stopped.
-- 
2.53.0



