Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440DA20330;
	Tue, 26 Aug 2025 11:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208956; cv=none; b=OIh2dfXVERSy9FAk4QcAPwTbD0RjnIc3iaBPb+7Hfud5cvD/b2Zzc82J1LiKsPcaAgy5Aehc6Rmjrh/uT7g1hPjXgn9t+Es2QiiKXsDHLPWdlb1l1GlAXNi1V8VVGQkfHk13wSFJPhROD00OgG5LhOc1WRkybnHuXRtdShgtg88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208956; c=relaxed/simple;
	bh=7zejeRPR4+JewCdIXCLkunPlenSAFgaQOWLGOVGM0gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocUyH+QwyUOFXV+jJVBd9d7U8M75fjpLmrwFlV8E0YJnICyyNRTUkJfcewEqJcZAp9RZMn8IxeJYoe5rDAj2qJEO5nOp+1oO64rwcoqz+3eirX7gJlwYZOM346ku75WqM0rU9/lAg5sgwbGISWt4xg+rvgkGHWDtwWd1lotQN3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSwvnrsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSwvnrsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D222CC4CEF1;
	Tue, 26 Aug 2025 11:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208956;
	bh=7zejeRPR4+JewCdIXCLkunPlenSAFgaQOWLGOVGM0gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSwvnrsItLK0ZYudtbru7hV4HUbeCIXDSxVPhjboyhSTCs2yXaXxSaoF/3DVpZ8Sg
	 M2p4+O/WEkGG7ByQ1aFDy1uWwKFur194dM/0vek+xQqoUj8SDd5chgqMj1uvteflw1
	 suD4FOSczjUtto55+/PoXFZApBpjhRdd68mY/ygg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiande Lu <jiande.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/322] Bluetooth: btmtk: Fix wait_on_bit_timeout interruption during shutdown
Date: Tue, 26 Aug 2025 13:11:33 +0200
Message-ID: <20250826110922.788618751@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiande Lu <jiande.lu@mediatek.com>

[ Upstream commit 099799fa9b76c5c02b49e07005a85117a25b01ea ]

During the shutdown process, an interrupt occurs that
prematurely terminates the wait for the expected event.
This change replaces TASK_INTERRUPTIBLE with
TASK_UNINTERRUPTIBLE in the wait_on_bit_timeout call to ensure
the shutdown process completes as intended without being
interrupted by signals.

Fixes: d019930b0049 ("Bluetooth: btmtk: move btusb_mtk_hci_wmt_sync to btmtk.c")
Signed-off-by: Jiande Lu <jiande.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 05de2e6f563d..07979d47eb76 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -642,12 +642,7 @@ static int btmtk_usb_hci_wmt_sync(struct hci_dev *hdev,
 	 * WMT command.
 	 */
 	err = wait_on_bit_timeout(&data->flags, BTMTK_TX_WAIT_VND_EVT,
-				  TASK_INTERRUPTIBLE, HCI_INIT_TIMEOUT);
-	if (err == -EINTR) {
-		bt_dev_err(hdev, "Execution of wmt command interrupted");
-		clear_bit(BTMTK_TX_WAIT_VND_EVT, &data->flags);
-		goto err_free_wc;
-	}
+				  TASK_UNINTERRUPTIBLE, HCI_INIT_TIMEOUT);
 
 	if (err) {
 		bt_dev_err(hdev, "Execution of wmt command timed out");
-- 
2.50.1



