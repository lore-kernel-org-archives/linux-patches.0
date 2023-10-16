Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0851A28F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCSK0SHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857B0C433C7;
	Mon, 16 Oct 2023 08:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446459;
	bh=Z736QbVHUDF3qrK6i9NKZkblZIedGQgY1btUASBvLOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCSK0SHWDSIpiMjNf833iiJS2GLxQCeBRKVT1tsto19ITyFD6vwxQ8fO/923kRT9O
	 Kw/hHDtycjjzASPjJGpWhPLvRkf1XD+PgmLudSZmtQ2hxujr7JucFrcCcecp1Tp8OB
	 EXEwtbExgoZLjYdBNn7zfKcg8Yl4qt87hoAMvNc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/131] pinctrl: nuvoton: wpcm450: fix out of bounds write
Date: Mon, 16 Oct 2023 10:40:16 +0200
Message-ID: <20231016084000.888367115@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8193b92da4031..274e01d5212d5 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
@@ -1041,13 +1041,13 @@ static int wpcm450_gpio_register(struct platform_device *pdev,
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



