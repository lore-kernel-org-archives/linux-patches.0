Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AA7285404;
	Wed,  4 Feb 2026 15:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217303; cv=none; b=GhwPSgiRta5dmYWtObS5dcGAeHZN4dmkdcoG3maCDCIO/51tLnZal5bcuWTfpO+k9BAP5/MoNRli505vBF/FlRmtfxOGOyoJogBTEFY4+pTuE7I5sdQ0I+Ai5yq6aLDDs9QisDCO7V99VuWcozdvpe+ni6bJVfCfO7/0t1OoLkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217303; c=relaxed/simple;
	bh=8V8D4l2dzhmg6/GRhObbgTrF+syftXFtWre9W8aFE60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5FxPaWyBmbWgXS8N3mhEzqPn7UGQ4o1lID/JVlgwwcSfYxqln6e7MnAoAPqEVWEO9s9GkMmy+cB2UIiipXgpZKj1HcmA7Y3vXzbGfJGCiHHXJV0/A/E9nsA9yZoazDQ5ngCh2FElURUjRq0zG73nL2Yumc/k5IrbdyjSFJSAoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y04N6Jqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y04N6Jqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41269C4CEF7;
	Wed,  4 Feb 2026 15:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217302;
	bh=8V8D4l2dzhmg6/GRhObbgTrF+syftXFtWre9W8aFE60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y04N6Jqz5BGSpb6M4Pju8/vTnvpDbfNosL9rMzhrOQpsniDVdfkFNst+dqY31JbaL
	 MF1nmOip+7f2XFz3z7tbDDJl10oe6Xg9e5L/ReGlUAY5Mu/cnHEASWmM3VJMth/X6/
	 tg3cmbAbv1mjjqWD8aII57kxSb3osSySGATTcYoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Hsu <yinghsu@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 5.15 184/206] Bluetooth: Fix hci_suspend_sync crash
Date: Wed,  4 Feb 2026 15:40:15 +0100
Message-ID: <20260204143904.847167191@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Adjust context ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3706,6 +3706,9 @@ static int hci_suspend_notifier(struct n
 	int ret = 0;
 	u8 state = BT_RUNNING;
 
+	/* To avoid a potential race with hci_unregister_dev. */
+	hci_dev_hold(hdev);
+
 	/* If powering down, wait for completion. */
 	if (mgmt_powering_down(hdev)) {
 		set_bit(SUSPEND_POWERING_DOWN, hdev->suspend_tasks);
@@ -3757,6 +3760,7 @@ done:
 		bt_dev_err(hdev, "Suspend notifier action (%lu) failed: %d",
 			   action, ret);
 
+	hci_dev_put(hdev);
 	return NOTIFY_DONE;
 }
 


