Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8949D269831;
	Tue,  8 Apr 2025 11:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111916; cv=none; b=CzbgNKDHHdLZFa+VmvtFOvQ4PFkZ4sBUw9ZMMLe4ZIOU/7dceVZxwAQzA+zz/YSgyTClNZsK005sLs6XSe3w0llizssbjD0MCDfVgtUclVc9yHMozp55Iw1lUPnqEXsCvYMOfoE70CvJP/otY+eCbIzQ9386EyTznZEPSL/2mTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111916; c=relaxed/simple;
	bh=4CM5t5kwgeTUjWJdVYNynUNN5lNpEWuh+SOkLpPV4Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JY5EpAfMVW9a8hiOdJOOuvCveF50tIAyQmC/kSUX2vL92zLhRStICaUL3lHpk4T5FEIC4O5wy1LT+9hvIbp9uXSC2Z6TthK9Due0dqM/Hsu0jz90pcLZjR6Uur6zJHmeSJPfQ5x6q3R01zrsK9u3lTIAtxZ2CpiXSU8dJkS8zes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jz/crCJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jz/crCJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18979C4CEE5;
	Tue,  8 Apr 2025 11:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111916;
	bh=4CM5t5kwgeTUjWJdVYNynUNN5lNpEWuh+SOkLpPV4Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jz/crCJ8qBbRJcrZWjmz4pnxC3UULinEVMpekVHOnciq4FW8lgh1gSSDYk0S3IQ6g
	 3PSGQpojMA86qPMsDhdwgJdJihiOgafPhpZpjNiTAdP0nQZuezk7K5nXtVi85v8EU/
	 xd0PmueIUmg5I8jq01zfAp72CYL1pUA07AY96ils=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 608/731] spi: bcm2835: Do not call gpiod_put() on invalid descriptor
Date: Tue,  8 Apr 2025 12:48:25 +0200
Message-ID: <20250408104928.414631945@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 0d1aa65924846..06a81727d74dd 100644
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



