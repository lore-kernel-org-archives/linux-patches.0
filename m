Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEBF367B92;
	Tue, 21 Jul 2026 22:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673610; cv=none; b=i73AXZ3t1kN9ah7Syra9Jb9mjlvT2b8Q5CT4Ny+MxSY/X8edmj1n3IkgduZBGPReMrcDWviBXx5049cweklK8NwA7h/E2GmIkrE+d3UewHS0WowI1PqmrMvIV+OZkPsrrpwGqdCenHZR4lUTrkd7I1S3M4WUxXp+aW4ByZJNDRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673610; c=relaxed/simple;
	bh=Py7ysGZP7BrMbQOvWBo9D0VZqOROeb9tv/KtVFI2ojc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKMwmJDxnZ6OAMxXSwDC6I9JfxApsWsroFy0D6Ys5QeiPOYkWb4sG9h0LQpjS4xg4NQh/R7Ph6iEhgmCzZbFRazP7dazmrA2+DJOOd6GInbl2Iu4KRCAPlQs7jGbVTPdoaCzeb3pQS1tY5y5kOyl9jL1p8MX5lRKgPE6UsuvLRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFsx2sA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFsx2sA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09FD1F000E9;
	Tue, 21 Jul 2026 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673609;
	bh=iQFzK4qc7uhse574MapjHk57joOyqc6Ht7k2pSUHY18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFsx2sA12oIc7uYHAimPp3UaX0Moqz4rxqmHBvcD9pPgHVAmX/wUfnyvbchQsXhdM
	 Of3oxfVKCoVhQVYLCua+9+WUg/sK9v8ACxakpnMmR0XxHUchyrI0QETg3lupuzmEnd
	 XmN2lRsUEhdGSuxMLBITad0yl0ipxRZqySvrtCg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/699] ARM: imx31: Fix IIM mapping leak in revision check
Date: Tue, 21 Jul 2026 17:19:39 +0200
Message-ID: <20260721152400.663340555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



