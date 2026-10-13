Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C56211A09;
	Tue, 13 Oct 2026 12:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894846; cv=none; b=MKocVFVej9bNXYlmXx3qsjP8MwqACujY2W9IRHEGm1T6/70oMvhy1cjCeQCfzFSQHkyoZNfom96stezXelsYQbVqf5TS9ip0VOw3Js52/Zqou9Ozcxe0s4pdXmZId/Gz89lsLMjNl8PIuHr3riojoZMz3vPwWvpXksTMJr3YiwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894846; c=relaxed/simple;
	bh=7ntSQGOBIWI8dS/A2swxqz85MyNDwqBqSvt+BPhKisU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyRFJSlbRyJIBfy4TWsotJe/2JnkQU5Ep4gh4lNolis5eq0P6SBQ3fSz+VZP1ZtcBY0mHk+ST2YATh4CKKA5OPwAlhpyL9GZsnETbyQ4Ri+emAco1IedgTtRmVvsU0uW+vPPCjArzXBqb1Y1sqIKrkAQmb1+XCLqmvVfgbdOTaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlMd0WJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlMd0WJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEC71F00893;
	Tue, 13 Oct 2026 12:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894845;
	bh=+k4yazN4crLFQ/x+upfxXXNanid0PSyxCSD1L+c23GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HlMd0WJfTx+Pl8YAG2JKIstj2vgWjqq9znHyEpKC9q7wTqtjz7SJzumscDuxo/8q/
	 Wni5KCloU29c1+IXQlhGUP3HPNnzefyDIGiQuIlhrUK66IsxalKgGSsMcKv66ihS1Q
	 +rKLE5BExSpF3DJGxOHuvx1cPvby4bpzKwHDCgnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+217e3f1283cafe80586e@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/497] Bluetooth: hci_sync: dont drain cmd_sync backlog on unregister
Date: Tue, 13 Oct 2026 13:34:02 +0200
Message-ID: <20261013112909.667486425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index 78d9623f5faef..4505dc25f77c8 100644
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



