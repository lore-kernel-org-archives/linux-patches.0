Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC113C1419;
	Sat, 12 Sep 2026 07:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197013; cv=none; b=Wk0NuETyBaDThuCF385X30hqYWxk9Y0nIE3fUaLHUJgco0A6kaV3MBjZXZRfTHVGAxqZ5v7Cwctpy43JyxOiQYKr898n6yens7cJIz+L/IzadyIesuHczA7hmBU6U6x6U7OMO+igYnW/FVzsJ0+w+rRYhI20bynS1MfaSx8M3FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197013; c=relaxed/simple;
	bh=fTHpbTT97kqMjlGvawkZyF6eY/wdNIWT97Qd4NtUl5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzF1Tt49q4kmUw4bETHjZvsymdyRB4H/LhcJWaTX+ApstilqQA5GEx4zG+AEMvU6xNKz3/59seZKVcxM8GTpHQ2xPaWxTf34sahD6fCBqBYwClIowlfAS45XD32by6k7yAf3bKO0TLH5PjMcjCxW5zAVF968vUQkeHG/JN/uIow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgg2n0IM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgg2n0IM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37801F000FF;
	Sat, 12 Sep 2026 07:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197012;
	bh=bVTFjdvSzb9a9tk5jYBLAOHW8nqnn9b3nkcW8UHXmSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgg2n0IMSa9pxvt4aHPziYLBwlREuxg6VGh7bWyeJCV5c4ulGB2YdblbZFbUcBr1P
	 WTdk1RCJg1/IEGbCHnnZksbQ6ss2sxZpDNag5mwXs51oUU0wAqxBXROVWfemZ/7hRq
	 OXHqM4Fr83pYNXw6WhNxJ5cjsM3xLTIyr+vkrbrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Joey Lu <a0987203069@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0082/1815] clk: nuvoton: ma35d1: fix ignored div_u64 return values in PLL freq calculation
Date: Sat, 12 Sep 2026 08:30:32 +0200
Message-ID: <20260912065650.933787747@linuxfoundation.org>
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



