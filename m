Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0038E46EF96;
	Sat, 12 Sep 2026 10:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210248; cv=none; b=uCuv6Z+bB8qAP4j4Jv6wX/0QKE7dnzN3bkethY3nECrYqcDWR95A+RGAK2mGO1htdjHumUs6gtb2s2O8LCtuow1yw4uPIvEcBT+iNtQqKeQkrvAtyBCcNZswoRuMfE7RA/KscL6gsx5RPWMl3wcxq0A5ev12rrxGPhJ+2Y7UegE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210248; c=relaxed/simple;
	bh=u5NdSwl9fcWa6Li4XOgbNs0Lq3TQIYCICJeJc4Q6MJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKdUQ3N6wRl/uSktl0eFOM7d62LHD01YmTE0JJ4x949bxfEM1xhiFUVhy9SnM564hDfH/dsiRadyQ13gm4MYymBAZbH8RJKT/n3iIQQDeLWEc1++Cch4m+5dzQXdYkI3TsmXDE9DJso3/0CORkBtyrCuj8QxpT23PNIXTrtO3VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNhcJeGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNhcJeGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF63A1F000FF;
	Sat, 12 Sep 2026 10:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210246;
	bh=iKxU905VIFAYhD9cljeaYzFJNnSYZUEtJQw1eC5+YPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNhcJeGLIdLlNCSBmYeEeZdMwTKeXYiCxPrRsZNNwsN1vNY7983CN0NAjeDNq2Rw/
	 TNPgmcZLLil7sq/qPXB5lbJYbo7DLdlHLl+tu9Aa6VfjQpwlqYmEfxpVY3NUUcJNdJ
	 smO7U50KZcHUT2FNOIcDFRFzlJWkRQ99LH83MsiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0987/1518] Bluetooth: btusb: refactor endpoint lookup
Date: Sat, 12 Sep 2026 08:52:36 +0200
Message-ID: <20260912065645.786203886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 5c31aaa05624b54dc18c9e313bcee5a88c025593 ]

Use the common USB helper for looking up bulk and interrupt endpoints
instead of open coding.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 33c6a8d01889 ("Bluetooth: btusb: QCA: Fix populating devcoredump fields on unenabled devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 51 ++++++---------------------------------
 1 file changed, 8 insertions(+), 43 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index cc972ddd09785..f399599f4b3bf 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3658,31 +3658,14 @@ static inline int __set_diag_interface(struct hci_dev *hdev)
 {
 	struct btusb_data *data = hci_get_drvdata(hdev);
 	struct usb_interface *intf = data->diag;
-	int i;
+	int ret;
 
 	if (!data->diag)
 		return -ENODEV;
 
-	data->diag_tx_ep = NULL;
-	data->diag_rx_ep = NULL;
-
-	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
-		struct usb_endpoint_descriptor *ep_desc;
-
-		ep_desc = &intf->cur_altsetting->endpoint[i].desc;
-
-		if (!data->diag_tx_ep && usb_endpoint_is_bulk_out(ep_desc)) {
-			data->diag_tx_ep = ep_desc;
-			continue;
-		}
-
-		if (!data->diag_rx_ep && usb_endpoint_is_bulk_in(ep_desc)) {
-			data->diag_rx_ep = ep_desc;
-			continue;
-		}
-	}
-
-	if (!data->diag_tx_ep || !data->diag_rx_ep) {
+	ret = usb_find_common_endpoints(intf->cur_altsetting, &data->diag_rx_ep,
+					&data->diag_tx_ep, NULL, NULL);
+	if (ret) {
 		bt_dev_err(hdev, "invalid diagnostic descriptors");
 		return -ENODEV;
 	}
@@ -4013,12 +3996,11 @@ static struct hci_drv btusb_hci_drv = {
 static int btusb_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
 {
-	struct usb_endpoint_descriptor *ep_desc;
 	struct gpio_desc *reset_gpio;
 	struct btusb_data *data;
 	struct hci_dev *hdev;
 	unsigned ifnum_base;
-	int i, err, priv_size;
+	int err, priv_size;
 
 	BT_DBG("intf %p id %p", intf, id);
 
@@ -4055,26 +4037,9 @@ static int btusb_probe(struct usb_interface *intf,
 	if (!data)
 		return -ENOMEM;
 
-	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
-		ep_desc = &intf->cur_altsetting->endpoint[i].desc;
-
-		if (!data->intr_ep && usb_endpoint_is_int_in(ep_desc)) {
-			data->intr_ep = ep_desc;
-			continue;
-		}
-
-		if (!data->bulk_tx_ep && usb_endpoint_is_bulk_out(ep_desc)) {
-			data->bulk_tx_ep = ep_desc;
-			continue;
-		}
-
-		if (!data->bulk_rx_ep && usb_endpoint_is_bulk_in(ep_desc)) {
-			data->bulk_rx_ep = ep_desc;
-			continue;
-		}
-	}
-
-	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep) {
+	err = usb_find_common_endpoints(intf->cur_altsetting, &data->bulk_rx_ep,
+					&data->bulk_tx_ep, &data->intr_ep, NULL);
+	if (err) {
 		kfree(data);
 		return -ENODEV;
 	}
-- 
2.53.0



