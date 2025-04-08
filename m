Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FD2269AFB;
	Tue,  8 Apr 2025 12:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114084; cv=none; b=l2kA/zGPVHvtjjxtbV9VkjsKkrAw14BlfPKWX/1wC6UECfPByNNVrxjWImZw+1YvVZDxrhyNz9Ip4RpnUPXtGF8Hesu83T0SwxpJxjQlqvdH7K9O/k1ljN0bTV6nwBOUPBsRdajBk8hwnOJv/7hOuf//dU0sF+XgTmkWuOXbYiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114084; c=relaxed/simple;
	bh=9fhnO/tC1tZ3EWFmI/BSlTnpkbS/gTzWKKufwjrZOfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWQL0+3Z/+vEUpwYpU20mL7aw9cwQ1YvNPhxxg9exEtT2pRA/AJBPgHZhs2F30kLFTFIB2S6Ek7q9gjGp6Km6/53wyc6vzGjd5EZMG7rcHMuD/W46N7VH9wY7f2/PfYlCeecpB9nvCa68tWmECA0tU3YKjVb+fnodnUZ5NYZhrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCJiaFWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCJiaFWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D90C4CEE5;
	Tue,  8 Apr 2025 12:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114084;
	bh=9fhnO/tC1tZ3EWFmI/BSlTnpkbS/gTzWKKufwjrZOfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCJiaFWZyXLmRqY9o+b84RpEXDfNqKtqnmA0vYdTEx3PuVo5kcB/g/1Jvw6L3ukto
	 drMz5ULoEfyXXzQCCfDHDHJzLl3L+FiaCuJQxcbhBTcXj0k+aUUzvXBlC8M9dr3Kvc
	 ZW1tlogJMcbZXLheD/k0bnYULfRHQdf48GGjoLVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/154] mfd: sm501: Switch to BIT() to mitigate integer overflows
Date: Tue,  8 Apr 2025 12:50:54 +0200
Message-ID: <20250408104818.953763829@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 2d8cb9ffe18c2f1e5bd07a19cbce85b26c1d0cf0 ]

If offset end up being high enough, right hand expression in functions
like sm501_gpio_set() shifted left for that number of bits, may
not fit in int type.

Just in case, fix that by using BIT() both as an option safe from
overflow issues and to make this step look similar to other gpio
drivers.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: f61be273d369 ("sm501: add gpiolib support")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20250115171206.20308-1-n.zhandarovich@fintech.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/sm501.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index aab8d8910319d..96616f8267530 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -920,7 +920,7 @@ static void sm501_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct sm501_gpio_chip *smchip = gpiochip_get_data(chip);
 	struct sm501_gpio *smgpio = smchip->ourgpio;
-	unsigned long bit = 1 << offset;
+	unsigned long bit = BIT(offset);
 	void __iomem *regs = smchip->regbase;
 	unsigned long save;
 	unsigned long val;
@@ -946,7 +946,7 @@ static int sm501_gpio_input(struct gpio_chip *chip, unsigned offset)
 	struct sm501_gpio_chip *smchip = gpiochip_get_data(chip);
 	struct sm501_gpio *smgpio = smchip->ourgpio;
 	void __iomem *regs = smchip->regbase;
-	unsigned long bit = 1 << offset;
+	unsigned long bit = BIT(offset);
 	unsigned long save;
 	unsigned long ddr;
 
@@ -971,7 +971,7 @@ static int sm501_gpio_output(struct gpio_chip *chip,
 {
 	struct sm501_gpio_chip *smchip = gpiochip_get_data(chip);
 	struct sm501_gpio *smgpio = smchip->ourgpio;
-	unsigned long bit = 1 << offset;
+	unsigned long bit = BIT(offset);
 	void __iomem *regs = smchip->regbase;
 	unsigned long save;
 	unsigned long val;
-- 
2.39.5



