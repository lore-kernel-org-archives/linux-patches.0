Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDBA3BE175;
	Sat, 12 Sep 2026 07:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197023; cv=none; b=F5yt6JaS0v7FHrmtiHo91KDGLqCzD6hA/aMQULvW2tqWlSltkKZImbEgtjLo/Y0s8f8Pd2b1b+7uailt1oXhys8diUJesa5bxyxNbQlNh2z/ZC2jaiOQTXFtaK0zmVk0MXSvZFUHxQteu2Ov/RncUqCsgIUA75FiQsZyXGqRO34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197023; c=relaxed/simple;
	bh=iZSoM/HbNxYjCLpyLV5Tj3PRBuZOvoqYjgi4tDSzZZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7iezt3CT9uklbbrmq2uTpglC9ahevaolrw6BAWYmHESHS7kBH2YhfzInkZ6RLbGyhtOKm9j/qyaZaezxCfPqztyUCSJVOIF4SLA4pNsTEqf+n45pF9jMrPWeIHRlFomigQROdLwwBrsDHcza7xgFg4G9B0obORyKyxnmRmpcpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fH7MiKpN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fH7MiKpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D1D1F000FF;
	Sat, 12 Sep 2026 07:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197022;
	bh=zyR5IK7i/NkWhFXzEyM8oWzTzg5hEDAr2R6KcocRDsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fH7MiKpNeKtcq1dVRK46gdEgp/SdX6Iwz+tanbnuiKnx0QHHlvb/kljMf2dBo4Doc
	 viyHAzIpSmH/zHBnfFmLAbSF8eOnhq6YpyS3rinGhfNbxXxCPTsVNVQgy3nSBMSL7K
	 hiix0vuqkDRmtMW81UmBg9Sc4FXBxQFbeissXhes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joey Lu <a0987203069@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0083/1815] clk: nuvoton: ma35d1: fix PLL_CTL1_FRAC bit field width and fractional calc
Date: Sat, 12 Sep 2026 08:30:33 +0200
Message-ID: <20260912065650.955975490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joey Lu <a0987203069@gmail.com>

[ Upstream commit 26de5aed72d80bd8aec2583134aca3597c64fda9 ]

PLL_CTL1_FRAC was defined as GENMASK(31, 24), covering only 8 bits.
The hardware fractional field occupies bits [31:8] (24 bits), so the
mask must be GENMASK(31, 8).

The previous fractional-mode calculation used FIELD_MAX(PLL_CTL1_FRAC)
as the denominator to obtain 2 decimal places.  With the corrected 24-bit
mask the old divisor is wrong; replace the arithmetic with a proper
24-bit fixed-point rounding to 3 decimal places using the kernel's
DIV_ROUND_CLOSEST_ULL helper:

  n_frac = n * 1000 + DIV_ROUND_CLOSEST_ULL(x * 1000, 1 << 24)

Fixes: 691521a367cf ("clk: nuvoton: Add clock driver for ma35d1 clock controller")
Signed-off-by: Joey Lu <a0987203069@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nuvoton/clk-ma35d1-pll.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/nuvoton/clk-ma35d1-pll.c b/drivers/clk/nuvoton/clk-ma35d1-pll.c
index bfedd45bd04b7..eb9d69d2077b1 100644
--- a/drivers/clk/nuvoton/clk-ma35d1-pll.c
+++ b/drivers/clk/nuvoton/clk-ma35d1-pll.c
@@ -48,7 +48,7 @@
 #define PLL_CTL1_PD		BIT(0)
 #define PLL_CTL1_BP		BIT(1)
 #define PLL_CTL1_OUTDIV		GENMASK(6, 4)
-#define PLL_CTL1_FRAC		GENMASK(31, 24)
+#define PLL_CTL1_FRAC		GENMASK(31, 8)
 #define PLL_CTL2_SLOPE		GENMASK(23, 0)
 
 #define INDIV_MIN		1
@@ -113,9 +113,9 @@ static unsigned long ma35d1_calc_pll_freq(u8 mode, u32 *reg_ctl, unsigned long p
 		pll_freq = div_u64(pll_freq, m * p);
 	} else {
 		x = FIELD_GET(PLL_CTL1_FRAC, reg_ctl[1]);
-		/* 2 decimal places floating to integer (ex. 1.23 to 123) */
-		n = n * 100 + ((x * 100) / FIELD_MAX(PLL_CTL1_FRAC));
-		pll_freq = div_u64(parent_rate * n, 100 * m * p);
+		/* convert 24-bit fraction to 3 decimal digits, rounding to closest */
+		n = n * 1000 + DIV_ROUND_CLOSEST_ULL((u64)x * 1000, 1ULL << 24);
+		pll_freq = div_u64((u64)parent_rate * n, 1000 * m * p);
 	}
 	return pll_freq;
 }
-- 
2.53.0



