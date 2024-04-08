Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC04A7F465;
	Mon,  8 Apr 2024 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584987; cv=none; b=ZYTPTHbh59xd5ZYjDKP0Y/Kgz1rIRMC1yEl41utghYWQ7JqUDmWeXwB07NwrhSlb9aLy/8PYbNC32e+H40oC445DhY5aEjYlLgx7E0IYzzUR7YRkg4vl2J0kErnQbbj1AznlPIcCQvWVI6b31masnFNc1/5Yn3YVDzkoKS6i/XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584987; c=relaxed/simple;
	bh=Ar2ZlbZg306hAuknfIGwvRyA/Ies6ibP/m86o5vIn7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSpdeVkuVhslephEmnsCbHNwicELjQTefCScWjf0a1qjqhINazD6xl33AOspMCP0abO366lMo0tfGjPUGbAV+3vYBgNGADLWELfK/g0t2Q93IApFqx1JJw8sB2oJPgHeBhBiYmCaZ1aC4NDtR9S3CPRbpg3DtnfZexYOKU86Kkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffvUOQyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffvUOQyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52717C433F1;
	Mon,  8 Apr 2024 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584987;
	bh=Ar2ZlbZg306hAuknfIGwvRyA/Ies6ibP/m86o5vIn7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffvUOQyYtsD4DTbxLRbY2YQIISLMPTmedBRScCDhjXGWfQ46RdLc/BrOgCvqv/AAM
	 ZikwlcByAEwqmY0QCKt23N5ZQO8KPbKsd0POjOQNMyB+49SlW9yTGN/5apt/jVDTfg
	 rL5VZswTVl85oTAEz/oKAWTY3fwGal3JA1J0avqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Hui Wang <hui.wang@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 625/690] Bluetooth: hci_event: set the conn encrypted before conn establishes
Date: Mon,  8 Apr 2024 14:58:11 +0200
Message-ID: <20240408125422.283436124@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2729,6 +2729,31 @@ static void hci_conn_complete_evt(struct
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


