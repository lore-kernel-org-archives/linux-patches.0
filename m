Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AC31A76A5;
	Mon, 14 Oct 2024 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918782; cv=none; b=iVGYOJ9Dj2AeOcf5yzZXmAbZPcj49vPcDchxJda24RusZa42tyPucQP+EK7HEuY2FAm3KIgLqIisSX2IVLn2hhfk3qIBH0nve6hajDbjq8r26hxqwEuKzEhDB6/A81vFAWUADfWwgsj9y7i/w/MygdWCXOTbFY2pTqitrnFPbwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918782; c=relaxed/simple;
	bh=2XRTV2ZRiRCHqDjsM/+2t5opdohrePOkRb3R1bY+AJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soPSRUEFQBXTZ2Ec+8stzI9qUb42FNXlHKSEOiZRMXGSM7FQBhGNb3RfTWmpwP3rqqtI/GWF+AaklcJuvk1yQtmem0hl8ZiliqpCqh/x+nwVto32OU9HIUaphhbier9l1MGpAh/SUqC8P3xiarU0a+JdMjQCHGwUhatO/A27RlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mz0YS5/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mz0YS5/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891A1C4CEC7;
	Mon, 14 Oct 2024 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918782;
	bh=2XRTV2ZRiRCHqDjsM/+2t5opdohrePOkRb3R1bY+AJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mz0YS5/+jUFZwKn71gCIgZ7FyavyDS3s8O8p8b3tkbkDTr/wcKdUim4YRBkQlAvcT
	 lgDowpVhYQEtGJyJEtDawWL6v15E7raEQrawFF1BuA4sR3IaA9kQppnHa/+f2hSzr3
	 r+tN7wUUtzDBCl5sLvVE3SEwbMUpYXqOZWnkyraU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 395/798] Bluetooth: btmrvl: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Mon, 14 Oct 2024 16:15:49 +0200
Message-ID: <20241014141233.462072895@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ba057ebfda5c2..981b43f79e4a3 100644
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



