Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD7F223C63;
	Thu, 12 Dec 2024 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021561; cv=none; b=svWOKOYo6bAc2o38KWfBtaUpym9zmJ+EV4NSzGl3I2InRFCetwO3FXP5BZX6tJGDVyDl80Xij95VOKZTYwm18IFs2jrrHMIxGjGQUHO8ICL9eiN/VHq4xyQopVil3I54+6QW5OLo/DQR1CVTRYfUMe0Io1g9JAv5Vk+ZtVtSTvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021561; c=relaxed/simple;
	bh=Q+N55HCq73NSi9749xLgSaA9uiEANwGLFSUpP+DqO58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRlD9sJg3Q+jW4pE2J5NtKPrqPfDNvnBwdEfkxjNEyUTJwbSxnpwg9SBU0YKJTO8vYFh//pSnFIJu9HxAau0xyqdztDKDSHVusZrIAG+8l+aIWO3Anu+UP7lGGDPs7mKVGWF+uoMreYOPAuyf7vVLP2u8MDWOT1KzcF6Dgc+9xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zw6vnh85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zw6vnh85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A37C4CECE;
	Thu, 12 Dec 2024 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021561;
	bh=Q+N55HCq73NSi9749xLgSaA9uiEANwGLFSUpP+DqO58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zw6vnh85MuMG8VwuZmrlOU3bzSOWAWZ0iW2kROd+ZFXVahwLzWi9OT+dmJgzZa+Rz
	 4IlOl2lyNoz+CV5fnlF55J222TmVkNP7xAiUdmPx/NNidsA/dQ5Grk4K+nZB0pjEk6
	 bMM6uTDjzLJVWseP4NuEioWsIIrEQxJFNmKNbOxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 772/772] Bluetooth: MGMT: Fix possible deadlocks
Date: Thu, 12 Dec 2024 16:01:57 +0100
Message-ID: <20241212144421.831449972@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit a66dfaf18fd61bb75ef8cee83db46b2aadf153d0 upstream.

This fixes possible deadlocks like the following caused by
hci_cmd_sync_dequeue causing the destroy function to run:

 INFO: task kworker/u19:0:143 blocked for more than 120 seconds.
       Tainted: G        W  O        6.8.0-2024-03-19-intel-next-iLS-24ww14 #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:kworker/u19:0   state:D stack:0     pid:143   tgid:143   ppid:2      flags:0x00004000
 Workqueue: hci0 hci_cmd_sync_work [bluetooth]
 Call Trace:
  <TASK>
  __schedule+0x374/0xaf0
  schedule+0x3c/0xf0
  schedule_preempt_disabled+0x1c/0x30
  __mutex_lock.constprop.0+0x3ef/0x7a0
  __mutex_lock_slowpath+0x13/0x20
  mutex_lock+0x3c/0x50
  mgmt_set_connectable_complete+0xa4/0x150 [bluetooth]
  ? kfree+0x211/0x2a0
  hci_cmd_sync_dequeue+0xae/0x130 [bluetooth]
  ? __pfx_cmd_complete_rsp+0x10/0x10 [bluetooth]
  cmd_complete_rsp+0x26/0x80 [bluetooth]
  mgmt_pending_foreach+0x4d/0x70 [bluetooth]
  __mgmt_power_off+0x8d/0x180 [bluetooth]
  ? _raw_spin_unlock_irq+0x23/0x40
  hci_dev_close_sync+0x445/0x5b0 [bluetooth]
  hci_set_powered_sync+0x149/0x250 [bluetooth]
  set_powered_sync+0x24/0x60 [bluetooth]
  hci_cmd_sync_work+0x90/0x150 [bluetooth]
  process_one_work+0x13e/0x300
  worker_thread+0x2f7/0x420
  ? __pfx_worker_thread+0x10/0x10
  kthread+0x107/0x140
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x3d/0x60
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1b/0x30
  </TASK>

Tested-by: Kiran K <kiran.k@intel.com>
Fixes: f53e1c9c726d ("Bluetooth: MGMT: Fix possible crash on mgmt_index_removed")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1521,7 +1521,8 @@ static void mgmt_set_discoverable_comple
 	bt_dev_dbg(hdev, "err %d", err);
 
 	/* Make sure cmd still outstanding. */
-	if (cmd != pending_find(MGMT_OP_SET_DISCOVERABLE, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_SET_DISCOVERABLE, hdev))
 		return;
 
 	hci_dev_lock(hdev);
@@ -1695,7 +1696,8 @@ static void mgmt_set_connectable_complet
 	bt_dev_dbg(hdev, "err %d", err);
 
 	/* Make sure cmd still outstanding. */
-	if (cmd != pending_find(MGMT_OP_SET_CONNECTABLE, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_SET_CONNECTABLE, hdev))
 		return;
 
 	hci_dev_lock(hdev);
@@ -1928,7 +1930,7 @@ static void set_ssp_complete(struct hci_
 	bool changed;
 
 	/* Make sure cmd still outstanding. */
-	if (cmd != pending_find(MGMT_OP_SET_SSP, hdev))
+	if (err == -ECANCELED || cmd != pending_find(MGMT_OP_SET_SSP, hdev))
 		return;
 
 	if (err) {
@@ -3853,7 +3855,8 @@ static void set_name_complete(struct hci
 
 	bt_dev_dbg(hdev, "err %d", err);
 
-	if (cmd != pending_find(MGMT_OP_SET_LOCAL_NAME, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_SET_LOCAL_NAME, hdev))
 		return;
 
 	if (status) {
@@ -4028,7 +4031,8 @@ static void set_default_phy_complete(str
 	struct sk_buff *skb = cmd->skb;
 	u8 status = mgmt_status(err);
 
-	if (cmd != pending_find(MGMT_OP_SET_PHY_CONFIGURATION, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_SET_PHY_CONFIGURATION, hdev))
 		return;
 
 	if (!status) {
@@ -5919,13 +5923,16 @@ static void start_discovery_complete(str
 {
 	struct mgmt_pending_cmd *cmd = data;
 
+	bt_dev_dbg(hdev, "err %d", err);
+
+	if (err == -ECANCELED)
+		return;
+
 	if (cmd != pending_find(MGMT_OP_START_DISCOVERY, hdev) &&
 	    cmd != pending_find(MGMT_OP_START_LIMITED_DISCOVERY, hdev) &&
 	    cmd != pending_find(MGMT_OP_START_SERVICE_DISCOVERY, hdev))
 		return;
 
-	bt_dev_dbg(hdev, "err %d", err);
-
 	mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode, mgmt_status(err),
 			  cmd->param, 1);
 	mgmt_pending_remove(cmd);
@@ -6158,7 +6165,8 @@ static void stop_discovery_complete(stru
 {
 	struct mgmt_pending_cmd *cmd = data;
 
-	if (cmd != pending_find(MGMT_OP_STOP_DISCOVERY, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_STOP_DISCOVERY, hdev))
 		return;
 
 	bt_dev_dbg(hdev, "err %d", err);
@@ -8105,7 +8113,8 @@ static void read_local_oob_ext_data_comp
 	u8 status = mgmt_status(err);
 	u16 eir_len;
 
-	if (cmd != pending_find(MGMT_OP_READ_LOCAL_OOB_EXT_DATA, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_READ_LOCAL_OOB_EXT_DATA, hdev))
 		return;
 
 	if (!status) {


