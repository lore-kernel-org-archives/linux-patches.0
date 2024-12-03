Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3185C1EE001;
	Tue,  3 Dec 2024 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239370; cv=none; b=szl/Bb4s3fa8EDjCDNdBftjML/l8g/NkM66FOu8+smFVR664LpRIVf+DdeCUZzjebT0id7Puy5uWz/PeICU2u30sf+iA1uXfE+T0iV3Gcr6Qr8jWyKDqG5Z057hsSTAjAaWBCEU2b8JYYz23RUo2UQDAHYGKiOL5jQvCfaEhF8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239370; c=relaxed/simple;
	bh=ENBlz68+AoXG+i2fJ3/zjfF7t73TEZDXlMx5hg9XWik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rl6TGFutrz+EDMAL5boE7aeWnEd5q1rIRoi/0RNcnjsfcoTTZk6sB8Uq4Q7lA/baAAmjXjCNKvQJkHaEMe3k7N1WWZIsOpqW0HxauyCFWTgG//tLHG8COw+qSajjGkO7tVEtcyfhnJnNhDOVGjqL1524j4s2lF9TS63ZzBQK0Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzpNkYOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzpNkYOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA9FC4CECF;
	Tue,  3 Dec 2024 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239370;
	bh=ENBlz68+AoXG+i2fJ3/zjfF7t73TEZDXlMx5hg9XWik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzpNkYOXuST6FfJLN4JKQ/GKbvPHeUsoIIs0L8zwkYLWg3pp+JTz/ARd/vFyLRjQ9
	 liaiZAVqJxdiN1U1t6nM6gjwM772ghvAXrnfG+Ucq3yJj3NUJg+exTIyaS1gp3IPPI
	 8NrDJeQy3PDLic7JbPngDZY7qyFIfd6km0ze/6+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 591/817] Bluetooth: MGMT: Fix possible deadlocks
Date: Tue,  3 Dec 2024 15:42:43 +0100
Message-ID: <20241203144018.993183940@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

[ Upstream commit a66dfaf18fd61bb75ef8cee83db46b2aadf153d0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 3cd747ca65437..ac5684b38dbeb 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1517,7 +1517,8 @@ static void mgmt_set_discoverable_complete(struct hci_dev *hdev, void *data,
 	bt_dev_dbg(hdev, "err %d", err);
 
 	/* Make sure cmd still outstanding. */
-	if (cmd != pending_find(MGMT_OP_SET_DISCOVERABLE, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_SET_DISCOVERABLE, hdev))
 		return;
 
 	hci_dev_lock(hdev);
@@ -1691,7 +1692,8 @@ static void mgmt_set_connectable_complete(struct hci_dev *hdev, void *data,
 	bt_dev_dbg(hdev, "err %d", err);
 
 	/* Make sure cmd still outstanding. */
-	if (cmd != pending_find(MGMT_OP_SET_CONNECTABLE, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_SET_CONNECTABLE, hdev))
 		return;
 
 	hci_dev_lock(hdev);
@@ -1923,7 +1925,7 @@ static void set_ssp_complete(struct hci_dev *hdev, void *data, int err)
 	bool changed;
 
 	/* Make sure cmd still outstanding. */
-	if (cmd != pending_find(MGMT_OP_SET_SSP, hdev))
+	if (err == -ECANCELED || cmd != pending_find(MGMT_OP_SET_SSP, hdev))
 		return;
 
 	if (err) {
@@ -3789,7 +3791,8 @@ static void set_name_complete(struct hci_dev *hdev, void *data, int err)
 
 	bt_dev_dbg(hdev, "err %d", err);
 
-	if (cmd != pending_find(MGMT_OP_SET_LOCAL_NAME, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_SET_LOCAL_NAME, hdev))
 		return;
 
 	if (status) {
@@ -3964,7 +3967,8 @@ static void set_default_phy_complete(struct hci_dev *hdev, void *data, int err)
 	struct sk_buff *skb = cmd->skb;
 	u8 status = mgmt_status(err);
 
-	if (cmd != pending_find(MGMT_OP_SET_PHY_CONFIGURATION, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_SET_PHY_CONFIGURATION, hdev))
 		return;
 
 	if (!status) {
@@ -5855,13 +5859,16 @@ static void start_discovery_complete(struct hci_dev *hdev, void *data, int err)
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
@@ -6094,7 +6101,8 @@ static void stop_discovery_complete(struct hci_dev *hdev, void *data, int err)
 {
 	struct mgmt_pending_cmd *cmd = data;
 
-	if (cmd != pending_find(MGMT_OP_STOP_DISCOVERY, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_STOP_DISCOVERY, hdev))
 		return;
 
 	bt_dev_dbg(hdev, "err %d", err);
@@ -8085,7 +8093,8 @@ static void read_local_oob_ext_data_complete(struct hci_dev *hdev, void *data,
 	u8 status = mgmt_status(err);
 	u16 eir_len;
 
-	if (cmd != pending_find(MGMT_OP_READ_LOCAL_OOB_EXT_DATA, hdev))
+	if (err == -ECANCELED ||
+	    cmd != pending_find(MGMT_OP_READ_LOCAL_OOB_EXT_DATA, hdev))
 		return;
 
 	if (!status) {
-- 
2.43.0



