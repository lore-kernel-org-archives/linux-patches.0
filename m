Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABDD316191;
	Wed, 17 Sep 2025 12:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113828; cv=none; b=ncYiSyN/GPsGeJpjnbBkINmxwRYVCwIMRJnyfKq+bY+gEJLoEKfYnQESkoFjVcIYo+cUYVuLUrY4EY8KxuYcqXCIf8cVPfE38OXp60sl21ZTVBI2/v7w3FDN8BZ5cVCNNwWG7AtDfVy9q3B1wHQI2ANs+aVAm9RB8q+/ouV6k60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113828; c=relaxed/simple;
	bh=oTg8UztC8UC5dmj/f2A5CrcyEm76TENTGNIXFemhPJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/MHtANipL8OPAdBiOCL1YMv+bsKEt5U0TSzmWQaYr9d89Qino7d+HUrGDziq+eO80gkkpzCwbt/iT7HONAvdh8433CfEvajGwgtAr6eGFigrPXpY7uIpvQ8nnDX3Bxeml8hkvQZQDtc2t2xTaVj1QC4E6oE7JGuto9VWkR2kkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fm2kJMze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fm2kJMze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A53C4CEF0;
	Wed, 17 Sep 2025 12:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113827;
	bh=oTg8UztC8UC5dmj/f2A5CrcyEm76TENTGNIXFemhPJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fm2kJMzec7e+FPyIU4d7x47FuttUwPZdmwv5sO3K8XZ58KVW5fDCH6HeRqkbGycC8
	 xjVh2Jdaia9swZpNM3ouVHWN8sV6U2iZWt1KCjomQO5olOaGikL7U5gIKunYzzDdsL
	 YxPabhEBRTpBbyjxtcAVRuApr4Asj37u3n+QyLsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 063/101] serial: sc16is7xx: fix bug in flow control levels init
Date: Wed, 17 Sep 2025 14:34:46 +0200
Message-ID: <20250917123338.365836532@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 535fd4c98452c87537a40610abba45daf5761ec6 upstream.

When trying to set MCR[2], XON1 is incorrectly accessed instead. And when
writing to the TCR register to configure flow control levels, we are
incorrectly writing to the MSR register. The default value of $00 is then
used for TCR, which means that selectable trigger levels in FCR are used
in place of TCR.

TCR/TLR access requires EFR[4] (enable enhanced functions) and MCR[2]
to be set. EFR[4] is already set in probe().

MCR access requires LCR[7] to be zero.

Since LCR is set to $BF when trying to set MCR[2], XON1 is incorrectly
accessed instead because MCR shares the same address space as XON1.

Since MCR[2] is unmodified and still zero, when writing to TCR we are in
fact writing to MSR because TCR/TLR registers share the same address space
as MSR/SPR.

Fix by first removing useless reconfiguration of EFR[4] (enable enhanced
functions), as it is already enabled in sc16is7xx_probe() since commit
43c51bb573aa ("sc16is7xx: make sure device is in suspend once probed").
Now LCR is $00, which means that MCR access is enabled.

Also remove regcache_cache_bypass() calls since we no longer access the
enhanced registers set, and TCR is already declared as volatile (in fact
by declaring MSR as volatile, which shares the same address).

Finally disable access to TCR/TLR registers after modifying them by
clearing MCR[2].

Note: the comment about "... and internal clock div" is wrong and can be
      ignored/removed as access to internal clock div registers (DLL/DLH)
      is permitted only when LCR[7] is logic 1, not when enhanced features
      is enabled. And DLL/DLH access is not needed in sc16is7xx_startup().

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20250731124451.1108864-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1163,17 +1163,6 @@ static int sc16is7xx_startup(struct uart
 	sc16is7xx_port_write(port, SC16IS7XX_FCR_REG,
 			     SC16IS7XX_FCR_FIFO_BIT);
 
-	/* Enable EFR */
-	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
-			     SC16IS7XX_LCR_CONF_MODE_B);
-
-	regcache_cache_bypass(one->regmap, true);
-
-	/* Enable write access to enhanced features and internal clock div */
-	sc16is7xx_port_update(port, SC16IS7XX_EFR_REG,
-			      SC16IS7XX_EFR_ENABLE_BIT,
-			      SC16IS7XX_EFR_ENABLE_BIT);
-
 	/* Enable TCR/TLR */
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG,
 			      SC16IS7XX_MCR_TCRTLR_BIT,
@@ -1185,7 +1174,8 @@ static int sc16is7xx_startup(struct uart
 			     SC16IS7XX_TCR_RX_RESUME(24) |
 			     SC16IS7XX_TCR_RX_HALT(48));
 
-	regcache_cache_bypass(one->regmap, false);
+	/* Disable TCR/TLR access */
+	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG, SC16IS7XX_MCR_TCRTLR_BIT, 0);
 
 	/* Now, initialize the UART */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, SC16IS7XX_LCR_WORD_LEN_8);


