Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F34370D47;
	Sat, 12 Sep 2026 09:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206061; cv=none; b=tCAUp0Te6iI4lio+khj6+4Pu5mJXX1ZHESUOalyk5i5M5q/dU91MqH74c/NvrJbAqxI4MlZ7G/yufvV3IZgXA6WNaZYnW+l5m+/jMtW6mX6kTJ3V9AbhzAfpoAYVl0d+ZXFezO+yt6ZwdgMmWTWvmPXw3rLtJxGVn7l7SJ7R1Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206061; c=relaxed/simple;
	bh=XOPJxAhjG9CIR56DOSb8Ersg10RmNZN6tYPz9DCGLmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR7hexWkE4H3Te2hXjNeuxM2LklJSozfEOkcKRm9BfGahPpV/xAZUwDTB8tlWnXaYvHVIAlnIIPxQYH+QKDRxIuQ/lbF1qQJdTPp71ihG8IKUGEeIbp+ER+cSu3F42pPhQ/I88YdM2bGFvZz3dAdWnAThvkEoG1r/IX/q3v3hYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0EqlmY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0EqlmY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772261F000FF;
	Sat, 12 Sep 2026 09:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206060;
	bh=7/6+RcunnGIz3NME//eQ187L+RxFjn15m3I1n7Oy6pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0EqlmY4N/l4sSE3Y6Mg+XOJRpzU7pg1VvSUKrBKfr1hZZ1aB307o7CG4o/SEe7i/
	 PTCeRTgC85dT95lejueYU+q2bMyYg8ayEJp8wq5dPezLtX/ovqK47TgbwvbwK2nj//
	 VKNRe22X5/y4sveWXNaHOkMOu1yvYvpxDY1haLMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Joey Lu <a0987203069@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0128/1518] clk: nuvoton: ma35d1: fix ignored div_u64 return values in PLL freq calculation
Date: Sat, 12 Sep 2026 08:38:17 +0200
Message-ID: <20260912065626.384395399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joey Lu <a0987203069@gmail.com>

[ Upstream commit b3a2223a7805c7e6759a32a5d6ca574ad07e2710 ]

div_u64() does not modify its argument in place; the return value must
be assigned.  Both ma35d1_calc_smic_pll_freq() and ma35d1_calc_pll_freq()
called div_u64() and discarded the result, leaving pll_freq holding the
undivided product and thus returning a frequency orders of magnitude too
high.

Fixes: 691521a367cf ("clk: nuvoton: Add clock driver for ma35d1 clock controller")

Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Joey Lu <a0987203069@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nuvoton/clk-ma35d1-pll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/nuvoton/clk-ma35d1-pll.c b/drivers/clk/nuvoton/clk-ma35d1-pll.c
index 4620acfe47e85..bfedd45bd04b7 100644
--- a/drivers/clk/nuvoton/clk-ma35d1-pll.c
+++ b/drivers/clk/nuvoton/clk-ma35d1-pll.c
@@ -92,7 +92,7 @@ static unsigned long ma35d1_calc_smic_pll_freq(u32 pll0_ctl0,
 	p = FIELD_GET(SPLL0_CTL0_OUTDIV, pll0_ctl0);
 	outdiv = 1 << p;
 	pll_freq = (u64)parent_rate * n;
-	div_u64(pll_freq, m * outdiv);
+	pll_freq = div_u64(pll_freq, m * outdiv);
 	return pll_freq;
 }
 
@@ -110,7 +110,7 @@ static unsigned long ma35d1_calc_pll_freq(u8 mode, u32 *reg_ctl, unsigned long p
 
 	if (mode == PLL_MODE_INT) {
 		pll_freq = (u64)parent_rate * n;
-		div_u64(pll_freq, m * p);
+		pll_freq = div_u64(pll_freq, m * p);
 	} else {
 		x = FIELD_GET(PLL_CTL1_FRAC, reg_ctl[1]);
 		/* 2 decimal places floating to integer (ex. 1.23 to 123) */
-- 
2.53.0



