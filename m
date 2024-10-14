Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343DF18035;
	Mon, 14 Oct 2024 14:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916162; cv=none; b=RQpWJooHvgn6Hzy3KQwjiAECJEW2Q1WARpFYJhK7glql2huwsGPnRgVU9YpnRKPMvJ+dHcVBZWXVK5hVUPTDC1W8RAxx1JNnzIlm8FkKI9tyjsC7M8fgdyqI1+sazve7k2aUzjdWJ6UKbANMeHtM2v1YoM2K/j6sTpnl5ko6quM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916162; c=relaxed/simple;
	bh=/kl86Vu/SiPIRJ0zQJCRmCambDqfLFy8VG3LgamEOUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdTXht1YFKR95FN9bXJ+0O1nTC5YrfFxxlU288BmcDYPmLTwMOEIhZlsY7c0c50RXp0Hdtr11tmDyjFUoFp36LRtn1thqZWEjwFDOwoGDWhcF3UPaLfoZ7dyIo9zJ7iveuwLE+wtH6WEZkm4hLIwtFJ38g34Ch4aCms9Qr5fIHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jm9lomXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jm9lomXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE76C4CEC3;
	Mon, 14 Oct 2024 14:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916162;
	bh=/kl86Vu/SiPIRJ0zQJCRmCambDqfLFy8VG3LgamEOUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jm9lomXwQwpsGUtKslmQYsT2udV+YCx42uq8u/XcfYrjwmlrBag3m0YCICNXeNViz
	 Nowt4OWKn6QwP5Ieu8hFBAtm0iFXDId5SgT1x+DNtgZXZclbAxDZl8czazLZO72/bm
	 CQT3S3Og+oXeANXJ7o2Rn1HGy+OrkuRUr2cZ9A9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 103/214] Bluetooth: btusb: Dont fail external suspend requests
Date: Mon, 14 Oct 2024 16:19:26 +0200
Message-ID: <20241014141049.013288325@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 610712298b11b2914be00b35abe9326b5dbb62c8 ]

Commit 4e0a1d8b0675
("Bluetooth: btusb: Don't suspend when there are connections")
introduces a check for connections to prevent auto-suspend but that
actually ignored the fact the .suspend callback can be called for
external suspend requests which
Documentation/driver-api/usb/power-management.rst states the following:

 'External suspend calls should never be allowed to fail in this way,
 only autosuspend calls.  The driver can tell them apart by applying
 the :c:func:`PMSG_IS_AUTO` macro to the message argument to the
 ``suspend`` method; it will return True for internal PM events
 (autosuspend) and False for external PM events.'

In addition to that align system suspend with USB suspend by using
hci_suspend_dev since otherwise the stack would be expecting events
such as advertising reports which may not be delivered while the
transport is suspended.

Fixes: 4e0a1d8b0675 ("Bluetooth: btusb: Don't suspend when there are connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 93dbeb8b348d5..a1e9b052bc847 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4092,16 +4092,29 @@ static void btusb_disconnect(struct usb_interface *intf)
 static int btusb_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct btusb_data *data = usb_get_intfdata(intf);
+	int err;
 
 	BT_DBG("intf %p", intf);
 
-	/* Don't suspend if there are connections */
-	if (hci_conn_count(data->hdev))
+	/* Don't auto-suspend if there are connections; external suspend calls
+	 * shall never fail.
+	 */
+	if (PMSG_IS_AUTO(message) && hci_conn_count(data->hdev))
 		return -EBUSY;
 
 	if (data->suspend_count++)
 		return 0;
 
+	/* Notify Host stack to suspend; this has to be done before stopping
+	 * the traffic since the hci_suspend_dev itself may generate some
+	 * traffic.
+	 */
+	err = hci_suspend_dev(data->hdev);
+	if (err) {
+		data->suspend_count--;
+		return err;
+	}
+
 	spin_lock_irq(&data->txlock);
 	if (!(PMSG_IS_AUTO(message) && data->tx_in_flight)) {
 		set_bit(BTUSB_SUSPENDING, &data->flags);
@@ -4109,6 +4122,7 @@ static int btusb_suspend(struct usb_interface *intf, pm_message_t message)
 	} else {
 		spin_unlock_irq(&data->txlock);
 		data->suspend_count--;
+		hci_resume_dev(data->hdev);
 		return -EBUSY;
 	}
 
@@ -4229,6 +4243,8 @@ static int btusb_resume(struct usb_interface *intf)
 	spin_unlock_irq(&data->txlock);
 	schedule_work(&data->work);
 
+	hci_resume_dev(data->hdev);
+
 	return 0;
 
 failed:
-- 
2.43.0



