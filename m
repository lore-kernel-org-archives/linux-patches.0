Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7656A2459DD;
	Thu, 28 May 2026 20:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001185; cv=none; b=A76Ax9Z9/LpFThPtA2uZ3dtfg4E5RnUWgluDD5XYuNiEGzuuos2ArRc3oO98ZTEYszkEdLz8yEPpJX4vBnua5vbwcQx9ZI5lZPK4O+O5PAfvVuloxsSARinH+JwxJQCr/sO/CgHFeeLL9EiYDsov7D1sC35ROXB6C8dx8fx2Qq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001185; c=relaxed/simple;
	bh=ZPxltN+b/4ni/dPO0Bdyqs8QJVu088oXCA9fT7IuOAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEpy3pKcFOkTtIV/sr3BzjYW3y90amNxW5ZkO+SanBkjCESc/9hDJzbTZdEyjQ809xU6kl843o702qig8nhy2VTFGe56G16bzaaVb9aJJnNPvXWmHRvnWtHqLi9U+gpXu26Gkm+c68C66+z+Wsxj+h5zhLXDLdrZX0gnc47jnFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=er6e0NsT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="er6e0NsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D496E1F000E9;
	Thu, 28 May 2026 20:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001184;
	bh=CGRVPhBq50JGub2kIiqv/VrZaSXZm6xpfd2DWTylTu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=er6e0NsTszC1nSUPolMGzGwdplaChKuuNfFYS1Rn6EIy+PDp2Tijn6c242gffRicd
	 O6fqWOzsLWdiDhyfmlxssDs5kV12xyjsgyQmm4euBbStF8rfRtlD1KT09Ap+7LjpCf
	 c4eX9DeuoYt22oaar+j/eYIPgMHdQTOa/ynWSUug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 038/186] Bluetooth: hci_uart: fix UAFs and race conditions in close and init paths
Date: Thu, 28 May 2026 21:48:38 +0200
Message-ID: <20260528194929.993140323@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -692,6 +720,10 @@ static int hci_uart_register_dev(struct
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


