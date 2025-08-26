Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88A342CA7;
	Tue, 26 Aug 2025 13:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214396; cv=none; b=VtbrWHYl9sQCRxRkM5m4L3e+BYw5tOVQUIUdjQKJYfcgVMNtPSH/casLZctE+Efa7nllBFfuRbHTMomBK+3Jb/xU0d3+2Z1sMuF36Wx9MecnwqwEutd1aIeqFjYriiV1q2BuyLxYu80F4ryWD8hb3b4l+0ZuSyY3LOpuL5tCuJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214396; c=relaxed/simple;
	bh=pJu5+5BbVhRLd3UwhR6WjZ/cO3amm/HEwz8KK2tYmK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqKYCpMC0fbeVf4sJ8yZ0T2PlpPcmRaRuSGjQWmz3lXHbsKOsrezEuizqrXG1vB2GyLyjLTnSxsuExNmJZ5Ikt0LkDCTgyRed/Pw9d7WKeNw/okvuzA0HtZGjT4Xsx/8slr4kiToIXmkiPWuSoeNvHTYOH0EXRnRbNUnWTq/MwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlHytPjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlHytPjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD80C4CEF1;
	Tue, 26 Aug 2025 13:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214395;
	bh=pJu5+5BbVhRLd3UwhR6WjZ/cO3amm/HEwz8KK2tYmK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlHytPjSZI02VpDXcx6PSzFdYaPS7yldm7lxhOLQ4JE24+g8iBjrCxZzBpiLSRb4F
	 FGYopWZvMrTUfsFAcT9T4J/n2phNj1hzKtZfLNaP7FpWyHaNPLViWFG98DGSmq6BCx
	 f27MAjs7HhMIJL8XED5IfCHhdj8qQKqCc7JO1n7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/482] net: usb: cdc-ncm: check for filtering capability
Date: Tue, 26 Aug 2025 13:06:07 +0200
Message-ID: <20250826110933.644390063@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 61c3e8940f2d8b5bfeaeec4bedc2f3e7d873abb3 ]

If the decice does not support filtering, filtering
must not be used and all packets delivered for the
upper layers to sort.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20250717120649.2090929-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c   | 20 ++++++++++++++++----
 include/linux/usb/cdc_ncm.h |  1 +
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 789e3647f979..9eb3c6b66a38 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -892,6 +892,10 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 		}
 	}
 
+	if (ctx->func_desc)
+		ctx->filtering_supported = !!(ctx->func_desc->bmNetworkCapabilities
+			& USB_CDC_NCM_NCAP_ETH_FILTER);
+
 	iface_no = ctx->data->cur_altsetting->desc.bInterfaceNumber;
 
 	/* Device-specific flags */
@@ -1897,6 +1901,14 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
 	}
 }
 
+static void cdc_ncm_update_filter(struct usbnet *dev)
+{
+	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
+
+	if (ctx->filtering_supported)
+		usbnet_cdc_update_filter(dev);
+}
+
 static const struct driver_info cdc_ncm_info = {
 	.description = "CDC NCM (NO ZLP)",
 	.flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET
@@ -1907,7 +1919,7 @@ static const struct driver_info cdc_ncm_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
-	.set_rx_mode = usbnet_cdc_update_filter,
+	.set_rx_mode = cdc_ncm_update_filter,
 };
 
 /* Same as cdc_ncm_info, but with FLAG_SEND_ZLP  */
@@ -1921,7 +1933,7 @@ static const struct driver_info cdc_ncm_zlp_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
-	.set_rx_mode = usbnet_cdc_update_filter,
+	.set_rx_mode = cdc_ncm_update_filter,
 };
 
 /* Same as cdc_ncm_info, but with FLAG_WWAN */
@@ -1935,7 +1947,7 @@ static const struct driver_info wwan_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
-	.set_rx_mode = usbnet_cdc_update_filter,
+	.set_rx_mode = cdc_ncm_update_filter,
 };
 
 /* Same as wwan_info, but with FLAG_NOARP  */
@@ -1949,7 +1961,7 @@ static const struct driver_info wwan_noarp_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
-	.set_rx_mode = usbnet_cdc_update_filter,
+	.set_rx_mode = cdc_ncm_update_filter,
 };
 
 static const struct usb_device_id cdc_devs[] = {
diff --git a/include/linux/usb/cdc_ncm.h b/include/linux/usb/cdc_ncm.h
index 2d207cb4837d..4ac082a63173 100644
--- a/include/linux/usb/cdc_ncm.h
+++ b/include/linux/usb/cdc_ncm.h
@@ -119,6 +119,7 @@ struct cdc_ncm_ctx {
 	u32 timer_interval;
 	u32 max_ndp_size;
 	u8 is_ndp16;
+	u8 filtering_supported;
 	union {
 		struct usb_cdc_ncm_ndp16 *delayed_ndp16;
 		struct usb_cdc_ncm_ndp32 *delayed_ndp32;
-- 
2.39.5



