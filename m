Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD73749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8A8C433D2;
	Thu, 12 Jan 2023 14:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532683;
	bh=9g3w6FqGG5dKfjDgxqMNoBNcBj3pFG2i7rm2kfMKH0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BX2WOiPhko+7C7ucZKLQwL6pwwxsCbx7Kr24anmY//ZqQR323iSSCO/G2SNX3PF85
	 usUt5cJSqXPx8wHiBarrjR7w7VecV/4bcXyS2FOq8RPJ/mCdzJouYFcA16b3KDsIM7
	 462lk4yUecxrHicBcmwniwXXfx5tAYMDn/hASAFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/783] spi: spidev: mask SPI_CS_HIGH in SPI_IOC_RD_MODE
Date: Thu, 12 Jan 2023 14:48:37 +0100
Message-Id: <20230112135533.657723768@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 7dbfa445ff7393d1c4c066c1727c9e0af1251958 ]

Commit f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
has changed the user-space interface so that bogus SPI_CS_HIGH started
to appear in the mask returned by SPI_IOC_RD_MODE even for active-low CS
pins. Commit 138c9c32f090
("spi: spidev: Fix CS polarity if GPIO descriptors are used") fixed only
SPI_IOC_WR_MODE part of the problem. Let's fix SPI_IOC_RD_MODE
symmetrically.

Test case:

	#include <sys/ioctl.h>
	#include <fcntl.h>
	#include <linux/spi/spidev.h>

	int main(int argc, char **argv)
	{
		char modew = SPI_CPHA;
		char moder;
		int f = open("/dev/spidev0.0", O_RDWR);

		if (f < 0)
			return 1;

		ioctl(f, SPI_IOC_WR_MODE, &modew);
		ioctl(f, SPI_IOC_RD_MODE, &moder);

		return moder == modew ? 0 : 2;
	}

Fixes: f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20221130162927.539512-1-alexander.sverdlin@siemens.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 859910ec8d9f..9c5ec99431d2 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -376,12 +376,23 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	/* read requests */
 	case SPI_IOC_RD_MODE:
-		retval = put_user(spi->mode & SPI_MODE_MASK,
-					(__u8 __user *)arg);
-		break;
 	case SPI_IOC_RD_MODE32:
-		retval = put_user(spi->mode & SPI_MODE_MASK,
-					(__u32 __user *)arg);
+		tmp = spi->mode;
+
+		{
+			struct spi_controller *ctlr = spi->controller;
+
+			if (ctlr->use_gpio_descriptors && ctlr->cs_gpiods &&
+			    ctlr->cs_gpiods[spi->chip_select])
+				tmp &= ~SPI_CS_HIGH;
+		}
+
+		if (cmd == SPI_IOC_RD_MODE)
+			retval = put_user(tmp & SPI_MODE_MASK,
+					  (__u8 __user *)arg);
+		else
+			retval = put_user(tmp & SPI_MODE_MASK,
+					  (__u32 __user *)arg);
 		break;
 	case SPI_IOC_RD_LSB_FIRST:
 		retval = put_user((spi->mode & SPI_LSB_FIRST) ?  1 : 0,
-- 
2.35.1



