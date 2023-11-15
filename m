Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA303BB4D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRD7tuFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD7AC433C9;
	Wed, 15 Nov 2023 19:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076642;
	bh=D19gDffhUXnxjKbZIin2HwBgQ/KPAdcOSBeYSUgzWzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRD7tuFue72kGtzJCID47dag/y71P5J322QwaGGDqti0YSKgVMnr8jxdMiZd7EHiZ
	 jMAsnD1oPgcDB2b0EVl6jdfCARgG4dkHN0RmYBbpstsglJOcfq3jPNJq1RI5j6t1fW
	 EMsMylV8D8jFtgO31gvFY/KQVNhtqhz/j3Sk8+m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Stefan Wahren <wahrenst@gmx.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 332/550] ARM: 9323/1: mm: Fix ARCH_LOW_ADDRESS_LIMIT when CONFIG_ZONE_DMA
Date: Wed, 15 Nov 2023 14:15:16 -0500
Message-ID: <20231115191623.778806090@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wahrenst <wahrenst@gmx.net>

[ Upstream commit 399da29ff5eb3f675c71423bec4cf2208f218576 ]

Configuring VMSPLIT_2G + LPAE on Raspberry Pi 4 leads to SWIOTLB
buffer allocation beyond platform dma_zone_size of SZ_1G, which
results in broken SD card boot.

So fix this be setting ARCH_LOW_ADDRESS_LIMIT in CONFIG_ZONE_DMA
case.

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Fixes: e9faf9b0b07a ("ARM: add multi_v7_lpae_defconfig")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/dma.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index c6aded1b069cf..e2a1916013e75 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -12,6 +12,9 @@
 	extern phys_addr_t arm_dma_zone_size; \
 	arm_dma_zone_size && arm_dma_zone_size < (0x100000000ULL - PAGE_OFFSET) ? \
 		(PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
+
+extern phys_addr_t arm_dma_limit;
+#define ARCH_LOW_ADDRESS_LIMIT arm_dma_limit
 #endif
 
 #ifdef CONFIG_ISA_DMA_API
-- 
2.42.0



