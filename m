Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F501F8190;
	Wed,  6 Nov 2024 13:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898182; cv=none; b=Buof0aLLl3pDhBXBgoqkrh+CdFxpa4Tt4Hf71NhjPfujog/a4XI9dc0Ar6Ft95zdNUvmvJTtupn4MsN3q/hgpWTgwA+rH+HB4h13LwQI9YFIn15AGkHXKCOfvHE4Uh2Gn/YwkVEKSso3vbeaYjJHaRbHjRmu4lqDZc4KOvwRbP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898182; c=relaxed/simple;
	bh=ibqh/zWg6woWaq4jvM7QX18wL/DGWvi1kVSrVZh+1Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ke5IIexTpYZBR9oNC8rS4Cs8WbULp5K011C2E0U+Liq/+njrHoC2pmP3JTFkmUMFFIh94sGQHYDzzMoOUZxAQ90bWRl0+/y/Qg7ycrOOfJnGrps8aPyonlh1z5tVM0+t1+9lTM0egfJrzdvZo7c9aQsdt63S7botKCqRih0LRMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3+3eqVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3+3eqVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E438C4CECD;
	Wed,  6 Nov 2024 13:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898182;
	bh=ibqh/zWg6woWaq4jvM7QX18wL/DGWvi1kVSrVZh+1Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3+3eqVey3hm49bSrSNiTtwgrFKsdzDxdy3hF5XQCSQCeU4+EbO8buygi2/RupXes
	 bjSX8nvzDzLgieN1tstXFMDS5KoowKTz8vNYGNWHiimpwbm+iJiisCUm7+GP7HUTpw
	 prcP5bS6fD32jFYfHu1R0eWhRxG3txKxBHRVPiCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/462] clk: ti: dra7-atl: Fix leak of of_nodes
Date: Wed,  6 Nov 2024 13:00:08 +0100
Message-ID: <20241106120334.347103445@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 9d6e9f10e2e031fb7bfb3030a7d1afc561a28fea ]

This fix leaking the of_node references in of_dra7_atl_clk_probe().

The docs for of_parse_phandle_with_args() say that the caller must call
of_node_put() on the returned node. This adds the missing of_node_put()
to fix the leak.

Fixes: 9ac33b0ce81f ("CLK: TI: Driver for DRA7 ATL (Audio Tracking Logic)")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240826-clk-fix-leak-v1-1-f55418a13aa6@baylibre.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-dra7-atl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index 62ea790d79f96..640642b3e9a2f 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -257,6 +257,7 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		}
 
 		clk = of_clk_get_from_provider(&clkspec);
+		of_node_put(clkspec.np);
 		if (IS_ERR(clk)) {
 			pr_err("%s: failed to get atl clock %d from provider\n",
 			       __func__, i);
-- 
2.43.0



