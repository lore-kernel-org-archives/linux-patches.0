Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89F633E6;
	Tue, 23 Jan 2024 01:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975005; cv=none; b=eyWDzpQWy1BGdlo34tChSgAs52SogN4XlTTmF1XbuKxnyjiwy1DZc/Fr5ey3b2SAFhEEBr1Hh8fGomVMAKqGrUqSr1C+qa78ysYVyo7bJB8imDji3jEU55zz4YdGIWRMwXU55TdeV0Gl1To7Wv1zTYak9qNwxSTENMMn6+HgFdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975005; c=relaxed/simple;
	bh=YwMOsLwhYZtQ7q3nv9XRO/hDgZeNejoC3T66p41XUq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNgNRPz8SEUOGzCuzoRtsMIQjJuUvqfXp/BiJqTHA9rWWuLSfNEeJKBZrIOWEUnx7NvDh6ZehuUhXtKA0sOIiBMrs+JARrsA1eRFAa30nxR2O0gB1l+9Gp+n0/9qd5cljdsecUoM4j0D6AAInV2AQ3ebFC9R9xbE0No/5tiE5pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwIkwMVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwIkwMVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8674C433F1;
	Tue, 23 Jan 2024 01:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975005;
	bh=YwMOsLwhYZtQ7q3nv9XRO/hDgZeNejoC3T66p41XUq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwIkwMVlbnQG53zMTUHb9GCok38cU0HeIjDeHOvwBx7w1ynNjVwazUleElsVah/9t
	 icaVcskSaEENr7EIyaMkFVx12XxJ5d6eVsdN+ijzyIJ3QtI61ItWrIDM9bNMIoo1Cg
	 pqpWYI0jB6YmqwvdWdabVi4JlJMj43lzfyGZjNNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 5.15 289/374] serial: sc16is7xx: set safe default SPI clock frequency
Date: Mon, 22 Jan 2024 15:59:05 -0800
Message-ID: <20240122235754.834029316@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 3ef79cd1412236d884ab0c46b4d1921380807b48 upstream.

15 MHz is supported only by 76x variants.

If the SPI clock frequency is not specified, use a safe default clock value
of 4 MHz that is supported by all variants.

Also use HZ_PER_MHZ macro to improve readability.

Fixes: 2c837a8a8f9f ("sc16is7xx: spi interface is added")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-4-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -24,6 +24,7 @@
 #include <linux/tty_flip.h>
 #include <linux/spi/spi.h>
 #include <linux/uaccess.h>
+#include <linux/units.h>
 #include <uapi/linux/sched/types.h>
 
 #define SC16IS7XX_NAME			"sc16is7xx"
@@ -1454,7 +1455,7 @@ static int sc16is7xx_spi_probe(struct sp
 		return dev_err_probe(&spi->dev, -EINVAL, "Unsupported SPI mode\n");
 
 	spi->mode		= spi->mode ? : SPI_MODE_0;
-	spi->max_speed_hz	= spi->max_speed_hz ? : 15000000;
+	spi->max_speed_hz	= spi->max_speed_hz ? : 4 * HZ_PER_MHZ;
 	ret = spi_setup(spi);
 	if (ret)
 		return ret;


