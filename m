Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331C7280023;
	Tue, 27 May 2025 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368628; cv=none; b=RftvIRMU66wTGmwj1uoHhgAfEzq3rDDeEetq2Mb0ZmI3zoJXniz8BGOC4fPiu5Jtq4iJtqI2Mb0+BcHFfUh+WdtPGtO5Uoje4/IU3MOkksoL9vUn/EH83ghVBnh2lru+8M6OVBbXwy/ZkH4n8Cf7CfkgkuILZHI54zLrhhzxBes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368628; c=relaxed/simple;
	bh=9kUUrSd/ndOcbbHy7p1vl2rSnvN0Uw9tRmILx6busBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ke0uMGC0zRyHxeJ76dTdq/J6CraJh10t9YEwbvZoKE0V0sUhmbIpluKgADwXvGrkIgk9AErBB1UbEXfLAs8yJzlWXH6tjkAnEfXaUn9HDFsYtCJ4t4KKGDIwysQ9MO4dRO9ky/W7HbKe8HWsnJy/ZmSizMp/cny1psy8lSplJTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZDT0pZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZDT0pZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65E4C4CEE9;
	Tue, 27 May 2025 17:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368628;
	bh=9kUUrSd/ndOcbbHy7p1vl2rSnvN0Uw9tRmILx6busBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZDT0pZUoLB8CsiIwkhwtOl0HR9GdJCufHqTknKC8TRiZDmGz+Kin0gGp9Z37lijo
	 5pV+Jj1hEbrC2iP5bhOtLYz0ajzRREoAQ/vzyF4uIJtJCwJS/1q/XHgnFxiesPweyD
	 wnWQ1yiqPAe6MliaRLB78vqsAjNCp3LNuaxg3xqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.14 767/783] Bluetooth: btmtksdio: Do close if SDIO card removed without close
Date: Tue, 27 May 2025 18:29:24 +0200
Message-ID: <20250527162544.372766460@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lu <chris.lu@mediatek.com>

commit 0b6d58bc6ea85e57de25c828444928e4a0aa79cb upstream.

To prevent Bluetooth SDIO card from be physically removed suddenly,
driver needs to ensure btmtksdio_close is called before
btmtksdio_remove to disable interrupts and txrx workqueue.

Fixes: 6ac4233afb9a ("Bluetooth: btmtksdio: Prevent enabling interrupts after IRQ handler removal")
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtksdio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1447,11 +1447,15 @@ static void btmtksdio_remove(struct sdio
 	if (!bdev)
 		return;
 
+	hdev = bdev->hdev;
+
+	/* Make sure to call btmtksdio_close before removing sdio card */
+	if (test_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state))
+		btmtksdio_close(hdev);
+
 	/* Be consistent the state in btmtksdio_probe */
 	pm_runtime_get_noresume(bdev->dev);
 
-	hdev = bdev->hdev;
-
 	sdio_set_drvdata(func, NULL);
 	hci_unregister_dev(hdev);
 	hci_free_dev(hdev);


