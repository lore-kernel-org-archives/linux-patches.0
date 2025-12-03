Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DB7303A3D;
	Wed,  3 Dec 2025 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776324; cv=none; b=Ltk5B/+jBayDpa7LbnhIFcEb+tBigetZVSt3PSX6mVfoAr/5hG5JXNIVnHdx6V2fFH2dB+tLgjAYEdE9JU+4JPQ9O+kqY6KkV6JSS7+NzgeuSNHeWGNfjHgeogermSMeA7QWCUtx3yHgeW9EG176ZVdoMkuhmWtMk6mV37LHKV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776324; c=relaxed/simple;
	bh=OB8yzuLl1tcK+cqwFWFxlIeA7zIdAXTnJJmi1cRbems=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yoql5OeDawGA0P4MNZM1wNrhGOV0V7At49OuCr97s2I3gM9hJqqbGbqyPDeeaWjk21Y9YSXDijego29v1TcoZ4Mp61W9VcvgXN7eck72GrZMyZj2Qvy2TKMjX2blcZYTvztoLVSSY6c3JciKFUwa45y0YAGCvxXNkjekUwA1Dx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMvJM9Di; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMvJM9Di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB18C4CEF5;
	Wed,  3 Dec 2025 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776324;
	bh=OB8yzuLl1tcK+cqwFWFxlIeA7zIdAXTnJJmi1cRbems=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMvJM9DiDqAJQX4wKxFs3VGmEeLsJWussH/7UNAEhrS+dIf72qjCSWHk7qOvriR/A
	 Ch8vdF0gzvBenk0OA/btOQG8gOTOioJAzI7BQweHxf5/976Ibsqmv3NuWWCUAnUyHW
	 chs01R9nnGS/sGMrioU8LXJzUTmxfbDgojKC5v74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Cristian Birsan <cristian.birsan@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/300] ARM: at91: pm: save and restore ACR during PLL disable/enable
Date: Wed,  3 Dec 2025 16:25:53 +0100
Message-ID: <20251203152406.137569309@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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
index b683c2caa40b9..80494afb28a33 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -373,6 +373,10 @@ ENDPROC(at91_backup_mode)
 	bic	tmp2, tmp2, #AT91_PMC_PLL_UPDT_ID
 	str	tmp2, [pmc, #AT91_PMC_PLL_UPDT]
 
+	/* save acr */
+	ldr	tmp2, [pmc, #AT91_PMC_PLL_ACR]
+	str	tmp2, .saved_acr
+
 	/* save div. */
 	mov	tmp1, #0
 	ldr	tmp2, [pmc, #AT91_PMC_PLL_CTRL0]
@@ -442,7 +446,7 @@ ENDPROC(at91_backup_mode)
 	str	tmp1, [pmc, #AT91_PMC_PLL_UPDT]
 
 	/* step 2. */
-	ldr	tmp1, =AT91_PMC_PLL_ACR_DEFAULT_PLLA
+	ldr	tmp1, .saved_acr
 	str	tmp1, [pmc, #AT91_PMC_PLL_ACR]
 
 	/* step 3. */
@@ -694,6 +698,8 @@ ENDPROC(at91_sramc_self_refresh)
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



