Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230F9140E3C;
	Thu, 11 Apr 2024 10:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832104; cv=none; b=sM17U1TfGhu3j9YX4H3bC01kU8mIoE+OOJPduByNYy4nK9CcZmjDruwXbW3Jqrdmn+go07iKDD2zGsJSgedx1gPM7FtE+VIStqFeB1Y2vIcBW/iDQVX4mAV7biuwe864KxBYUx2CXiRUs/LtysTKlzsNufe1x2fJQKX1duR3Cd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832104; c=relaxed/simple;
	bh=im50JodZtUZUEleW1RofrP1NYo6QHv+SBYd/zwLwvm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdimO0/iQVx6/xuDf8nSD5b6hwbLtMnVdPGZnZxs2SQ/7GpRgWig02pWEiLQF79uQVGzivCp3Ti9XXdmp8cPACzoVYBVoszmCnVPaQ9lxaG8flXxgZiRiFXBHJsv07CApgk8mBjiCvVk2ESzZhpguoH0bY0t+oWQb217HDCs9gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDbZ6VeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDbZ6VeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D819C433F1;
	Thu, 11 Apr 2024 10:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832104;
	bh=im50JodZtUZUEleW1RofrP1NYo6QHv+SBYd/zwLwvm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDbZ6VeFFiofM23xwwIMfX3kDIGC3AMd/7JisxekLzKqQjhuHCUs8psoc9jKWIlEK
	 Xl1PY9HlAI23BbxuH165K5Y6P1NdfEikkh2d1vlJxZ9rYfqFxzfDSPH2XE4yR5gNxX
	 DM07TaK3FX1GQielhLCTfndr4iFlXTvy04hEQNzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Hui Wang <hui.wang@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 191/294] Bluetooth: hci_event: set the conn encrypted before conn establishes
Date: Thu, 11 Apr 2024 11:55:54 +0200
Message-ID: <20240411095441.364997512@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

commit c569242cd49287d53b73a94233db40097d838535 upstream.

We have a BT headset (Lenovo Thinkplus XT99), the pairing and
connecting has no problem, once this headset is paired, bluez will
remember this device and will auto re-connect it whenever the device
is powered on. The auto re-connecting works well with Windows and
Android, but with Linux, it always fails. Through debugging, we found
at the rfcomm connection stage, the bluetooth stack reports
"Connection refused - security block (0x0003)".

For this device, the re-connecting negotiation process is different
from other BT headsets, it sends the Link_KEY_REQUEST command before
the CONNECT_REQUEST completes, and it doesn't send ENCRYPT_CHANGE
command during the negotiation. When the device sends the "connect
complete" to hci, the ev->encr_mode is 1.

So here in the conn_complete_evt(), if ev->encr_mode is 1, link type
is ACL and HCI_CONN_ENCRYPT is not set, we set HCI_CONN_ENCRYPT to
this conn, and update conn->enc_key_size accordingly.

After this change, this BT headset could re-connect with Linux
successfully. This is the btmon log after applying the patch, after
receiving the "Connect Complete" with "Encryption: Enabled", will send
the command to read encryption key size:
> HCI Event: Connect Request (0x04) plen 10
        Address: 8C:3C:AA:D8:11:67 (OUI 8C-3C-AA)
        Class: 0x240404
          Major class: Audio/Video (headset, speaker, stereo, video, vcr)
          Minor class: Wearable Headset Device
          Rendering (Printing, Speaker)
          Audio (Speaker, Microphone, Headset)
        Link type: ACL (0x01)
...
> HCI Event: Link Key Request (0x17) plen 6
        Address: 8C:3C:AA:D8:11:67 (OUI 8C-3C-AA)
< HCI Command: Link Key Request Reply (0x01|0x000b) plen 22
        Address: 8C:3C:AA:D8:11:67 (OUI 8C-3C-AA)
        Link key: ${32-hex-digits-key}
...
> HCI Event: Connect Complete (0x03) plen 11
        Status: Success (0x00)
        Handle: 256
        Address: 8C:3C:AA:D8:11:67 (OUI 8C-3C-AA)
        Link type: ACL (0x01)
        Encryption: Enabled (0x01)
< HCI Command: Read Encryption Key... (0x05|0x0008) plen 2
        Handle: 256
< ACL Data TX: Handle 256 flags 0x00 dlen 10
      L2CAP: Information Request (0x0a) ident 1 len 2
        Type: Extended features supported (0x0002)
> HCI Event: Command Complete (0x0e) plen 7
      Read Encryption Key Size (0x05|0x0008) ncmd 1
        Status: Success (0x00)
        Handle: 256
        Key size: 16

Cc: stable@vger.kernel.org
Link: https://github.com/bluez/bluez/issues/704
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2636,6 +2636,31 @@ static void hci_conn_complete_evt(struct
 		if (test_bit(HCI_ENCRYPT, &hdev->flags))
 			set_bit(HCI_CONN_ENCRYPT, &conn->flags);
 
+		/* "Link key request" completed ahead of "connect request" completes */
+		if (ev->encr_mode == 1 && !test_bit(HCI_CONN_ENCRYPT, &conn->flags) &&
+		    ev->link_type == ACL_LINK) {
+			struct link_key *key;
+			struct hci_cp_read_enc_key_size cp;
+
+			key = hci_find_link_key(hdev, &ev->bdaddr);
+			if (key) {
+				set_bit(HCI_CONN_ENCRYPT, &conn->flags);
+
+				if (!(hdev->commands[20] & 0x10)) {
+					conn->enc_key_size = HCI_LINK_KEY_SIZE;
+				} else {
+					cp.handle = cpu_to_le16(conn->handle);
+					if (hci_send_cmd(hdev, HCI_OP_READ_ENC_KEY_SIZE,
+							 sizeof(cp), &cp)) {
+						bt_dev_err(hdev, "sending read key size failed");
+						conn->enc_key_size = HCI_LINK_KEY_SIZE;
+					}
+				}
+
+				hci_encrypt_cfm(conn, ev->status);
+			}
+		}
+
 		/* Get remote features */
 		if (conn->type == ACL_LINK) {
 			struct hci_cp_read_remote_features cp;


