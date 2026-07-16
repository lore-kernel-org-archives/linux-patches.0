Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83ACE2F6911;
	Thu, 16 Jul 2026 13:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209506; cv=none; b=ItxdvavMNbkNRTAhMeFFLfdOxKxVOOZZBvApBMyuXXu82Lp+rpaaOvf/+80WgpdKwmnGjxWnLIpHZ+yNzJ8YVzNpjXu8KSlNU6c2MSvuncVEbRhWo1L8GRfPRpAfW8KXXN6GZnlaJJOnszDvXWRuCxr075uCK2oSxGk3fZO/Rwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209506; c=relaxed/simple;
	bh=0Vxh5dlDplThBreoFRHFhNY37fVnWfiXhCMho3Bji54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfaYfYe/kIokl/eXY7hThZ7kgYcP7aERnFGI1bBaS8ynY9UDgiyhPNOa76sDncodfE5ZCd4b8ezf7M3Fuo9Yoy+8DwOmQpt04JJ6dN5eJDreRNLQDiopzKkOkHnvNT0SHNXv5MjcfqObACAvHZUQXCW5+8k8WTggKsQ9dhwmSuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4dRdQq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4dRdQq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E240E1F000E9;
	Thu, 16 Jul 2026 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209505;
	bh=NxdFsuQjiFGsVUcY7r7gmFMFYhUzAivTpXSlJbQAPOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4dRdQq7KDDeUEMpyIOX6EPLb0pPwzW9GitPlzDJSlvvUMe90a5wd6NVUgOkTQSjr
	 BMEwBWnXUMlJkzdnCOajSgoFxX+my3KqdnDXtE+vIu0G8cmr9drWqbuhg1h+gP3ja8
	 sZ3BPRlHnD0EqQVhu/hFdj+2IyJ8Bcn+Vb82Qkc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 209/518] Bluetooth: hci_uart: clear HCI_UART_SENDING when write_work is canceled
Date: Thu, 16 Jul 2026 15:27:57 +0200
Message-ID: <20260716133052.392594001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


