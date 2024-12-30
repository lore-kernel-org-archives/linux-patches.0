Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546E715E8B;
	Mon, 30 Dec 2024 15:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574358; cv=none; b=elAwD8rdNS5PxImPk22wlKvR4axZ/Zw/OhT6fwxIm1npb0otO2EJ9Jy9Scteerv45sOJ38t3rV0TJeA++R+9iBgiehoiJoj6jsBNlizOLT1vZYlBgkPqUYl2DzkNWAa0hj5mJhDTEN+7MnWIN92at9Y9thLmLROjjkjTU62x0ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574358; c=relaxed/simple;
	bh=m5BCvAzgB3S8YhqI1l72qACd/wspZkQyCEBMNMjtuZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7b3eQLbmb0gm3UTwtzdjq4WBgQw6YAzhoOhHNsl0c4UQdwpV3wJn3FXbbIeY5yAkyyr+HrJZtv7a6+LMEXm3fictM9jkemVPyU9vgbKJPxsHRNCSIoFejLt9n7iWV5t1JFxBeVkrMTCgByDEgzb/5a/cIXgmr+aRIbfvNJ19fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmLPpSbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmLPpSbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CC0C4CED0;
	Mon, 30 Dec 2024 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574358;
	bh=m5BCvAzgB3S8YhqI1l72qACd/wspZkQyCEBMNMjtuZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmLPpSbvBCFWmiTA0blBsHKC42oBNFhz04uF7SQFxH6Nu0dSjJn6WvgibApASOGZS
	 cY/pFnwubsFPajR1QkgtjGxn42WsPktsk1ECGakqNjPDJNScsJmtKgn8ziFWy+WSd2
	 O7VL7xUEeh8XpxfVBWihxBMBR29/CICwFOLBZ1H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Fedor Pchelkin <boddah8794@gmail.com>
Subject: [PATCH 6.12 112/114] Bluetooth: btusb: mediatek: change the conditions for ISO interface
Date: Mon, 30 Dec 2024 16:43:49 +0100
Message-ID: <20241230154222.442678563@linuxfoundation.org>
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

commit defc33b5541e0a7e45cc2d99d72fbe80a597afc5 upstream.

Change conditions for Bluetooth driver claiming and releasing usb
ISO interface for MediaTek ISO data transmission.

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Fedor Pchelkin <boddah8794@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2648,7 +2648,7 @@ static void btusb_mtk_release_iso_intf(s
 {
 	struct btmtk_data *btmtk_data = hci_get_priv(hdev);
 
-	if (btmtk_data->isopkt_intf) {
+	if (test_bit(BTMTK_ISOPKT_OVER_INTR, &btmtk_data->flags)) {
 		usb_kill_anchored_urbs(&btmtk_data->isopkt_anchor);
 		clear_bit(BTMTK_ISOPKT_RUNNING, &btmtk_data->flags);
 
@@ -2688,8 +2688,8 @@ static int btusb_mtk_reset(struct hci_de
 	if (err < 0)
 		return err;
 
-	if (test_bit(BTMTK_ISOPKT_RUNNING, &btmtk_data->flags))
-		btusb_mtk_release_iso_intf(hdev);
+	/* Release MediaTek ISO data interface */
+	btusb_mtk_release_iso_intf(hdev);
 
 	btusb_stop_traffic(data);
 	usb_kill_anchored_urbs(&data->tx_anchor);
@@ -2734,22 +2734,22 @@ static int btusb_mtk_setup(struct hci_de
 	btmtk_data->reset_sync = btusb_mtk_reset;
 
 	/* Claim ISO data interface and endpoint */
-	btmtk_data->isopkt_intf = usb_ifnum_to_if(data->udev, MTK_ISO_IFNUM);
-	if (btmtk_data->isopkt_intf)
+	if (!test_bit(BTMTK_ISOPKT_OVER_INTR, &btmtk_data->flags)) {
+		btmtk_data->isopkt_intf = usb_ifnum_to_if(data->udev, MTK_ISO_IFNUM);
 		btusb_mtk_claim_iso_intf(data);
+	}
 
 	return btmtk_usb_setup(hdev);
 }
 
 static int btusb_mtk_shutdown(struct hci_dev *hdev)
 {
-	struct btmtk_data *btmtk_data = hci_get_priv(hdev);
 	int ret;
 
 	ret = btmtk_usb_shutdown(hdev);
 
-	if (test_bit(BTMTK_ISOPKT_RUNNING, &btmtk_data->flags))
-		btusb_mtk_release_iso_intf(hdev);
+	/* Release MediaTek iso interface after shutdown */
+	btusb_mtk_release_iso_intf(hdev);
 
 	return ret;
 }


