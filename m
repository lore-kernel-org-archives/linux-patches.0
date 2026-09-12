Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F793B47D5;
	Sat, 12 Sep 2026 09:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206034; cv=none; b=QvY86qza3O+iatFmRZP2JB4EjO7f3Of+lld92gfwk6UxwbbkKfuGZBY8g2eH9UfsF87AYfixPTEvOZ5d9b1jmmm5uNSzXu7angG2zUnloOTZsBu30FrZRT8jjW+3UEONEwl8wJ792QFSMWPmt9C5OXsCinlmRMaxjy0/9XJjSKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206034; c=relaxed/simple;
	bh=md5qXXp8OpGCroySZXuBng/SXWxXjr7MlXN9BSHkspk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTYal+P7OCqylOaj80w+xBVz1ied1QoZLUE01UleaBOGBwZL6A/UrrSu42XsGKyr/nhlGIKCnbHY5ZwUe5+q7X0wqBD4oPF0OYX0o2+l2614w/Q9QuxD+nlhM44XTfNtQViAC5sWW2wCtOWRdGwmcqKg7vrpm+2GdUDODp9/XSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nU84ZMLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nU84ZMLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74EE1F000FF;
	Sat, 12 Sep 2026 09:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206033;
	bh=XAUj3LiSob3ZVLhpuvgDCTT4x2rXNbJQV/Ijo2ySb48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nU84ZMLO86BUY84Ux22vn6GnZRBsiEhY7myDpgzPz/Q1h8UPFpnKqD5BO5zivE6q2
	 a2Rsl9q8r5uoVSQruk1tmvxPHcfLEgupIgyX72bSa6AKgg3o0ELDDmWJgT11i/g0aN
	 si0AjjCCEdMUCU5UchhbA5+KVh4AA6y1j4iMCco8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0122/1518] soc: samsung: exynos-pmu: fix of_node refcount leak in exynos_get_pmu_regmap()
Date: Sat, 12 Sep 2026 08:38:11 +0200
Message-ID: <20260912065626.250091801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f8fe1a5965ab4..d910499731131 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -300,8 +300,8 @@ static const struct mfd_cell exynos_pmu_devs[] = {
  */
 struct regmap *exynos_get_pmu_regmap(void)
 {
-	struct device_node *np = of_find_matching_node(NULL,
-						      exynos_pmu_of_device_ids);
+	struct device_node *np __free(device_node) =
+		of_find_matching_node(NULL, exynos_pmu_of_device_ids);
 	if (np)
 		return exynos_get_pmu_regmap_by_phandle(np, NULL);
 	return ERR_PTR(-ENODEV);
-- 
2.53.0



