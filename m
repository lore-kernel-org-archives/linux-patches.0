Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232BADF59;
	Wed,  5 Feb 2025 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767795; cv=none; b=N//yqNhZmT43Ql3gXY7o2DOSu8MxAu2GUTHVUgrXWyflWXmRYfCfjfoMJDTAcs7hfwZozHNJlSm8OfAaJIHN3Pce9gcN3GzhxSpMSxeIcK2pfmyvPbNAXTlzE759B1FT1Vumu/rxLKZE0j209csBsPo/GeBV3Dd5I86vIOvZVRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767795; c=relaxed/simple;
	bh=GViLDs6d5Njm/u1K2NuzxBQmnv/JOncR9bHnej6zmKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjetsQi7VIwAJMHgj6A/DrtcyCS7ys+yt2h68tsQrGd4M00E7KQodvDWm5DYa9+WXF3Oe1B2Ufe7FnqkzylPfJNQCWbzmEHdRbbg7DOfV7wlHqG86/RSCwew5ui07nyyMkqHaiRHBRZ3K8WRrgHpf7X1xTwl4xDA5i+/Pu9BCDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Loo73Akv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Loo73Akv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECFEC4CED1;
	Wed,  5 Feb 2025 15:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767795;
	bh=GViLDs6d5Njm/u1K2NuzxBQmnv/JOncR9bHnej6zmKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Loo73AkvkwwzQ/GA0jh3g0YZu0x8WW3JX2pEbFbGxzVItxJNWb4HxCIGOQCh97Kql
	 9avfnNRs7VQDcd1Ihwsz6CldaE9MQgiPoiDrNBTDBKT6J//FOUSoidaH41gNVwNYhW
	 2w6QmJPQWj/PQtc2cEbYaK4cHriWnHsmp2Ib2atw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 510/590] Bluetooth: btusb: mediatek: Add locks for usb_driver_claim_interface()
Date: Wed,  5 Feb 2025 14:44:25 +0100
Message-ID: <20250205134514.778810155@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e9087e828827e5a5c85e124ce77503f2b81c3491 ]

The documentation for usb_driver_claim_interface() says that "the
device lock" is needed when the function is called from places other
than probe(). This appears to be the lock for the USB interface
device. The Mediatek btusb code gets called via this path:

  Workqueue: hci0 hci_power_on [bluetooth]
  Call trace:
   usb_driver_claim_interface
   btusb_mtk_claim_iso_intf
   btusb_mtk_setup
   hci_dev_open_sync
   hci_power_on
   process_scheduled_works
   worker_thread
   kthread

With the above call trace the device lock hasn't been claimed. Claim
it.

Without this fix, we'd sometimes see the error "Failed to claim iso
interface". Sometimes we'd even see worse errors, like a NULL pointer
dereference (where `intf->dev.driver` was NULL) with a trace like:

  Call trace:
   usb_suspend_both
   usb_runtime_suspend
   __rpm_callback
   rpm_suspend
   pm_runtime_work
   process_scheduled_works

Both errors appear to be fixed with the proper locking.

Fixes: ceac1cb0259d ("Bluetooth: btusb: mediatek: add ISO data transmission functions")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 0c85c981a8334..258a5cb6f27af 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2632,8 +2632,15 @@ static void btusb_mtk_claim_iso_intf(struct btusb_data *data)
 	struct btmtk_data *btmtk_data = hci_get_priv(data->hdev);
 	int err;
 
+	/*
+	 * The function usb_driver_claim_interface() is documented to need
+	 * locks held if it's not called from a probe routine. The code here
+	 * is called from the hci_power_on workqueue, so grab the lock.
+	 */
+	device_lock(&btmtk_data->isopkt_intf->dev);
 	err = usb_driver_claim_interface(&btusb_driver,
 					 btmtk_data->isopkt_intf, data);
+	device_unlock(&btmtk_data->isopkt_intf->dev);
 	if (err < 0) {
 		btmtk_data->isopkt_intf = NULL;
 		bt_dev_err(data->hdev, "Failed to claim iso interface");
-- 
2.39.5



