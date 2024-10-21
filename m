Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9848A1E47AC;
	Mon, 21 Oct 2024 10:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506716; cv=none; b=pv30dXxCJ4awp5Mw87gFahr+CAlLrjkJTtSKdODXA5mdn0winLYdk3FSM7W67vxYpkmJKh/bP8VkXaAwV+1uWGO4NhjjhcrDKe+eL922NfeCE89udbTYRjWNMttZ8JNxy3bPFNriHSG5fgXRSnnp3ieHGbo6YMegvlMZ4tY0Z44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506716; c=relaxed/simple;
	bh=oGZGF2/1VdY2Z3iPwRddJi9ELOwmPnoKFw1New4Dixo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sh7AuCsP4vat7Z9LAu5q7QdBBk717Y1r1oprBjpf1edMfW2CIkzNSB247I4QSh6dVzdEwqthdcbIetApGi2aRF5AH1hFF7KGb8qdVbhpVuSc7Xyll4N/f8AfCVS53TY5//4LIQDWXdrC0sPUl7Awff1MhHftP0eWxWqKSKGG0lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrVUZUMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrVUZUMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E15C4CEE5;
	Mon, 21 Oct 2024 10:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506716;
	bh=oGZGF2/1VdY2Z3iPwRddJi9ELOwmPnoKFw1New4Dixo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrVUZUMNlFGtodblmw6qAgz1+qWOUUwEf8J9e70W6Jgjahw+WPbogEnZkN53Fjrky
	 jOgHVr014VzaSENSNFXuiivdenKNYijP4bdwqxnVg4uneXAUqgHFp5tPHH+283ttua
	 YFraYYi0aVUWhqwnUawmhEIsp0+aODigxSRLNsEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Kenneth Crudup <kenny@panix.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.11 097/135] Bluetooth: btusb: Fix not being able to reconnect after suspend
Date: Mon, 21 Oct 2024 12:24:13 +0200
Message-ID: <20241021102303.120595342@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

commit 4084286151fc91cd093578f615bfb68f9efbbfcb upstream.

This partially reverts 81b3e33bb054 ("Bluetooth: btusb: Don't fail
external suspend requests") as it introduced a call to hci_suspend_dev
that assumes the system-suspend which doesn't work well when just the
device is being suspended because wakeup flag is only set for remote
devices that can wakeup the system.

Reported-by: Rafael J. Wysocki <rafael@kernel.org>
Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Reported-by: Kenneth Crudup <kenny@panix.com>
Fixes: 610712298b11 ("Bluetooth: btusb: Don't fail external suspend requests")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4092,7 +4092,6 @@ static void btusb_disconnect(struct usb_
 static int btusb_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct btusb_data *data = usb_get_intfdata(intf);
-	int err;
 
 	BT_DBG("intf %p", intf);
 
@@ -4105,16 +4104,6 @@ static int btusb_suspend(struct usb_inte
 	if (data->suspend_count++)
 		return 0;
 
-	/* Notify Host stack to suspend; this has to be done before stopping
-	 * the traffic since the hci_suspend_dev itself may generate some
-	 * traffic.
-	 */
-	err = hci_suspend_dev(data->hdev);
-	if (err) {
-		data->suspend_count--;
-		return err;
-	}
-
 	spin_lock_irq(&data->txlock);
 	if (!(PMSG_IS_AUTO(message) && data->tx_in_flight)) {
 		set_bit(BTUSB_SUSPENDING, &data->flags);
@@ -4122,7 +4111,6 @@ static int btusb_suspend(struct usb_inte
 	} else {
 		spin_unlock_irq(&data->txlock);
 		data->suspend_count--;
-		hci_resume_dev(data->hdev);
 		return -EBUSY;
 	}
 
@@ -4243,8 +4231,6 @@ static int btusb_resume(struct usb_inter
 	spin_unlock_irq(&data->txlock);
 	schedule_work(&data->work);
 
-	hci_resume_dev(data->hdev);
-
 	return 0;
 
 failed:


