Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD4338AC9A;
	Sat, 12 Sep 2026 12:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214551; cv=none; b=UptSguD/P4bJ+wY1EmFjJK2eejDY8fBmqNZf0NQeCXP6R+aresVkGzXiczyt+mdkHtSm/S3eckESCXo2x/UYNlDbrp03/yY5NJcIOwVVOtBkHSbJGkVTs2W5IMzKlmGGDePg+VTBRvApw67bqX5MPBVrm0X2vB8k/sGEgI5FVCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214551; c=relaxed/simple;
	bh=sU+ECDUUK5forbbKVOUzs4A2BltqArXUesSQLi0a+jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdolfttXUgBG2GUMYeMo2t257v3XvW7ZkHskVYSrcX2p1MKtz07HxAm0jy+lHnw+mJgaSlwIpwqQdg7BN+lYvKuYX+Unt1zttQGdWEJJwNcmKbNcxGEPw0iDPlU6dfyoItlBfz92upsU+tCOAXNc+YTkRpWRpRgccjwhloxhLno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tk6q1P0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tk6q1P0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E8C1F00898;
	Sat, 12 Sep 2026 12:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214550;
	bh=KwsFpebNVzKIE0He0wk4WoJJfWvhKy8Y4Wpg1xHe3Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tk6q1P0dzBiF/SaM7Rjom6udNFKt7GCeqlnMJ+gT5fYF7SfqMlkUTmF39hzY+RIof
	 4/0WiaUd66eCo9VvfpWtbJ6TO6qz7NQxvGjHITfKU36cthl5cs2nZaQ0+86I480IvK
	 tblxz4aoul2ops6d8i1WJV/Jt3RAM+yBb/cJdT3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joey Lu <a0987203069@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0332/1376] clk: nuvoton: ma35d1: fix PLL_CTL1_FRAC bit field width and fractional calc
Date: Sat, 12 Sep 2026 08:45:58 +0200
Message-ID: <20260912065614.948009218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 9bb18fc371d17..64f473fd770bc 100644
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



