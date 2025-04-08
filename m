Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CCF279354;
	Tue,  8 Apr 2025 12:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116929; cv=none; b=FipkcxKLQzNk/L4E4eRqq6i8I5GYb/09bm18Pb+vtbPSVyumvnuXoCWlyU+Jm4sRHZIY+LW76pQQ6XUO/4ZTRlDz+CyXKyXIQq1MRowb5tXiAnEQkXFuI934digbENTf1gYAstNeuYpWFIwgyZDCB5bORD/a7SDhhyM/j2ugiDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116929; c=relaxed/simple;
	bh=fmcM4GAkTkEecgAlQWnoKJjV7IqnIna7DKCKG+rrE04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdKNUyXPdd/4n/TiXf+5kJiYR+XCyuHgNDD/HHMs0NkvmCnEhin22idOCP1MCMgarZxqPA2kaXLgUzS28AFRPe2c6K14qJiPIAq6i7X3l7KF+piAc7h5DK/vXMOC2jcR5CUD7+0SQTTD+RTIjcNpquM8i1wVGGBqtFd6E0vUUJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpMcRYgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpMcRYgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CEDC4CEE5;
	Tue,  8 Apr 2025 12:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116929;
	bh=fmcM4GAkTkEecgAlQWnoKJjV7IqnIna7DKCKG+rrE04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpMcRYgZfUrqNdd+dMF/SgxZu8mGTPNUXtaingMf3gahcdCjBsRyEdJy2qBKQvCzf
	 49IUO5/bjJlpKybmmTGN8XLaH2Zv+3d3QwtQ9WnoyQpTFW5v9fQzCk0Nt3nHzSc44e
	 N70IWug26O9Y097PWurZoCIMM3FIYCTjz4maRYhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/423] spi: bcm2835: Do not call gpiod_put() on invalid descriptor
Date: Tue,  8 Apr 2025 12:50:47 +0200
Message-ID: <20250408104853.291380146@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit d6691010523fe1016f482a1e1defcc6289eeea48 ]

If we are unable to lookup the chip-select GPIO, the error path will
call bcm2835_spi_cleanup() which unconditionally calls gpiod_put() on
the cs->gpio variable which we just determined was invalid.

Fixes: 21f252cd29f0 ("spi: bcm2835: reduce the abuse of the GPIO API")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250401224238.2854256-1-florian.fainelli@broadcom.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index e1b9b12357877..a5d621b94d5e3 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1162,7 +1162,8 @@ static void bcm2835_spi_cleanup(struct spi_device *spi)
 				 sizeof(u32),
 				 DMA_TO_DEVICE);
 
-	gpiod_put(bs->cs_gpio);
+	if (!IS_ERR(bs->cs_gpio))
+		gpiod_put(bs->cs_gpio);
 	spi_set_csgpiod(spi, 0, NULL);
 
 	kfree(target);
-- 
2.39.5



