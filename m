Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4E15383FA;
	Wed, 23 Sep 2026 14:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174538; cv=none; b=erfFPOeBnVp6waA/HjPZ8B4rjuJElFc9VGWz42+vzg3IXDq1U+Hvzmt/Sv3Q9vFGRj0qOBZ97cF4hA1+WPZvIWJGZQVSVWkOrrXkeYKmVj/mBcUxJPuzkzwHaykmOIJWJXlw/E4qDmkKjefZODNfMV/6114P9BBF9wlmT1T7G24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174538; c=relaxed/simple;
	bh=zhtrFbGYqiyB4TpcDagY4OJN/djlZFcnfGxW3pXWSrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNRP7P90RRzRz9LD4hmdRfdIy7f6d2k82p2PFZ/24wXcjF808GymaGzE43UvCDPDx+MIOPECFq4vIWbC5+23/WCjwaavRX4MvWUC74lWlPKXSvstZ5nEsvyGUzYjk549xeD1W8xKm2tvD83mpLp8/svYvor7Ku8oaicTNd2Zjic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCDbTAnC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCDbTAnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037BC1F00898;
	Wed, 23 Sep 2026 14:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174536;
	bh=Ote9ybkPMKIZRD3z03OhJegW+DeogK6Alh6id5OS96A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCDbTAnCRUQTYONUBcGso/HvlAkcslfL2w1z500mcL2n+g4drdBZYWbFErKbsHe7A
	 zzijOy5hNCydwJ3JRL1dGLWUbShTmxwbqZ4Gqj9t9EEIj1cYrtxqqrnEJL7TcODKGZ
	 WOwGWGhuJOvAKjlYRI06/WJHRdcFT8lYCYFINClM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Abdelkader <iabdelka@qti.qualcomm.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 147/398] Bluetooth: hci_qca: Do not write to the serial port after it is closed
Date: Wed, 23 Sep 2026 16:03:41 +0200
Message-ID: <20260923140647.243204590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ibrahim Abdelkader <iabdelka@qti.qualcomm.com>

[ Upstream commit 4e93c65f87825e1e012bce56615320aeb123815d ]

hci_uart_close() closes the serdev port if HCI_QUIRK_NON_PERSISTENT_SETUP
is set (for example, for the WCN399x family). A failed hci_dev_open_sync()
following a successful qca_setup() calls hdev->close() but not
hdev->shutdown(), so the port is closed while power->vregs_on is left true.
qca_serdev_remove() then passes its power->vregs_on test and calls
qca_power_off(), which writes to the closed port unconditionally.

Seen on a WCN3988 by unbinding the driver after a controller failure. The
trace below is from a 7.0.0 based kernel, where qca_power_off() was still
named qca_power_shutdown():

  Unable to handle kernel NULL pointer dereference at virtual address
  0000000000000038
  Call trace:
   tty_set_termios+0x50/0x238 (P)
   ttyport_set_baudrate+0x84/0xc0
   serdev_device_set_baudrate+0x24/0x40
   qca_power_shutdown+0x158/0x1fc [hci_uart]
   qca_serdev_remove+0x54/0x68 [hci_uart]
   serdev_drv_remove+0x1c/0x2c
   device_remove+0x4c/0x80
   device_release_driver_internal+0x1cc/0x224
   device_driver_detach+0x18/0x24
   unbind_store+0xb4/0xc0

Check HCI_UART_PROTO_READY, which hci_uart_close() clears in the same place
it closes the port, before writing to it. The regulator disable is left
unconditional so the controller is still powered down.

The dangling serport->tty that turns this into a use-after-free is
addressed in a separate patch.

Fixes: fa9ad876b8e0 ("Bluetooth: hci_qca: Add support for Qualcomm Bluetooth chip wcn3990")
Signed-off-by: Ibrahim Abdelkader <iabdelka@qti.qualcomm.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 8de195c2fc8d6..cdc51460bd8de 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2221,8 +2221,8 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	bool sw_ctrl_state;
 	struct qca_power *power;
 
-	/* From this point we go into power off state. But serial port is
-	 * still open, stop queueing the IBS data and flush all the buffered
+	/* From this point we go into power off state. But serial port may
+	 * still be open, stop queueing the IBS data and flush all the buffered
 	 * data in skb's.
 	 */
 	spin_lock_irqsave(&qca->hci_ibs_lock, flags);
@@ -2244,8 +2244,14 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	case QCA_WCN3990:
 	case QCA_WCN3991:
 	case QCA_WCN3998:
-		host_set_baudrate(hu, 2400);
-		qca_send_power_pulse(hu, false);
+		/* Both of these write to the serial port which may have
+		 * already been closed by hci_uart_close(), which closes
+		 * the port if HCI_QUIRK_NON_PERSISTENT_SETUP is set.
+		 */
+		if (test_bit(HCI_UART_PROTO_READY, &hu->flags)) {
+			host_set_baudrate(hu, 2400);
+			qca_send_power_pulse(hu, false);
+		}
 		break;
 	default:
 		break;
-- 
2.53.0



