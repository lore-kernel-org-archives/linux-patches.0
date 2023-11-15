Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A33E3A8F7
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMYpHmlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29256C433C9;
	Wed, 15 Nov 2023 19:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078109;
	bh=qRa0GdpTMFbqsliEcWAeID04F9gR6CIYY9D7RbiOB6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMYpHmlIg+RbPNJeSKR+ceFvi5SLeL18QV7rXhUDwGLI3BTSmQ9mbKyJJx60ZefMF
	 eGIWbhncOXCIgvG4PGrzdIaMFjqc089ouc4uQOhG9BDXniaJua76f4cVF3TLxe363n
	 QH8y/k0ODL/gmAby8Xtt+KO7cMM+UwAsqq1A9ucA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/379] clk: renesas: rzg2l: Trust value returned by hardware
Date: Wed, 15 Nov 2023 14:22:45 -0500
Message-ID: <20231115192650.455683641@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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
index a703a3b35e642..f2fc14f60ca0b 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -242,14 +242,8 @@ static u8 rzg2l_cpg_sd_clk_mux_get_parent(struct clk_hw *hw)
 
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



