Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B6C200D5
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I64Ay/Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3A4C433C9;
	Mon, 16 Oct 2023 14:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467553;
	bh=2Ln5V7rOMWyAgSGswvQ8Nor+pGrCoYs5SXcwQJK57rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I64Ay/IyVITXubRW2qBGyMBBX7Bb1laK+u49ZJhhm6bDlfX8JeGSK2cZqN3pZh3vs
	 vot48tNGYOrL1q9Gs4nrgw81M8xXu83RgEVECPZTr+3W4ww3O8e4KxuTLkbHPjk/Nf
	 b5T7jTgz29Q+8gQrazfapz2vXMo2EGv/RiyY6OGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 042/191] pinctrl: nuvoton: wpcm450: fix out of bounds write
Date: Mon, 16 Oct 2023 10:40:27 +0200
Message-ID: <20231016084016.390429199@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kobuk <m.kobuk@ispras.ru>

[ Upstream commit 87d315a34133edcb29c4cadbf196ec6c30dfd47b ]

Write into 'pctrl->gpio_bank' happens before the check for GPIO index
validity, so out of bounds write may happen.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a1d1e0e3d80a ("pinctrl: nuvoton: Add driver for WPCM450")
Signed-off-by: Mikhail Kobuk <m.kobuk@ispras.ru>
Reviewed-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Link: https://lore.kernel.org/r/20230825101532.6624-1-m.kobuk@ispras.ru
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-wpcm450.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c b/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
index 2d1c1652cfd9d..8a9961ac87128 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
@@ -1062,13 +1062,13 @@ static int wpcm450_gpio_register(struct platform_device *pdev,
 		if (ret < 0)
 			return ret;
 
-		gpio = &pctrl->gpio_bank[reg];
-		gpio->pctrl = pctrl;
-
 		if (reg >= WPCM450_NUM_BANKS)
 			return dev_err_probe(dev, -EINVAL,
 					     "GPIO index %d out of range!\n", reg);
 
+		gpio = &pctrl->gpio_bank[reg];
+		gpio->pctrl = pctrl;
+
 		bank = &wpcm450_banks[reg];
 		gpio->bank = bank;
 
-- 
2.40.1



