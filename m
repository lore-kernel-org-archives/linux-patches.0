Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E002571AC;
	Tue, 25 Mar 2025 12:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906094; cv=none; b=QqQCCv6UiUT/hRlMFJacwA/F8Z4CNF5JprqZkF2XBbFzexK8KZ0w82alSzMCaDvwAP7JTDmFy/yF/k9IRtKnMU61F+lC9nbSu7bsIWRgEiayqcur3GvFbtZYiyLBGWoyzrlYethKB+vpn5Eg/AxsAf8QOeT6bLwOsBuPh2+nUZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906094; c=relaxed/simple;
	bh=TXqjaYeIXmyY6/RgS271turChjqz9D8uLIJwOPbvdkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekuiTurpKXy8hippnipBeqjgVfckmKHOSc1ha10yfLZPawMCrskZB2ScYmkbLPmAbpjyC3JTLDpM79/YKN/flKfOCh2dZ3U7j2yvWMCLQq5Hi7cvqxt0bIjKBlowgjxN1oX1si6uABpFkWINVB5LqtVKEufqOeZd5xt9irv1dU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgSMDmwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgSMDmwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26685C4CEE4;
	Tue, 25 Mar 2025 12:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906094;
	bh=TXqjaYeIXmyY6/RgS271turChjqz9D8uLIJwOPbvdkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgSMDmwlqpsBWYrhnma0Wof0WPvyjoiigzatPa6zoIHJj1TIli+eBvCPWr7CZT9XU
	 F7J5hQNYJr4d98t9/o7ZfnarOkxy5+pxSQ/I/ZxOqlULoregIW/wAyqp1W67lXgfUq
	 aortMdwZT2dbmk7Q2h7wjYUVfzqP6nZGYFabA1oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 12/77] ARM: OMAP1: select CONFIG_GENERIC_IRQ_CHIP
Date: Tue, 25 Mar 2025 08:22:07 -0400
Message-ID: <20250325122144.652342497@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 98f3ab18a0a55aa1ff2cd6b74bd0c02c8f76f17e ]

When GENERIC_IRQ_CHIP is disabled, OMAP1 kernels fail to link:

arm-linux-gnueabi-ld: arch/arm/mach-omap1/irq.o: in function `omap1_init_irq':
irq.c:(.init.text+0x1e8): undefined reference to `irq_alloc_generic_chip'
arm-linux-gnueabi-ld: irq.c:(.init.text+0x228): undefined reference to `irq_setup_generic_chip'
arm-linux-gnueabi-ld: irq.c:(.init.text+0x2a8): undefined reference to `irq_gc_set_wake'
arm-linux-gnueabi-ld: irq.c:(.init.text+0x2b0): undefined reference to `irq_gc_mask_set_bit'
arm-linux-gnueabi-ld: irq.c:(.init.text+0x2b4): undefined reference to `irq_gc_mask_clr_bit'

This has apparently been the case for many years, but I never caught it
in randconfig builds until now, as there are dozens of other drivers
that also 'select GENERIC_IRQ_CHIP' and statistically there is almost
always one of them enabled.

Fixes: 55b447744389 ("ARM: OMAP1: Switch to use generic irqchip in preparation for sparse IRQ")
Link: https://lore.kernel.org/r/20250205121151.289535-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index cbf703f0d850f..c5bd2535e0f4c 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -9,6 +9,7 @@ menuconfig ARCH_OMAP1
 	select ARCH_OMAP
 	select CLKSRC_MMIO
 	select FORCE_PCI if PCCARD
+	select GENERIC_IRQ_CHIP
 	select GPIOLIB
 	help
 	  Support for older TI OMAP1 (omap7xx, omap15xx or omap16xx)
-- 
2.39.5



