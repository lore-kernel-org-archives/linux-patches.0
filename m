Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211E42FDC32;
	Tue, 12 Aug 2025 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020630; cv=none; b=sxuB0Exh8uRZWa9YamapROiTwiN7BaurxO16D1U/VT3sUXQ3j/heBBIsVd+MAHB0W1xQdYVrxhrlOedsefF+u8m+7A3xwg/PqBbs9cpusowhk4iKFfTTBCGTy19yS9T2Apr90RO1noDRrU3mcE1fcHXBBozk6LRIQqvUeFvUrOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020630; c=relaxed/simple;
	bh=vMsiozkvRUDcrDYGFg++QOHgUpZ9c92Pz2dByYNMzhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QosXWRHFeBvsOc1lKRpzwlbE09bqXwqjbNZ/ATeFEFdn/IRdAkI2Vn1yb7snnblv6h5aVhsT0GyBQc9lJUmyBBljQMr5qLQtVfaR7nPcDa8JxCIB4W9dE+eSuNqBdcYjuvR6WKRorYjmegLpoCK/fKF3zAP4+Mz3j4Icr0Gt01I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxiTGDp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxiTGDp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AAAC4CEF0;
	Tue, 12 Aug 2025 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020630;
	bh=vMsiozkvRUDcrDYGFg++QOHgUpZ9c92Pz2dByYNMzhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxiTGDp0+EkFsVo5QzjZ3mek90eE3ZxTy3bn9GGXrqnXLNBEC/656RbPsoImSiGZ5
	 ZdpX3xYoBUKURViyEV0MnHZUQNZa/BbQOSCfPEagVtegQBRXLj0c4iH/IpuJ5t/w3B
	 A/wqQ+iuuvfinPDPIqMKlVLskWewEAZU5Eq731gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephane Grosjean <stephane.grosjean@hms-networks.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/253] can: peak_usb: fix USB FD devices potential malfunction
Date: Tue, 12 Aug 2025 19:28:37 +0200
Message-ID: <20250812172954.184889586@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <stephane.grosjean@hms-networks.com>

[ Upstream commit 788199b73b6efe4ee2ade4d7457b50bb45493488 ]

The latest firmware versions of USB CAN FD interfaces export the EP numbers
to be used to dialog with the device via the "type" field of a response to
a vendor request structure, particularly when its value is greater than or
equal to 2.

Correct the driver's test of this field.

Fixes: 4f232482467a ("can: peak_usb: include support for a new MCU")
Signed-off-by: Stephane Grosjean <stephane.grosjean@hms-networks.com>
Link: https://patch.msgid.link/20250724081550.11694-1-stephane.grosjean@free.fr
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
[mkl: rephrase commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 2ea1500df393..a203b7fca2f3 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -49,7 +49,7 @@ struct __packed pcan_ufd_fw_info {
 	__le32	ser_no;		/* S/N */
 	__le32	flags;		/* special functions */
 
-	/* extended data when type == PCAN_USBFD_TYPE_EXT */
+	/* extended data when type >= PCAN_USBFD_TYPE_EXT */
 	u8	cmd_out_ep;	/* ep for cmd */
 	u8	cmd_in_ep;	/* ep for replies */
 	u8	data_out_ep[2];	/* ep for CANx TX */
@@ -939,10 +939,11 @@ static int pcan_usb_fd_init(struct peak_usb_device *dev)
 			dev->can.ctrlmode |= CAN_CTRLMODE_FD_NON_ISO;
 		}
 
-		/* if vendor rsp is of type 2, then it contains EP numbers to
-		 * use for cmds pipes. If not, then default EP should be used.
+		/* if vendor rsp type is greater than or equal to 2, then it
+		 * contains EP numbers to use for cmds pipes. If not, then
+		 * default EP should be used.
 		 */
-		if (fw_info->type != cpu_to_le16(PCAN_USBFD_TYPE_EXT)) {
+		if (le16_to_cpu(fw_info->type) < PCAN_USBFD_TYPE_EXT) {
 			fw_info->cmd_out_ep = PCAN_USBPRO_EP_CMDOUT;
 			fw_info->cmd_in_ep = PCAN_USBPRO_EP_CMDIN;
 		}
@@ -975,11 +976,11 @@ static int pcan_usb_fd_init(struct peak_usb_device *dev)
 	dev->device_number =
 		le32_to_cpu(pdev->usb_if->fw_info.dev_id[dev->ctrl_idx]);
 
-	/* if vendor rsp is of type 2, then it contains EP numbers to
-	 * use for data pipes. If not, then statically defined EP are used
-	 * (see peak_usb_create_dev()).
+	/* if vendor rsp type is greater than or equal to 2, then it contains EP
+	 * numbers to use for data pipes. If not, then statically defined EP are
+	 * used (see peak_usb_create_dev()).
 	 */
-	if (fw_info->type == cpu_to_le16(PCAN_USBFD_TYPE_EXT)) {
+	if (le16_to_cpu(fw_info->type) >= PCAN_USBFD_TYPE_EXT) {
 		dev->ep_msg_in = fw_info->data_in_ep;
 		dev->ep_msg_out = fw_info->data_out_ep[dev->ctrl_idx];
 	}
-- 
2.39.5



