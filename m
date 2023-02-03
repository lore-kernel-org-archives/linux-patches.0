Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447FC1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C5EC433D2;
	Fri,  3 Feb 2023 10:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419941;
	bh=umkUf+5D1xScySsFuEDErZfzGsoQr1emY0Ux8g6f1+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNS55dfNzjv3Mkot9Hxe2IArg29KFcOm51neXXG0DwP8CNliIuM+ugPipKsVVTYyB
	 89bASttulu+0+s07/N15F5G5DX3tPEIDfICL7++pQms7fJVyiAEo5/P3v311zn2XGn
	 mZm5ImeYCx19PITdyhGzyg9lsETJcu1x9iWXWl+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/134] ARM: imx31: Retrieve the IIM base address from devicetree
Date: Fri,  3 Feb 2023 11:11:52 +0100
Message-Id: <20230203101024.183651231@linuxfoundation.org>
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

[ Upstream commit 3172225d45bd918a5c4865e7cd8eb0c9d79f8530 ]

Now that imx31 has been converted to a devicetree-only platform,
retrieve the IIM base address from devicetree.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 87b30c4b0efb ("ARM: imx: add missing of_node_put()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/cpu-imx31.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/cpu-imx31.c b/arch/arm/mach-imx/cpu-imx31.c
index 3ee684b71006..b9c24b851d1a 100644
--- a/arch/arm/mach-imx/cpu-imx31.c
+++ b/arch/arm/mach-imx/cpu-imx31.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/of_address.h>
 #include <linux/io.h>
 
 #include "common.h"
@@ -32,10 +33,16 @@ static struct {
 
 static int mx31_read_cpu_rev(void)
 {
+	void __iomem *iim_base;
+	struct device_node *np;
 	u32 i, srev;
 
+	np = of_find_compatible_node(NULL, NULL, "fsl,imx31-iim");
+	iim_base = of_iomap(np, 0);
+	BUG_ON(!iim_base);
+
 	/* read SREV register from IIM module */
-	srev = imx_readl(MX31_IO_ADDRESS(MX31_IIM_BASE_ADDR + MXC_IIMSREV));
+	srev = imx_readl(iim_base + MXC_IIMSREV);
 	srev &= 0xff;
 
 	for (i = 0; i < ARRAY_SIZE(mx31_cpu_type); i++)
-- 
2.39.0



