Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EA734BA21;
	Fri, 21 Nov 2025 13:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732181; cv=none; b=HH24Sh1hmCEjisA4A6bJRLLyVZUkutn7ruXpzM4bFeCNYR0nlAKg2JiuwoyQhiwpgv4RrKF5TqQsT9VpPWlf8Rmu0zcjmCDy8cULg5iUgvVaNjxZNKhnfm2HjISxwj1A9xxGwDVcLKhvNPnqvhNDqCF/wblukTKqWTZ5fo7f1xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732181; c=relaxed/simple;
	bh=nhsqUwMsmPa0rO/++WT2cSGtL1TSgsZAVM+4/T0P7v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWp6ZbFeRt95wpmnQeT4gMrBogf5M1ROKP+cb3LLbpAAuiEEi+jaNZwu2hAtb6dzHo0xWiqATTLYRrxI1jYiDx341vcK/3j3HcOxTsyCIwZFDQ1IdQoEa8k0/uxRHtPFEd02Zeq5zLklSNY5y5Aez8acRgrj9UWnSapqw8KvtM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2gqRQoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2gqRQoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0873CC4CEFB;
	Fri, 21 Nov 2025 13:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732181;
	bh=nhsqUwMsmPa0rO/++WT2cSGtL1TSgsZAVM+4/T0P7v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2gqRQoXIXEnMiiyr2jjWrjD+Cd9B5sVIiY5or0jVcPbwDY1m7EzowMKwzbFoMJln
	 FLE7JnVtiHj7Fb5cLm9lEKjcGuhWyQI36uZhdbiky5xuzqCq+tAzTdSbz+YG38nbWP
	 WYOLmArBay0lMhhX1MmUJG689/rODLsiHLYa1x0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/529] Bluetooth: btmtksdio: Add pmctrl handling for BT closed state during reset
Date: Fri, 21 Nov 2025 14:05:31 +0100
Message-ID: <20251121130232.141370210@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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



