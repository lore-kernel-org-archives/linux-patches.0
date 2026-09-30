Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29693C3F6F;
	Wed, 30 Sep 2026 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795032; cv=none; b=qW3lrOcP2Ozj79uK/czr7oxW+qgYP61GwunINTWBcJoKneQpIJI33OnppPaMCdzfJTP7rm4GbHA2VvPyUdBSlB/W6RR9BQO7c0aHMbq2mEexWCi0xWWCfSG3xyYie3NUXSniMbyc1twl6cmJHfC4dYX5o+oByvO9emBcNS0VmMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795032; c=relaxed/simple;
	bh=FvLGWLzyFH0V8lpD0I8KRk/j1XUwEJfuFIgmBgzx5iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKqmELwMT5pGWKTkYowiEe5PFvHmi1s5CRVlmnfbA7jtFcce6sslFBy3QsTrK9IDK8h/4ag2oLxoVEHcipycZWtDAjkXn0WJW/E+uhMgwzTSMYv22UXt6HpmKUSTASE/uzp1rEKbHgwwT+wSpzBj0Lc/H2EcfymsSRD6Hwe6WG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEOuYQC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEOuYQC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3E21F000FF;
	Wed, 30 Sep 2026 19:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795031;
	bh=CbSejmLnCZI/+tUeRK+n/qGSGMAvt88P0J9sUPW1TUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEOuYQC6XanJbUHmVrUAXj8V3BKvcr9Hk5VXrpZKxwIgbgYZ7L/Y3mXZMs0/HSheu
	 MW6G3moONRDAMm0InlmH7YlPVmRVeCVnqRsXO1BRhjD87TXZe7r5u5D4TwfuS9HC9z
	 uL4ue8XE5Fyo9tLUtzRqASolMpC2mr97+y/8z1Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+14ce1b05b7d5a989abbe@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0417/1193] Bluetooth: hci_core: Fix race condition during device registration
Date: Wed, 30 Sep 2026 17:18:21 +0200
Message-ID: <20260930152443.464833637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit 57938bbdb9bf7fd41cbd5cd509ec10c4b22bec18 ]

In hci_register_dev(), the power_on work item is queued to
hdev->req_workqueue before initializing hdev->adv_monitors_idr and
registering the MSFT extension via msft_register(). For devices marked with
quirks such as HCI_QUIRK_RAW_DEVICE, the HCI_UNCONFIGURED flag is set on
the device. When the power_on work item runs concurrently on another CPU,
hci_power_on() detects that the device is unconfigured and immediately
invokes hci_dev_do_close(), which calls msft_do_close().

Concurrently, msft_register() allocates the msft structure and exposes it
to hdev->msft_data prior to calling mutex_init(&msft->filter_lock). If
msft_do_close() executes while hdev->msft_data is already assigned but the
mutex has not yet been initialized, mutex_lock(&msft->filter_lock) operates
on an uninitialized mutex, triggering a DEBUG_LOCKS warning:

DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: kernel/locking/mutex.c:625 at __mutex_lock_common
kernel/locking/mutex.c:625 [inline]
WARNING: kernel/locking/mutex.c:625 at __mutex_lock+0x12d8/0x1550
kernel/locking/mutex.c:821
...
Call Trace:
 <TASK>
 msft_do_close+0x308/0x7b0 net/bluetooth/msft.c:693
 hci_dev_close_sync+0x86b/0x10a0 net/bluetooth/hci_sync.c:5522
 hci_dev_do_close net/bluetooth/hci_core.c:499 [inline]
 hci_power_on+0x32c/0x750 net/bluetooth/hci_core.c:937
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fix this by moving the queue_work() call in hci_register_dev() to after
idr_init(&hdev->adv_monitors_idr) and msft_register(hdev) so that device
structures and extensions are fully initialized before asynchronous tasks
can access them. Additionally, assign hdev->msft_data in msft_register()
only after mutex_init(&msft->filter_lock) has completed.

Fixes: 9e14606d8f38 ("Bluetooth: msft: Extended monitor tracking by address filter")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+14ce1b05b7d5a989abbe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=14ce1b05b7d5a989abbe
Link: https://syzkaller.appspot.com/ai_job?id=2bc9e8aa-ca6d-43e2-be2c-fd5d9f649d7e
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 ++--
 net/bluetooth/msft.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index cf9121f01fc67..efc23bed5b9fe 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2662,11 +2662,11 @@ int hci_register_dev(struct hci_dev *hdev)
 	if (error)
 		BT_WARN("register suspend notifier failed error:%d\n", error);
 
-	queue_work(hdev->req_workqueue, &hdev->power_on);
-
 	idr_init(&hdev->adv_monitors_idr);
 	msft_register(hdev);
 
+	queue_work(hdev->req_workqueue, &hdev->power_on);
+
 	return id;
 
 err_wqueue:
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 01592eb4704ff..98b6e1ee9833d 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -770,8 +770,8 @@ void msft_register(struct hci_dev *hdev)
 
 	INIT_LIST_HEAD(&msft->handle_map);
 	INIT_LIST_HEAD(&msft->address_filters);
-	hdev->msft_data = msft;
 	mutex_init(&msft->filter_lock);
+	hdev->msft_data = msft;
 }
 
 void msft_release(struct hci_dev *hdev)
-- 
2.53.0



