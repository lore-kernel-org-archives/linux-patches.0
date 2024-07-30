Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E932F1A76C7;
	Tue, 30 Jul 2024 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359214; cv=none; b=tvhNu6xTWME70P3yCCO30pDAP4UI1QG4wCRpuleMo+Dte+CtOmxUoF93CxvaxohmXMtnQzM1AjQ5jFNPoNZ/IYeoLw/xGvA6bPIX4DQuptlxd0IeCCN5y9hox/arlURI6MdKpxUwOgVcflSGB8b0HomKZ0XPc7FxhkdO+7nwui4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359214; c=relaxed/simple;
	bh=o+ZxN/pb3eXHv8GiqOiWNhqogNqjbeCTJnES4uDdiLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJRDVuLOfsq179QRIkWT+HP5IsfGo8+jHQgxN2/55I/d9ok0MetOOr9aeWBNvR1OYvrmbG3vn3xRWYyuhBYnIz8tMK+85+AKak/8LbFmF8Ytc+yyZWekvaCUcoe3K8dXhbRFEtaOqgMSRu1jWyyzBPkuOCYBqPvAMo3xdpvqr0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nP+CCVV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nP+CCVV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18972C32782;
	Tue, 30 Jul 2024 17:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359213;
	bh=o+ZxN/pb3eXHv8GiqOiWNhqogNqjbeCTJnES4uDdiLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nP+CCVV6D4CXurNcf7oirPlF0ZgEQD9jxLVE2G+7J7diMwBSTqy1oe7V5zJgQj07F
	 vB/PFrjVSXA+jExaC00LNsLRCGbqmB+DSDUIWycDRqmpTSHKm7Dr3mDrbhn3pOW1Od
	 69jvuQgh3ccNYKSOkgiXgmbbwcZDWAcUmmc5mswg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 452/809] clk: en7523: fix rate divider for slic and spi clocks
Date: Tue, 30 Jul 2024 17:45:28 +0200
Message-ID: <20240730151742.560062749@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ccc3946926712..bdf5cbc12e236 100644
--- a/drivers/clk/clk-en7523.c
+++ b/drivers/clk/clk-en7523.c
@@ -57,6 +57,7 @@ struct en_clk_desc {
 	u8 div_shift;
 	u16 div_val0;
 	u8 div_step;
+	u8 div_offset;
 };
 
 struct en_clk_gate {
@@ -90,6 +91,7 @@ static const struct en_clk_desc en7523_base_clks[] = {
 		.div_bits = 3,
 		.div_shift = 0,
 		.div_step = 1,
+		.div_offset = 1,
 	}, {
 		.id = EN7523_CLK_EMI,
 		.name = "emi",
@@ -103,6 +105,7 @@ static const struct en_clk_desc en7523_base_clks[] = {
 		.div_bits = 3,
 		.div_shift = 0,
 		.div_step = 1,
+		.div_offset = 1,
 	}, {
 		.id = EN7523_CLK_BUS,
 		.name = "bus",
@@ -116,6 +119,7 @@ static const struct en_clk_desc en7523_base_clks[] = {
 		.div_bits = 3,
 		.div_shift = 0,
 		.div_step = 1,
+		.div_offset = 1,
 	}, {
 		.id = EN7523_CLK_SLIC,
 		.name = "slic",
@@ -156,13 +160,14 @@ static const struct en_clk_desc en7523_base_clks[] = {
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
@@ -202,7 +207,7 @@ static u32 en7523_get_div(void __iomem *base, int i)
 	if (!val && desc->div_val0)
 		return desc->div_val0;
 
-	return (val + 1) * desc->div_step;
+	return (val + desc->div_offset) * desc->div_step;
 }
 
 static int en7523_pci_is_enabled(struct clk_hw *hw)
-- 
2.43.0



