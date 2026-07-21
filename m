Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46A73B9930;
	Tue, 21 Jul 2026 22:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671546; cv=none; b=PoSAzYwabEMSwVqLE9Cr9Ed2f78NyD65hegnnLNwtxiwnugrjxoW29wmiYFADpABkl45PJcgiTzoYvduM+0t3Aqs1mG+gL5imlGpuGgeGZyO9tnizBZ2AhCnzfTKhyYsajpP1mwej4M8P4uc2s3z4A03mOnLBmhj9F8bsOIjdWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671546; c=relaxed/simple;
	bh=U/maiAw3VQswtMjQMZZmg8A31xd9jigob0SWHnO6L98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZvTRR2Iz7Ek3f/ujSuypaL6u1g+RNjEaay7LQEtesxRnvDFvnY5wP9t4Q2GmMI5ILN5/ExJgLgPbpNM282hSUkVnOBZVoNZ2qYYiCd1MMxdL0gDekPwcLh5UhRBwKEzyrl6Oq3SGTG7N2TkV0cDb6llcqvzVB7Qc9Q54wRgUfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/LG4TYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/LG4TYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250531F000E9;
	Tue, 21 Jul 2026 22:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671545;
	bh=O57rY3SqZ4jpZsroXgvnNIoMymU2NyKen5ZIlRdP+7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/LG4TYYU1Yv+/uFZOBUfh+6f5Vvb2RXVL6IHMhEF6il+ZxTfc/tThEWBJOVbMBiV
	 qZN3sHkjxHPaxdFs4XioAR6iwbjpRsgUNxzumXbxJm3RLhRVeP0VYS7g5n9sGeQGuE
	 WIm6zp4558UtfgSkjYhyjZUeZhkc6evrqk4sAg3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 287/843] ARM: imx31: Fix IIM mapping leak in revision check
Date: Tue, 21 Jul 2026 17:18:42 +0200
Message-ID: <20260721152412.485905891@linuxfoundation.org>
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

[ Upstream commit ccb4b54b8ecf1ebafef96d538cd6c5c8455bb390 ]

mx31_read_cpu_rev() maps the IIM registers with of_iomap() to read the
silicon revision, but returns without unmapping the MMIO mapping.

Keep the normalized revision value in a local variable and route the
return path through iounmap() after the revision register has been read.

Fixes: 3172225d45bd ("ARM: imx31: Retrieve the IIM base address from devicetree")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/cpu-imx31.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/cpu-imx31.c b/arch/arm/mach-imx/cpu-imx31.c
index 35c544924e5095..e81ef9e36a1fab 100644
--- a/arch/arm/mach-imx/cpu-imx31.c
+++ b/arch/arm/mach-imx/cpu-imx31.c
@@ -36,6 +36,7 @@ static int mx31_read_cpu_rev(void)
 	void __iomem *iim_base;
 	struct device_node *np;
 	u32 i, srev;
+	int rev = IMX_CHIP_REVISION_UNKNOWN;
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx31-iim");
 	iim_base = of_iomap(np, 0);
@@ -48,13 +49,17 @@ static int mx31_read_cpu_rev(void)
 
 	for (i = 0; i < ARRAY_SIZE(mx31_cpu_type); i++)
 		if (srev == mx31_cpu_type[i].srev) {
+			rev = mx31_cpu_type[i].rev;
 			imx_print_silicon_rev(mx31_cpu_type[i].name,
 						mx31_cpu_type[i].rev);
-			return mx31_cpu_type[i].rev;
+			goto out;
 		}
 
 	imx_print_silicon_rev("i.MX31", IMX_CHIP_REVISION_UNKNOWN);
-	return IMX_CHIP_REVISION_UNKNOWN;
+
+out:
+	iounmap(iim_base);
+	return rev;
 }
 
 int mx31_revision(void)
-- 
2.53.0



