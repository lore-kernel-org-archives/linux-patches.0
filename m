Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78184223E7F;
	Thu, 12 Dec 2024 16:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019641; cv=none; b=j/oMzbQfuAFlJe3l2NO9tl9qwewu0J8IptDsysf2dmWkvuq4ut+VUYhB/uROUWWAlQ8krsp3n/U0MIcBjgmRDSGGtniZpvWV79+pkqxx6pSnXaZEJlouXKrMtF5s5FPm8pSv/mt9kdTDSEYmx+UoIQUO9B3i53I1IREhB0SJmuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019641; c=relaxed/simple;
	bh=dRTmWifHlnTHeK+WIBoNFTLy5TIkXbO6nx2ToWR7XMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQ6zedDbFhZgCWMQ+UtFYgx1C/SVjAagdX/zO59xt5TjQ0M/SFIu5KDkq46KUl2bCBmdo7rZhcKsejD+Cdt079mRHqeORLTK0CDyrllZIhFFmt01AdvSahUku0ElBg+jmt6lqNTSOJvqu18xyUUr5y0ObjF0wIrg0Sh+38Cgv7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+d5fLKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+d5fLKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE654C4CECE;
	Thu, 12 Dec 2024 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019641;
	bh=dRTmWifHlnTHeK+WIBoNFTLy5TIkXbO6nx2ToWR7XMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+d5fLKVG3MoLPn29Up/IjDBLFVo3ezeZNP1OU1CRz/7ZSIFFrendKMRtHHacQJHa
	 XbSlfHWgTtojqzYt/ihb0Q93R7AEuqfLEtdk81tLDtfUEauomj0X0cxxvwkN+POtYj
	 7jlL142W03QVQyg/O/VLhZPhuKm9FuWaaBaV9krI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hien Huynh <hien.huynh.px@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 230/772] clk: renesas: rzg2l: Fix FOUTPOSTDIV clk
Date: Thu, 12 Dec 2024 15:52:55 +0100
Message-ID: <20241212144359.421445304@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 473feb36a38f2..5617040f307c4 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -289,7 +289,7 @@ static unsigned long
 rzg2l_cpg_get_foutpostdiv_rate(struct rzg2l_pll5_param *params,
 			       unsigned long rate)
 {
-	unsigned long foutpostdiv_rate;
+	unsigned long foutpostdiv_rate, foutvco_rate;
 
 	params->pl5_intin = rate / MEGA;
 	params->pl5_fracin = div_u64(((u64)rate % MEGA) << 24, MEGA);
@@ -298,10 +298,11 @@ rzg2l_cpg_get_foutpostdiv_rate(struct rzg2l_pll5_param *params,
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



