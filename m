Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1823B813A;
	Sat, 12 Sep 2026 07:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196944; cv=none; b=Def/rt/YIyXcYI0oIOXimNkPtdw5hXObk0OZrMRde6oF/Jpnzh9wDp0oxXwG4sRYuQZ96NzO3ESI+KolONq0EPNTOo4Byf4AAJnwi3ulQaywV5tJMwd3pl8I8du4xSB0DS2xGxLvIM3/j3VcGXV9n0kg1S3w/N16qbcUqHYLre4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196944; c=relaxed/simple;
	bh=2RkhV2uYqDTWJFOUNlKBRf3LjYtR7hQpDm1+2n+t7J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNyE8AxGxFd7e4zuPczbrJlUqF328SEx3ANRSLiQGV3FCwf0SfPJr76cGfHnEWxFD5+bx4rIPZvuPITrfhfeYj4B2kvRtMWmDsK6nDKR159u/7QZ4QDroyG6ZgbRpZQ4DzSMmHu7/tLDhfVuHk2ZxcMPnugABRsvR10cEeBCBek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWyHCaZR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWyHCaZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304C81F000FF;
	Sat, 12 Sep 2026 07:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196943;
	bh=eHd72daUOufVAmgR6Z/uACugPVfZnavGP7bGwFEKRAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWyHCaZRkyCwptkA1yQl1wvanJPI7sYsVNX0cun6yZrEjsLiBKIEU3e/qIckMhbDN
	 cwIxJ6uhIC4jS11dDmRGcbi0w96EDik1HZSLFJPHy7HDbWgYv4anF6YtqlU+Bdi61l
	 scwpRqY3TFdsWCLwNH7pumL6vfMEk97GzCa86JEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0069/1815] soc: samsung: exynos-pmu: fix of_node refcount leak in exynos_get_pmu_regmap()
Date: Sat, 12 Sep 2026 08:30:19 +0200
Message-ID: <20260912065650.636177419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d58376c38179b..f5fcdde9750e2 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -167,8 +167,8 @@ static const struct mfd_cell exynos_pmu_devs[] = {
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



