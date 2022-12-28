Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312EE1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B123C433D2;
	Wed, 28 Dec 2022 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246129;
	bh=P9OsdIVMBEreN4JcSrTvRIENSHE29Zj6l6lLqaOumn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9tVAnu+OkhK/eWreBA42rBxjceiducAuMzy6m2GEu10sajTxr+wDuycyta0agXsL
	 wIcJRwgNoOMN6xL2uxaWpUA3UUJraGTz8/tkORAu7bmqFSruTIamh7N3l9yZ3sBgn7
	 ++ZNirjHA87BqDFWq7/ldgQ54g+YoBRcxRlZ1UD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1017/1073] MIPS: ralink: mt7621: avoid to init common ralink reset controller
Date: Wed, 28 Dec 2022 15:43:25 +0100
Message-Id: <20221228144355.804661925@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 76ce51798cb16738a4a28a6662e7344aaf7ef769 ]

Commit 38a8553b0a22 ("clk: ralink: make system controller node a reset provider")
make system controller a reset provider for mt7621 ralink SoCs. Ralink init code
also tries to start previous common reset controller which at the end tries to
find device tree node 'ralink,rt2880-reset'. mt7621 device tree file is not
using at all this node anymore. Hence avoid to init this common reset controller
for mt7621 ralink SoCs to avoid 'Failed to find reset controller node' boot
error trace error.

Fixes: 64b2d6ffff86 ("staging: mt7621-dts: align resets with binding documentation")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/of.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index ea8072acf8d9..01c132bc33d5 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -21,6 +21,7 @@
 #include <asm/bootinfo.h>
 #include <asm/addrspace.h>
 #include <asm/prom.h>
+#include <asm/mach-ralink/ralink_regs.h>
 
 #include "common.h"
 
@@ -81,7 +82,8 @@ static int __init plat_of_setup(void)
 	__dt_register_buses(soc_info.compatible, "palmbus");
 
 	/* make sure that the reset controller is setup early */
-	ralink_rst_init();
+	if (ralink_soc != MT762X_SOC_MT7621AT)
+		ralink_rst_init();
 
 	return 0;
 }
-- 
2.35.1



