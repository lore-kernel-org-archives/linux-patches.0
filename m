Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938932BE7CD;
	Fri,  9 Oct 2026 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556085; cv=none; b=Id57kYO5QX1CL6IpFKaoZ/Y2FsO51p8HxOzeFVrLQAbRPsbpUcx82RWNAZU79vNOZYabNhFDUUTjX0s5JgGA/KMfIY0VRqjFn/cTFKa5mujumGPXtCFy8B643J2//iBanSQQdWyhbwfiLMFiGjG4w6KbW9IQwr/5DAMxbSSNtBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556085; c=relaxed/simple;
	bh=N/9Yes2qGu59BNHX+DW19pc6GjFOuyGY0TUlQ0MMZS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2rJX+qtaWn9D2cBhs/5vj/K+bXjd3F7WUezhuqpQdqT+lrZxkNVaeglQTXOEsU7mNcu1l9FuOMDC8sUCusQy61rsYuBDUZLwNtSMzLrehrnUirR2KygbAfXJYQQQcaJ7gySNAvsM3H0pjb79/wSzqUrATNwwE4OEwBUKKYCDxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9zF+W/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9zF+W/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28F51F000FF;
	Fri,  9 Oct 2026 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556084;
	bh=vj6R5ypaDN7+a/eTUWnuWajlu53Chsa/wEovhXOhKsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9zF+W/G1ghfRWv4KpvegDQevUx47rlstMulbhhQO9gSMQXYnpYNHhn3mapxH0w2K
	 1NjTUIXb/OZYfZxJ1djEUeZL/SBKgr+qthgECEaw9qT6zikG5TGsTxgYO+00sGxxnO
	 tUgki35fiXFtNhQi3E2KgNcBVQXwruMMhusanZNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+217e3f1283cafe80586e@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 118/428] Bluetooth: hci_sync: dont drain cmd_sync backlog on unregister
Date: Fri,  9 Oct 2026 16:07:35 +0200
Message-ID: <20261009140948.787453044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit b1f24c1ab52345e810c42a1a81286cb5a7c92252 ]

hci_unregister_dev() disables cmd_work and cmd_timer, then calls
hci_cmd_sync_clear(), whose cancel_work_sync() waits for
hci_cmd_sync_work() to return. That worker dequeues and runs every
entry on cmd_sync_work_list. With cmd_work disabled nothing reaches
the controller, so each queued HCI command waits the full
HCI_CMD_TIMEOUT (2s).

The backlog has no bound. Userspace can keep queuing MGMT commands
such as MGMT_OP_GET_CLOCK_INFO against a controller that doesn't
answer. Closing /dev/vhci then blocks in vhci_release() for
backlog * 2s:

  INFO: task syz-executor:5749 blocked for more than 143 seconds.
   cancel_work_sync
   hci_cmd_sync_clear
   hci_unregister_dev
   vhci_release

In a local reproduction the backlog held more than 5000 entries,
which comes to hours of hang.

Stop the worker from taking new entries once HCI_UNREGISTER is set,
and wake any request still waiting with -ENODEV before cancelling
the work. The entries left over are destroyed with -ECANCELED by the
existing sweep in hci_cmd_sync_clear(). They stay on the list until
the work has stopped, so hci_cmd_sync_dequeue() and friends still see
them. A callback already running may still issue another command,
which delays unregister by at most one timeout per remaining command,
not by the whole backlog.

Fixes: 008ee9eb8a11 ("Bluetooth: hci_sync: Fix not processing all entries on cmd_sync_work")
Reported-by: syzbot+217e3f1283cafe80586e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=217e3f1283cafe80586e
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 9d9e270492f93..ad1304e60977a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -312,6 +312,10 @@ static void hci_cmd_sync_work(struct work_struct *work)
 	while (1) {
 		struct hci_cmd_sync_work_entry *entry;
 
+		/* Leave the backlog to hci_cmd_sync_clear() */
+		if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
+			break;
+
 		mutex_lock(&hdev->cmd_sync_work_lock);
 		entry = list_first_entry_or_null(&hdev->cmd_sync_work_list,
 						 struct hci_cmd_sync_work_entry,
@@ -658,6 +662,8 @@ void hci_cmd_sync_clear(struct hci_dev *hdev)
 {
 	struct hci_cmd_sync_work_entry *entry, *tmp;
 
+	/* cmd_work is disabled, the pending request can only time out */
+	hci_cmd_sync_cancel_sync(hdev, ENODEV);
 	cancel_work_sync(&hdev->cmd_sync_work);
 	cancel_work_sync(&hdev->reenable_adv_work);
 
-- 
2.53.0



