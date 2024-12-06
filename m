Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3227B13E03A;
	Fri,  6 Dec 2024 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497533; cv=none; b=NmT9B0Cc9830DHzR41VOXs3JPI/ZyasR+N3aRv32EHtD+eSY8J6PHSiG1VY6e+gZbe/exYMZ6wCBFgNnxuiNsTVld/C6T+XS1CtNEIdHvocLaGJDBKNbQ5nVg9i64IDTiFXRUBf87dSU8AUSWKJt3uZY+92628UrL5JYGpxMPWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497533; c=relaxed/simple;
	bh=x/npLsWmy2YnR1ZuSLgPPDcwMhQteV1I4ch/xdUOrd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7wWBj2/uHIe9NHCsUZa8XA1t69p2VuB1LvVQr5Sp2g+Gwno2Wkp90OnPaU09O6uDVWN9aIRlaVU0+8Rpm7fr/DsK9eGjUVfnrhPl9gjy0cClqjXFDKPTUy/kCe33zew08g+XO5d5FI5XqPD8J4CEa1PjNt0G2ohr2BtPojnGLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sz/PKg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sz/PKg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920C8C4CED1;
	Fri,  6 Dec 2024 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497533;
	bh=x/npLsWmy2YnR1ZuSLgPPDcwMhQteV1I4ch/xdUOrd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sz/PKg86s1RhvnaOdVOhdMZSIREB3TwfUxA2lhRCKasT9VGm4cg6itl5O/cb3hrJ
	 DUYU6BJZYLAUJUCcsjX8zrI18GhJgSC2aBuVWpu56Y6vrUq2pyKDX76LKvjNX4P/Og
	 EWeIIjYymkoXW8qMGrwdiXSPsbSedUwVPDBa+zBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hien Huynh <hien.huynh.px@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/676] clk: renesas: rzg2l: Fix FOUTPOSTDIV clk
Date: Fri,  6 Dec 2024 15:31:46 +0100
Message-ID: <20241206143704.551141575@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit dabf72b85f298970e86891b5218459c17b57b26a ]

While computing foutpostdiv_rate, the value of params->pl5_fracin
is discarded, which results in the wrong refresh rate. Fix the formula
for computing foutpostdiv_rate.

Fixes: 1561380ee72f ("clk: renesas: rzg2l: Add FOUTPOSTDIV clk support")
Signed-off-by: Hien Huynh <hien.huynh.px@renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20241024134236.315289-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 75f9eca020ce5..f8dbb092b9f1b 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -285,7 +285,7 @@ static unsigned long
 rzg2l_cpg_get_foutpostdiv_rate(struct rzg2l_pll5_param *params,
 			       unsigned long rate)
 {
-	unsigned long foutpostdiv_rate;
+	unsigned long foutpostdiv_rate, foutvco_rate;
 
 	params->pl5_intin = rate / MEGA;
 	params->pl5_fracin = div_u64(((u64)rate % MEGA) << 24, MEGA);
@@ -294,10 +294,11 @@ rzg2l_cpg_get_foutpostdiv_rate(struct rzg2l_pll5_param *params,
 	params->pl5_postdiv2 = 1;
 	params->pl5_spread = 0x16;
 
-	foutpostdiv_rate =
-		EXTAL_FREQ_IN_MEGA_HZ * MEGA / params->pl5_refdiv *
-		((((params->pl5_intin << 24) + params->pl5_fracin)) >> 24) /
-		(params->pl5_postdiv1 * params->pl5_postdiv2);
+	foutvco_rate = div_u64(mul_u32_u32(EXTAL_FREQ_IN_MEGA_HZ * MEGA,
+					   (params->pl5_intin << 24) + params->pl5_fracin),
+			       params->pl5_refdiv) >> 24;
+	foutpostdiv_rate = DIV_ROUND_CLOSEST_ULL(foutvco_rate,
+						 params->pl5_postdiv1 * params->pl5_postdiv2);
 
 	return foutpostdiv_rate;
 }
-- 
2.43.0



