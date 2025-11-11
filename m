Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AACC26561D;
	Tue, 11 Nov 2025 01:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825205; cv=none; b=mSUmrTf/xKAGSa/ttTyrJ3XCywreS7Ip3+hmMuVk7ON9SGXQAoaqn7AvD7rsIrVy2CPR14PqHEKXJTSsSqSNXXM5uMr8H9mvjexqdGeUF09pEyhuHHBi40iHFXkSlAr04m1YDLJ13Bb3BxwjKK3b+zpqPbGAnhKG49UdWEMD1y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825205; c=relaxed/simple;
	bh=INsWlxbGHftrGwqnYtRfCB/futVZSpFXCj5l9FOy1X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfNNWZ1ap2/2Uin05088pG98UYre55okdxwPTWo4nLw91QTpg+av45CcYbtblHwIJ+tyWAjUBAd1LM5Wi8GuS93jJ3N66wh9VKbWk7NZaCav/WzQdYQA2RNg7hVvQNxycb8o6LIYyfCc5Ea+fwIq6R5PWiB0Fsl8DSheFcqDnQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jojVACfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jojVACfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF87C4CEFB;
	Tue, 11 Nov 2025 01:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825204;
	bh=INsWlxbGHftrGwqnYtRfCB/futVZSpFXCj5l9FOy1X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jojVACfegnJTmOuojmd5THbLV6iwzRJ5tbtA+JdOIpP1+LniJfFDvLT8RtmhrhfbM
	 i74naWdT21TYwJ3+oONMg1gz8NJ7SEb9d/3cRatkc3F0iebDbQE2cr1YuERSrKyAgu
	 a7EwHBBtXf/apvI5N1AAaARgDr5tg+uP9GqFh+vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Cristian Birsan <cristian.birsan@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 703/849] ARM: at91: pm: save and restore ACR during PLL disable/enable
Date: Tue, 11 Nov 2025 09:44:33 +0900
Message-ID: <20251111004553.430965021@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 7e6c94f8edeef..aad53ec9e957b 100644
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
@@ -1207,6 +1211,8 @@ ENDPROC(at91_pm_suspend_in_sram)
 #endif
 .saved_mckr:
 	.word 0
+.saved_acr:
+	.word 0
 .saved_pllar:
 	.word 0
 .saved_sam9_lpr:
-- 
2.51.0



