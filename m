Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C9A1AE016;
	Mon, 14 Oct 2024 15:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919921; cv=none; b=X3MOugUV4zT1wKDaGpKvjxNb4BBPUDE+XedUS/IRK38Fy76Z7ryoDeNENXHxd6OOBtSNq/HjUNDBFeEqtX7rCfluxGIA/ivozteNAfMn8Ai6cTzlOkWl04fFY5/ak+murzuJipH/Gc3RP5bONo3UbNfFu/ZfthGG1AcvewJj25g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919921; c=relaxed/simple;
	bh=oUXXhSRTH0REa0pLmfWmDi9LbY19H601rvO51+Lcm0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5WwcSz88W/CrdFRpbOtaZqPcSJEvbnFQqjbBCcVJd9StSo9/IZi6dEVqMdOTRsH0kEQ3L98CbN1iUMHz2Z2LCFRn2aTmSZjSF+KPdLB/73yXr1MMCuPHPEAaD+oADsmWLpJY4O3dxdEUSR8mwTIcNx7hBV/oeB212ANCBPc5Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hde7pIm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hde7pIm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A757C4CEC3;
	Mon, 14 Oct 2024 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919921;
	bh=oUXXhSRTH0REa0pLmfWmDi9LbY19H601rvO51+Lcm0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hde7pIm7emGp0nGmEoMCHnEgFIpPiA9pGSF524ZqqjQoAeu4zspdT+nHRdDOQGs7T
	 g7cScLR3X3ZC3xi3BwxcNO+zjXUhomC/cGOZk4hGGQ9qRRSNRwv0ZFvzJbVnFTVi9P
	 IeWuGChr+tjj68TC2zeXymEhI1tBN/Idv4Yb0R1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 747/798] gpio: aspeed: Add the flush write to ensure the write complete.
Date: Mon, 14 Oct 2024 16:21:41 +0200
Message-ID: <20241014141247.415491665@linuxfoundation.org>
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
index 42d3e1cf73528..3cfb2c6103c6b 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -404,6 +404,8 @@ static void __aspeed_gpio_set(struct gpio_chip *gc, unsigned int offset,
 	gpio->dcache[GPIO_BANK(offset)] = reg;
 
 	iowrite32(reg, addr);
+	/* Flush write */
+	ioread32(addr);
 }
 
 static void aspeed_gpio_set(struct gpio_chip *gc, unsigned int offset,
-- 
2.43.0



