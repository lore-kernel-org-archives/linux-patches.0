Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5823BE141;
	Sat, 12 Sep 2026 07:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196989; cv=none; b=JBHnfGcMrPEMfBLCL5YnLVml+dC8OgwCcDL4UvPi9qnEa0/zlEKw3C8up5HTdu5nogeHUEMIjsRzKknYZIFqHRdWe1bZElPqRI2wq7F66PV+6VdVdLHlM8fapFQaOcQqNuoMA7mXHRooSKIHJET0uyq4ZHODJ3ulwodxD2shzZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196989; c=relaxed/simple;
	bh=GdAi13wHyaS32inI5M2ZM9vRLGgOxlkHldJ1MIpMPiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdaPFlt7KYLt2p15PoG+SMkfkyYrYP0oR3pUxSGUK1Nnc+EPWLZuPlAk/5t6whMGYIezCU3PdReItAyRkJNPmbzyqwKGbeI8XtQgHiib6AK4klpRMaSAGbq4m1Ev1uYxEmXswTZ3Z26PtNGpJuPoaThnUazkqDbury9RgBrxUYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4D490T0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4D490T0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ADF1F000FF;
	Sat, 12 Sep 2026 07:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196987;
	bh=04puTAVnwiYmRHKc91SyPGdjrPOGBxqOszcOiq88Ink=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4D490T0s1wTFum4KtbQ7lDpIndvYwakmLfhw58jTEwd5vcus1ZRiFc1SfKlp8uNN
	 AQ7uAgsNZxXxFl9X9c6h1pk+QF7Y7dCHSNjnd7nQxWKeZlKxYx6gUOvKN2P+GGvUMN
	 g/U8WMvXaJPbc40M6IVpq7PAysADCRp55Ptyj+x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Martin Kaiser <martin@kaiser.cx>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0077/1815] ARM: imx: avic: Fix OF node reference leaks
Date: Sat, 12 Sep 2026 08:30:27 +0200
Message-ID: <20260912065650.820205131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit b24c12e1bad863d27141e4e9c19d25eebd68c4a6 ]

of_find_compatible_node() returns a device node with its reference count
incremented. mxc_init_irq() looks up the i.MX25 CCM node for of_iomap()
and the AVIC node for irq_domain_create_legacy(), but does not release
either temporary reference.

of_iomap() does not consume the node reference, and
irq_domain_create_legacy() takes its own fwnode reference for the domain.
Drop the temporary OF node references after each use.

Fixes: 9b454d16e57d ("ARM: imx: avic: set low-power interrupt mask for imx25")
Fixes: 544496ab5cbd ("ARM: imx: move irq_domain_add_legacy call into avic driver")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/avic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-imx/avic.c b/arch/arm/mach-imx/avic.c
index 3067c06b4b8eb..6873a50bbe2c0 100644
--- a/arch/arm/mach-imx/avic.c
+++ b/arch/arm/mach-imx/avic.c
@@ -173,6 +173,7 @@ static void __init mxc_init_irq(void __iomem *irqbase)
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx25-ccm");
 	mx25_ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 
 	if (mx25_ccm_base) {
 		/*
@@ -203,6 +204,7 @@ static void __init mxc_init_irq(void __iomem *irqbase)
 	np = of_find_compatible_node(NULL, NULL, "fsl,avic");
 	domain = irq_domain_create_legacy(of_fwnode_handle(np), AVIC_NUM_IRQS, irq_base, 0,
 					  &irq_domain_simple_ops, NULL);
+	of_node_put(np);
 	WARN_ON(!domain);
 
 	for (i = 0; i < AVIC_NUM_IRQS / 32; i++, irq_base += 32)
-- 
2.53.0



