Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C348C30CB5A;
	Wed, 17 Sep 2025 13:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114103; cv=none; b=a6HAdZL/Cv5vc7Ocq+zkZ6w+ZxIj8qUURNEW+cOnSLlY5n6n/p01iZ0ZutopelF+KNcTNaVxK4lWvvJa114LBFO5Wd+Af/gVBf4qUIFs4RZxfRE8ycRk7ar/qO3hpAXgxssUD6seQg5qjYw2vXwbh0ZnYYZ4e5ESapyg582dF54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114103; c=relaxed/simple;
	bh=PEztl7FQQbA9koXQl98fPFMLj7gcoqoyPGy1CiFYtPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlP9tUAw5rD9ZWiHFBmere5mbKOL/yXJmzd1v3tgK0wYHpmOf34RcKiOv8OUOzKzLQbZeCN16ZaOAUZxkCm86qnqUafTrEntA9QBkV6olrmpEVULCo/1NJumligTjHnhVRt/wIDlL8hnlUoMPHN+jlh7rYt4Y2dsR9SqKoGoIBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POidMi2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POidMi2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36FDC4CEF0;
	Wed, 17 Sep 2025 13:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114103;
	bh=PEztl7FQQbA9koXQl98fPFMLj7gcoqoyPGy1CiFYtPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POidMi2i56tQCNTVWqysXYYjWZA78luWIPBI9dQ2NpgTHooJjSErkwQX/RLoA4RgA
	 D7Vx+S2QWTkcK+QpgTEq/9sSDO6Bre39pqJTEOSsmpqqu9eaTbeNiKxMVYScDEV2Qz
	 momTUKsIQxQ4ZD9QMUt6fWQ0tJCJYjdNmG+1b0ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.1 47/78] serial: sc16is7xx: fix bug in flow control levels init
Date: Wed, 17 Sep 2025 14:35:08 +0200
Message-ID: <20250917123330.714257037@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1166,17 +1166,6 @@ static int sc16is7xx_startup(struct uart
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
@@ -1188,7 +1177,8 @@ static int sc16is7xx_startup(struct uart
 			     SC16IS7XX_TCR_RX_RESUME(24) |
 			     SC16IS7XX_TCR_RX_HALT(48));
 
-	regcache_cache_bypass(one->regmap, false);
+	/* Disable TCR/TLR access */
+	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG, SC16IS7XX_MCR_TCRTLR_BIT, 0);
 
 	/* Now, initialize the UART */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, SC16IS7XX_LCR_WORD_LEN_8);


