Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F86078B5E;
	Wed, 21 Feb 2024 14:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524951; cv=none; b=j+VqkeoSoO6hXLXh0YjsXGFbLQesUnHtp5qtBCVrZUQPuhFEXFoe1UjZupEf7VTzKiK5r+7j1wPidRnaV1Zzucg5rtIsAubtkQ6MCGj2Z+xvt/u2HyVm1P8LEO+D/ClXbvb5Olp27FY86j31/m545pFcjFEtCaJENUoZXCdLMI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524951; c=relaxed/simple;
	bh=zNf16ppu1uZTPwXoBXBnMwQ/95EgVpiZsDrmINEnKqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anezaPJydOqT7PtXr5KcRzNymxBj+95c0xAFaIqvvvTSzbD9zuaZW6EizcEOlj8uciPAtEqWmn/MQrZGa1l9viV4mYe5iE4aNxZtNzBVIziZ0ANUSD3/NVvVuOuHQdIq/oBP8mib2wj7wL7jc9Yaqy5HgLWPPhmGkg/yYNmy9Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzD8WXh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzD8WXh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23CEC433F1;
	Wed, 21 Feb 2024 14:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524951;
	bh=zNf16ppu1uZTPwXoBXBnMwQ/95EgVpiZsDrmINEnKqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzD8WXh7/MSJ8iw5vPImvaHDCFXZhQ9oKdHzeDSd4yTP7vwk9TLvrQa4YhfQy8Gnu
	 yhKx7u/DQ9Zxb8IWLn313w/DQcgw2bnlxHv5srZSeZbo2CWfEKicmovNpvSIIpgqLv
	 jEMnh29R4v+Z4lvnlEQkWoYVNPp7PIUTrAXcTu6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/267] serial: sc16is7xx: set safe default SPI clock frequency
Date: Wed, 21 Feb 2024 14:05:47 +0100
Message-ID: <20240221125940.266201729@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 3ef79cd1412236d884ab0c46b4d1921380807b48 ]

15 MHz is supported only by 76x variants.

If the SPI clock frequency is not specified, use a safe default clock value
of 4 MHz that is supported by all variants.

Also use HZ_PER_MHZ macro to improve readability.

Fixes: 2c837a8a8f9f ("sc16is7xx: spi interface is added")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-4-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 42e1e6101485..ce0681ba7734 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -24,6 +24,7 @@
 #include <linux/tty_flip.h>
 #include <linux/spi/spi.h>
 #include <linux/uaccess.h>
+#include <linux/units.h>
 #include <uapi/linux/sched/types.h>
 
 #define SC16IS7XX_NAME			"sc16is7xx"
@@ -1414,7 +1415,7 @@ static int sc16is7xx_spi_probe(struct spi_device *spi)
 	spi->bits_per_word	= 8;
 	/* only supports mode 0 on SC16IS762 */
 	spi->mode		= spi->mode ? : SPI_MODE_0;
-	spi->max_speed_hz	= spi->max_speed_hz ? : 15000000;
+	spi->max_speed_hz	= spi->max_speed_hz ? : 4 * HZ_PER_MHZ;
 	ret = spi_setup(spi);
 	if (ret)
 		return ret;
-- 
2.43.0



