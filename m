Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE95044C97;
	Sun,  1 Sep 2024 16:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208031; cv=none; b=R9w1KqXugrp9yX4vgsLuZ65+ZWJj/RHTm1YWcQvhUE0s4pf3xrvfBvcYBWp4D46eHpM5u1q90jLOUpGWAFRns1W8h0/Dk6hd0xGyrBlIINh4AFfy4DQA3SwdMjmsEk6Lytis1QMgUDuebJK5OAfRrbFg/pBXLDLteyw20iHY41Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208031; c=relaxed/simple;
	bh=rDYNZXDJO5SC4pfnIwp/GdaPNS1ZxewP5SS5G2YAX2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbOl1NNNgphhjXKUkc8DfymltTAnXjZzCw9EftkZUEm/Jm+8yCsFWqd4fD1MReiYtkiWxUru6+8km1RQy+u05GsGqQvKMCl8djOAu6qyf/4WTR1X//qHg/Eqqmv7hnslhrwv+Vycifiv34DqNylQZ2QjKU9f448Zxk88qjQIllw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kdx95ZQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kdx95ZQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0BBC4CEC3;
	Sun,  1 Sep 2024 16:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208030;
	bh=rDYNZXDJO5SC4pfnIwp/GdaPNS1ZxewP5SS5G2YAX2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kdx95ZQ338OCYhGaOrAqqdHtvFiIVWz2Y72jivJxBMLtiBOTEzzdaGf6Egy3XLbW7
	 hitsgV86yg46rz5iCz+OxxkYXEaB66butqiOvd+a95KIgFfGfrqQ1FG7O3n1VA/zK5
	 i/a+MWmKziZI1/ehcwczG2wYFVagrnuIZq6BF6V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Guillaume Legoupil <guillaume.legoupil@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 52/93] Bluetooth: btnxpuart: Handle FW Download Abort scenario
Date: Sun,  1 Sep 2024 18:16:39 +0200
Message-ID: <20240901160809.322900563@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>

[ Upstream commit e3c4891098c875a63ab0c3b31d584f6d4f1895fd ]

This adds a new flag BTNXPUART_FW_DOWNLOAD_ABORT which handles the
situation where driver is removed while firmware download is in
progress.

logs:
modprobe btnxpuart
[65239.230431] Bluetooth: hci0: ChipID: 7601, Version: 0
[65239.236670] Bluetooth: hci0: Request Firmware: nxp/uartspi_n61x_v1.bin.se
rmmod btnxpuart
[65241.425300] Bluetooth: hci0: FW Download Aborted

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Tested-by: Guillaume Legoupil <guillaume.legoupil@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 35237475384a ("Bluetooth: btnxpuart: Fix random crash seen while removing driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 47 ++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index 2e18f89a931b8..f72086ee614fb 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -29,6 +29,7 @@
 #define BTNXPUART_CHECK_BOOT_SIGNATURE	3
 #define BTNXPUART_SERDEV_OPEN		4
 #define BTNXPUART_IR_IN_PROGRESS	5
+#define BTNXPUART_FW_DOWNLOAD_ABORT	6
 
 /* NXP HW err codes */
 #define BTNXPUART_IR_HW_ERR		0xb0
@@ -159,6 +160,7 @@ struct btnxpuart_dev {
 	u8 fw_name[MAX_FW_FILE_NAME_LEN];
 	u32 fw_dnld_v1_offset;
 	u32 fw_v1_sent_bytes;
+	u32 fw_dnld_v3_offset;
 	u32 fw_v3_offset_correction;
 	u32 fw_v1_expected_len;
 	u32 boot_reg_offset;
@@ -566,6 +568,7 @@ static int nxp_download_firmware(struct hci_dev *hdev)
 	nxpdev->fw_v1_sent_bytes = 0;
 	nxpdev->fw_v1_expected_len = HDR_LEN;
 	nxpdev->boot_reg_offset = 0;
+	nxpdev->fw_dnld_v3_offset = 0;
 	nxpdev->fw_v3_offset_correction = 0;
 	nxpdev->baudrate_changed = false;
 	nxpdev->timeout_changed = false;
@@ -580,14 +583,23 @@ static int nxp_download_firmware(struct hci_dev *hdev)
 					       !test_bit(BTNXPUART_FW_DOWNLOADING,
 							 &nxpdev->tx_state),
 					       msecs_to_jiffies(60000));
+
+	release_firmware(nxpdev->fw);
+	memset(nxpdev->fw_name, 0, sizeof(nxpdev->fw_name));
+
 	if (err == 0) {
-		bt_dev_err(hdev, "FW Download Timeout.");
+		bt_dev_err(hdev, "FW Download Timeout. offset: %d",
+				nxpdev->fw_dnld_v1_offset ?
+				nxpdev->fw_dnld_v1_offset :
+				nxpdev->fw_dnld_v3_offset);
 		return -ETIMEDOUT;
 	}
+	if (test_bit(BTNXPUART_FW_DOWNLOAD_ABORT, &nxpdev->tx_state)) {
+		bt_dev_err(hdev, "FW Download Aborted");
+		return -EINTR;
+	}
 
 	serdev_device_set_flow_control(nxpdev->serdev, true);
-	release_firmware(nxpdev->fw);
-	memset(nxpdev->fw_name, 0, sizeof(nxpdev->fw_name));
 
 	/* Allow the downloaded FW to initialize */
 	msleep(1200);
@@ -998,8 +1010,9 @@ static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *skb)
 		goto free_skb;
 	}
 
-	serdev_device_write_buf(nxpdev->serdev, nxpdev->fw->data + offset -
-				nxpdev->fw_v3_offset_correction, len);
+	nxpdev->fw_dnld_v3_offset = offset - nxpdev->fw_v3_offset_correction;
+	serdev_device_write_buf(nxpdev->serdev, nxpdev->fw->data +
+				nxpdev->fw_dnld_v3_offset, len);
 
 free_skb:
 	kfree_skb(skb);
@@ -1430,16 +1443,22 @@ static void nxp_serdev_remove(struct serdev_device *serdev)
 	struct btnxpuart_dev *nxpdev = serdev_device_get_drvdata(serdev);
 	struct hci_dev *hdev = nxpdev->hdev;
 
-	/* Restore FW baudrate to fw_init_baudrate if changed.
-	 * This will ensure FW baudrate is in sync with
-	 * driver baudrate in case this driver is re-inserted.
-	 */
-	if (nxpdev->current_baudrate != nxpdev->fw_init_baudrate) {
-		nxpdev->new_baudrate = nxpdev->fw_init_baudrate;
-		nxp_set_baudrate_cmd(hdev, NULL);
+	if (is_fw_downloading(nxpdev)) {
+		set_bit(BTNXPUART_FW_DOWNLOAD_ABORT, &nxpdev->tx_state);
+		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
+		wake_up_interruptible(&nxpdev->fw_dnld_done_wait_q);
+	} else {
+		/* Restore FW baudrate to fw_init_baudrate if changed.
+		 * This will ensure FW baudrate is in sync with
+		 * driver baudrate in case this driver is re-inserted.
+		 */
+		if (nxpdev->current_baudrate != nxpdev->fw_init_baudrate) {
+			nxpdev->new_baudrate = nxpdev->fw_init_baudrate;
+			nxp_set_baudrate_cmd(hdev, NULL);
+		}
+		ps_cancel_timer(nxpdev);
 	}
-
-	ps_cancel_timer(nxpdev);
 	hci_unregister_dev(hdev);
 	hci_free_dev(hdev);
 }
-- 
2.43.0



