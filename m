Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624367;
	b=Syn5UG3WeHuflizCt7YRT8d5y3yipraGpR8BkkIwDzOJgECZIzr04ad4TfOI8PD2bA2t
	 dFu6MRx2Y98TgKN6ra/uaTzpwHmVnljMLZ6ukgENYv2MDw/tbZao8rMOg1dycx9FSz9yG
	 qeoKzCjy17rcyUo7CfnF2L05oATkDuV2B8dmVpITEyvJoHq2l8EIHoo7/piQhL6IV44y0
	 Nr1XX0fOda0YmNCuiNc+SeRRn1L8lWos0GAd55emtjVwZjtM0u4CF4mMRiRdwoL/Odr+T
	 TUMRUQtkIN+mq9/dTPfyGglv87Nuc3aFeOR5N7lL93Y1lK5ncvHT7uazqQ5z1m/OhBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tpc+c1JKjwajDujcqFYVLPPOSOTGZHUbZ2rja3zl3eg=;
	b=O2Ro+v6W+w8GfSQsyyQyroRevGgik+18qpmn6lh5wZYmuiRy3sSskn0eZ3oBhIgGxtXy
	 1Doh2apXofas2GWkz8XWCyyHqmF5NUwDy1rFPIScXZEgi4gEjGKZXI8VuzJbV2VpwsP4T
	 QJjYbPgrhUFLx+JDniccZOEJnq7C5XFaChDvYMDac6k6oreRYlQBnnUAz5F6C01McEjvV
	 zdCWyAhcvOew5aK5mFXiu056kVt0IA+aUiOusDEmg3JhGmEXfBzwepqFwiA8mJdhAzwHT
	 Shm0GAaSztS96tsAGJ6y0NXsswgNU3P5qfvxgx9dMTHBTJBumHJOKissu9QBaif1dzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nj8F3DAx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7105606A338;
	Wed, 25 Nov 2026 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nj8F3DAx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FA01F000CA;
	Wed, 25 Nov 2026 16:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624366;
	bh=Tpc+c1JKjwajDujcqFYVLPPOSOTGZHUbZ2rja3zl3eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nj8F3DAxqTNLcn3gqajZd7nP/C+OXCUvivG3uAwdLUvd+T1LA4C7cjx5gBFIqSgTl
	 JtpE4v5Y/elkcZkWtAvaHIlKQj4qOfPMDn3bWY3ccgNgDRrmMP0tkvm3ioN1G600YW
	 HwQZudANkeqL60kFJXAu9qfVGRyG+5ULyPHjAQ+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Dewald <kevin@simpleble.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/816] Bluetooth: MGMT: Fix discovery stuck after a failed Stop Discovery
Date: Wed, 25 Nov 2026 15:28:36 +0100
Message-ID: <20261125143853.083515570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Dewald <kevin@simpleble.org>

[ Upstream commit 60b10121db602a43ada3dbc39792bbf93d25991b ]

Stop Discovery moves the discovery to DISCOVERY_STOPPING, and
stop_discovery_complete() only moves it on to DISCOVERY_STOPPED when
stopping succeeded. When it fails, for example because LE Set Scan
Enable times out, nothing moves the discovery out of
DISCOVERY_STOPPING: Stop Discovery is rejected, as the discovery is not
active anymore, and the LE scan timeout was cancelled before the scan
was disabled. Until the controller is powered off, every Start
Discovery then fails with Busy, and hci_update_passive_scan_sync()
skips background scanning, so devices set to auto-connect are not
connected anymore.

Move the discovery back to DISCOVERY_FINDING when stopping it failed
while its inquiry or active LE scan is still running, so that it can be
stopped again. Only change the state while the discovery is still
stopping, as Inquiry Cancel may already have stopped it, for example
when only the passive scan could not be disabled, and a new Start
Discovery may have followed. Do this under hci_dev_lock(), like the
command completions that change these flags, and before replying, so
that a client acting on the reply sees the new state. Only cancel the
LE scan timeout once the scan is disabled, so that the discovery still
ends on its own, except when suspending, where it is still cancelled
first.

A timed out LE Set Scan Enable can still complete afterwards, which
cancels the timeout as well, so also stop the discovery when its scan
is disabled while the timeout is pending, or while the timeout work
waits for the lock.

Fixes: 0e05bba6f6f8 ("Bluetooth: Update stop_discovery to use HCI request")
Assisted-by: Claude:claude-opus-5.5
Signed-off-by: Kevin Dewald <kevin@simpleble.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 12 +++++++++++-
 net/bluetooth/hci_sync.c  | 26 +++++++++++++++++++++++---
 net/bluetooth/mgmt.c      | 23 ++++++++++++++++++++---
 3 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 9e5b71786122e..1fb641656fe0a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1759,6 +1759,8 @@ static void store_pending_adv_report(struct hci_dev *hdev, bdaddr_t *bdaddr,
 
 static void le_set_scan_enable_complete(struct hci_dev *hdev, u8 enable)
 {
+	bool timeout_pending;
+
 	hci_dev_lock(hdev);
 
 	switch (enable) {
@@ -1788,10 +1790,18 @@ static void le_set_scan_enable_complete(struct hci_dev *hdev, u8 enable)
 		/* Cancel this timer so that we don't try to disable scanning
 		 * when it's already disabled.
 		 */
-		cancel_delayed_work(&hdev->le_scan_disable);
+		timeout_pending = cancel_delayed_work(&hdev->le_scan_disable);
 
 		hci_dev_clear_flag(hdev, HCI_LE_SCAN);
 
+		/* The scan of a discovery was disabled before its timeout,
+		 * for example by a Stop Discovery that timed out and still
+		 * completed, so nothing else would end the discovery.
+		 */
+		if (timeout_pending &&
+		    hdev->discovery.state == DISCOVERY_FINDING)
+			hci_discovery_set_state(hdev, DISCOVERY_STOPPED);
+
 		if (hdev->discovery.type == DISCOV_TYPE_INTERLEAVED &&
 		    test_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks) &&
 		    !test_bit(HCI_INQUIRY, &hdev->flags) &&
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index d0ae0e01c52f7..e51af37b10152 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -376,8 +376,18 @@ static void le_scan_disable(struct work_struct *work)
 	bt_dev_dbg(hdev, "");
 	hci_dev_lock(hdev);
 
-	if (!hci_dev_test_flag(hdev, HCI_LE_SCAN))
+	if (!hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
+		/* The scan of a discovery can be disabled while this work
+		 * waits for the lock, for example by a Stop Discovery that
+		 * timed out and still completed, so end the discovery as
+		 * le_set_scan_enable_complete() does when it cancels this
+		 * work.
+		 */
+		if (hdev->discovery.state == DISCOVERY_FINDING)
+			goto discov_stopped;
+
 		goto _return;
+	}
 
 	status = hci_cmd_sync_queue(hdev, scan_disable_sync, NULL, NULL);
 	if (status) {
@@ -5763,11 +5773,15 @@ int hci_stop_discovery_sync(struct hci_dev *hdev)
 		}
 
 		if (hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
-			cancel_delayed_work(&hdev->le_scan_disable);
-
 			err = hci_scan_disable_sync(hdev);
 			if (err)
 				return err;
+
+			/* Only cancel the LE scan timeout once the scan is
+			 * disabled, so that the discovery still ends if
+			 * stopping it failed.
+			 */
+			cancel_delayed_work(&hdev->le_scan_disable);
 		}
 
 	} else {
@@ -6403,6 +6417,12 @@ static int hci_pause_discovery_sync(struct hci_dev *hdev)
 		return 0;
 
 	hci_discovery_set_state(hdev, DISCOVERY_STOPPING);
+
+	/* Cancel the LE scan timeout first, so that it does not run while
+	 * suspended if the scan cannot be disabled.
+	 */
+	cancel_delayed_work(&hdev->le_scan_disable);
+
 	err = hci_stop_discovery_sync(hdev);
 	if (err)
 		return err;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 6405c41f8ceec..fa91db7dab4f4 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -6320,12 +6320,29 @@ static void stop_discovery_complete(struct hci_dev *hdev, void *data, int err)
 
 	bt_dev_dbg(hdev, "err %d", err);
 
+	hci_dev_lock(hdev);
+
+	/* Change the state before replying, so that a client acting on the
+	 * reply sees it, and only while the discovery is still stopping, as
+	 * Inquiry Cancel may already have stopped it and a new Start Discovery
+	 * may have followed. Go back to DISCOVERY_FINDING when stopping failed
+	 * while the inquiry or the active LE scan of the discovery is still
+	 * running, so that it can be stopped again.
+	 */
+	if (hdev->discovery.state == DISCOVERY_STOPPING) {
+		if (err && (test_bit(HCI_INQUIRY, &hdev->flags) ||
+			    (hci_dev_test_flag(hdev, HCI_LE_SCAN) &&
+			     hdev->le_scan_type == LE_SCAN_ACTIVE)))
+			hci_discovery_set_state(hdev, DISCOVERY_FINDING);
+		else
+			hci_discovery_set_state(hdev, DISCOVERY_STOPPED);
+	}
+
+	hci_dev_unlock(hdev);
+
 	mgmt_cmd_complete(cmd->sk, cmd->hdev->id, cmd->opcode, mgmt_status(err),
 			  cmd->param, 1);
 	mgmt_pending_free(cmd);
-
-	if (!err)
-		hci_discovery_set_state(hdev, DISCOVERY_STOPPED);
 }
 
 static int stop_discovery_sync(struct hci_dev *hdev, void *data)
-- 
2.53.0



