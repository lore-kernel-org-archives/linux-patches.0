Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6DA333443;
	Tue, 11 Nov 2025 01:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824554; cv=none; b=EG9O8K5fhscYq8SqDo/2J2UY+bzNRYwfYrwGujJxyBIyKKFtTTOdzoqylP7stnigyU/3R/ARFe8z8FsdzAgyc12YJbUlMTb5nKy/na1kD+8/cyhTh6ugVxrZ7czLEXqILLIbM4N1tYOy7eICKZ52uHI/YY19kksndcPAjAKA3H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824554; c=relaxed/simple;
	bh=1ZS5WDExK27thcnymUTqHvAS+2whPudeKzdsfcEBUA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUHgEZ9AlFD/r3zUvhIKKF7jKqQMUrHJpAHUAU3tWBOrm9seZMO0cRSzNge2xzkWmJx5roJzYBWQp2GB1pFeR6okMghOFUFLpAQHQf4C0XuVShidkhjAJF/k6xnaY/1invUyivrQ+vh3jU82lg8PQ1osFMR+e0Gss065vsD3BLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNH62QZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNH62QZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09ABC116B1;
	Tue, 11 Nov 2025 01:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824554;
	bh=1ZS5WDExK27thcnymUTqHvAS+2whPudeKzdsfcEBUA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNH62QZxlA0/sEh/3EtTv4pA0wa0v3jYm1kC3iZfGdP7Ta4fvBJ98RtFoHtcBYg/x
	 S+kRa/oLieO5LdRl238101g9OKx2+E9uNaB7pIZt0JM+4jKAZRx1OA9U+rcpqBdaMH
	 s36vjqNbQ2beZlB291eC5BnEHqjpfWtEoYUrypVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Cristian Birsan <cristian.birsan@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 468/565] ARM: at91: pm: save and restore ACR during PLL disable/enable
Date: Tue, 11 Nov 2025 09:45:24 +0900
Message-ID: <20251111004537.431382915@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 0c01fe49651d387776abed6a28541e80c8a93319 ]

Add a new word in assembly to store ACR value during the calls
to at91_plla_disable/at91_plla_enable macros and use it.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
[cristian.birsan@microchip.com: remove ACR_DEFAULT_PLLA loading]
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Link: https://lore.kernel.org/r/20250827145427.46819-4-nicolas.ferre@microchip.com
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm_suspend.S | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index 94dece1839af3..99aaf5cf89696 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -689,6 +689,10 @@ sr_dis_exit:
 	bic	tmp2, tmp2, #AT91_PMC_PLL_UPDT_ID
 	str	tmp2, [pmc, #AT91_PMC_PLL_UPDT]
 
+	/* save acr */
+	ldr	tmp2, [pmc, #AT91_PMC_PLL_ACR]
+	str	tmp2, .saved_acr
+
 	/* save div. */
 	mov	tmp1, #0
 	ldr	tmp2, [pmc, #AT91_PMC_PLL_CTRL0]
@@ -758,7 +762,7 @@ sr_dis_exit:
 	str	tmp1, [pmc, #AT91_PMC_PLL_UPDT]
 
 	/* step 2. */
-	ldr	tmp1, =AT91_PMC_PLL_ACR_DEFAULT_PLLA
+	ldr	tmp1, .saved_acr
 	str	tmp1, [pmc, #AT91_PMC_PLL_ACR]
 
 	/* step 3. */
@@ -1134,6 +1138,8 @@ ENDPROC(at91_pm_suspend_in_sram)
 	.word 0
 .saved_mckr:
 	.word 0
+.saved_acr:
+	.word 0
 .saved_pllar:
 	.word 0
 .saved_sam9_lpr:
-- 
2.51.0



