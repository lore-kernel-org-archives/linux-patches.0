Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C6234A31F;
	Tue, 26 Aug 2025 11:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207935; cv=none; b=BflKZQayhGunnoe8C9qN9zLjClLqfUPV4rI7TRWaZw/9AMnWTAXmPg4P6QbGIhXfHSm9veXqcrO8REyKUrjuDNjD5yMNkax3a9zt/zX10zpqzymAqPDXNgJ0xqIqDNTrhtaHD3XMNtfcitA6c++yhpnH0rxWUtyj97EiFBFi4d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207935; c=relaxed/simple;
	bh=arbwwwQ4fQuONvjC9OEFCkh66XDmduIbhchjKd90xW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlHaIrFX2ew5FSjMrgkxK8Fsp0dfFGbNqCwaJIC7JYMOEWhK5ObzjkgRx71fpHktKfWctKB+X0hcN0GgfsnKCEtzcqlff8ZI0PwC6dhM/Xu2dSGmDPu/WiAfOrpNBnc0zx+8BXhyWHreY2kG3tBg+pqcDXzqBrejDXndsyYP0+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgBY5wIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgBY5wIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC49C4CEF1;
	Tue, 26 Aug 2025 11:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207935;
	bh=arbwwwQ4fQuONvjC9OEFCkh66XDmduIbhchjKd90xW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgBY5wInyUp53iGvq2rPalWNbRWNcFubRWNhwhEu8wceA0mwbEnX/RypSmbZXoWBk
	 RI5oBY6LNiqKvLOaMzwx5UNWGQZNC8iRAHDgrgBDNiSiqaugllANLbR2ZyHkHKhUQJ
	 4M8awo/jsfnUKi8dhiBp9urYQnG3ebAVAhZVtt9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiande Lu <jiande.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 374/457] Bluetooth: btmtk: Fix wait_on_bit_timeout interruption during shutdown
Date: Tue, 26 Aug 2025 13:10:58 +0200
Message-ID: <20250826110946.540897902@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 4390fd571dbd..a8c520dc09e1 100644
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



