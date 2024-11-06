Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B981F8EE3;
	Wed,  6 Nov 2024 13:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898281; cv=none; b=DxMpRgf3mhUms2aPHotZJuUp9Nb6aHp4iJJYHzYFA4bk1PvIApS5gjL4YNFScQvAwCInCmOUN47FyP0+huxF3cUxRKdX/HnOAHK45NFA6DuuZHjcb5YOVFxhJ1VR8ql4s3ltwTb6P62VK+TtSt7U4Q8LWzLrqSpUf0e1Rm+untM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898281; c=relaxed/simple;
	bh=etJPoxsTpfL/csH+qVzAaXrqoEmV3NS40oC+sPizABw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n06hzSDE4mve2yY6YXcW+S0uIkEfIENqL4yHl4gaaJ+c/CUGKlCOonuC/A44rCafWcn8QoHnys6/xWUzdzikopjN3NAnXCLL9lPh0jTQkwQvVQ6/B7MowIIXYIfMuTstiv3q674yqjEAyhirzcUvmbinCfZ+WRkM8d4z9pxdeJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMAwRERq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMAwRERq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C85AC4CECD;
	Wed,  6 Nov 2024 13:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898281;
	bh=etJPoxsTpfL/csH+qVzAaXrqoEmV3NS40oC+sPizABw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMAwRERqrN3JAE0mKpqD4HGHiIg0PoS2F2YNrgA2xB2wgnYl35tu4gTjV1ZOxXe1C
	 Jq04vocr7ore4gH6Fc8b7mEzM/sxm0S5/cpTPGnQLKo8yxBjs1a6Mwyh9ALy1YbZo2
	 PY05qdsoJTISil77+8QPmruB2r4/BbhPZGIO6Ucg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 184/462] Bluetooth: btmrvl: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Wed,  6 Nov 2024 13:01:17 +0100
Message-ID: <20241106120336.060914310@linuxfoundation.org>
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
index cfb9f9db44a0d..be7145d43570f 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -105,7 +105,7 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 		} else {
 			ret = devm_request_irq(dev, cfg->irq_bt,
 					       btmrvl_wake_irq_bt,
-					       0, "bt_wake", card);
+					       IRQF_NO_AUTOEN, "bt_wake", card);
 			if (ret) {
 				dev_err(dev,
 					"Failed to request irq_bt %d (%d)\n",
@@ -114,7 +114,6 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 
 			/* Configure wakeup (enabled by default) */
 			device_init_wakeup(dev, true);
-			disable_irq(cfg->irq_bt);
 		}
 	}
 
-- 
2.43.0



