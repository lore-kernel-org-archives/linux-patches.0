Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2882FB978;
	Mon, 13 Oct 2025 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368950; cv=none; b=PzW0kuHWs639djkhuOQcC5ZGSF/ArN9CWgFpT+BtVKaDzbKp7GbiKKerAyPH8Se2DFzC7/GcykKdTraoSaEmul31MhPrcXe0xVAONDNBFLIM94zKdSvnTOa1FYy0T8luxoffS5tW4NUfFRTVn4LHY4w2Q9fvIxqQj0prIq9wOIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368950; c=relaxed/simple;
	bh=gQXrBGSfxiGx4zZlOcmvDV4LN+J9K8kNmvmen4pdA6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsK6AIhk4GgqeIxDxLKc5aX5siuFHI7xjcSPhlXhTKfihhOLYDhChCrXyWX9eSG+DKc3yAHBNInW23c3cjSxvn/u1KoOVYmF5kQGh3+LojT5WC97C71zh3mPNvx2hZretH0X5LquY+Y2+HKt/sp6N+/JrxqgkzvkASfelTuCUtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itG6dPrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itG6dPrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D741CC4CEFE;
	Mon, 13 Oct 2025 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368950;
	bh=gQXrBGSfxiGx4zZlOcmvDV4LN+J9K8kNmvmen4pdA6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itG6dPrsXtraIZjp0uY8rLaCRsxtk4ABHaUizAgF04u6mwM0KWSPfa7mqmN7E3XCi
	 W3jtwpYEIXpUOMbFGv5UdBAY7YleuAaBY8SEZjbSIPEPrLKyXZSVyPM/6tBgP6YkXX
	 1YvDRag6LfGbGV7l1EafysOpuR9aOSLspSofho9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 075/563] ARM: at91: pm: fix MCKx restore routine
Date: Mon, 13 Oct 2025 16:38:56 +0200
Message-ID: <20251013144414.010002627@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

[ Upstream commit 296302d3d81360e09fa956e9be9edc8223b69a12 ]

The at91_mckx_ps_restore() assembly function is responsible for setting
back MCKx system bus clocks after exiting low power modes.

Fix a typo and use tmp3 variable instead of tmp2 to correctly set MCKx
to previously saved state.
Tmp2 was used without the needed changes in CSS and DIV. Moreover the
required bit 7, telling that MCR register's content is to be changed
(CMD/write), was not set.

Fix function comment to match tmp variables actually used.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Fixes: 28eb1d40fe57 ("ARM: at91: pm: add support for MCK1..4 save/restore for ulp modes")
Link: https://lore.kernel.org/r/20250827145427.46819-3-nicolas.ferre@microchip.com
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
[claudiu.beznea: s/sate/state in commit description]
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm_suspend.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index e23b868340965..7e6c94f8edeef 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -904,7 +904,7 @@ e_done:
 /**
  * at91_mckx_ps_restore: restore MCKx settings
  *
- * Side effects: overwrites tmp1, tmp2
+ * Side effects: overwrites tmp1, tmp2 and tmp3
  */
 .macro at91_mckx_ps_restore
 #ifdef CONFIG_SOC_SAMA7
@@ -980,7 +980,7 @@ r_ps:
 	bic	tmp3, tmp3, #AT91_PMC_MCR_V2_ID_MSK
 	orr	tmp3, tmp3, tmp1
 	orr	tmp3, tmp3, #AT91_PMC_MCR_V2_CMD
-	str	tmp2, [pmc, #AT91_PMC_MCR_V2]
+	str	tmp3, [pmc, #AT91_PMC_MCR_V2]
 
 	wait_mckrdy tmp1
 
-- 
2.51.0



