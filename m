Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD5614A62A;
	Thu, 23 May 2024 13:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470506; cv=none; b=l1G/C5t847a+1k/Top/B2VNYjKa9+h6MjcG2FLzreXWs0PR1drOgTBTobRTE4EskJ+jlgxUH5uovur4Dbaj+GXPOgu093W9kjLw3jUTl1DfkDaHHqdSPHa1TMvOI+3qZW4hrOq5J/L7k0SYDV2ikgUojYhVNA6t8TwzpnPkmFag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470506; c=relaxed/simple;
	bh=uKulHPDSUGUuCEDljX2BCiUUkKCQ4n9JDG8pBVG+yQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqTZJWw6cAs7qNg8tDEg9LQrkyIBsi/lT1rhksucKFFuUBPG+5/zEJd0NgJxgcazPeGeHOOk9rZhc8qF5z92X5Z+Me9/0g5XwYalFfn+xUsjFJFO+2VGg6dVXeOMWjiJu7ICTKCSUhop/XmrLbp/5hQFt0ZRl1DUy3yY85EISyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J57PDqyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J57PDqyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52798C2BD10;
	Thu, 23 May 2024 13:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470506;
	bh=uKulHPDSUGUuCEDljX2BCiUUkKCQ4n9JDG8pBVG+yQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J57PDqyC4GYvffLYMtXBHwHu6KAh7krFcHrAiIlOmHZPGyyKFw+5VnZ6IC9oG14wj
	 aO5dOUF1T2nf+MIlLma7zHFeiS1rOwRzOgzjQUmNkiQ2z5aG1kuwWZv5AUh4SF+q79
	 k8VTlFRiCLQaG6R74R0LqnjNwvCwMp9FMY5HTRgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco@wolfvision.net>
Subject: [PATCH 6.8 15/23] usb: typec: tipd: fix event checking for tps6598x
Date: Thu, 23 May 2024 15:13:42 +0200
Message-ID: <20240523130330.327224201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco@wolfvision.net>

commit 409c1cfb5a803f3cf2d17aeaf75c25c4be951b07 upstream.

The current interrupt service routine of the tps6598x only reads the
first 64 bits of the INT_EVENT1 and INT_EVENT2 registers, which means
that any event above that range will be ignored, leaving interrupts
unattended. Moreover, those events will not be cleared, and the device
will keep the interrupt enabled.

This issue has been observed while attempting to load patches, and the
'ReadyForPatch' field (bit 81) of INT_EVENT1 was set.

Given that older versions of the tps6598x (1, 2 and 6) provide 8-byte
registers, a mechanism based on the upper byte of the version register
(0x0F) has been included. The manufacturer has confirmed [1] that this
byte is always 0 for older versions, and either 0xF7 (DH parts) or 0xF9
(DK parts) is returned in newer versions (7 and 8).

Read the complete INT_EVENT registers to handle all interrupts generated
by the device and account for the hardware version to select the
register size.

Link: https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/1346521/tps65987d-register-command-to-distinguish-between-tps6591-2-6-and-tps65987-8 [1]
Fixes: 0a4c005bd171 ("usb: typec: driver for TI TPS6598x USB Power Delivery controllers")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco@wolfvision.net>
Link: https://lore.kernel.org/r/20240429-tps6598x_fix_event_handling-v3-2-4e8e58dce489@wolfvision.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c     |   45 +++++++++++++++++++++++++++-----------
 drivers/usb/typec/tipd/tps6598x.h |   11 +++++++++
 2 files changed, 43 insertions(+), 13 deletions(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -28,6 +28,7 @@
 #define TPS_REG_MODE			0x03
 #define TPS_REG_CMD1			0x08
 #define TPS_REG_DATA1			0x09
+#define TPS_REG_VERSION			0x0F
 #define TPS_REG_INT_EVENT1		0x14
 #define TPS_REG_INT_EVENT2		0x15
 #define TPS_REG_INT_MASK1		0x16
@@ -636,49 +637,67 @@ err_unlock:
 
 static irqreturn_t tps6598x_interrupt(int irq, void *data)
 {
+	int intev_len = TPS_65981_2_6_INTEVENT_LEN;
 	struct tps6598x *tps = data;
-	u64 event1 = 0;
-	u64 event2 = 0;
+	u64 event1[2] = { };
+	u64 event2[2] = { };
+	u32 version;
 	u32 status;
 	int ret;
 
 	mutex_lock(&tps->lock);
 
-	ret = tps6598x_read64(tps, TPS_REG_INT_EVENT1, &event1);
-	ret |= tps6598x_read64(tps, TPS_REG_INT_EVENT2, &event2);
+	ret = tps6598x_read32(tps, TPS_REG_VERSION, &version);
+	if (ret)
+		dev_warn(tps->dev, "%s: failed to read version (%d)\n",
+			 __func__, ret);
+
+	if (TPS_VERSION_HW_VERSION(version) == TPS_VERSION_HW_65987_8_DH ||
+	    TPS_VERSION_HW_VERSION(version) == TPS_VERSION_HW_65987_8_DK)
+		intev_len = TPS_65987_8_INTEVENT_LEN;
+
+	ret = tps6598x_block_read(tps, TPS_REG_INT_EVENT1, event1, intev_len);
+
+	ret = tps6598x_block_read(tps, TPS_REG_INT_EVENT1, event1, intev_len);
 	if (ret) {
-		dev_err(tps->dev, "%s: failed to read events\n", __func__);
+		dev_err(tps->dev, "%s: failed to read event1\n", __func__);
 		goto err_unlock;
 	}
-	trace_tps6598x_irq(event1, event2);
+	ret = tps6598x_block_read(tps, TPS_REG_INT_EVENT2, event2, intev_len);
+	if (ret) {
+		dev_err(tps->dev, "%s: failed to read event2\n", __func__);
+		goto err_unlock;
+	}
+	trace_tps6598x_irq(event1[0], event2[0]);
 
-	if (!(event1 | event2))
+	if (!(event1[0] | event1[1] | event2[0] | event2[1]))
 		goto err_unlock;
 
 	if (!tps6598x_read_status(tps, &status))
 		goto err_clear_ints;
 
-	if ((event1 | event2) & TPS_REG_INT_POWER_STATUS_UPDATE)
+	if ((event1[0] | event2[0]) & TPS_REG_INT_POWER_STATUS_UPDATE)
 		if (!tps6598x_read_power_status(tps))
 			goto err_clear_ints;
 
-	if ((event1 | event2) & TPS_REG_INT_DATA_STATUS_UPDATE)
+	if ((event1[0] | event2[0]) & TPS_REG_INT_DATA_STATUS_UPDATE)
 		if (!tps6598x_read_data_status(tps))
 			goto err_clear_ints;
 
 	/* Handle plug insert or removal */
-	if ((event1 | event2) & TPS_REG_INT_PLUG_EVENT)
+	if ((event1[0] | event2[0]) & TPS_REG_INT_PLUG_EVENT)
 		tps6598x_handle_plug_event(tps, status);
 
 err_clear_ints:
-	tps6598x_write64(tps, TPS_REG_INT_CLEAR1, event1);
-	tps6598x_write64(tps, TPS_REG_INT_CLEAR2, event2);
+	tps6598x_block_write(tps, TPS_REG_INT_CLEAR1, event1, intev_len);
+	tps6598x_block_write(tps, TPS_REG_INT_CLEAR2, event2, intev_len);
 
 err_unlock:
 	mutex_unlock(&tps->lock);
 
-	if (event1 | event2)
+	if (event1[0] | event1[1] | event2[0] | event2[1])
 		return IRQ_HANDLED;
+
 	return IRQ_NONE;
 }
 
--- a/drivers/usb/typec/tipd/tps6598x.h
+++ b/drivers/usb/typec/tipd/tps6598x.h
@@ -253,4 +253,15 @@
 #define TPS_PTCC_DEV				2
 #define TPS_PTCC_APP				3
 
+/* Version Register */
+#define TPS_VERSION_HW_VERSION_MASK            GENMASK(31, 24)
+#define TPS_VERSION_HW_VERSION(x)              TPS_FIELD_GET(TPS_VERSION_HW_VERSION_MASK, (x))
+#define TPS_VERSION_HW_65981_2_6               0x00
+#define TPS_VERSION_HW_65987_8_DH              0xF7
+#define TPS_VERSION_HW_65987_8_DK              0xF9
+
+/* Int Event Register length */
+#define TPS_65981_2_6_INTEVENT_LEN             8
+#define TPS_65987_8_INTEVENT_LEN               11
+
 #endif /* __TPS6598X_H__ */


