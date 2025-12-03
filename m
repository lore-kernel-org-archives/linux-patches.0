Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADE0314A99;
	Wed,  3 Dec 2025 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776797; cv=none; b=rupozPkxH58NFR/XpAzOczT6K8VyxbNUZW9uCTJPeHHEEVFgkAzIdzVUJUu4h//c6qRv5Gu6YgyqEGJRuiiSyEbr93NxYrQPWuW4h2nClbXRAJfdszG17OxmvfxIzTwHe/3nHRalfigXu5n+iSWZWSPb/NCFS/l16Emy41za9NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776797; c=relaxed/simple;
	bh=thZ4wmJ8UTDMhjY0LtUXl6eM4D3VjZ7IBIXzwSFHtXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSJU4MwJ/pelKVmo3L0ReoV2hcV+ANmD3p8n7gEP2482dCovP3cITydz3nxibOrUyO5TLHK5ykSZuG4sLt0p5bDLGY9ZKjSsj0eGmuaW9jdiGTX+8csCj0u7uR2at2ph4RVEC5DfcAWPGRERaO2gDsXepJqdg2/vymEHEhXEzcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeL3XI/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeL3XI/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08558C4CEF5;
	Wed,  3 Dec 2025 15:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776797;
	bh=thZ4wmJ8UTDMhjY0LtUXl6eM4D3VjZ7IBIXzwSFHtXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeL3XI/ldsvhUaJyg0JGtR6JsVf3/si8wotV1rU4KIvPHqbbmVvVljqIHF2+j8GTl
	 CcYPeR/60nD2AOk0vf1QFMBb8zq0qNJkjM7kQgtk/2DRYMg6oCpBP0tM4Y4hJAYbqa
	 7dHoGM7FMuhO3FenF/6fE2ZaM1pWw+7znBtzSpa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lu <alex_lu@realsil.com.cn>,
	Max Chou <max.chou@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Nazar Kalashnikov <sivartiwe@gmail.com>
Subject: [PATCH 5.10 291/300] Bluetooth: Add more enc key size check
Date: Wed,  3 Dec 2025 16:28:15 +0100
Message-ID: <20251203152411.402480641@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Lu <alex_lu@realsil.com.cn>

[ Upstream commit 04a342cc49a8522e99c9b3346371c329d841dcd2 ]

When we are slave role and receives l2cap conn req when encryption has
started, we should check the enc key size to avoid KNOB attack or BLUFFS
attack.
>From SIG recommendation, implementations are advised to reject
service-level connections on an encrypted baseband link with key
strengths below 7 octets.
A simple and clear way to achieve this is to place the enc key size
check in hci_cc_read_enc_key_size()

The btmon log below shows the case that lacks enc key size check.

> HCI Event: Connect Request (0x04) plen 10
        Address: BB:22:33:44:55:99 (OUI BB-22-33)
        Class: 0x480104
          Major class: Computer (desktop, notebook, PDA, organizers)
          Minor class: Desktop workstation
          Capturing (Scanner, Microphone)
          Telephony (Cordless telephony, Modem, Headset)
        Link type: ACL (0x01)
< HCI Command: Accept Connection Request (0x01|0x0009) plen 7
        Address: BB:22:33:44:55:99 (OUI BB-22-33)
        Role: Peripheral (0x01)
> HCI Event: Command Status (0x0f) plen 4
      Accept Connection Request (0x01|0x0009) ncmd 2
        Status: Success (0x00)
> HCI Event: Connect Complete (0x03) plen 11
        Status: Success (0x00)
        Handle: 1
        Address: BB:22:33:44:55:99 (OUI BB-22-33)
        Link type: ACL (0x01)
        Encryption: Disabled (0x00)
...

> HCI Event: Encryption Change (0x08) plen 4
        Status: Success (0x00)
        Handle: 1 Address: BB:22:33:44:55:99 (OUI BB-22-33)
        Encryption: Enabled with E0 (0x01)
< HCI Command: Read Encryption Key Size (0x05|0x0008) plen 2
        Handle: 1 Address: BB:22:33:44:55:99 (OUI BB-22-33)
> HCI Event: Command Complete (0x0e) plen 7
      Read Encryption Key Size (0x05|0x0008) ncmd 2
        Status: Success (0x00)
        Handle: 1 Address: BB:22:33:44:55:99 (OUI BB-22-33)
        Key size: 6
// We should check the enc key size
...

> ACL Data RX: Handle 1 flags 0x02 dlen 12
      L2CAP: Connection Request (0x02) ident 3 len 4
        PSM: 25 (0x0019)
        Source CID: 64
< ACL Data TX: Handle 1 flags 0x00 dlen 16
      L2CAP: Connection Response (0x03) ident 3 len 8
        Destination CID: 64
        Source CID: 64
        Result: Connection pending (0x0001)
        Status: Authorization pending (0x0002)
> HCI Event: Number of Completed Packets (0x13) plen 5
        Num handles: 1
        Handle: 1 Address: BB:22:33:44:55:99 (OUI BB-22-33)
        Count: 1
        #35: len 16 (25 Kb/s)
        Latency: 5 msec (2-7 msec ~4 msec)
< ACL Data TX: Handle 1 flags 0x00 dlen 16
      L2CAP: Connection Response (0x03) ident 3 len 8
        Destination CID: 64
        Source CID: 64
        Result: Connection successful (0x0000)
        Status: No further information available (0x0000)

Cc: stable@vger.kernel.org
Signed-off-by: Alex Lu <alex_lu@realsil.com.cn>
Signed-off-by: Max Chou <max.chou@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Nazar Kalashnikov: change status to 
rp_status due to function parameter conflict ]
Signed-off-by: Nazar Kalashnikov <sivartiwe@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Backport fix for CVE-2023-24023
 net/bluetooth/hci_event.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3043,6 +3043,7 @@ static void read_enc_key_size_complete(s
 	const struct hci_rp_read_enc_key_size *rp;
 	struct hci_conn *conn;
 	u16 handle;
+	u8 rp_status;
 
 	BT_DBG("%s status 0x%02x", hdev->name, status);
 
@@ -3052,6 +3053,7 @@ static void read_enc_key_size_complete(s
 	}
 
 	rp = (void *)skb->data;
+	rp_status = rp->status;
 	handle = le16_to_cpu(rp->handle);
 
 	hci_dev_lock(hdev);
@@ -3064,15 +3066,30 @@ static void read_enc_key_size_complete(s
 	 * secure approach is to then assume the key size is 0 to force a
 	 * disconnection.
 	 */
-	if (rp->status) {
+	if (rp_status) {
 		bt_dev_err(hdev, "failed to read key size for handle %u",
 			   handle);
 		conn->enc_key_size = 0;
 	} else {
 		conn->enc_key_size = rp->key_size;
+		rp_status = 0;
+
+		if (conn->enc_key_size < hdev->min_enc_key_size) {
+			/* As slave role, the conn->state has been set to
+			 * BT_CONNECTED and l2cap conn req might not be received
+			 * yet, at this moment the l2cap layer almost does
+			 * nothing with the non-zero status.
+			 * So we also clear encrypt related bits, and then the
+			 * handler of l2cap conn req will get the right secure
+			 * state at a later time.
+			 */
+			rp_status = HCI_ERROR_AUTH_FAILURE;
+			clear_bit(HCI_CONN_ENCRYPT, &conn->flags);
+			clear_bit(HCI_CONN_AES_CCM, &conn->flags);
+		}
 	}
 
-	hci_encrypt_cfm(conn, 0);
+	hci_encrypt_cfm(conn, rp_status);
 
 unlock:
 	hci_dev_unlock(hdev);


