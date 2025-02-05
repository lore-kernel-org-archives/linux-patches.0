Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06701519B4;
	Wed,  5 Feb 2025 15:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768390; cv=none; b=OTq/O8F9IIK8CV/EY+0f9I/Klol5SruJ2mr2BFCFiVNpjlsRTmHiUP5znLwBhpJGpK+0B/EdBv1EbskKnCyfDew0tIepn47LdpqOqu6HnqloXLRBlZVlc9rHUmPvZmffLZldN/YcSS3AktXsibzMnUPr/wffJm4p8IGdpVqAgbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768390; c=relaxed/simple;
	bh=S0uRdZkoDOgAH6muUI30Iv/ExzFPjpSDrI6c/eS1qX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMdHd5iCUUeJ4jYOHD9ga8EVbVMAp4nAyHFmDG5ngqP1X6Ausj3v4O8EEyFbXnv+p28/Dk0mPYGYuuTydS5pEF5PKZqxdWAdM0++gaTMYZgN3WqnpV+QUEM8ww8oCxIJGdANymlaJku0EZpk7XVzjyEyvWj9yXn1jQx2PTx/IN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAOsj2Ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAOsj2Ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFD8C4CED1;
	Wed,  5 Feb 2025 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768390;
	bh=S0uRdZkoDOgAH6muUI30Iv/ExzFPjpSDrI6c/eS1qX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAOsj2IbgDw/yr9DfxFC4SIxY5sizVB8CZat7H4uNl/F2vm9Tmvy3M9KRGsTvbiff
	 L19aZUx/pQhMgsJjdDQHKAI+FyER2tQasvD0MgTP2pGX63pvQGIVEomzo85biJ0OaO
	 jukaZARTWvpCjncc8KoRjSKZaJXPgZ+EpxjELIrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 542/623] Bluetooth: btusb: mediatek: Add locks for usb_driver_claim_interface()
Date: Wed,  5 Feb 2025 14:44:44 +0100
Message-ID: <20250205134516.957708847@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 279fe6c115fac..f69df515d668b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2638,8 +2638,15 @@ static void btusb_mtk_claim_iso_intf(struct btusb_data *data)
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



