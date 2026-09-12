Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D86479892;
	Sat, 12 Sep 2026 12:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214439; cv=none; b=nWbY5hSnop3Ez16YDhKDi6nzo3QYZ2n3XGixk7/fsW9ioi7OgAADYyRwdwvJDaB0PGrEA49rtXT4oUlpZuhrBWXHqj5CQ+oVB8ZWnEb1Infj11rKuU0V5bJqVwj1jxk0XkB3vGbYroGETvt07y4+kplc0LXUd20F66Kd6GtMKEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214439; c=relaxed/simple;
	bh=XgC3Lrj4HMV5EWlfLZQ7vShgCfj2/7vQn/lYfmha6wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKHL1DaPxG3BhEHpxtfofmitMAQXEIwG/jCXNEBv4/OKNxEdb8w2FYaO4nqlL+XKHZOEsdfLbu0/mxskjPcR05y+fTZU4vt5n0dyxWf51C7qemXzcefOYPTT/Nr3A2CYutbrOiOnAltMKnuMDZ9kNX8q7j+7PzKcsjtOf6vONI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsM+xG23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsM+xG23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE67C1F000FF;
	Sat, 12 Sep 2026 12:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214437;
	bh=1gSOoneA+QrGL27Jt+FdBFV0KDmpjDcjKn64D14csLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsM+xG23k2XCDb3mOJv9Kx2fe+84u3Hr2jtrP4fV1HauIHSeJfTxfXX7ea1OmPKzE
	 62bl4x3O+sYC63G0eHYeWFerwHcTmN0+8qFs/YHhFRpw27RjWzL0X3SEczO6UejgFL
	 btljzwn9VyXQe8JVLeskPttJXhi4/4wZiobcav5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0324/1376] soc: samsung: exynos-pmu: fix of_node refcount leak in exynos_get_pmu_regmap()
Date: Sat, 12 Sep 2026 08:45:50 +0200
Message-ID: <20260912065614.768541859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7291c2fb14d70..a294018ed7584 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -276,8 +276,8 @@ static const struct mfd_cell exynos_pmu_devs[] = {
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



