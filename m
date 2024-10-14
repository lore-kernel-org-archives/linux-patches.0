Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DB319E802;
	Mon, 14 Oct 2024 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917044; cv=none; b=Ngxq7eDd9JvmV1kIF/jWNWPAFT9fGsZ9pM/nSlTEY8QwwQ8LM1zHiUkNoPeRadGapnVkJybnT5OfHP0xO4XRuX0pEzEGjMkxYwGKPosyp18aFokRczyy/gjg6Q4qFdMHt48DHL5QBFq3jPcty16WAEUr422rHnEwpIlO02G0R8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917044; c=relaxed/simple;
	bh=Z9Vs0DkQEFRppSpbePD5ddbuKoHaBQdKK/8mqhhDiS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orxw7PSWbAm7wU0ePu3vYiwRBwJ/kmopqsLI62/h9W3MOUx1RI/sHb5HoXrqRnzEr7ZRkNWgtv2cqrKFL7mAp64vyVToIpi75YaqmKmSfWy727U9w7cFsat/m5GXftvQP1tr72XLsubh/+TWhwA4syIygdyJ6Cn3oLGdMRaZGSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p22DXGV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p22DXGV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8ABC4CEC3;
	Mon, 14 Oct 2024 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917044;
	bh=Z9Vs0DkQEFRppSpbePD5ddbuKoHaBQdKK/8mqhhDiS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p22DXGV1UY/W9TaEZFpgF/5YcQes8kMAi3RfuE71ApDTmw/48gsQxYbChrv88WIyY
	 Lm9Z07NbJXRhdvCHs3Bv9ZZqkLqBRuSKmAYJZ0ec/2aofPxsL/sceHW1qb2I/Nbvqu
	 QlX2/ZIqSY1tI4lI8v9tCUFuQ6VU52bJqNqoAwGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/213] gpio: aspeed: Add the flush write to ensure the write complete.
Date: Mon, 14 Oct 2024 16:20:41 +0200
Message-ID: <20241014141048.237752081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 1bb5a99e1f3fd27accb804aa0443a789161f843c ]

Performing a dummy read ensures that the register write operation is fully
completed, mitigating any potential bus delays that could otherwise impact
the frequency of bitbang usage. E.g., if the JTAG application uses GPIO to
control the JTAG pins (TCK, TMS, TDI, TDO, and TRST), and the application
sets the TCK clock to 1 MHz, the GPIO's high/low transitions will rely on
a delay function to ensure the clock frequency does not exceed 1 MHz.
However, this can lead to rapid toggling of the GPIO because the write
operation is POSTed and does not wait for a bus acknowledgment.

Fixes: 361b79119a4b ("gpio: Add Aspeed driver")
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20241008081450.1490955-2-billy_tsai@aspeedtech.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-aspeed.c b/drivers/gpio/gpio-aspeed.c
index 58f107194fdaf..017f083bc8c29 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -406,6 +406,8 @@ static void __aspeed_gpio_set(struct gpio_chip *gc, unsigned int offset,
 	gpio->dcache[GPIO_BANK(offset)] = reg;
 
 	iowrite32(reg, addr);
+	/* Flush write */
+	ioread32(addr);
 }
 
 static void aspeed_gpio_set(struct gpio_chip *gc, unsigned int offset,
-- 
2.43.0



