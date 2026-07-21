Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642284D90D6;
	Tue, 21 Jul 2026 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649127; cv=none; b=DzK2QfqT03GcMbSf8t/n85sypImDybMbDprUJ7rxgr8+x8hb2ic/ksnIywjNtxO63LG6MJCVVc5EOm+8YosGzI9+WSUUKISDkmvJvZvMghgb54MeoQwqnygoHli2LMzuLcE4X0WOK6sUambv4lcEiP6qb81gNmgqcdz42tvDvEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649127; c=relaxed/simple;
	bh=57l3EEtfyslBOeNBhiY8nzOTsi9/x0xGepqreu06d/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBoGFgWPNPUP5SLZ+ppqlMa1r1Ciqr9sW5Ou4Fm8aPBl/95/rsrvd2x+FF4qTHGM5+4QfGda9epladcB3CiqjT10DEmlS4oI2b9FmHQIJFOblCHkPy2v0mZ68i2L1bjGlCqML29zgygT67kL3E+BBEZCkkgKSU2+yqo1lwHxZi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CvFb056; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CvFb056"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0281F000E9;
	Tue, 21 Jul 2026 15:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649126;
	bh=rf5G+qyDwIJrkN7Y4pqT6NFhb/v+UKv0SqG8kA/JMDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1CvFb056CVQvfGQoCOA7xGJksjtlqGNbJgDt/QVaMj8lZ9EZnIXjgFBV+vXd8Wqbc
	 QeTm2TIfLRZhEbqlzHlDzRIzDjh+jlnbHMhcpgRGpOBPCYIQKgczaTLZjbo4w9RAzw
	 XRrWFukkfch6P6Gi9ppkurpNPTiPnGDZGf92W5RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0416/2077] ARM: imx3: Fix CCM node reference leak
Date: Tue, 21 Jul 2026 17:01:29 +0200
Message-ID: <20260721152602.547043789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0788c5cc7f9e64..9b0b014d7fe276 100644
--- a/arch/arm/mach-imx/mm-imx3.c
+++ b/arch/arm/mach-imx/mm-imx3.c
@@ -106,6 +106,7 @@ void __init imx31_init_early(void)
 	arm_pm_idle = imx31_idle;
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx31-ccm");
 	mx3_ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!mx3_ccm_base);
 }
 #endif /* ifdef CONFIG_SOC_IMX31 */
@@ -143,6 +144,7 @@ void __init imx35_init_early(void)
 	arch_ioremap_caller = imx3_ioremap_caller;
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx35-ccm");
 	mx3_ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!mx3_ccm_base);
 }
 #endif /* ifdef CONFIG_SOC_IMX35 */
-- 
2.53.0



