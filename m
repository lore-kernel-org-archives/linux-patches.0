Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768E147A87A;
	Sat, 12 Sep 2026 12:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214497; cv=none; b=NLiDcgUBBfx5gA55t6TjhLT3SXoieJEjZCxKgji7Hoz9tYL9MY1MrWMy6xqPYNgdhlnW7s5EC58cuQ4A9owhzFqvhapuIiVW5ulL2Z6ehUVrJQPK+szGGZcScrLQ/NtVDLffNTV+KYrafQB0nbH+1MrSeJ/ooJJhYVJNDJCDKKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214497; c=relaxed/simple;
	bh=At1rkUzhyRxZ1RiV0+MGu7W0KVdjaNug/Fs6YL+cMQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJIc417N6IBgtGXgABGyMLiEShxjaizl5gBYSbxn46RXXYANyL2RvLcb7Vsq89wh9gjkehZGusmyIrCsLPm0CtDfgyYInekNTq/WNNaBhgCZtB6IMZsh07FJc0798weZNxxxWd8X0XGZDwEx+z4s4cJ1DQcEXjKbCAkUD5XcjOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSiQiPlt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSiQiPlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10411F000FF;
	Sat, 12 Sep 2026 12:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214496;
	bh=iFWHBVafvb0Xm+Oetx2eDSSGksJSoxTkECEOYS+Nhjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSiQiPltYI8KAJo9lUAocyhCgpF95tObTZpsq8iaBSH7cQpuuznvEV5P3BPu6z2HM
	 2l+niAtaX0i/xeIIU9dasQiTc2vAjfsBgiojPcgCQfDSv0A0+Zc0CeishVCB8EpeJ5
	 22jqj73xS5cEZn1I4mURzDMVouwcYLt2TuFrP9cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Joey Lu <a0987203069@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0331/1376] clk: nuvoton: ma35d1: fix ignored div_u64 return values in PLL freq calculation
Date: Sat, 12 Sep 2026 08:45:57 +0200
Message-ID: <20260912065614.924807182@linuxfoundation.org>
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



