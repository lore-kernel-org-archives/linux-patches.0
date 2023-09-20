Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6790F28E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E396EC433C9;
	Wed, 20 Sep 2023 11:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210882;
	bh=VuRmSFvF0HaRnrC6HcoIEiJr1+nFKC8gcSiDbz1TSw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L877GICIWD2f1LaR4iAdUcrgX1RfaWnVQLAhVpgJ0ef61sipinz6GAFHPnUe7Z7vr
	 vaSwLBy6R82cOZ7CuDJhoAQ3324dOOo18HkyoxRXqzF/XQCp6xKgGmff3aXkaPR9UN
	 Q+nWP3OODZZPJYlqgIbkGLVjza6opeRxtZlE/f4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Hsu <yinghsu@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/139] Bluetooth: Fix hci_suspend_sync crash
Date: Wed, 20 Sep 2023 13:29:21 +0200
Message-ID: <20230920112836.612326047@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

From: Ying Hsu <yinghsu@chromium.org>

[ Upstream commit 573ebae162111063eedc6c838a659ba628f66a0f ]

If hci_unregister_dev() frees the hci_dev object but hci_suspend_notifier
may still be accessing it, it can cause the program to crash.
Here's the call trace:
  <4>[102152.653246] Call Trace:
  <4>[102152.653254]  hci_suspend_sync+0x109/0x301 [bluetooth]
  <4>[102152.653259]  hci_suspend_dev+0x78/0xcd [bluetooth]
  <4>[102152.653263]  hci_suspend_notifier+0x42/0x7a [bluetooth]
  <4>[102152.653268]  notifier_call_chain+0x43/0x6b
  <4>[102152.653271]  __blocking_notifier_call_chain+0x48/0x69
  <4>[102152.653273]  __pm_notifier_call_chain+0x22/0x39
  <4>[102152.653276]  pm_suspend+0x287/0x57c
  <4>[102152.653278]  state_store+0xae/0xe5
  <4>[102152.653281]  kernfs_fop_write+0x109/0x173
  <4>[102152.653284]  __vfs_write+0x16f/0x1a2
  <4>[102152.653287]  ? selinux_file_permission+0xca/0x16f
  <4>[102152.653289]  ? security_file_permission+0x36/0x109
  <4>[102152.653291]  vfs_write+0x114/0x21d
  <4>[102152.653293]  __x64_sys_write+0x7b/0xdb
  <4>[102152.653296]  do_syscall_64+0x59/0x194
  <4>[102152.653299]  entry_SYSCALL_64_after_hwframe+0x5c/0xc1

This patch holds the reference count of the hci_dev object while
processing it in hci_suspend_notifier to avoid potential crash
caused by the race condition.

Signed-off-by: Ying Hsu <yinghsu@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 146553c0054f6..fa4dd5fab0d44 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2436,6 +2436,9 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 	if (hci_dev_test_flag(hdev, HCI_USER_CHANNEL))
 		return NOTIFY_DONE;
 
+	/* To avoid a potential race with hci_unregister_dev. */
+	hci_dev_hold(hdev);
+
 	if (action == PM_SUSPEND_PREPARE)
 		ret = hci_suspend_dev(hdev);
 	else if (action == PM_POST_SUSPEND)
@@ -2445,6 +2448,7 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 		bt_dev_err(hdev, "Suspend notifier action (%lu) failed: %d",
 			   action, ret);
 
+	hci_dev_put(hdev);
 	return NOTIFY_DONE;
 }
 
-- 
2.40.1



