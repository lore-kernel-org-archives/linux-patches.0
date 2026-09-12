Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47BF2E2663;
	Sat, 12 Sep 2026 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222382; cv=none; b=PdTVccyr2kV3JEjMw8SiLoSoGVqwFjHMAEKmcvxpUfuWmwosZD0l1Ke0eS8BpSaHOJrRIP4sQSZELNpYYKJRGntaNoTZEOEOzozf4iO0Lel1i/n/5FO1NODS2mHN9isU9S+8ySenxi1ih6EMog8viJd1vpwN6mnW1hJOzIcYhms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222382; c=relaxed/simple;
	bh=WCLx5lpXfhSPLzsbD8ImhTau5U8DotzbYF12hcMULKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxRqZSqhcJqXMgHF+V1O9urnYYW3dMpVkH9Y/7+L8IJ8zg5u1I+VGZ3g0s1G/PTlNkq2Lqkosh8NhqebV33HJMjcPizh2SRoqxZL8K0M2fYhbN3TD6FTlsWZN95HuvcfA2UYYQnTEsCJZuWvd1/puzGMRuIx5BA4m3VyUY27BZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Npwq+nRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Npwq+nRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95961F000FF;
	Sat, 12 Sep 2026 14:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222381;
	bh=Hsh0+BMpmBkLmU1IjAGlGStNSzOzrRM+SFlTz9CRf/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Npwq+nRzaF4wJKfOpjsN2cQS3dVeh2o8X+eGgkwB6SCAkIN1V11vxMyIOiF523IK9
	 JwRiyO6YVY580/HrlcgeVj4Op+LXG+yEPY/lqIBH5u2Tr1tUALxu/5zr6m7MKg+8DY
	 FPJrKu9DDH6k0xN9VNy45JZEA1nq9JsvM9Vqb9dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0574/1424] soc: samsung: exynos-pmu: fix of_node refcount leak in exynos_get_pmu_regmap()
Date: Sat, 12 Sep 2026 08:50:06 +0200
Message-ID: <20260912065620.154253191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 250537d7cfd64..aea4afefb3454 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -115,8 +115,8 @@ static const struct mfd_cell exynos_pmu_devs[] = {
 
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



