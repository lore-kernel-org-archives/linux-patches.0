Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D1615E8B;
	Mon, 30 Dec 2024 15:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574351; cv=none; b=QgVajs95YlrNe5JrOMvq/JHGIY4qmaQyPVTKRlVu96wn5GIDaWvcOXgia05FCDWAw5hcdJjMeDVxkC4Il+mmiBcAI+scZaHb4riQS0YcJVkN+XhRwdVKF09VcSCkW/vXdDus3yoo6+Wtmd1lxsjetallEtDgBOOyKGNjd1qjgsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574351; c=relaxed/simple;
	bh=QeZ1NHZvax0gybjtvAgfCMqFB25GltiOWpI9A7HOTrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IN6f5c9rDkUkMakE/REXH4GgaLS+az6XNETO0buVqpqa2x1aMT5tIIhCATzSpAP3x2nQXvGtnrvoL/RX3wVgpHl/FBTJb1pwgZSOYWpZ/VQcjQ904m4wrA397qCh+270LeLEoTO0YekI1CnAaDdqn730wJVySYOEAcG2D0Uk06c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFR+1qz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFR+1qz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47181C4CED0;
	Mon, 30 Dec 2024 15:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574351;
	bh=QeZ1NHZvax0gybjtvAgfCMqFB25GltiOWpI9A7HOTrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFR+1qz9yCPPdB43QIHSDzYrKdCSvL/kR6QK30uLBf3o54xBjBX8KzDV+lnTBnYdJ
	 ACujDCm2bMJTsClwHcSfKJ3+20K83/yge/g0fWRbB/AFjFXbBPstblyYfXd6j3Oteb
	 bg+Ypqq4DbF/6TFztMvWDk830ciazCxgQQ3X/G2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Fedor Pchelkin <boddah8794@gmail.com>
Subject: [PATCH 6.12 111/114] Bluetooth: btusb: mediatek: add intf release flow when usb disconnect
Date: Mon, 30 Dec 2024 16:43:48 +0100
Message-ID: <20241230154222.404191715@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Chris Lu <chris.lu@mediatek.com>

commit 489304e67087abddc2666c5af0159cb95afdcf59 upstream.

MediaTek claim an special usb intr interface for ISO data transmission.
The interface need to be released before unregistering hci device when
usb disconnect. Removing BT usb dongle without properly releasing the
interface may cause Kernel panic while unregister hci device.

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Fedor Pchelkin <boddah8794@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2644,9 +2644,9 @@ static void btusb_mtk_claim_iso_intf(str
 	init_usb_anchor(&btmtk_data->isopkt_anchor);
 }
 
-static void btusb_mtk_release_iso_intf(struct btusb_data *data)
+static void btusb_mtk_release_iso_intf(struct hci_dev *hdev)
 {
-	struct btmtk_data *btmtk_data = hci_get_priv(data->hdev);
+	struct btmtk_data *btmtk_data = hci_get_priv(hdev);
 
 	if (btmtk_data->isopkt_intf) {
 		usb_kill_anchored_urbs(&btmtk_data->isopkt_anchor);
@@ -2662,6 +2662,16 @@ static void btusb_mtk_release_iso_intf(s
 	clear_bit(BTMTK_ISOPKT_OVER_INTR, &btmtk_data->flags);
 }
 
+static int btusb_mtk_disconnect(struct hci_dev *hdev)
+{
+	/* This function describes the specific additional steps taken by MediaTek
+	 * when Bluetooth usb driver's resume function is called.
+	 */
+	btusb_mtk_release_iso_intf(hdev);
+
+	return 0;
+}
+
 static int btusb_mtk_reset(struct hci_dev *hdev, void *rst_data)
 {
 	struct btusb_data *data = hci_get_drvdata(hdev);
@@ -2679,7 +2689,7 @@ static int btusb_mtk_reset(struct hci_de
 		return err;
 
 	if (test_bit(BTMTK_ISOPKT_RUNNING, &btmtk_data->flags))
-		btusb_mtk_release_iso_intf(data);
+		btusb_mtk_release_iso_intf(hdev);
 
 	btusb_stop_traffic(data);
 	usb_kill_anchored_urbs(&data->tx_anchor);
@@ -2733,14 +2743,13 @@ static int btusb_mtk_setup(struct hci_de
 
 static int btusb_mtk_shutdown(struct hci_dev *hdev)
 {
-	struct btusb_data *data = hci_get_drvdata(hdev);
 	struct btmtk_data *btmtk_data = hci_get_priv(hdev);
 	int ret;
 
 	ret = btmtk_usb_shutdown(hdev);
 
 	if (test_bit(BTMTK_ISOPKT_RUNNING, &btmtk_data->flags))
-		btusb_mtk_release_iso_intf(data);
+		btusb_mtk_release_iso_intf(hdev);
 
 	return ret;
 }
@@ -3854,6 +3863,7 @@ static int btusb_probe(struct usb_interf
 		data->recv_acl = btmtk_usb_recv_acl;
 		data->suspend = btmtk_usb_suspend;
 		data->resume = btmtk_usb_resume;
+		data->disconnect = btusb_mtk_disconnect;
 	}
 
 	if (id->driver_info & BTUSB_SWAVE) {


