Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A97334695;
	Sat, 30 May 2026 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162190; cv=none; b=GERLJFA8ZKE53AePw9sj4VRSGahCKU8orOE5kxrZlbG1S7il79Ou3ZX5dKFjFUKNBBpFeWX/ymMprwqLvPev2QiPAiVTMBRNEZnmnzGimX7UaqxdlIyiV/wUE7XrsCqXwvwfbmWssizKiJK2a1giiUErR4U5B77sp4wsF1NwDAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162190; c=relaxed/simple;
	bh=R0FYGSPfzA9Ru1fBKL782BwyD8M2lhC5t+UpwBBMMhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpcfwZWaWIjWRLzRUQQ2ulKhqKVjNNQcJmH/FbOjKstxMjk+EKXUg0ZrmYHAkWZItI7qRQ6bzfoXtO+i6U3BUZOVmvZvLXWbDvjP3tWzKpYxvC64xY5i9g1gJ+ZFIG5qsi+/QD1pymCvLsg8ukbrKL2xO0XDZ827aiSDypP1/VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlF2FNHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlF2FNHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD6A1F00893;
	Sat, 30 May 2026 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162189;
	bh=NAf5C4z5zYCMXKkHC2Iax6Fbu+IexaXGXkYL5XMBkJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jlF2FNHx/2Eo92JQCHPdYv9TDwX1hTmFYJWONK1g+z/BIxGcbxnwllx4IKpRbYUZA
	 3uqG9pK8z27W/+tUUtVpDNZ3zuQ2rKB434YVUE9MdpUPhpXvx9a+7aPEpkp1tr/+ga
	 stO18LH+h2bEX2dwyzUgQsYEMAF4WpGGNqG441W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 847/969] Bluetooth: hci_uart: fix UAFs and race conditions in close and init paths
Date: Sat, 30 May 2026 18:06:11 +0200
Message-ID: <20260530160324.050836369@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

commit c1bb9336ae6b54a5f6a353c4bd4ed9a4307e429b upstream.

Vulnerabilities leading to Use-After-Free (UAF) and Null Pointer
Dereference (NPD) conditions were observed in the lifecycle management
of hci_uart.

The primary issue arises because the workqueues (init_ready and
write_work) are only flushed/cancelled if the HCI_UART_PROTO_READY
flag is set during TTY close. If a hangup occurs before setup completes,
hci_uart_tty_close() skips the teardown of these workqueues and
proceeds to free the `hu` struct. When the scheduled work executes
later, it blindly dereferences the freed `hu` struct.

Furthermore, several data races and UAFs were identified in the teardown
sequence:
1. Calling hci_uart_flush() from hci_uart_close() without effectively
   disabling write_work causes a race condition where both can concurrently
   double-free hu->tx_skb. This happens because protocol timers can
   concurrently invoke hci_uart_tx_wakeup() and requeue write_work.
2. Calling hci_free_dev(hdev) before hu->proto->close(hu) causes a UAF
   when vendor specific protocol close callbacks dereference hu->hdev.
3. In the initialization error paths, failing to take the proto_lock
   write lock before clearing PROTO_READY leads to races with active
   readers. Additionally, hci_uart_tty_receive() accesses hu->hdev
   outside the read lock, leading to UAFs if the initialization error
   path frees hdev concurrently.

Fix these synchronization and lifecycle issues by:
1. Re-ordering hci_uart_tty_close() to clear HCI_UART_PROTO_READY first,
   followed immediately by a cancel_work_sync(&hu->write_work). Clearing
   the flag locks out concurrent protocol timers from successfully invoking
   hci_uart_tx_wakeup(), effectively rendering the cancellation permanent
   and preventing the tx_skb double-free.
2. Note: Clearing PROTO_READY early causes hci_uart_close() to skip
   hu->proto->flush(). This is perfectly safe in the tty_close path
   because hu->proto->close() executes shortly after, which intrinsically
   purges all protocol SKB queues and tears down the state.
3. Relocating hu->proto->close(hu) strictly prior to hci_free_dev(hdev)
   across all close and error paths to prevent vendor-level UAFs.
4. Moving the hdev->stat.byte_rx increment in hci_uart_tty_receive()
   inside the proto_lock read-side critical section to safely synchronize
   with device unregistration.
5. Adding cancel_work_sync(&hu->write_work) to hci_uart_close() to safely
   flush the workqueue before hci_uart_flush() is invoked via the HCI core.
6. Utilizing cancel_work_sync() instead of disable_work_sync() across
   all paths to prevent permanently breaking user-space retry capabilities.

Fixes: 3b799254cf6f ("Bluetooth: hci_uart: Cancel init work before unregistering")
Cc: stable@vger.kernel.org
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_ldisc.c |   48 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 8 deletions(-)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -194,7 +194,15 @@ void hci_uart_init_work(struct work_stru
 	err = hci_register_dev(hu->hdev);
 	if (err < 0) {
 		BT_ERR("Can't register HCI device");
+
+		percpu_down_write(&hu->proto_lock);
 		clear_bit(HCI_UART_PROTO_READY, &hu->flags);
+		percpu_up_write(&hu->proto_lock);
+
+		/* Safely cancel work after clearing flags */
+		cancel_work_sync(&hu->write_work);
+
+		/* Close protocol before freeing hdev */
 		hu->proto->close(hu);
 		hdev = hu->hdev;
 		hu->hdev = NULL;
@@ -263,8 +271,12 @@ static int hci_uart_open(struct hci_dev
 /* Close device */
 static int hci_uart_close(struct hci_dev *hdev)
 {
+	struct hci_uart *hu = hci_get_drvdata(hdev);
+
 	BT_DBG("hdev %p", hdev);
 
+	cancel_work_sync(&hu->write_work);
+
 	hci_uart_flush(hdev);
 	hdev->flush = NULL;
 	return 0;
@@ -528,6 +540,7 @@ static void hci_uart_tty_close(struct tt
 {
 	struct hci_uart *hu = tty->disc_data;
 	struct hci_dev *hdev;
+	bool proto_ready;
 
 	BT_DBG("tty %p", tty);
 
@@ -537,24 +550,38 @@ static void hci_uart_tty_close(struct tt
 	if (!hu)
 		return;
 
-	hdev = hu->hdev;
-	if (hdev)
-		hci_uart_close(hdev);
+	/* Wait for init_ready to finish to prevent registration races */
+	cancel_work_sync(&hu->init_ready);
 
-	if (test_bit(HCI_UART_PROTO_READY, &hu->flags)) {
+	proto_ready = test_bit(HCI_UART_PROTO_READY, &hu->flags);
+	if (proto_ready) {
 		percpu_down_write(&hu->proto_lock);
 		clear_bit(HCI_UART_PROTO_READY, &hu->flags);
 		percpu_up_write(&hu->proto_lock);
+	}
 
-		cancel_work_sync(&hu->init_ready);
-		cancel_work_sync(&hu->write_work);
+	/*
+	 * Unconditionally cancel write_work AFTER clearing PROTO_READY.
+	 * This ensures that concurrent protocol timers cannot requeue
+	 * write_work via hci_uart_tx_wakeup(), permanently preventing
+	 * double-free races and UAFs.
+	 */
+	cancel_work_sync(&hu->write_work);
+
+	hdev = hu->hdev;
+	if (hdev)
+		hci_uart_close(hdev); /* proto->flush is safely skipped */
 
+	if (proto_ready) {
 		if (hdev) {
 			if (test_bit(HCI_UART_REGISTERED, &hu->flags))
 				hci_unregister_dev(hdev);
-			hci_free_dev(hdev);
 		}
+		/* Close protocol before freeing hdev (intrinsically purges queues) */
 		hu->proto->close(hu);
+
+		if (hdev)
+			hci_free_dev(hdev);
 	}
 	clear_bit(HCI_UART_PROTO_SET, &hu->flags);
 
@@ -622,11 +649,12 @@ static void hci_uart_tty_receive(struct
 	 * tty caller
 	 */
 	hu->proto->recv(hu, data, count);
-	percpu_up_read(&hu->proto_lock);
 
 	if (hu->hdev)
 		hu->hdev->stat.byte_rx += count;
 
+	percpu_up_read(&hu->proto_lock);
+
 	tty_unthrottle(tty);
 }
 
@@ -697,6 +725,10 @@ static int hci_uart_register_dev(struct
 		percpu_down_write(&hu->proto_lock);
 		clear_bit(HCI_UART_PROTO_INIT, &hu->flags);
 		percpu_up_write(&hu->proto_lock);
+		/* Cancel work after clearing flags */
+		cancel_work_sync(&hu->write_work);
+
+		/* Close protocol before freeing hdev */
 		hu->proto->close(hu);
 		hu->hdev = NULL;
 		hci_free_dev(hdev);


