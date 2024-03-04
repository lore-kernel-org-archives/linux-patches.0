Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D81B8F58;
	Mon,  4 Mar 2024 21:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588284; cv=none; b=H6n4yvClZmj40uAKsB/boqHxMHSUuYxv+L2sH+dOmLqyvbLF+5zgjYDh3pIR3lnpkmY+HLjSC3RArjYXBbrKZJhtYrrc21ERG61yEXz3EPGxcHyX6qPiTD7QA6osQ1mYDrSRpbMorDijtJhtzgEDi+F+6awjXNOK2wKMgMZvqHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588284; c=relaxed/simple;
	bh=bPwx5gg5J8+9gGuWmpUP+1uIGXlZZOUD+FFxH+dwaoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyNCXlvN0YUrEOylzOvt7C2/VeV9yjA/4vB5Sw4KkyQdEVGwOQnw2f0IZR6QsL9Ffm/pcfh1NoadtItfdIBDmIKxiuNv+7P5notjVZUnvam/WePHl8K4ck8Okd9jgUS3RRbINn0G99Ql3tGzHL3NgogXIc5nqKWJfeo6t/UAugY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJq9p3GQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJq9p3GQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A416EC433C7;
	Mon,  4 Mar 2024 21:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588284;
	bh=bPwx5gg5J8+9gGuWmpUP+1uIGXlZZOUD+FFxH+dwaoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJq9p3GQqcNx8i46FO7PmUXSWY35MgJy0ulJ5ZqXmM+60gagiRdehPTDRbQGwBkp4
	 T3/MBXh3MnVNEo37ocaQaA1CuhTtkFPx6MMUPXCQ67axRqljaLrcCYVxRSVvFFM8Ta
	 RoxH0DD4dd6pSk7dJmKgEotkuptCxUFn5s3R74uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Hsu <yinghsu@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/143] Bluetooth: Avoid potential use-after-free in hci_error_reset
Date: Mon,  4 Mar 2024 21:22:24 +0000
Message-ID: <20240304211550.718590902@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65601aa52e0d8..2821a42cefdc6 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1049,6 +1049,7 @@ static void hci_error_reset(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev, error_reset);
 
+	hci_dev_hold(hdev);
 	BT_DBG("%s", hdev->name);
 
 	if (hdev->hw_error)
@@ -1056,10 +1057,10 @@ static void hci_error_reset(struct work_struct *work)
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



