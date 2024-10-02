Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328C1D0E16;
	Wed,  2 Oct 2024 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878250; cv=none; b=pbNCcLnjFoXcRjJTn5ncI3AB254HG+XGDZnzfOu3V2VHVhP82+5OvByMo9LvrDlp6SD04L3/9KH0zG+B/LbltfjOyvfmeasZ8JJkpbb6VIxnK/U/ZjyGiwgS39h8kqD/+9S7V1N5KqsUtnUAWlG7cXY+a69LHBvU3RwsTjXMsuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878250; c=relaxed/simple;
	bh=E7RbdtDAl7A5ddyHn9ZgpKcYBx40eM/QPi9SAsoBwZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbhBtngS+s50vDpclxN0HhVHe58bNPJGtJ6cnSyZDiUxV++GmbhMopaK45PrQzu0BGdHigAMJwEubhGEb0/peMfwqpSqnMV1xFbYc7C6vAKfVaJOd+HyH3QtNdSDdEdTUpJqyjw2ISmA97c36S2ACq130T6ESpywX1MdGpSX61Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPgu/UYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPgu/UYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF23C4CEC2;
	Wed,  2 Oct 2024 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878250;
	bh=E7RbdtDAl7A5ddyHn9ZgpKcYBx40eM/QPi9SAsoBwZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPgu/UYf2eseWumAMESEBZNrIdNRK4JQTjD6ipT92OE9zQEZuK8EtsE9PCExw9fm5
	 ODNoDKVmS/BOzeVPjzVOwCdOK9clC/kzVV2bjQM7tQM44PLPJC/tKlKPh6kQfbYlx2
	 OFmHW+aC/7CiB2bEhI9wUcHVYEEy2qO0/R4UlZxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 350/634] clk: at91: sama7g5: Allocate only the needed amount of memory for PLLs
Date: Wed,  2 Oct 2024 14:57:30 +0200
Message-ID: <20241002125824.914703731@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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



