Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D9E3B9D9D;
	Tue, 21 Jul 2026 22:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671544; cv=none; b=VKGoKAuwvjZvIAksAgVul04bEzr4g24USo+U4VciDvmdaLUiL2YO94RIpTiqBJx70WFQ8hpmunPXnDdu5EbAlm5VGpX3qBb45M/FTaA1wd2Sa8Tvi91sraZ6pJkHs0HKbaxDWD6ZQDJHL20gZpzoygmpT1A5+glzFp/4ibuZ6gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671544; c=relaxed/simple;
	bh=O4bS6txSrU5wBC9JrzCFqH7a+g1bXityqzNlzbOxBeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMpZJ+vGSoJFxKSNyQhjfsjAL/FkpFpqta+ySAvf1tfUml9k5xsXLwqF0hpyxy75CzGhBOAK7L+4Z3m+KK3q6p6bX5kri0AgvSx+CJH8AP7FIhf//ZOSZzgn4bbr2+BNzem25QYFeBOlakRlxaewiMEc7h09TmGmc4PRRIr8y3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JM45tQh9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JM45tQh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B25A1F000E9;
	Tue, 21 Jul 2026 22:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671543;
	bh=HD2lI7pVw7FpmpVr+Ad5MiViZTEWcqIm7gdidboDM+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JM45tQh9LPj3vn8R9G7y89XVEF/wqR+OKzdSkOLzMHgMR0VeNjwPrXXAolUEmIjXo
	 e50DpkYORFUC0dmw5SouBFjN67WqlJNjh7Ip+Qu4NnOhwz4wdMlQD/rmMgHa34CNdE
	 eBkg9hBT6nUCy3kPe9/lJAhsHiU6BDU/pIfgtBWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/843] ARM: imx3: Fix CCM node reference leak
Date: Tue, 21 Jul 2026 17:18:41 +0200
Message-ID: <20260721152412.463013533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 36d46348eb5fc4bc505cd2290ddd70c25fbe6bb3 ]

of_find_compatible_node() returns a referenced device node. The i.MX31
and i.MX35 early init paths use the node to map the CCM registers with
of_iomap(), but never drop the node reference.

Release the node after the mapping is created.

Fixes: 2cf98d12958c ("ARM: imx3: Retrieve the CCM base address from devicetree")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/mm-imx3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-imx/mm-imx3.c b/arch/arm/mach-imx/mm-imx3.c
index 28db97289ee8ff..d333a8fdb7319a 100644
--- a/arch/arm/mach-imx/mm-imx3.c
+++ b/arch/arm/mach-imx/mm-imx3.c
@@ -107,6 +107,7 @@ void __init imx31_init_early(void)
 	arm_pm_idle = imx31_idle;
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx31-ccm");
 	mx3_ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!mx3_ccm_base);
 }
 #endif /* ifdef CONFIG_SOC_IMX31 */
@@ -144,6 +145,7 @@ void __init imx35_init_early(void)
 	arch_ioremap_caller = imx3_ioremap_caller;
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx35-ccm");
 	mx3_ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!mx3_ccm_base);
 }
 #endif /* ifdef CONFIG_SOC_IMX35 */
-- 
2.53.0



