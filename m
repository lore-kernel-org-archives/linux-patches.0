Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9801F75AC;
	Tue,  3 Dec 2024 16:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241650; cv=none; b=oY2tMCMRKCADKBmbA+Ht6M7sV9Cbg1LwcGZemekpwmWKmWvibpehnyV70Mka7KWwznsJCKvcRRHvx0kzD6Bmui5HuXpYSDQ/Vuri3nalU+xVZoqvog1MclSpvLi+lfWvSjjqqsCrjjNs5KWesFoEc+WYHd5vKdZ1aiEJIblj2Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241650; c=relaxed/simple;
	bh=Zd+QnFcLhhyJ0572m+oBPI3tN4KM0B2XVwUjE7TTDmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzVvAHPFZNq7XXpuE8Du5lYgdjODlIUJ0ZL3j9rSrSoTXHvBdsWWbJJ+Bpgf8m/PJkEebhWfzOcSIG8I1P3ZvJlGQJ/egTtGsXuyMnqh/NfmBBCnKFaqa9DvhgGyj6RiRwEL+55BC5uLG8SxgCZwO/YTAUN6Byh3x76dQPqRGjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWgjjMOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWgjjMOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C66BC4CED6;
	Tue,  3 Dec 2024 16:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241650;
	bh=Zd+QnFcLhhyJ0572m+oBPI3tN4KM0B2XVwUjE7TTDmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWgjjMORbFWeVxIcIad1w7RwDzkI+H3IIt3dHCzJYuMPuuuzBOTzjMePZZw1Dqbll
	 nhhl0nmqgdOBn4A0Ero1+5RGjWDrt4y2JUkqzjlwsbcYi3u0DY9BDelT6B01k+rjDQ
	 4z3D2afmcsyACJy0pSovFgjSC1hJQ5uolLmLSuU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 448/826] clk: ralink: mtmips: fix clock plan for Ralink SoC RT3883
Date: Tue,  3 Dec 2024 15:42:55 +0100
Message-ID: <20241203144801.235556652@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 33239152305567b3e9bf052f71fd4baecd626341 ]

Clock plan for Ralink SoC RT3883 needs an extra 'periph' clock to properly
set some peripherals that has this clock as their parent. When this driver
was mainlined we could not find any active users of this SoC so we cannot
perform any real tests for it. Now, one user of a Belkin f9k1109 version 1
device which uses this SoC appear and reported some issues in openWRT:
- https://github.com/openwrt/openwrt/issues/16054
The peripherals that are wrong are 'uart', 'i2c', 'i2s' and 'uartlite' which
has a not defined 'periph' clock as parent. Hence, introduce it to have a
properly working clock plan for this SoC.

Fixes: 6f3b15586eef ("clk: ralink: add clock and reset driver for MTMIPS SoCs")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20240910044024.120009-2-sergio.paracuellos@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ralink/clk-mtmips.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ralink/clk-mtmips.c b/drivers/clk/ralink/clk-mtmips.c
index 50a443bf79ecd..62f9801ecd3a4 100644
--- a/drivers/clk/ralink/clk-mtmips.c
+++ b/drivers/clk/ralink/clk-mtmips.c
@@ -267,6 +267,11 @@ static struct mtmips_clk_fixed rt305x_fixed_clocks[] = {
 	CLK_FIXED("xtal", NULL, 40000000)
 };
 
+static struct mtmips_clk_fixed rt3883_fixed_clocks[] = {
+	CLK_FIXED("xtal", NULL, 40000000),
+	CLK_FIXED("periph", "xtal", 40000000)
+};
+
 static struct mtmips_clk_fixed rt3352_fixed_clocks[] = {
 	CLK_FIXED("periph", "xtal", 40000000)
 };
@@ -779,8 +784,8 @@ static const struct mtmips_clk_data rt3352_clk_data = {
 static const struct mtmips_clk_data rt3883_clk_data = {
 	.clk_base = rt3883_clks_base,
 	.num_clk_base = ARRAY_SIZE(rt3883_clks_base),
-	.clk_fixed = rt305x_fixed_clocks,
-	.num_clk_fixed = ARRAY_SIZE(rt305x_fixed_clocks),
+	.clk_fixed = rt3883_fixed_clocks,
+	.num_clk_fixed = ARRAY_SIZE(rt3883_fixed_clocks),
 	.clk_factor = NULL,
 	.num_clk_factor = 0,
 	.clk_periph = rt5350_pherip_clks,
-- 
2.43.0



