Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8FA335BC5;
	Mon, 18 Aug 2025 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525291; cv=none; b=g10qNkSV4UqZYKREiWqfZO0RxDJ2UYx7uhpV15QqmCXN3weiA9RQl5qDdgUylCkYZ2CuOGd+muv8TTU4YWPAhmBULKri9JctLPZrQxVyT4fJ9EN8DxLD/8rc0nqw8yJZaqqEb+ch2so/URqghdxoKrRQf8jYdJpmxaCK5BRzOoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525291; c=relaxed/simple;
	bh=4pqBOxNAHZ12MKFRx9GccNWTV8ha71Q4SLPYYh9io3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFb9EN4TQJALRwMN+5yBU+KgzwvXVXwEJ8uplKKZHsubfAjqKkypBk24c+uj/WWpknJ+kV0evmhNUpM3B+n0WYfNNfRfRUiGYCxNd6Nk2oev8VCURc/27w5mmONA9mown/tyxVSoE8woYH+la2wJTpZds6aWLhVFQfUZ2zTRrVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKGu39gR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKGu39gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26B9C4CEF1;
	Mon, 18 Aug 2025 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525291;
	bh=4pqBOxNAHZ12MKFRx9GccNWTV8ha71Q4SLPYYh9io3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKGu39gRt0JhyE/tK/puyKS9epilz61ngOGMyrw1K8HHHYfB95b9pYejI/QpSZLld
	 v5/Y8ff/FUHev6t9P4JF7KgVaHWT5f++v1xp1c4Qo57XlXjZ4N3ySn4vIOuwyn5etq
	 sL1luVO0xCoapiAZNfSvLBzj71H5GaanVmEGSQ8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 218/570] net: usb: cdc-ncm: check for filtering capability
Date: Mon, 18 Aug 2025 14:43:25 +0200
Message-ID: <20250818124514.196147589@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 34e82f1e37d9..ea0e5e276cd6 100644
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
@@ -1898,6 +1902,14 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
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
@@ -1908,7 +1920,7 @@ static const struct driver_info cdc_ncm_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
-	.set_rx_mode = usbnet_cdc_update_filter,
+	.set_rx_mode = cdc_ncm_update_filter,
 };
 
 /* Same as cdc_ncm_info, but with FLAG_SEND_ZLP  */
@@ -1922,7 +1934,7 @@ static const struct driver_info cdc_ncm_zlp_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
-	.set_rx_mode = usbnet_cdc_update_filter,
+	.set_rx_mode = cdc_ncm_update_filter,
 };
 
 /* Same as cdc_ncm_info, but with FLAG_SEND_ZLP */
@@ -1964,7 +1976,7 @@ static const struct driver_info wwan_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
-	.set_rx_mode = usbnet_cdc_update_filter,
+	.set_rx_mode = cdc_ncm_update_filter,
 };
 
 /* Same as wwan_info, but with FLAG_NOARP  */
@@ -1978,7 +1990,7 @@ static const struct driver_info wwan_noarp_info = {
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



