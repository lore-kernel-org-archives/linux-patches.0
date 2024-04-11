Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97F5146A8F;
	Thu, 11 Apr 2024 10:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830841; cv=none; b=k5xe6iA7dFNIydCQdEnyx3eGndDD9U2ObQBBCqxoIZwMIDu0Biolav5MZZTB/tMHFGkiKeor5Uk6Z0Mw6Ulso1H6bqPNUCRqnLMY12lbCnR48sDMbx1VR5yO3rOrk+aUKkIaGo725kZQqR5AcrE2KelgUi6BP1upp4pXFamZ8Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830841; c=relaxed/simple;
	bh=DqtuvfKP9+a7wQ9xuhrKLKqx120tJQenJYRjG1NDatc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nz+byzOJDDujFuDykaUFcrrL1NLhnhYt6Uualgrww1zX7EdIIVLOeOzInuz9EK9IHYE7YjCtIIirdqq50EMXxZ9T72KWQmc9bLwD1eT2IInA71iqJm+MM1P6f5KWaQXDisKPt4KPOiigwsLvy8g4P0cOtJrzSuAg0IrQ55CpwXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKZNahKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKZNahKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1FDC433F1;
	Thu, 11 Apr 2024 10:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830841;
	bh=DqtuvfKP9+a7wQ9xuhrKLKqx120tJQenJYRjG1NDatc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKZNahKlVyjt3gGYky5t6yhxT6VFCM/jPNro1NZgXEfBOu0q16MfTSYJVH4nCFOvt
	 nV4wxX22FppmrejaMNopMbm8YoeZIEzh0zxP1xDv1XMPA/EIMvzmY3OtKIEHGWhmy0
	 BpFBq5e3iuREpMyo4lRyIn9Tbn9RG0ACM0Eq3Tz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Hui Wang <hui.wang@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.4 135/215] Bluetooth: hci_event: set the conn encrypted before conn establishes
Date: Thu, 11 Apr 2024 11:55:44 +0200
Message-ID: <20240411095428.952351211@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2537,6 +2537,31 @@ static void hci_conn_complete_evt(struct
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


