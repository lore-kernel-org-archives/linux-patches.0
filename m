Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549B944AB7F;
	Tue, 21 Jul 2026 21:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668938; cv=none; b=MRtzj2NTcEc1XVJZPPoZukfnjMR1kBIojrlolQME0odbI5LdTPPojeh2qzrS4tyRlxWviiysRf5zvQFXu4MIOVXTMMvXBM3xEOAwLHgykQm2AIQu89SR9QYIRqpkOYUaflbIz4zId48RJTF0p++wc7cSGV8lgs1UdR4o/0AZkmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668938; c=relaxed/simple;
	bh=BmnB0lpxv6CFsLLDilDUKPBQfBKzgHsfhsYbe20IZEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scVNUQdDImp36MypPuvPIkhQUBpjk4Xeb8F2qZNDKmjz4PKCuI+wau8ZQboZEbYderfjbHDi4ejLxb6rRJOX0eMRuI5mB6+9Kxt1QArxvHqERoOwY3fjmx2E3WX6xSQ+4hNm5l0h+IlR4QppLEFBG6bgb13f8/ORYKUVF7zX4xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFhw5kfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFhw5kfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8662F1F000E9;
	Tue, 21 Jul 2026 21:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668937;
	bh=qElD4DxMncGf+zzWihZSe8sXjlW6qgFxUsBJm6DIzfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFhw5kfbC0u8ZjDa8UrN6Dc45FebBOlF2e/HgguJrVjbSRDKrjdSBsZ7IFHW0GLw4
	 1VjgTzk/yFJvpY6qJC6TnZI6fRuS6AKuLQPGtssubhfg5RgE7hQ/ags5wFqvF0m6u0
	 bkop/TN5/eS64XHYrVngiL//KOie8R5Sugp1Lm28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0364/1067] ARM: imx3: Fix CCM node reference leak
Date: Tue, 21 Jul 2026 17:16:05 +0200
Message-ID: <20260721152432.761243590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



