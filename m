Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D0155C1D4;
	Wed,  9 Sep 2026 13:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962322; cv=none; b=oIV4IPdeowVKhn7KS3vLfDZt8WzP3vf4uwS7DDFz0a7qSOdVoPg7t7pRFBXaMBYXWXBGRbiGa+Bb2cFQe0kHulnA9Dncmr/JDRNfKHiyi9Y6XXc04EVq51Pz8iyUTTl8nnnx8jts2wJUhTRYAcpaKEvfqaPcUR78sfrJl1AzgJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962322; c=relaxed/simple;
	bh=S7tF8OJ5hGXYqGla/PF97NpUzwPMWU73fbf8FAsxUVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJpAVMnOpoBxexL9fhHTy9irgWwyGRIb0WkvJCFAkefqItBigS+jLdVl0JF74zXkVbFF7zHRj/HflSbp4Y6IJQzX74oPzi+wSPokoxn++A3AZ77WT6YZVrknZZ9jjUlffT2+c6kXnxjKTaZq4qQknZDkCFoDcNhkFLGH2xcR63w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HC7OsCf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HC7OsCf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCAE1F00A3A;
	Wed,  9 Sep 2026 13:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962320;
	bh=Bc177pmbfkeSjiEPMvMJqsHdTVNEeTV4sUlNbs+P26M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HC7OsCf9U0fwPE6oVOTEwBl1xttjHPi0ymda/IGhdeKykH7+Fq8DFvpuDvLpgMGkn
	 gLJrHJ8gbWLgycgUYZnb00nIuNeCbTxq2pIW2dGNwU4jHVVXAHIscmq0eiG18nuVK+
	 PwQjx3YG0M85LPrOjxpLwsUOovQrgbIWyPqHSWVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 7.2 213/556] clk: rockchip: rk3588: Dont change PLL rates when setting dclk_vop2_src
Date: Wed,  9 Sep 2026 15:38:13 +0200
Message-ID: <20260909134237.891845280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Heiko Stuebner <heiko.stuebner@cherry.de>

commit 13b10571cc353448275365ede1a5396d20dfe839 upstream.

dclk_vop2_src currently has the CLK_SET_RATE_PARENT flag set, which is
very different from dclk_vop0_src or dclk_vop1_src, which don't have it.

With this flag in dclk_vop2_src, actually setting the clock then results
in a lot of other peripherals breaking, because setting the rate results
in the PLL source getting changed:

[   14.898718] clk_core_set_rate_nolock: setting rate for dclk_vop2 to 152840000
[   15.155017] clk_change_rate: setting rate for pll_gpll to 1680000000
[ clk adjusting every gpll user ]

This includes possibly the other vops, i2s, spdif and even the uarts.
Among other possible things, this breaks the uart console on a board
I use. Sometimes it recovers later on, but there will be a big block
of garbled output for a while at least.

Shared PLLs should not be changed by individual users, so drop this flag
from dclk_vop2_src.

Fixes: f1c506d152ff ("clk: rockchip: add clock controller for the RK3588")
Cc: stable@vger.kernel.org
Tested-by: Quentin Schulz <quentin.schulz@cherry.de> # RK3588 Tiger w/ DP
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Tested-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://patch.msgid.link/20260304121426.1184680-2-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/rockchip/clk-rk3588.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/rockchip/clk-rk3588.c
+++ b/drivers/clk/rockchip/clk-rk3588.c
@@ -2102,7 +2102,7 @@ static struct rockchip_clk_branch rk3588
 	COMPOSITE(DCLK_VOP1_SRC, "dclk_vop1_src", gpll_cpll_v0pll_aupll_p, 0,
 			RK3588_CLKSEL_CON(111), 14, 2, MFLAGS, 9, 5, DFLAGS,
 			RK3588_CLKGATE_CON(52), 11, GFLAGS),
-	COMPOSITE(DCLK_VOP2_SRC, "dclk_vop2_src", gpll_cpll_v0pll_aupll_p, CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
+	COMPOSITE(DCLK_VOP2_SRC, "dclk_vop2_src", gpll_cpll_v0pll_aupll_p, CLK_SET_RATE_NO_REPARENT,
 			RK3588_CLKSEL_CON(112), 5, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3588_CLKGATE_CON(52), 12, GFLAGS),
 	COMPOSITE_NODIV(DCLK_VOP0, "dclk_vop0", dclk_vop0_p,


