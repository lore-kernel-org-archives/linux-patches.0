Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B3A1F4725;
	Wed,  6 Nov 2024 13:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898278; cv=none; b=E2quw/CGL9hxVL9TaGE3ubww97XOaj/Bw+54GZu/uJG9FU8yO27/wbsbZII2NYoRX+yn8BArGQ4ur9hoZBfTUAVyV83Y3z6K1F6bliL8VRqs4m4WXOpFO17rzYpjgWrFWTIFNadcPwcZQ6TOzg9XNb62Yry1GWt9nfail+RatbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898278; c=relaxed/simple;
	bh=0Refu1hYEJFEnLFCfQibOM9ztpSr0nTUmW3ZVLaDnqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaMQfvg9PUc1sNlksjdfxjhvCUrYjcvBPEedtqQxTbF62AM1d3QZwYHivnnozq9D/2xaw6lqW8QciLVBFTkUTAOUqeH9/sh0SC7Pfk+9iAg7kBgUoRg9Ht6fEUFNTv5+CMXuIuulrK78t2cRfFx6fro/BROHHVT+h7cHT085xCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVj8jSk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVj8jSk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998AAC4CECD;
	Wed,  6 Nov 2024 13:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898278;
	bh=0Refu1hYEJFEnLFCfQibOM9ztpSr0nTUmW3ZVLaDnqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVj8jSk6yeBlToXtiaX6LqPQ6ekvI2vLQ81uiBRfvzTm1bAV/5ksElETvuBy4Kuha
	 TWlPM3fqhvDjdgA78kKVPI5L/92F2PbQGap8bxZHXyyLoxn/3CJrIh3MWeiv/qLR6q
	 usWyh6TkfjGkXbJJ7SpIn1iNMB1lQxbDiDIbEY3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/462] Bluetooth: btmrvl_sdio: Refactor irq wakeup
Date: Wed,  6 Nov 2024 13:01:16 +0100
Message-ID: <20241106120336.036455892@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

[ Upstream commit e660b3510eb4b3c06ce1188a1d305b6f653106fc ]

Use device_init_wakeup to allow the Bluetooth dev to wake the system
from suspend. Currently, the device can wake the system but no
power/wakeup entry is created in sysfs to allow userspace to disable
wakeup.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: 7b1ab460592c ("Bluetooth: btmrvl: Use IRQF_NO_AUTOEN flag in request_irq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmrvl_sdio.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 4c7978cb1786f..cfb9f9db44a0d 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -111,6 +111,9 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 					"Failed to request irq_bt %d (%d)\n",
 					cfg->irq_bt, ret);
 			}
+
+			/* Configure wakeup (enabled by default) */
+			device_init_wakeup(dev, true);
 			disable_irq(cfg->irq_bt);
 		}
 	}
@@ -1654,6 +1657,7 @@ static void btmrvl_sdio_remove(struct sdio_func *func)
 							MODULE_SHUTDOWN_REQ);
 				btmrvl_sdio_disable_host_int(card);
 			}
+
 			BT_DBG("unregister dev");
 			card->priv->surprise_removed = true;
 			btmrvl_sdio_unregister_dev(card);
@@ -1690,7 +1694,8 @@ static int btmrvl_sdio_suspend(struct device *dev)
 	}
 
 	/* Enable platform specific wakeup interrupt */
-	if (card->plt_wake_cfg && card->plt_wake_cfg->irq_bt >= 0) {
+	if (card->plt_wake_cfg && card->plt_wake_cfg->irq_bt >= 0 &&
+	    device_may_wakeup(dev)) {
 		card->plt_wake_cfg->wake_by_bt = false;
 		enable_irq(card->plt_wake_cfg->irq_bt);
 		enable_irq_wake(card->plt_wake_cfg->irq_bt);
@@ -1707,7 +1712,8 @@ static int btmrvl_sdio_suspend(struct device *dev)
 			BT_ERR("HS not activated, suspend failed!");
 			/* Disable platform specific wakeup interrupt */
 			if (card->plt_wake_cfg &&
-			    card->plt_wake_cfg->irq_bt >= 0) {
+			    card->plt_wake_cfg->irq_bt >= 0 &&
+			    device_may_wakeup(dev)) {
 				disable_irq_wake(card->plt_wake_cfg->irq_bt);
 				disable_irq(card->plt_wake_cfg->irq_bt);
 			}
@@ -1767,7 +1773,8 @@ static int btmrvl_sdio_resume(struct device *dev)
 	hci_resume_dev(hcidev);
 
 	/* Disable platform specific wakeup interrupt */
-	if (card->plt_wake_cfg && card->plt_wake_cfg->irq_bt >= 0) {
+	if (card->plt_wake_cfg && card->plt_wake_cfg->irq_bt >= 0 &&
+	    device_may_wakeup(dev)) {
 		disable_irq_wake(card->plt_wake_cfg->irq_bt);
 		disable_irq(card->plt_wake_cfg->irq_bt);
 		if (card->plt_wake_cfg->wake_by_bt)
-- 
2.43.0



