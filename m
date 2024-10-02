Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C40218DF60;
	Wed,  2 Oct 2024 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876267; cv=none; b=ZcIMoOf29L+gOMg+DvvQO06mIlyWFJ7+6jGmm580nT5HMW8DTuGMf5ydNgUA9Bx+Wm8g4SIIKHpp5onOcHSwsdIEpC5GBZFWQZvbtKrE8cRCZwzPbUFJeNOkXFOgVo/T2QTWCzbpxvFBIIlQc94QtWW5HlTcYJ0QwGIjGsM44B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876267; c=relaxed/simple;
	bh=4LqQsKpZi/Jh1/G/mP94p3P9NdngHjWJzuAx7auA8n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdT1FiFoRlJ8+IejA/jcMfu6gKvGJgFhhfBuARjImBflI+7Xi7KNfOfYK1XeqLrdkWJ0S0CRHywWtCyrv2NjEm5+YeDOvXaLIakUSzPpUwGA67P4wt92txbqVY4fyj8RJZFU3K8D0ENoWNcGBPDMJ/C/pB1MyPs+hMbdWQDi5JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcbrhWl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcbrhWl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72239C4CEC5;
	Wed,  2 Oct 2024 13:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876266;
	bh=4LqQsKpZi/Jh1/G/mP94p3P9NdngHjWJzuAx7auA8n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcbrhWl3RrDGeXXavYH33NEN3IgEcMFsOQrQTWvrVtRjIaZX+2ZuGhm2mmrQq3iua
	 /vO83RnDfQ6TyKGoTbZEQiOVfaQqbNIos8kWku9/yiC0CJbQLnsVq7kfbDBSUrZyVv
	 ysucpFi44RUAh1FVcjfBPkEOnIQ2U4xI6rva+87s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 384/695] clk: at91: sama7g5: Allocate only the needed amount of memory for PLLs
Date: Wed,  2 Oct 2024 14:56:22 +0200
Message-ID: <20241002125837.785595047@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea@tuxon.dev>

[ Upstream commit 2d6e9ee7cb3e79b1713783c633b13af9aeffc90c ]

The maximum number of PLL components on SAMA7G5 is 3 (one fractional
part and 2 dividers). Allocate the needed amount of memory for
sama7g5_plls 2d array. Previous code used to allocate 7 array entries for
each PLL. While at it, replace 3 with PLL_COMPID_MAX in the loop which
parses the sama7g5_plls 2d array.

Fixes: cb783bbbcf54 ("clk: at91: sama7g5: add clock support for sama7g5")
Acked-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240714141315.19480-1-claudiu.beznea@tuxon.dev
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sama7g5.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/at91/sama7g5.c b/drivers/clk/at91/sama7g5.c
index 91b5c6f148196..4e9594714b142 100644
--- a/drivers/clk/at91/sama7g5.c
+++ b/drivers/clk/at91/sama7g5.c
@@ -66,6 +66,7 @@ enum pll_component_id {
 	PLL_COMPID_FRAC,
 	PLL_COMPID_DIV0,
 	PLL_COMPID_DIV1,
+	PLL_COMPID_MAX,
 };
 
 /*
@@ -165,7 +166,7 @@ static struct sama7g5_pll {
 	u8 t;
 	u8 eid;
 	u8 safe_div;
-} sama7g5_plls[][PLL_ID_MAX] = {
+} sama7g5_plls[][PLL_COMPID_MAX] = {
 	[PLL_ID_CPU] = {
 		[PLL_COMPID_FRAC] = {
 			.n = "cpupll_fracck",
@@ -1038,7 +1039,7 @@ static void __init sama7g5_pmc_setup(struct device_node *np)
 	sama7g5_pmc->chws[PMC_MAIN] = hw;
 
 	for (i = 0; i < PLL_ID_MAX; i++) {
-		for (j = 0; j < 3; j++) {
+		for (j = 0; j < PLL_COMPID_MAX; j++) {
 			struct clk_hw *parent_hw;
 
 			if (!sama7g5_plls[i][j].n)
-- 
2.43.0



