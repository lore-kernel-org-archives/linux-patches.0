Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEA82210E3;
	Thu, 12 Dec 2024 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018584; cv=none; b=I3w51t+hL8CX7fC763CGBTjmqfLT3TdgHt8Jci/CqGatGmXwMIELCsl1SCw1MDJhSin5/ftx7JMSfiI5LiNatWZiXDJcjoIamWcHFdX2vmVyYE7krcJbCX3FFuCmZ/8Vh1m9Tdh6FxGISAfDp8lnmXgDzOJujTi3cnySo775kos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018584; c=relaxed/simple;
	bh=hVHiHejRdR8pIrxl4lPQotPdXVIhAcaWSmFYT/UyXSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRFJST0zOX2HBjlON+8g7SoN3tBAkmS/N5mvKRyr4kYm8merSvDV9B4jy0T17noN/8XKxL/PX2m2850KAKEjwh43o59D1xtOotPVvkktrklkLf3PIUYy4PeziIf7YGj6TLGnF8wo71VTuJFlW3zlUjqXI4Vt+HLRhUQFsNMlr98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuN7uQI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuN7uQI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E470C4CECE;
	Thu, 12 Dec 2024 15:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018583;
	bh=hVHiHejRdR8pIrxl4lPQotPdXVIhAcaWSmFYT/UyXSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuN7uQI1ckn2aIZl8A1BEPfMyuLvPkOdBkUlTw9s2ZwZCP1dijx/sXVXX83A9IqPE
	 co0RzvanVjZCsnaOmkgYqU5W2CxdV+pZaiUgOSExoZVi49VcHMJGmiSwk42hNWjdha
	 haydJ8Jo+BrhykNieL80MJ9K+QR0Pp2tMG/CwphU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 333/356] clk: en7523: Initialize num before accessing hws in en7523_register_clocks()
Date: Thu, 12 Dec 2024 16:00:52 +0100
Message-ID: <20241212144257.717759057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoyu Li <lihaoyu499@gmail.com>

[ Upstream commit 52fd1709e41d3a85b48bcfe2404a024ebaf30c3b ]

With the new __counted_by annotation in clk_hw_onecell_data, the "num"
struct member must be set before accessing the "hws" array. Failing to
do so will trigger a runtime warning when enabling CONFIG_UBSAN_BOUNDS
and CONFIG_FORTIFY_SOURCE.

Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Signed-off-by: Haoyu Li <lihaoyu499@gmail.com>
Link: https://lore.kernel.org/r/20241203142915.345523-1-lihaoyu499@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-en7523.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-en7523.c b/drivers/clk/clk-en7523.c
index 7914e60f3d6c5..1331b4bacf0b6 100644
--- a/drivers/clk/clk-en7523.c
+++ b/drivers/clk/clk-en7523.c
@@ -284,6 +284,8 @@ static void en7523_register_clocks(struct device *dev, struct clk_hw_onecell_dat
 	u32 rate;
 	int i;
 
+	clk_data->num = EN7523_NUM_CLOCKS;
+
 	for (i = 0; i < ARRAY_SIZE(en7523_base_clks); i++) {
 		const struct en_clk_desc *desc = &en7523_base_clks[i];
 
@@ -302,8 +304,6 @@ static void en7523_register_clocks(struct device *dev, struct clk_hw_onecell_dat
 
 	hw = en7523_register_pcie_clk(dev, np_base);
 	clk_data->hws[EN7523_CLK_PCIE] = hw;
-
-	clk_data->num = EN7523_NUM_CLOCKS;
 }
 
 static int en7523_clk_probe(struct platform_device *pdev)
-- 
2.43.0



