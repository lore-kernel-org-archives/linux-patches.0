Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370763EBF04;
	Sat, 28 Feb 2026 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301360; cv=none; b=bhj5CFanX100UgUnvJQ+rRzOKJjXTxhxWkSIoI9LQFjHoSRtPd4H+8ivnDOhiPJaNggciNNSmgIpeVyUnIT5yJzpvMLeOXx50j2SBP4qORdMbjD4QoNkNAmAFBHR0S/yj3hcY7fmg6JnV90QE7KT8zX0sW94SyVy/v7OElqGTUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301360; c=relaxed/simple;
	bh=59EppQRRUUkNDsiJXqyzwrpObOW1D6YTxPbFo7kMLwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rmwn9iByumHmy85XvpjhhVnMrywZe5tS4L6I/dE7mu9yOBMux6PvNR3UkRsGusUrnOpBQIYoeCV4KTkNd5+fYxjWrnz3o6VScz2J83dpRTtanorY2EDfxEmxPPgyQRvgS+pm5MjHDe0r4qgJv0cRQxOWlGLYeD2ZzTLf3Tgy2Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XPpsq9Ux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XPpsq9Ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACB7C19423;
	Sat, 28 Feb 2026 17:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301360;
	bh=59EppQRRUUkNDsiJXqyzwrpObOW1D6YTxPbFo7kMLwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPpsq9UxCCr0zFp/Y2BPdjgqWArK3t9l3F9hlZ/NfYLaFSrnn54apisUHvlIbY9v8
	 NU+97G8wmPOuUL+HVJTXikh9rXvswLgzCJGXmCZM/jaP9PItUOfyyjRLuq7T8mycum
	 YE2yrejPEbBN1P5Z1wzToHPCVvd/CSU48HSHHeak/wDRxAPpvLNjlvX5QWQXMzpdDT
	 YAGJmnKwUlhpqZ6z7AuWtf/BMrnDIaCkYtgYV1/dP/2D7rK91XjVMaJksufaHHJfuo
	 6z6v5FlOfuO5nNurFgfrFCt+IRnvQERLz7kkTGvnjQDWNkErhguoDh8GBf2wkOIlag
	 zB0imGnV7DaUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shawn Lin <shawn.lin@rock-chips.com>,
	stable@vger.kernel.org,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Marco Schirrmeister <mschirrmeister@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 548/752] soc: rockchip: grf: Support multiple grf to be handled
Date: Sat, 28 Feb 2026 12:44:19 -0500
Message-ID: <20260228174750.1542406-548-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 75fb63ae031211e9264ac888fabc2ca9cd3fcccf ]

Currently, only the first matched node will be handled. This leads
to jtag switching broken for RK3576, as rk3576-sys-grf is found before
rk3576-ioc-grf. Change the code to scan all the possible node to fix
the problem.

Fixes: e1aaecacfa13 ("soc: rockchip: grf: Add rk3576 default GRF values")
Cc: stable@vger.kernel.org
Cc: Detlev Casanova <detlev.casanova@collabora.com>
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Tested-by: Marco Schirrmeister <mschirrmeister@gmail.com>
Link: https://patch.msgid.link/1768524932-163929-3-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/grf.c | 55 +++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/soc/rockchip/grf.c b/drivers/soc/rockchip/grf.c
index 9b96499fa1dfc..db407fa279850 100644
--- a/drivers/soc/rockchip/grf.c
+++ b/drivers/soc/rockchip/grf.c
@@ -202,34 +202,33 @@ static int __init rockchip_grf_init(void)
 	struct regmap *grf;
 	int ret, i;
 
-	np = of_find_matching_node_and_match(NULL, rockchip_grf_dt_match,
-					     &match);
-	if (!np)
-		return -ENODEV;
-	if (!match || !match->data) {
-		pr_err("%s: missing grf data\n", __func__);
-		of_node_put(np);
-		return -EINVAL;
-	}
-
-	grf_info = match->data;
-
-	grf = syscon_node_to_regmap(np);
-	of_node_put(np);
-	if (IS_ERR(grf)) {
-		pr_err("%s: could not get grf syscon\n", __func__);
-		return PTR_ERR(grf);
-	}
-
-	for (i = 0; i < grf_info->num_values; i++) {
-		const struct rockchip_grf_value *val = &grf_info->values[i];
-
-		pr_debug("%s: adjusting %s in %#6x to %#10x\n", __func__,
-			val->desc, val->reg, val->val);
-		ret = regmap_write(grf, val->reg, val->val);
-		if (ret < 0)
-			pr_err("%s: write to %#6x failed with %d\n",
-			       __func__, val->reg, ret);
+	for_each_matching_node_and_match(np, rockchip_grf_dt_match, &match) {
+		if (!of_device_is_available(np))
+			continue;
+		if (!match || !match->data) {
+			pr_err("%s: missing grf data\n", __func__);
+			of_node_put(np);
+			return -EINVAL;
+		}
+
+		grf_info = match->data;
+
+		grf = syscon_node_to_regmap(np);
+		if (IS_ERR(grf)) {
+			pr_err("%s: could not get grf syscon\n", __func__);
+			return PTR_ERR(grf);
+		}
+
+		for (i = 0; i < grf_info->num_values; i++) {
+			const struct rockchip_grf_value *val = &grf_info->values[i];
+
+			pr_debug("%s: adjusting %s in %#6x to %#10x\n", __func__,
+				val->desc, val->reg, val->val);
+			ret = regmap_write(grf, val->reg, val->val);
+			if (ret < 0)
+				pr_err("%s: write to %#6x failed with %d\n",
+					__func__, val->reg, ret);
+		}
 	}
 
 	return 0;
-- 
2.51.0

