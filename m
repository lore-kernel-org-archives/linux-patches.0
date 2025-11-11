Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540AB4C97;
	Tue, 11 Nov 2025 00:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822215; cv=none; b=qfi/xff/dzXtlKcFI5PVK9OKKpwBvfRXa6Q5/L42naoLmuSxxvdNz0mSaAsHUyS0jBNwlmdasXvoxsbrE+2ROQV9bbNr++9Ac8/SiYPiuSncxTIzycoCfQHpPrb693qL1jiPV0+ZMH0FWqQkl+95Yq5e1B3PJHPFVbU6ullvmf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822215; c=relaxed/simple;
	bh=klUJ310fL6TTrXiTBtOYkIEMjQhjaXyCxH+7eUE6w/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVywPMmCr0ddqvpOXLbKvJXNiKjh/QZbxRGRPI+LezC54WliIi57oa7clv81xbUuyTnRJxUWTEANR73qwYf8QqBO9w496eEPvw5KFu0quFNlNIH9MqwDgJSdl0mcXnD2EP5E9r6nECmVd5ED1F1xswuUSP0GlhpyvFyaFN1H1WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElLcs5rF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElLcs5rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23C1C4CEFB;
	Tue, 11 Nov 2025 00:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822215;
	bh=klUJ310fL6TTrXiTBtOYkIEMjQhjaXyCxH+7eUE6w/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElLcs5rFd6cnl3PebNtYQLbLmEzbCUhI7oNAILP8L6ZdFzJelbsK+xqZ48W7ByLhz
	 1DRy8TpIwe04VZclX1WbbhRsDHp12HkOoYNJx9hn7YoPCk8P/pfVw2+c78RRCI1YU5
	 zKScNC7GsPDswAtJl3w6scBEXZZoQHX0pLPOPzxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 059/849] Bluetooth: btmtksdio: Add pmctrl handling for BT closed state during reset
Date: Tue, 11 Nov 2025 09:33:49 +0900
Message-ID: <20251111004537.861777105@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 77343b8b4f87560f8f03e77b98a81ff3a147b262 ]

This patch adds logic to handle power management control when the
Bluetooth function is closed during the SDIO reset sequence.

Specifically, if BT is closed before reset, the driver enables the
SDIO function and sets driver pmctrl. After reset, if BT remains
closed, the driver sets firmware pmctrl and disables the SDIO function.

These changes ensure proper power management and device state consistency
across the reset flow.

Fixes: 8fafe702253d ("Bluetooth: mt7921s: support bluetooth reset mechanism")
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 4fc673640bfce..24ce1bf660669 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1270,6 +1270,12 @@ static void btmtksdio_reset(struct hci_dev *hdev)
 
 	sdio_claim_host(bdev->func);
 
+	/* set drv_pmctrl if BT is closed before doing reset */
+	if (!test_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state)) {
+		sdio_enable_func(bdev->func);
+		btmtksdio_drv_pmctrl(bdev);
+	}
+
 	sdio_writel(bdev->func, C_INT_EN_CLR, MTK_REG_CHLPCR, NULL);
 	skb_queue_purge(&bdev->txq);
 	cancel_work_sync(&bdev->txrx_work);
@@ -1285,6 +1291,12 @@ static void btmtksdio_reset(struct hci_dev *hdev)
 		goto err;
 	}
 
+	/* set fw_pmctrl back if BT is closed after doing reset */
+	if (!test_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state)) {
+		btmtksdio_fw_pmctrl(bdev);
+		sdio_disable_func(bdev->func);
+	}
+
 	clear_bit(BTMTKSDIO_PATCH_ENABLED, &bdev->tx_state);
 err:
 	sdio_release_host(bdev->func);
-- 
2.51.0



