Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6753F54B6;
	Thu, 16 Jul 2026 14:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210853; cv=none; b=J5brW8lHlS7X96CCLZq0Lr9fwXx+1t8smpcDFCAXqk9XoaEnGm9OfKItNa0NJZRkYxyVAR6Zb6FPQQm3GbwTjsvWWkqvBKr5zNTNfHSJcjXYtMKBURwTwsFlcrkGRmSX31V/eiR7tgN89EOgDDNOLsKfFozZEbx3tWXvLBDUs7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210853; c=relaxed/simple;
	bh=tIutXDufgBMOedgGLjJy9sEp1eb6pr/FVimFuQz3UFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVnKDoKaTEwd5JlZsrNq+L+7v4aIqiB5g4KjBrXpcYo5l10qnyQr8hxl8w/2BPosBsEUVqBovxVnhL7exAT5XAm54CeqIJWbmgJr4J9iVRgyopYLS96K/etFM485TQgfBbq+dVRg8M0c+rfOAn4XqNmmmwxum5v863/MllgGvO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=coUEE9CR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="coUEE9CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A365D1F000E9;
	Thu, 16 Jul 2026 14:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210852;
	bh=VEUa3SMZCfvIOJa7nnFuOzJm7BEdu3SEdQT3JfLLr4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=coUEE9CRhOQhbBDhg/sIQCVClxx5sxChXOxEc8RBOABeOSwJ0gzpd0rw+MqMrla9X
	 5CZOd4L3Y7UGBap1xiKepS8Qsc3kPrnMB7Sz0vJeBK4wg9zUNnTifLlDjmYhXvSjbt
	 QS24x612fhyIgVNK0bXw+nHPuHWcr+UnVtqB5ez4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 205/480] Bluetooth: hci_uart: clear HCI_UART_SENDING when write_work is canceled
Date: Thu, 16 Jul 2026 15:29:12 +0200
Message-ID: <20260716133049.160606402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

commit 1b0d946d6f08bd39211385bc703a440911b41e46 upstream.

HCI_UART_SENDING bit in tx_state means write_work is pending and blocks
queueing it again.  Currently this bit is not cleared when canceling the
work in hci_uart_close(), which blocks future writes when device is
reopened later if write_work was pending.

Fix by clearing HCI_UART_SENDING when canceling the work.

Also make clearing of tx_skb safe by using disable_work_sync +
enable_work instead of just cancel_work_sync.  hci_uart_flush() purges
the proto tx queue so we can cancel the pending write_work there,
instead of doing it just in hci_uart_close().  Re-enable and possibly
requeue the work after queue flush.

Fixes: c1bb9336ae6b ("Bluetooth: hci_uart: fix UAFs and race conditions in close and init paths")
Link: https://lore.kernel.org/linux-bluetooth/07e0a28650773abec711ee492fdb1bf5d21a6c98.camel@iki.fi/
Cc: stable@vger.kernel.org
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_ldisc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -239,6 +239,8 @@ static int hci_uart_flush(struct hci_dev
 
 	BT_DBG("hdev %p tty %p", hdev, tty);
 
+	disable_work_sync(&hu->write_work);
+
 	if (hu->tx_skb) {
 		kfree_skb(hu->tx_skb); hu->tx_skb = NULL;
 	}
@@ -254,6 +256,14 @@ static int hci_uart_flush(struct hci_dev
 
 	percpu_up_read(&hu->proto_lock);
 
+	/* Resume TX. Also reschedule in case work was queued concurrently;
+	 * this may schedule write_work although there's nothing to do.
+	 */
+	enable_work(&hu->write_work);
+	clear_bit(HCI_UART_SENDING, &hu->tx_state);
+	if (test_bit(HCI_UART_TX_WAKEUP, &hu->tx_state))
+		hci_uart_tx_wakeup(hu);
+
 	return 0;
 }
 
@@ -271,12 +281,8 @@ static int hci_uart_open(struct hci_dev
 /* Close device */
 static int hci_uart_close(struct hci_dev *hdev)
 {
-	struct hci_uart *hu = hci_get_drvdata(hdev);
-
 	BT_DBG("hdev %p", hdev);
 
-	cancel_work_sync(&hu->write_work);
-
 	hci_uart_flush(hdev);
 	hdev->flush = NULL;
 	return 0;


