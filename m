Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5557B569F2A;
	Wed,  9 Sep 2026 14:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963651; cv=none; b=VD7i/PQtCTApkbupo7erRvdLk2sHjPyE4IEDjqmQ7DVfaFnGlYn+o/ukQ06NFZP751fncCcaCj247lMu3AqShuKE7u5hvt+LD3CXJdr+jRfUsn8glPv5AwqDjMWriYcMu19gDf2DH3tRVy3qRel1K+iSF7s7Da0DML23GIZC2hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963651; c=relaxed/simple;
	bh=OPWb/N8Ord46KagulyiqPlbyAW6INSL3crXlIkXzsj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKTmCPL8kc/yL+OnFMzfEuA3C9bJKizrsR5mvFwOvU4L7zj+CZRS+12OQLH8vRGtNlH9CLaV/awDYZ25gGJF3qWYj2RaNpzuKOY9yTBFBWMHFdAeWhDHO+Z3QI4P5jnjjl/9kRux/ANyEFYQIAnmPzU/oIey9gPcO4ys3RxUhcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXnh3VmS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXnh3VmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4B01F00A3A;
	Wed,  9 Sep 2026 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963650;
	bh=57qfR/eKZdnjqkahYbeayOQjFodxOJla6fZUoWhXYvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXnh3VmSiqHpWfpvFzFAo/f+P18iEqe3Wz0GY8FbV6zvgYf+FeeFhygCtHktelfd2
	 2lPf7xckkKg6oZt919NRBauBX0ASbeDHUrrA58TwvKskL1QOWTfrOdkwLOW1UEvMpa
	 zwUvbwtr2QlXU5ZECZMTLqqF0RAagcphY1Vgk1E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 151/583] clk: rockchip: rk3588: Dont change PLL rates when setting dclk_vop2_src
Date: Wed,  9 Sep 2026 15:37:16 +0200
Message-ID: <20260909134243.412608945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -2094,7 +2094,7 @@ static struct rockchip_clk_branch rk3588
 	COMPOSITE(DCLK_VOP1_SRC, "dclk_vop1_src", gpll_cpll_v0pll_aupll_p, 0,
 			RK3588_CLKSEL_CON(111), 14, 2, MFLAGS, 9, 5, DFLAGS,
 			RK3588_CLKGATE_CON(52), 11, GFLAGS),
-	COMPOSITE(DCLK_VOP2_SRC, "dclk_vop2_src", gpll_cpll_v0pll_aupll_p, CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
+	COMPOSITE(DCLK_VOP2_SRC, "dclk_vop2_src", gpll_cpll_v0pll_aupll_p, CLK_SET_RATE_NO_REPARENT,
 			RK3588_CLKSEL_CON(112), 5, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3588_CLKGATE_CON(52), 12, GFLAGS),
 	COMPOSITE_NODIV(DCLK_VOP0, "dclk_vop0", dclk_vop0_p,


