Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E832931F5;
	Sat, 12 Sep 2026 14:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222407; cv=none; b=MfGuilTBDa0naiHIDoOCPTrOYX/cqhixs23PykCEkmwQg0ejfsDE5OcdspaURomTifM9A6Ygs1soHfElSYpqQ7hPlT+bk9WzMU5lnn6asLB6bYYWC4yl0ECw898sfZ039nLaV6Ct8sovEV6zmhVZZACxjpDhjiMtN1L5Gu+sZDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222407; c=relaxed/simple;
	bh=mCPNSFcN0SMFIhtmt21wMwd9vvoP3OF4Duf5cYy4gsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nB/Ljj9XF5AlCA4FMMS9tb3oB0Ag1yu9/y+V5wHVi05WzKQZv3QIpJLSvVAxB3uQPq9flK8HE4XNd1gcxEI64KF2VgyJ7QqjUNGx4mKQ5r0htyqyBbK1UBETmyHpTe+1+i1UNa7yWEjMO1E+YxMx7iB09ztHdmLlJISnvnYK1nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaqVXo1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaqVXo1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8F71F000FF;
	Sat, 12 Sep 2026 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222406;
	bh=XujbYX4lHlB3l3jjFTEo6XdEqgUmppB/cjQFF8Lzzi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VaqVXo1CeuqY1nHywK4EM4/14k1/ua+cBL/6c0i9leeniX+OnktYJpdZaIe49Yrf0
	 XMobgGwaJxiJFFvh/GGWz4PHWU55Rj1wxXUsiqJEqUrDfzUe70AOIZxltUatvpMRZa
	 sH3wVMDck+HU/Lid6+qk9zpV79P7bSMwfUBSg4W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Joey Lu <a0987203069@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0578/1424] clk: nuvoton: ma35d1: fix ignored div_u64 return values in PLL freq calculation
Date: Sat, 12 Sep 2026 08:50:10 +0200
Message-ID: <20260912065620.241287129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ff3fb8b87c24b..9bb18fc371d17 100644
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



