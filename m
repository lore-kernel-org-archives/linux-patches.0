Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B212312FF73;
	Tue, 23 Jan 2024 01:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971796; cv=none; b=k4hkiwgNJvr4ukzhJLSF/eK5v+WThlVUPsnrFzC5cjj+hpi6WWtJU+eGcUPl3GOb78Uae7hmDxaDphNvUl4kUTdyxC6ch+r8t1sHUJ3ssWnpWSLoass88EZ57Fmhp/pUQ7Thj/OGy32ZG7cmA+qQIYNndav/B5BAijKGfKbjFt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971796; c=relaxed/simple;
	bh=auqdmgquI4ieQRrzp17N/gauoSxnZjcBMhBl/z+Cymk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbLZs7G8lQZ29U4MwKhl8srrE6AEjD4F8IdozX30CepqobJ07N60F80Aba1e0B0wU3nCExCucvWJt57ksM0Hs2mpHk2eXf1/zFBxJgnqu+B/QCq223jhDBp+LcvEoJ+vUltLwlxLMZU1XPtXPBncH0a4/H7HjHPxK7NSBelZKGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+9oiZZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+9oiZZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737CEC433F1;
	Tue, 23 Jan 2024 01:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971796;
	bh=auqdmgquI4ieQRrzp17N/gauoSxnZjcBMhBl/z+Cymk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+9oiZZZW4fbI3+q6KmQkyTsfWRdLPLkj2FWX2Mp8zkFoR1Umb7114CicEcNQD9hm
	 OrYCBFfnByT9mAu/ZZIbZYhpvZJFPEBnsBrFxxo+gsvE4jhyCKBd6EsdCZTegk7qNJ
	 1iIbdZm1SpmpfM96rQ9DXunkZoiroAzOymKpURG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.1 322/417] serial: sc16is7xx: set safe default SPI clock frequency
Date: Mon, 22 Jan 2024 15:58:10 -0800
Message-ID: <20240122235802.957950334@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
@@ -1721,7 +1722,7 @@ static int sc16is7xx_spi_probe(struct sp
 		return dev_err_probe(&spi->dev, -EINVAL, "Unsupported SPI mode\n");
 
 	spi->mode		= spi->mode ? : SPI_MODE_0;
-	spi->max_speed_hz	= spi->max_speed_hz ? : 15000000;
+	spi->max_speed_hz	= spi->max_speed_hz ? : 4 * HZ_PER_MHZ;
 	ret = spi_setup(spi);
 	if (ret)
 		return ret;


