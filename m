Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CDF3EA6F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2yemiQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98DDC433C8;
	Wed, 15 Nov 2023 19:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076254;
	bh=A1KGLHdRUqT0CuPLLg1srXRAewXN78rBgUGbk/5dkxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2yemiQoc1Ua/fvMEwzplbrwH7uAw9ORwWkcmRRP2BQGjs9opgDv6bJ2FTGRYBHrC
	 oruY6f3N1bUJJyGLVh026/3EwGXZCBMDcPJ+0T/O3Jm8FgR2cVA0ktWLQnkHChX3LT
	 cbtgL61wiOh8q7zA0LxKu/3D0Hpme7A+1UuqId0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 166/550] clk: renesas: rzg2l: Trust value returned by hardware
Date: Wed, 15 Nov 2023 14:12:30 -0500
Message-ID: <20231115191612.220367769@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit bf51d3b2d048c312764a55d91d67a85ee5535e31 ]

The onitial value of the CPG_PL2SDHI_DSEL bits 0..1 or 4..6 is 01b.  The
hardware user's manual (r01uh0914ej0130-rzg2l-rzg2lc.pdf) specifies that
setting 0 is prohibited.  Hence rzg2l_cpg_sd_clk_mux_get_parent() should
just read CPG_PL2SDHI_DSEL, trust the value, and return the proper clock
parent index based on the value read.

Fixes: eaff33646f4cb ("clk: renesas: rzg2l: Add SDHI clk mux support")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230929053915.1530607-5-claudiu.beznea@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 7be098315899c..a0970f77c473f 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -245,14 +245,8 @@ static u8 rzg2l_cpg_sd_clk_mux_get_parent(struct clk_hw *hw)
 
 	val >>= GET_SHIFT(hwdata->conf);
 	val &= GENMASK(GET_WIDTH(hwdata->conf) - 1, 0);
-	if (val) {
-		val--;
-	} else {
-		/* Prohibited clk source, change it to 533 MHz(reset value) */
-		rzg2l_cpg_sd_clk_mux_set_parent(hw, 0);
-	}
 
-	return val;
+	return val ? val - 1 : 0;
 }
 
 static const struct clk_ops rzg2l_cpg_sd_clk_mux_ops = {
-- 
2.42.0



