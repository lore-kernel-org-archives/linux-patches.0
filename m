Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE7812B176;
	Tue, 30 Apr 2024 10:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474205; cv=none; b=G5hTlkQOJ5BUE5GYoRezRX2Et9xN3gE0zKAxzyDu7cgW2D9txqE1/7F4S/vYKhneNQH33LVEPfnZTOrT86Wr8dJCDvauBBmwW4m7jTsP8jdPLe6zMOPdRxEDm4qRZugsnjJN+Q+SgPsJv3QH6YI7dYCmtblHTCsu4OxdTbnxO7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474205; c=relaxed/simple;
	bh=qFBLTkQZDTVq39vz3/aj04OgN6g0Wdcrr96c+pKasOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MttKz+sF23uuJz2pOIsAEZV30fWXrkEBa0mRgHsL+xCZq83ZN1vitE6ErNtN4Ug/FhGMztSOfbn5urxnL/9DWrRSBzC/TOKPa63Mx71iRgM1XjFgC1fjEj/fLXhR5I1mCVNmRTU8MOS9R8xa8d/V9VU/xFzculdf1Qp+VyXz1LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6K7cbo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6K7cbo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EC0C2BBFC;
	Tue, 30 Apr 2024 10:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474205;
	bh=qFBLTkQZDTVq39vz3/aj04OgN6g0Wdcrr96c+pKasOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6K7cbo23HtqMErBJnXfHiudJHj3KGqG8J2jms9/l8PYH+vCAS5wK6ZWsHqEFhvhL
	 6zprBvIIDTaaeGqsnJM3/Dc/Zztg9qZORNXCnh4/O8ghgbYqUnNnjgiqgYww5fmjvh
	 MY1Ot3nuHVSsjafzs2h5kRbfTjLJozK68Ex4nA+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 087/228] Bluetooth: hci_event: Fix sending HCI_OP_READ_ENC_KEY_SIZE
Date: Tue, 30 Apr 2024 12:37:45 +0200
Message-ID: <20240430103106.313233031@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit a9a830a676a9a93c5020f5c61236166931fa4266 ]

The code shall always check if HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE has
been set before attempting to use HCI_OP_READ_ENC_KEY_SIZE.

Fixes: c569242cd492 ("Bluetooth: hci_event: set the conn encrypted before conn establishes")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 4 ++++
 net/bluetooth/hci_event.c        | 5 ++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index b6fb104ea1976..fe9e1524d30ff 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1907,6 +1907,10 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 #define privacy_mode_capable(dev) (use_ll_privacy(dev) && \
 				   (hdev->commands[39] & 0x04))
 
+#define read_key_size_capable(dev) \
+	((dev)->commands[20] & 0x10 && \
+	 !test_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &hdev->quirks))
+
 /* Use enhanced synchronous connection if command is supported and its quirk
  * has not been set.
  */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 9450df4ee5b9b..9d1063c51ed29 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3218,7 +3218,7 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 			if (key) {
 				set_bit(HCI_CONN_ENCRYPT, &conn->flags);
 
-				if (!(hdev->commands[20] & 0x10)) {
+				if (!read_key_size_capable(hdev)) {
 					conn->enc_key_size = HCI_LINK_KEY_SIZE;
 				} else {
 					cp.handle = cpu_to_le16(conn->handle);
@@ -3666,8 +3666,7 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, void *data,
 		 * controller really supports it. If it doesn't, assume
 		 * the default size (16).
 		 */
-		if (!(hdev->commands[20] & 0x10) ||
-		    test_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &hdev->quirks)) {
+		if (!read_key_size_capable(hdev)) {
 			conn->enc_key_size = HCI_LINK_KEY_SIZE;
 			goto notify;
 		}
-- 
2.43.0



