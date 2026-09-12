Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7662E8B64;
	Sat, 12 Sep 2026 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228882; cv=none; b=QqzZE+4miIrH1iIro6+5FZ3uQwuxx8nM6vU6oSS5IK8AuHETUx/TClWjvSNE3qrhXB/H6iIMssEStFCjAt4U5hu72XoPq067QMl4kBDmZuslrKbhVikOyl81hjCw/A6eAxPGQdT1K8p0U//rCE38l8SkanjGrnn++R5jOW+TPo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228882; c=relaxed/simple;
	bh=SjrLI2PzqQTXf1w4srCzG53FYKCCw2C/bhTX1VRbh4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nW4hxOWgdjG26nDbeJT3Q8gswZ6u/i/Qw68v+LH5OvNr8RthKQcpr/aGq6rltN8Yia2c59UTAbOb/BmvLMor1cEgVjT+VMso1ce2dBajjJmpvoVObh1K6xHjEPtWuDmQnNqz2bsJcu64qGEZIjRcPB9ohSN/2Pm1yeP5FHTHafs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3LoAaQE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3LoAaQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06A21F000FF;
	Sat, 12 Sep 2026 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228880;
	bh=p1g+sdKxiVxeSj6zMHrAsqNiRh53XYnaarjJQw1Pj4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3LoAaQE3qAAAVxCApodxonqP8l9dLz2MIPjsI5ZYcoX8ZCrfZxdxuNTBMeFPvS4Y
	 XMIgxO1I48JZxvquvSCpIJuANmOiDjM0b+FvP0qIV0A7dRYXqVTiGFED7Kk4kRM6HU
	 f83wvXRRjqBh18Cg9EymGdi0bX8mXmg0tuzdgpC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0477/1191] soc: samsung: exynos-pmu: fix of_node refcount leak in exynos_get_pmu_regmap()
Date: Sat, 12 Sep 2026 08:53:25 +0200
Message-ID: <20260912065558.947077460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 732c86ce2be8a..e9098b60712a8 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -106,8 +106,8 @@ static const struct mfd_cell exynos_pmu_devs[] = {
 
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



