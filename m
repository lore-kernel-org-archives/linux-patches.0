Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8AD1EE00B;
	Tue,  3 Dec 2024 16:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242614; cv=none; b=eGHNpr1MmKvjSFW4nYBAAKjfZINb09+9jqQYSlgUxK1Ac3cXhqYjy/Cladnnx9shWXeMrEl4yrGFCR/6dq34Z+1RGVSZVRYVMlB7rrWLTcomxJwapspMsPSTS1eKsHcRBFD5ZAJhwFotI285+hWU16dJN+uo2UTInzW0+Lvw50k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242614; c=relaxed/simple;
	bh=+0+6r2MHINbDQULt5wKOXblsY2cj8glUBQ0Fgyco8G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3pXIkQXKLGQdfNUpQLxyqAjiEYcYnDRSZffabBOeymiXGsRB1Wg5BXYqSDbXfOQOzMblLgTsXBPpUqosdNFhzkwXCrqlHqRMEHgZPNOx4Ge3otT24c/0SGIIIMUkCak7y2/5MJ0k7B7W6+ahbOsL1pckLd9eAVcNxnACwkYx/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvEfqCHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvEfqCHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6795EC4CECF;
	Tue,  3 Dec 2024 16:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242613;
	bh=+0+6r2MHINbDQULt5wKOXblsY2cj8glUBQ0Fgyco8G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvEfqCHqgmdY++Q5zw33TSSWACdWm2u5NxddPBg7w4ssBq1t/TqEJqnXjXshY9zls
	 2+B/PWWSWngLKRo1W7pKwp84UoOeRSumRSRLueXZQrAFx8su7fyzH7qs9mSE+AMMN+
	 QH7Bdj+jlyUHYOTZmVhCQgaOwfNgK6A0e5PBPwyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.12 715/826] serial: amba-pl011: fix build regression
Date: Tue,  3 Dec 2024 15:47:22 +0100
Message-ID: <20241203144811.654184578@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit b5a23a60e8ab5711f4952912424347bf3864ce8d upstream.

When CONFIG_DMA_ENGINE is disabled, the driver now fails to build:

drivers/tty/serial/amba-pl011.c: In function 'pl011_unthrottle_rx':
drivers/tty/serial/amba-pl011.c:1822:16: error: 'struct uart_amba_port' has no member named 'using_rx_dma'
 1822 |         if (uap->using_rx_dma) {
      |                ^~
drivers/tty/serial/amba-pl011.c:1823:20: error: 'struct uart_amba_port' has no member named 'dmacr'
 1823 |                 uap->dmacr |= UART011_RXDMAE;
      |                    ^~
drivers/tty/serial/amba-pl011.c:1824:32: error: 'struct uart_amba_port' has no member named 'dmacr'
 1824 |                 pl011_write(uap->dmacr, uap, REG_DMACR);
      |                                ^~

Add the missing #ifdef check around these field accesses, matching
what other parts of this driver do.

Fixes: 2bcacc1c87ac ("serial: amba-pl011: Fix RX stall when DMA is used")
Cc: stable <stable@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411140617.nkjeHhsK-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20241115110021.744332-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1819,10 +1819,12 @@ static void pl011_unthrottle_rx(struct u
 
 	pl011_write(uap->im, uap, REG_IMSC);
 
+#ifdef CONFIG_DMA_ENGINE
 	if (uap->using_rx_dma) {
 		uap->dmacr |= UART011_RXDMAE;
 		pl011_write(uap->dmacr, uap, REG_DMACR);
 	}
+#endif
 
 	uart_port_unlock_irqrestore(&uap->port, flags);
 }


