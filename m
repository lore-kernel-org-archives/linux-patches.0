Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FACC1C6AB;
	Mon,  4 Mar 2024 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589192; cv=none; b=BLszmbGuJpMgIXf1qc2bq1QGiYeV5WES2XJD1EUFccrYPRQ1OvUBachKQoHIjiQuZ3V6IANgnj4wD8tc5vpx+eYLxVk75ESG8BxU56j26m5mb1tqhRXqrzWDM5VsDSlr0NBLgcinpqwgUAkg5AAgDasQ055Mgbot7HbyuyOMJOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589192; c=relaxed/simple;
	bh=aevAlS9CIa95pKoO317HsyEsngtYZtdlrkWLDWxOHe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASqNqkf1MUGpfzVLm1JabSe8yaF+o67QrJyqIN5rOekkXydfRYLwCyDkphB3TldG7pon8LsGN7aEGQa1VjbjgRWwUDKGdqJqvRAWJm3JdUCusFSRn49n46sGY+m26mOCregjo+9Xxrht7ss2/YTsC1NTrQdcDprt/0eePjnpZlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qevr4EXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qevr4EXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A9EC433C7;
	Mon,  4 Mar 2024 21:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589192;
	bh=aevAlS9CIa95pKoO317HsyEsngtYZtdlrkWLDWxOHe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qevr4EXvqJ8u9KKEjdMJEj+D9KCSZLGcdDG8tv+D2IrlorgnpQLW449cr7LTh/oqo
	 wKA+5pqn8HHe4X0FvQqHL79Y/9asnpD+x5m+B//aL5EpUdMO9l7/DDeIylJFphwZ0q
	 djGhPCUYetQgUQWCkbqUbR/FzZUMnqDIKaflxNGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Hsu <yinghsu@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/84] Bluetooth: Avoid potential use-after-free in hci_error_reset
Date: Mon,  4 Mar 2024 21:23:48 +0000
Message-ID: <20240304211542.848322831@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Hsu <yinghsu@chromium.org>

[ Upstream commit 2449007d3f73b2842c9734f45f0aadb522daf592 ]

While handling the HCI_EV_HARDWARE_ERROR event, if the underlying
BT controller is not responding, the GPIO reset mechanism would
free the hci_dev and lead to a use-after-free in hci_error_reset.

Here's the call trace observed on a ChromeOS device with Intel AX201:
   queue_work_on+0x3e/0x6c
   __hci_cmd_sync_sk+0x2ee/0x4c0 [bluetooth <HASH:3b4a6>]
   ? init_wait_entry+0x31/0x31
   __hci_cmd_sync+0x16/0x20 [bluetooth <HASH:3b4a 6>]
   hci_error_reset+0x4f/0xa4 [bluetooth <HASH:3b4a 6>]
   process_one_work+0x1d8/0x33f
   worker_thread+0x21b/0x373
   kthread+0x13a/0x152
   ? pr_cont_work+0x54/0x54
   ? kthread_blkcg+0x31/0x31
    ret_from_fork+0x1f/0x30

This patch holds the reference count on the hci_dev while processing
a HCI_EV_HARDWARE_ERROR event to avoid potential crash.

Fixes: c7741d16a57c ("Bluetooth: Perform a power cycle when receiving hardware error event")
Signed-off-by: Ying Hsu <yinghsu@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b3b597960c562..a8854b24f4cfb 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2330,6 +2330,7 @@ static void hci_error_reset(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev, error_reset);
 
+	hci_dev_hold(hdev);
 	BT_DBG("%s", hdev->name);
 
 	if (hdev->hw_error)
@@ -2337,10 +2338,10 @@ static void hci_error_reset(struct work_struct *work)
 	else
 		bt_dev_err(hdev, "hardware error 0x%2.2x", hdev->hw_error_code);
 
-	if (hci_dev_do_close(hdev))
-		return;
+	if (!hci_dev_do_close(hdev))
+		hci_dev_do_open(hdev);
 
-	hci_dev_do_open(hdev);
+	hci_dev_put(hdev);
 }
 
 void hci_uuids_clear(struct hci_dev *hdev)
-- 
2.43.0



