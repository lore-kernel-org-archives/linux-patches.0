Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD774C97;
	Tue, 11 Nov 2025 00:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822407; cv=none; b=EdtAdOlf5ZPhoNdkWqpPsv5D3KrsRlDRG9fDLSOxaukYu3Yop+wOmZVVUKM9opiGcBgspNlMss/XdQGgxzzKhddch4h2HRlDQYxNbe/meiCh0ejB/k16HYtqISbq16JniIQ+y5hL80nycowEu0rmsHA8WC/WVG2fxhyVNguEm2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822407; c=relaxed/simple;
	bh=Y9Os1agqA+NZRAm+bBgOkBn+oChjCyOTIRyZBeB7Vs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrugraZLjDsQtoHM6rGRcjRWbsRGRrSDCm9odcndjlKYQUT/LB9B6jqwtPzVrq75/RpBIPKRdS/phfdW/HHOx++32bYomXAGnLR71pUfDRoDhqp0/pBsn3o8zawbwsyg9zEXeTf1MY93wH3XcjRWiS6Cl8QqUdteutu95YkaO/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4t5uhft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4t5uhft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD5EC4AF09;
	Tue, 11 Nov 2025 00:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822407;
	bh=Y9Os1agqA+NZRAm+bBgOkBn+oChjCyOTIRyZBeB7Vs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4t5uhftFg1EXFZQf4/CSuuI8jqE7t4B+Upc61UOPGnjyEUYMIvL5WiAd8ves79A7
	 U7PESF7IUg+KQjveTOHIN8Uc/MYKsi6li5Y6SeyVV4p79HuPyQey946flh5REVymd2
	 JfBZvvF9sBHBrzBD36dUlgsJKoaR6oYQ1zXrF6JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/565] Bluetooth: btmtksdio: Add pmctrl handling for BT closed state during reset
Date: Tue, 11 Nov 2025 09:38:20 +0900
Message-ID: <20251111004527.894458773@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 13dcc0077732b..206de38fc1c82 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1270,6 +1270,12 @@ static void btmtksdio_cmd_timeout(struct hci_dev *hdev)
 
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
@@ -1285,6 +1291,12 @@ static void btmtksdio_cmd_timeout(struct hci_dev *hdev)
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



