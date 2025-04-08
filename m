Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5558F26B950;
	Tue,  8 Apr 2025 12:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116481; cv=none; b=jzDw9c/17MoIK4ywAFtXJ13OZD7kmCDEXY/bwg9bU9vg0R3JemMKG8StQbnQGjKlhGqwWDctUzIOGYll0vQTeBERncyYREUBJSBexN95Y66PH3aKiKZGF6mHDoCEx4uXxAOXsn+AC/g+sZ9eDAspmyWULbuWenIZuJ0SBkMuCBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116481; c=relaxed/simple;
	bh=On2IIUIU6TK5Ys5ealtJaDyoA0d906hjZu+FKgwJaxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adAfuhlXCxqJ8o7PdRJvu7qyikBQlhccx+Dip1j0BtHwBfTheaazGQs6dcTV7KjotozoALneVQAydgFEmuabJ1TzOW+dTy1Ckoj0mqMcy0x1UrRnlW5AfTajXE//sp4BBa/YzEfMC/jjmfM0x4y/jPmnTcA+AUkN4lTZNSGL+OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGqxhKzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGqxhKzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9FEC4CEEF;
	Tue,  8 Apr 2025 12:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116481;
	bh=On2IIUIU6TK5Ys5ealtJaDyoA0d906hjZu+FKgwJaxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGqxhKzzyQT/iJ0VxhztzxZAO9ifyjZM0pgaGvxoZWbTJH3IueUXJW3L0JLQImCNs
	 1KyePPGz5DvrIRU8eLxzjGCwwNiKENouJwil517Y3f651giknCynBVgMBV7zObvr5X
	 SzspqNodjch853sQWV05tgHjbeoA/k1NndUPA7DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/423] mfd: sm501: Switch to BIT() to mitigate integer overflows
Date: Tue,  8 Apr 2025 12:48:01 +0200
Message-ID: <20250408104849.348968800@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b3592982a83b5..5b6dc1cb9bfc3 100644
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



