Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6434B259CAD;
	Tue, 25 Mar 2025 12:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905769; cv=none; b=Q/QtglNGV9Az8IIYip8KM3nyo+C8vqsXokcA2wpJEUpEq4cv/YT8okOxfdJvYfdBIr3T6Qb6GUnd0S3EF9fb05OglKdJovMkvr6jwdI8oJJJxx19TVUg883UPghvG1edoLD82PsczyZkJtBW7ZmztaUl4DeUyZPErX8a2vYjfvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905769; c=relaxed/simple;
	bh=Sv2ZImZOgUhO9zzn1bSTr1YMFSmIv9nJPx3Mk2MugDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsUvtFybj74IYpmHpuj6nHwAJdvv3Opwtz9FQNg4HwCnBTyJHYIlmR7no38X6G3gWUtmDK/oG8DI36IIURdwaXEXdgKFK5UmV/0ghwbC9sXzdZn3pJjN69Z+IIu50FLOBN6SEdymQ9Paz1tHWPVIfqPyaL/lfeFlZX1BItv4HnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xF1PbTmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xF1PbTmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C7AC4CEED;
	Tue, 25 Mar 2025 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905769;
	bh=Sv2ZImZOgUhO9zzn1bSTr1YMFSmIv9nJPx3Mk2MugDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xF1PbTmLOkPLQ+IkU/hVtQ3vmP717qi/vkuT48CCvjB75sqYHwD5MY732scpHLH/a
	 Lwf/mIe7eRiJr6CadT9nDT3pbWvF+4xPDTf0kVs2f6tiaIKhgbluHP1PvbPrZGMhnU
	 KYjphYkM2xUkW7D9wqfttDR8VebTQ8F6BWuCau5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/198] ARM: OMAP1: select CONFIG_GENERIC_IRQ_CHIP
Date: Tue, 25 Mar 2025 08:21:56 -0400
Message-ID: <20250325122200.698321683@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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
index 7ec7ada287e05..16bf3bed38feb 100644
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



