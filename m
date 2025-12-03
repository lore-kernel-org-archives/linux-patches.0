Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3215B34C991;
	Wed,  3 Dec 2025 16:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778746; cv=none; b=JlHhTow5gxTGn7pBzbNQxndRvehr3KWdfyhFzHU8gVCo/RnFchpaDS1Y8cdnrsH57GdTkKLRB1wr0DXym+iS2J4lzfet0ClH/lumAW0pYfCS9mJINZLuOccy5DnIHLoD/O/fLJY4eOGD0X7nhncgzhtq4LJjX0afL67g+dCvnpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778746; c=relaxed/simple;
	bh=X/kTASmfJn8JT1GNL+GE8fdvKnO/HQRD3U1ciq0YuLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQUs3DoLeF7RFPHBwTI1kOuNKlt3boPU7/Yd8guW2YpsA5pKy5usI/Ju6T4oL65tc98c8DwW7+0gSJSLX/WLofRzDzfgQ9+2xIE/KrXNcmeVHkT1tS8Rq3i/TwAoP5zyRRsrldDCig48OvvNxST/d4WXLyv2c4KYxxcqI+sTEso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYcuXEYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYcuXEYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB3AC4CEF5;
	Wed,  3 Dec 2025 16:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778745;
	bh=X/kTASmfJn8JT1GNL+GE8fdvKnO/HQRD3U1ciq0YuLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYcuXEYU6WkYLo2qVZ1+XY3OzpbqHjL3DnuvJ+E83vGzlCy+aCCM1uGDEITSo5Mry
	 Hn22hXH92QfBW5NvFuY/DkaSXOS47JeSJj5r/ZrVFugQKff/vxvBXumJvehl049MuY
	 gtbsXdK6d8tAVj4+AyBo2AjqQyl3Z0+XK5W1+pPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/568] Bluetooth: btmtksdio: Add pmctrl handling for BT closed state during reset
Date: Wed,  3 Dec 2025 16:20:49 +0100
Message-ID: <20251203152442.413868607@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f9a3444753c2b..97659b4792e69 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1257,6 +1257,12 @@ static void btmtksdio_cmd_timeout(struct hci_dev *hdev)
 
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
@@ -1272,6 +1278,12 @@ static void btmtksdio_cmd_timeout(struct hci_dev *hdev)
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



