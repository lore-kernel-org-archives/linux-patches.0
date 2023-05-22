Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05CE171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301C1C433D2;
	Mon, 22 May 2023 19:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784620;
	bh=SHIJtT+/f6e2zoHBjSbl6lAvp2ZShP6iuhKQ6fD0XjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0xZcvehp/vzll9A4R0jNW+MgcP97eBx+qd/KHiKlK1ttaEk3Arf4t3cwHcMHY5gE
	 Zj0oQPYqf8gMcvnhonXlBzdEfR4+/HMQAkb8egq0WisaanjLFLRHkMtB12rfuSCnwo
	 TE48Ys7LpWp8wZkDaxJdJ6XhJqpGwq4YUnzkQ8TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	imoc <wzj9912@gmail.com>,
	Raul Cheleguini <raul.cheleguini@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 142/364] Bluetooth: Add new quirk for broken set random RPA timeout for ATS2851
Date: Mon, 22 May 2023 20:07:27 +0100
Message-Id: <20230522190416.321104959@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Raul Cheleguini <raul.cheleguini@gmail.com>

[ Upstream commit 91b6d02ddcd113352bdd895990b252065c596de7 ]

The ATS2851 based controller advertises support for command "LE Set Random
Private Address Timeout" but does not actually implement it, impeding the
controller initialization.

Add the quirk HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT to unblock the controller
initialization.

< HCI Command: LE Set Resolvable Private... (0x08|0x002e) plen 2
        Timeout: 900 seconds
> HCI Event: Command Status (0x0f) plen 4
      LE Set Resolvable Private Address Timeout (0x08|0x002e) ncmd 1
        Status: Unknown HCI Command (0x01)

Co-developed-by: imoc <wzj9912@gmail.com>
Signed-off-by: imoc <wzj9912@gmail.com>
Signed-off-by: Raul Cheleguini <raul.cheleguini@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c   | 1 +
 include/net/bluetooth/hci.h | 8 ++++++++
 net/bluetooth/hci_sync.c    | 6 +++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1ab5663b009d8..0923582299f3a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4106,6 +4106,7 @@ static int btusb_probe(struct usb_interface *intf,
 		/* Support is advertised, but not implemented */
 		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &hdev->quirks);
 	}
 
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 997107bfc0b12..07df96c47ef4f 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -301,6 +301,14 @@ enum {
 	 * don't actually support features declared there.
 	 */
 	HCI_QUIRK_BROKEN_LOCAL_EXT_FEATURES_PAGE_2,
+
+	/*
+	 * When this quirk is set, the HCI_OP_LE_SET_RPA_TIMEOUT command is
+	 * skipped during initialization. This is required for the Actions
+	 * Semiconductor ATS2851 based controllers, which erroneously claims
+	 * to support it.
+	 */
+	HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 632be12672887..b65ee3a32e5d7 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4093,7 +4093,8 @@ static int hci_le_set_rpa_timeout_sync(struct hci_dev *hdev)
 {
 	__le16 timeout = cpu_to_le16(hdev->rpa_timeout);
 
-	if (!(hdev->commands[35] & 0x04))
+	if (!(hdev->commands[35] & 0x04) ||
+	    test_bit(HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT, &hdev->quirks))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_RPA_TIMEOUT,
@@ -4533,6 +4534,9 @@ static const struct {
 			 "HCI Set Event Filter command not supported."),
 	HCI_QUIRK_BROKEN(ENHANCED_SETUP_SYNC_CONN,
 			 "HCI Enhanced Setup Synchronous Connection command is "
+			 "advertised, but not supported."),
+	HCI_QUIRK_BROKEN(SET_RPA_TIMEOUT,
+			 "HCI LE Set Random Private Address Timeout command is "
 			 "advertised, but not supported.")
 };
 
-- 
2.39.2



