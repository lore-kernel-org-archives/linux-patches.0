Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8231F45000;
	Thu, 17 Sep 2026 18:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668828; cv=none; b=AM6TmYUT5t0+W45l/9FDN1gyC/hJviuqtkLQm+KrxLtda59Ek1vxExV55Y9QDpMdap5CAbrHQW1z/LuTr4gzqSX41VANrPCCe9nx0hFQiDFWIv2JVS18qu+BSsV0pT9U0oLjzj24JbdYBtSc9MHRDND2XZKh3HSREuybia3CGqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668828; c=relaxed/simple;
	bh=MzIZ3oMu15JYPp485gMxQglsIGBQWTh/VO4wqbgIOgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zs7fBrsiXrXYJn5SMaveiFfMbIayHNcBYae345+8gSvk77YRX+XUIpmDI7ZmR1L7U6Fawi9jABVZNQEoBUFiNWisJ7d0c/HckQk1tdWhRNf1sT91QH7W0H6pz/DR1jCTjmhCgVd9aRoDQChrUD3nizVMlK1ktbjRk9242HnwJPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V57D1mGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V57D1mGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B348F1F000FF;
	Thu, 17 Sep 2026 18:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668827;
	bh=lpijmF8AbwpG8X7vbbUc0cmwLoK/bXB3DMPZ7zlroxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V57D1mGQpBgEEFmrfr0DbBs4FJWGMIhdu4FpTQ6bd5aFJfSZMbFkr313oOIubSnLQ
	 UWhEMWT45J9ruAGFe+2/Jt28KfK4RgESlJtWdnjumR3TLsUc3QTCout2om9Y2bidMF
	 OZlp+i6AnJtZQHZL2RkJ9dZzwaJiqFsEzVg3Slnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+14ce1b05b7d5a989abbe@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0552/1102] Bluetooth: hci_core: Fix race condition during device registration
Date: Thu, 17 Sep 2026 16:08:15 +0100
Message-ID: <20260917151553.701364060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index aff8ecc879271..f68238406ad2e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2690,11 +2690,11 @@ int hci_register_dev(struct hci_dev *hdev)
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
index bb2cd4ea059b6..26f0ef9dc394f 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -769,8 +769,8 @@ void msft_register(struct hci_dev *hdev)
 
 	INIT_LIST_HEAD(&msft->handle_map);
 	INIT_LIST_HEAD(&msft->address_filters);
-	hdev->msft_data = msft;
 	mutex_init(&msft->filter_lock);
+	hdev->msft_data = msft;
 }
 
 void msft_release(struct hci_dev *hdev)
-- 
2.53.0



