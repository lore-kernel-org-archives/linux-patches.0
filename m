Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6001642BE99;
	Thu, 16 Jul 2026 14:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211980; cv=none; b=B9sUj/TzXmxrhPsxwxTQIlxNuwHPo/4HMwX3PFvm0vDKUAftKbfVF8YtFgvfHXum9Hw79DY9uq6i2P7FeHEsZt9oocKpVdoFsu+4AHcLqoxbgz6VRUASLH+VPmT2hOCLPSRRf1Y7SBgtgJghJmqbe9odnC4qKhDaYIB2qRrPz6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211980; c=relaxed/simple;
	bh=wUgyaxTUqeQVE9ZRloXn+MaPJa1UWuLMw+aS3E3B4bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExRGKXLaCBx+9y66lu8e2JiIEhejT+8WuzYO83RxZrpv1zym3fvfARhkXpLS9mJ6sKVSqJHR3sEaHEeYbgoVOnrncw8SLBeizg2FRyIaEvwl4k09io/bPi55cr31B1dXf6vYHmk9IEGCjH9l+335+XVZwfffTsoQAXYTRgO3gG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDWhjhxe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDWhjhxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7571F000E9;
	Thu, 16 Jul 2026 14:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211979;
	bh=s4NnnP1kFBLD8b57XFN4a/IgWJltlTtxRAdMFEp+rds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDWhjhxe7cwftQgNN0MA0m/zOk9acTA8huFslGkfoNLnRNGXmR9rsvEhRG3jhycYr
	 o/iA7SdLx497gyHJWb2PBiKKu7VtiDnwufZrOggywVMOZYUswWzOC5t9WRQ65UrD09
	 OtM7en5s+R80rQtiA7hBpz4HykkUaep+Hwzb5WaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 154/349] Bluetooth: hci_uart: clear HCI_UART_SENDING when write_work is canceled
Date: Thu, 16 Jul 2026 15:31:28 +0200
Message-ID: <20260716133036.831055700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


