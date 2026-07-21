Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF52F4307AD;
	Tue, 21 Jul 2026 20:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664665; cv=none; b=NE6o/80dGXBgg84662nnTzMrAwErj9jzkzHN9c40pNnajl4f/4OKzbxKeWgJqGRuEG7eV11cC7K71Q+2zqUxJqNFeC+bemgGY1fblaZZwMuvT+qoJuUqrsdfqXSqJaSrnCeFI4sAnCO5/uc1kfbXns23ypqdwR1pb9PhxNu5e/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664665; c=relaxed/simple;
	bh=2BZnzRehK8TaX1RzSWu6/lP9pAkKdP1Cchl5gK36ipc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMhEI/ftVkHu7cNOao0ThxGNsn8m/BY71HF8tc0XT5JIMqw+vgUhiPacQ7c080cxghmVHtjMQdneleckffHhWSITx8mF/sgAPasyIgmcLgCeZSAT6eRsch0LFwN6BRaOHcaxSHAodIkFT2mKf43Gdc4XPYeszi1rOcIh/FOsZac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OsqoS9sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsqoS9sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5E01F000E9;
	Tue, 21 Jul 2026 20:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664664;
	bh=nm3ZvNfWckYZfVj8DlcFYwy/X265aMzgU7T/NZvRADI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsqoS9sz10hcisCI7w6gYi+rPQUt/c31GLroubE+513hEszzGj/01gShD+e/y/FmK
	 ZMtQ1GKc9hiGaHvtIDO2MHRygGvDjR4plXUJDoiJG9nux+dkWBu9+/OEVU8793qC7o
	 ADb2/3f9L0J4wPMkbuJJtnDe8qZL6w6gf4tuwBkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiande Lu <jiande.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0013/1266] Bluetooth: btmtk: Fix wait_on_bit_timeout interruption during shutdown
Date: Tue, 21 Jul 2026 17:07:30 +0200
Message-ID: <20260721152442.088262981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 29d4a04ea0d46a..bd28a2d52af169 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -640,12 +640,7 @@ static int btmtk_usb_hci_wmt_sync(struct hci_dev *hdev,
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
2.53.0



