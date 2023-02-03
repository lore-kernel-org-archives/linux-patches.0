Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D71A1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95275C4339C;
	Fri,  3 Feb 2023 10:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419938;
	bh=jS1QrYajTpWYrBfhBqPa8aLRt4ccY2RztyTGwEJlCDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v08/CEzjZSS6SY8n0JM+ZgBDFcdTiDjVNdqOvPli7ap2A9xna1jpEL9W4immHrBzP
	 04ML8HtrNVT2qQxDEHuf3ZmY24Q9KzG792AJWagjiDlbAUHIdySWXXoX6TIwdWT5nd
	 fAPArS4OnRJfY+UwIBnbmnr6/OuOHp+hTfyAgOPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/134] ARM: imx27: Retrieve the SYSCTRL base address from devicetree
Date: Fri,  3 Feb 2023 11:11:51 +0100
Message-Id: <20230203101024.144479437@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 94b2bec1b0e054b27b0a0b5f52a0cd55c83340f4 ]

Now that imx27 has been converted to a devicetree-only platform,
retrieve the SYSCTRL base address from devicetree.

To keep devicetree compatibilty the SYSCTRL base address will be
retrieved from the CCM base address plus an 0x800 offset.

This is not a problem as the imx27.dtsi describes the CCM register
range as 0x1000.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 87b30c4b0efb ("ARM: imx: add missing of_node_put()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/cpu-imx27.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/cpu-imx27.c b/arch/arm/mach-imx/cpu-imx27.c
index a969aa71b60f..bf70e13bbe9e 100644
--- a/arch/arm/mach-imx/cpu-imx27.c
+++ b/arch/arm/mach-imx/cpu-imx27.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/io.h>
+#include <linux/of_address.h>
 #include <linux/module.h>
 
 #include "hardware.h"
@@ -17,16 +18,23 @@ static int mx27_cpu_rev = -1;
 static int mx27_cpu_partnumber;
 
 #define SYS_CHIP_ID             0x00    /* The offset of CHIP ID register */
+#define SYSCTRL_OFFSET		0x800	/* Offset from CCM base address */
 
 static int mx27_read_cpu_rev(void)
 {
+	void __iomem *ccm_base;
+	struct device_node *np;
 	u32 val;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,imx27-ccm");
+	ccm_base = of_iomap(np, 0);
+	BUG_ON(!ccm_base);
 	/*
 	 * now we have access to the IO registers. As we need
 	 * the silicon revision very early we read it here to
 	 * avoid any further hooks
 	*/
-	val = imx_readl(MX27_IO_ADDRESS(MX27_SYSCTRL_BASE_ADDR + SYS_CHIP_ID));
+	val = imx_readl(ccm_base + SYSCTRL_OFFSET + SYS_CHIP_ID);
 
 	mx27_cpu_partnumber = (int)((val >> 12) & 0xFFFF);
 
-- 
2.39.0



