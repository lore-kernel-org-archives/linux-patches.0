Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2732FE564;
	Mon, 13 Oct 2025 15:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368171; cv=none; b=qVr5f7Mcq+tkcqywROpVT/GwinCXUyzF34Jl3uxN84qeMJbJejMkPkv+9tacjzVBas8sc5i/BTtplDJ40aXY2Lwpqzq+fhTZ49LWG9rc7cveIa/MhOfQSHEHJwt6GsR+BQK4hn/fMEIIcfbTq8d2nPLvndfi/eS6gZIswrwF+VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368171; c=relaxed/simple;
	bh=kFsh0v7+q5yIQ+MKCUVGt/aWmJctvj5YazU91yaTzYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZJM3IXHrttSrD4194yTbd3E4fWac9bRkP0r/eeJJjb85x5joIbm1FZ8goskGiomKL6TzjY5m0ZIoro7YPvDe2MxAtOc8KvB9hyasPfmr6RwLsvJKLmNZGJpzf9q0s+uv/WkcEpcVDuVpTFSTHBfAs8vSrhlHPXZXTQ6eUjLVGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7ZlWCr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7ZlWCr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ECEC4CEE7;
	Mon, 13 Oct 2025 15:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368170;
	bh=kFsh0v7+q5yIQ+MKCUVGt/aWmJctvj5YazU91yaTzYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7ZlWCr3db2SGsSKO1QHNdhvzZfPj0BsycgEWoIEJpvFSyo/NNnQ2O3dtjKFcdZS1
	 rRK7uJ5RT2cJ68WOQarcCKiVOs355f8lieuW2W0KDRILOVSq9rjKhDYQMoXWhEb7qD
	 gEme535PUNXwNR01eTIComb/RsclrGWxSbHC5EIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/262] ARM: at91: pm: fix MCKx restore routine
Date: Mon, 13 Oct 2025 16:42:57 +0200
Message-ID: <20251013144327.396572571@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index e5869cca5e791..94dece1839af3 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -872,7 +872,7 @@ e_done:
 /**
  * at91_mckx_ps_restore: restore MCK1..4 settings
  *
- * Side effects: overwrites tmp1, tmp2
+ * Side effects: overwrites tmp1, tmp2 and tmp3
  */
 .macro at91_mckx_ps_restore
 #ifdef CONFIG_SOC_SAMA7
@@ -916,7 +916,7 @@ r_ps:
 	bic	tmp3, tmp3, #AT91_PMC_MCR_V2_ID_MSK
 	orr	tmp3, tmp3, tmp1
 	orr	tmp3, tmp3, #AT91_PMC_MCR_V2_CMD
-	str	tmp2, [pmc, #AT91_PMC_MCR_V2]
+	str	tmp3, [pmc, #AT91_PMC_MCR_V2]
 
 	wait_mckrdy tmp1
 
-- 
2.51.0



