Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B30415F14;
	Tue, 21 Jul 2026 19:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661832; cv=none; b=VrYTl9aPQ17cArBftOk+eBfGGjeFZLXAxLvm9P8Yk4jwJEZnseSDzuhaXVRWhKaAJPEfFr7fk7CGIDhJtxd4yHodyUaWKcK2r9oFglIpHqccWoDwBSZe5Ad1HwK89pfa+zBe4xfj2R7zTUsMvTHj+HpLNNLgk7IWh+uZO3ogzb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661832; c=relaxed/simple;
	bh=fFuhPJayTlCX6quHtctXPVBTaSJi5TPGEJDskPvprFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQtDwGTdPysCEnzzkn3tPsPL1b8w7VOm4iDGXBON+PWgr0epfb2/2h727clcX+v30JRGIOCahuPI87njvBqFK05X15o/0qboZtTYXcGG6OjzrMyYv0OSm9U4OfwnDQro7e9qu5x7fdozvHHGo5D0dO4a3mf7DQxTDJahIBvTrHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUgNtPfr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUgNtPfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF291F000E9;
	Tue, 21 Jul 2026 19:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661831;
	bh=xiBJxZx4iGsx4DzvzgIQ/Ux30f8dWVyE/oEKkWkGBlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUgNtPfr7zt8qgy7ObTR46lk2SsrsBFC48S+7gb6mzNSkyrMWbuCvenFWMD9iEtWM
	 yWDEBofZPf5CP2Kfwg1nWmbjVyYp96xqPJ5cvHFFeFcJPe+FXp4vv1zeckt8KPDVrk
	 9I5PUkJGtcwD8LTRDABiAFz1hlCVWEnGNfiVxH/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0214/1276] ARM: imx31: Fix IIM mapping leak in revision check
Date: Tue, 21 Jul 2026 17:10:57 +0200
Message-ID: <20260721152450.874408886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



