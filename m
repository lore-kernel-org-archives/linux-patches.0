Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98C61A618D;
	Tue, 30 Jul 2024 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356646; cv=none; b=uFWR+I1SVihYPim/PNiCIfu9VJGf7pYl6T2Y66rxxrRFrl3PgGSIzBVLYu6oMvKKYFscwY1mLbZrmmCWqH+iHUKhd0/BXqFYNAFmUJAVnw+3++nhsQhmJ1vz+rYZ0N+Tz57P487izVaI50jyfhbgkJjwSrPKUmM6POKQDSXPkt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356646; c=relaxed/simple;
	bh=SryfaR+a20mjwJcHS2+s+/VbuOj6XuYKr4qpVg3s7eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGc8x+Wz4qutBG7e9w6fxwvwXRpaCWwhkVDHpYi8XnG0bUTqRQIUPO+0rszcJaHKUgdhcnz1OSbU5BB7MPy3fj08YNq3Zm3pF27uJpeqDn4lYOzwktTscQBWl+XEquMSx0ouVljlzFcUt1g/Lw/IeHXKuDN+O4nG4XGTZ/apLD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gV5NvUfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gV5NvUfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5CBC32782;
	Tue, 30 Jul 2024 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356645;
	bh=SryfaR+a20mjwJcHS2+s+/VbuOj6XuYKr4qpVg3s7eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gV5NvUfeGvj+M/mFu9eQjZTeNv/iXlddi2XCvjwuKRFIzj4U/0R5qStB4HQfOc2BA
	 QEdtJvLmtWgGCNFYjZCxcadJff/mhJ2V5D0nQIa5HC/+hNiT8KVl7VCcI91J5kfA3C
	 rs59aUEYXsph74f3uuR4SDLoLNYhhZqEEVHGJHpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/440] clk: en7523: fix rate divider for slic and spi clocks
Date: Tue, 30 Jul 2024 17:47:28 +0200
Message-ID: <20240730151624.260897659@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 58c53d43142f222221e5a76a7016c4d8f3b84b97 ]

Introduce div_offset field in en_clk_desc struct in order to fix rate
divider estimation in en7523_get_div routine for slic and spi fixed
rate clocks.
Moreover, fix base_shift for crypto clock.

Fixes: 1e6273179190 ("clk: en7523: Add clock driver for Airoha EN7523 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/c491bdea05d847f1f1294b94f14725d292eb95d0.1718615934.git.lorenzo@kernel.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-en7523.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-en7523.c b/drivers/clk/clk-en7523.c
index 29f0126cbd05b..d22fae24a3dab 100644
--- a/drivers/clk/clk-en7523.c
+++ b/drivers/clk/clk-en7523.c
@@ -41,6 +41,7 @@ struct en_clk_desc {
 	u8 div_shift;
 	u16 div_val0;
 	u8 div_step;
+	u8 div_offset;
 };
 
 struct en_clk_gate {
@@ -68,6 +69,7 @@ static const struct en_clk_desc en7523_base_clks[] = {
 		.div_bits = 3,
 		.div_shift = 0,
 		.div_step = 1,
+		.div_offset = 1,
 	}, {
 		.id = EN7523_CLK_EMI,
 		.name = "emi",
@@ -81,6 +83,7 @@ static const struct en_clk_desc en7523_base_clks[] = {
 		.div_bits = 3,
 		.div_shift = 0,
 		.div_step = 1,
+		.div_offset = 1,
 	}, {
 		.id = EN7523_CLK_BUS,
 		.name = "bus",
@@ -94,6 +97,7 @@ static const struct en_clk_desc en7523_base_clks[] = {
 		.div_bits = 3,
 		.div_shift = 0,
 		.div_step = 1,
+		.div_offset = 1,
 	}, {
 		.id = EN7523_CLK_SLIC,
 		.name = "slic",
@@ -134,13 +138,14 @@ static const struct en_clk_desc en7523_base_clks[] = {
 		.div_bits = 3,
 		.div_shift = 0,
 		.div_step = 1,
+		.div_offset = 1,
 	}, {
 		.id = EN7523_CLK_CRYPTO,
 		.name = "crypto",
 
 		.base_reg = REG_CRYPTO_CLKSRC,
 		.base_bits = 1,
-		.base_shift = 8,
+		.base_shift = 0,
 		.base_values = emi_base,
 		.n_base_values = ARRAY_SIZE(emi_base),
 	}
@@ -185,7 +190,7 @@ static u32 en7523_get_div(void __iomem *base, int i)
 	if (!val && desc->div_val0)
 		return desc->div_val0;
 
-	return (val + 1) * desc->div_step;
+	return (val + desc->div_offset) * desc->div_step;
 }
 
 static int en7523_pci_is_enabled(struct clk_hw *hw)
-- 
2.43.0



