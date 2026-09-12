Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783D8757EA;
	Sat, 12 Sep 2026 19:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242261; cv=none; b=gWKACkxz0k/CaKmhMsq6XbpYNC2O/Z9DMuQGkPLjuUk1L1GysStWrtSTK9TVTTeZOB5fvCizhWuWJtZd/uU7HgCSHpD1QrkB0x7Hf5aUmVKqbq6q+BcrC9+lMAXVD32fFS1W2jvHYxaKsU2pROWuv+jD6gsCEesOI/xbGHr9kOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242261; c=relaxed/simple;
	bh=G7DPL8A8G5ozMt5t4nK31l0W2ER1rwVrTY3WKml+iJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6rpyDaF/dKBg07s6jYlMiahml8kF2xm0qOYx5ft8LbazZ4s//s1AFVi6GAAXJlhrzbaiq994p6uFAk9CLOAqxBo9E52Pg+WD32xsVm9DdEsh3AKQoUqbVCJnCDctJH4EIpJ0aGQwh9WwcnGZk67hHYHUn1bAQDwtsD8uujFaFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYMIiI4j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYMIiI4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2731F000FF;
	Sat, 12 Sep 2026 19:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242260;
	bh=yqnOlgTsoQ3RulIgPWOymPCmQGU+lH3IY1ZxKXeYpOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYMIiI4jMUdynMZSPBHPLHB4dE7Yey5QBXWuHWvD2afgd+zoDw7iLDpKjYSqFMCs2
	 azs/+QQvdjeHUdcdv/oWy4U22IeLXnXxpkuxBNxAtocY5umTfyRrGd1BMVyPY9I6sQ
	 4N+n/ADftFO3I5l91b/MC9simABiE7HSQ6TNiFmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 343/798] soc: samsung: exynos-pmu: fix of_node refcount leak in exynos_get_pmu_regmap()
Date: Sat, 12 Sep 2026 08:59:31 +0200
Message-ID: <20260912065525.021221698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit fa476d53edd24e8105faace04e881b9c4179738f ]

exynos_get_pmu_regmap() obtains a device_node via of_find_matching_node()
and passes it to exynos_get_pmu_regmap_by_phandle(np, NULL). With
propname == NULL the callee uses np directly and does not drop a
reference, so the reference taken by of_find_matching_node() is leaked on
every call -- including on each -EPROBE_DEFER retry of the only in-tree
caller, exynos_retention_init() in the Exynos pinctrl driver.

Annotate np with the __free(device_node) cleanup attribute so the
reference is released when the function returns.

Found by static analysis tool CodeQL.

Fixes: 76640b84bd7a ("soc: samsung: pmu: Provide global function to get PMU regmap")
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Link: https://patch.msgid.link/20260609143852.1783558-1-geoffreyhe2@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/samsung/exynos-pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index 17304fa184296..55d5cfd73f88d 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -99,8 +99,8 @@ static const struct of_device_id exynos_pmu_of_device_ids[] = {
 
 struct regmap *exynos_get_pmu_regmap(void)
 {
-	struct device_node *np = of_find_matching_node(NULL,
-						      exynos_pmu_of_device_ids);
+	struct device_node *np __free(device_node) =
+		of_find_matching_node(NULL, exynos_pmu_of_device_ids);
 	if (np)
 		return syscon_node_to_regmap(np);
 	return ERR_PTR(-ENODEV);
-- 
2.53.0



