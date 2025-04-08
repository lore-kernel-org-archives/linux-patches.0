Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8543C268691;
	Tue,  8 Apr 2025 11:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110081; cv=none; b=IqhGJTWvVLhIz3Sm3L53OfNzDiy7DCGjxC6ajQ23FNYz4LBTiFDFD99GO8d2wbCkNfpct+K8Qcq3aO6wrCk25MoAKoGXr0JNt1F5UQEN+Zl9OI3685c9yE69kzXpu5l7ks2qV2x6EF/1FFlIAO5kSqKk31OTU3oSvwRNcNILCjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110081; c=relaxed/simple;
	bh=ykFod5oZYAoCdBCqsT7VPJuZxxGXGwhG4DH00deLxBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROfN1mG+sqg/yvANMvCHYBjVn8fXoqr1s0RQgvICAvu/+Z5GVNt9Oq66QGYrXlUTcwlO8V7VscOSwahd/sY20s6dwHWWDA0rLTYT7roJDW8DDhfoCUrw69MliSaDGNSg1uplmmLURutm1zyGBXTJ8wpULZwyHoiKu+EIz6/RLOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY2FueT2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY2FueT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC22C4CEE5;
	Tue,  8 Apr 2025 11:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110079;
	bh=ykFod5oZYAoCdBCqsT7VPJuZxxGXGwhG4DH00deLxBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iY2FueT2E/aQkMgtdohm3uluRMG8xLGWvwjHOMPd4dPEqJNu3Q3CPvST7TFynL4qv
	 oy/Xa5i8MqyihtBzBQ3J93Vr4dAWxBxz0q1R2TnwfcpthZBzaDos2+R1wa/rDguHiP
	 BDwmKD/AqCV8Vq6iXF9MlqA5HqBdpxGUE04oIVTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/227] mfd: sm501: Switch to BIT() to mitigate integer overflows
Date: Tue,  8 Apr 2025 12:48:57 +0200
Message-ID: <20250408104825.084669633@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 37ad72d8cde2a..8c67fdc2af7f1 100644
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



