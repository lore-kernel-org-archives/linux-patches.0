Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601F518A6CF;
	Wed, 17 Sep 2025 12:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112934; cv=none; b=Fs7O1SpGn8hYYV4UGa4ZDp0JG29CTvS06eu4AR108b+afXWL/w8rEJSJgi1Pcg2m3ZZ1vL3UxCWiIpfbBN0GUATwNH3I/o8E3yskvbf8hjTJzKTOjChFKU5H5H/wtf1H+eTRDkkhvUkzR99mda2cxZy1Iqhj6gH71x8lRJYf8qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112934; c=relaxed/simple;
	bh=bO3FtTIVunsPXbOaYihxPQgyzwpSbRFnUott6tgYXLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5abuf6B8U6HUbrZr8yU81a/ACRpfnpZp3UIvNtsRFctiTLKW4fBFphUv2RmZ3EWIpZbc5zqQufqBlVY/shnQgWWuqhhaSwQvobxV/wG0YZhKOPNU9JvkYdO246k+hINQeO6IIshYsildhgdCuPpe9tJkwYkmwmDTgWrMRpQXQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuNFBFlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuNFBFlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD186C4CEF0;
	Wed, 17 Sep 2025 12:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112934;
	bh=bO3FtTIVunsPXbOaYihxPQgyzwpSbRFnUott6tgYXLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuNFBFlGrGcAj+VZwJewmOEAmPUQgfAnjDDqkd8uKyCR47PPf+Mjhczo0lDk0/lRE
	 SmYCkPMs1X5RtEsiHSNfS6gMYK6rSSIoXq6YMS3zBBvQLXlfbHWzREyoUAQb9VEf1x
	 epzt/ORpsh+A1bFgUP6LVN9MzvXepDgofvA700Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.16 121/189] serial: sc16is7xx: fix bug in flow control levels init
Date: Wed, 17 Sep 2025 14:33:51 +0200
Message-ID: <20250917123354.817986005@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1177,17 +1177,6 @@ static int sc16is7xx_startup(struct uart
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
@@ -1199,7 +1188,8 @@ static int sc16is7xx_startup(struct uart
 			     SC16IS7XX_TCR_RX_RESUME(24) |
 			     SC16IS7XX_TCR_RX_HALT(48));
 
-	regcache_cache_bypass(one->regmap, false);
+	/* Disable TCR/TLR access */
+	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG, SC16IS7XX_MCR_TCRTLR_BIT, 0);
 
 	/* Now, initialize the UART */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, SC16IS7XX_LCR_WORD_LEN_8);


