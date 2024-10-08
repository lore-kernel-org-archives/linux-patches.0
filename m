Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9544D1DEFEA;
	Tue,  8 Oct 2024 12:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389560; cv=none; b=sEJmdb9ET9cRMiyogNcy5FjCMkNCyVMJqZY+GZid2bGJ983OKSDz2vBmeEAgHBmxXf34dpHKEhWvAfObWp92bYyZD9inVqaU7xmqHLppLa+JlZJTIaxmJmkd/G7tioxFtlKBAVe0ZQ424xgbLTsGPyZ5rqfFjv9s5y0Ukar+PdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389560; c=relaxed/simple;
	bh=E+bU+PL+XPoZyd47yPktbiusQtipF43K4V3AqfleMZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cG2/WgERdJ0BpqRBNrFkJJbmujMIE2yzvku36M7OAesoZZrXlqZhS9hpZOajonJA2I//od1BLrTDNO2ESXMRpnbzSwsW/2fRsfPzRyh8e2IU+YU1/XLwco83O6iOl/k3BKocabyc6evMoBxrJfsGyT7i52Tz9lCBANIDe0itZ98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqsXE+li; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqsXE+li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03966C4CED3;
	Tue,  8 Oct 2024 12:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389560;
	bh=E+bU+PL+XPoZyd47yPktbiusQtipF43K4V3AqfleMZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqsXE+lieCKx9oUzYkgAz/E7yIWheSkIg4GbW1gX10ZBZhIVbnhhxYSxBa4oOo139
	 /DLUl+oKQ97jnqyq5hmxLW2v5nFLItDdNY1ZlSOqAlufG3XWSgiZc8wA6Regkt+tfN
	 tqjdsMsIL+jnhtj1zQA02Ouq+VQBkivL5UnCy8kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 030/482] Bluetooth: btmrvl: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  8 Oct 2024 14:01:33 +0200
Message-ID: <20241008115649.486294375@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 7b1ab460592ca818e7b52f27cd3ec86af79220d1 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: bb7f4f0bcee6 ("btmrvl: add platform specific wakeup interrupt support")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmrvl_sdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 85b7f2bb42598..07cd308f7abf6 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -92,7 +92,7 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 		} else {
 			ret = devm_request_irq(dev, cfg->irq_bt,
 					       btmrvl_wake_irq_bt,
-					       0, "bt_wake", card);
+					       IRQF_NO_AUTOEN, "bt_wake", card);
 			if (ret) {
 				dev_err(dev,
 					"Failed to request irq_bt %d (%d)\n",
@@ -101,7 +101,6 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 
 			/* Configure wakeup (enabled by default) */
 			device_init_wakeup(dev, true);
-			disable_irq(cfg->irq_bt);
 		}
 	}
 
-- 
2.43.0



