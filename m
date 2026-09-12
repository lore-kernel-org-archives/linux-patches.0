Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC133911A2;
	Sat, 12 Sep 2026 18:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238321; cv=none; b=sLXNxf0w2QLelchcq69uIDWJa6r6fgRCJXbDFxkpJGUElALH8ZJxFDgoQreGBNibWQ7Xgar0gzz5bB2utt3gr4w4NBwcswvwWfWQ2l+A+mlmRkKyPRjkiCToTnpsmscF3KqTJvFUzGdSKWF91sZ1ApVAKQNG2NbQ3CrKZMBDNbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238321; c=relaxed/simple;
	bh=mr9tGGcg1RUVnORJikQTtf7HkpmeMBoYwB+LDvbNotg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPUXb7T1q61KJEsyw+4aZgpSHjK+1YfOF4y2F+dmdrNGXrzvt2X66dAOvIBGxiYZv9TD2SXk3e5s0tsLlKh02i15ePyJzRaC0nzGm4NxUlaiYOwKJukT8xiHHvRofKfmQWSXe6hDzWyW8EL03KOjR9qBbBBLzMZRErLUvS5DEkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqp9OZHG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqp9OZHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014731F000FF;
	Sat, 12 Sep 2026 18:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238319;
	bh=Kpf4IJdJI5IoVHKU5ymM0bMkDZ+bmjhgSU9vzOEUfHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqp9OZHGY8wWUwSLabs5Xt8F71K3BrnGK96Biog4k4t36siRpihNUoDhC/OtT1MPp
	 GA/TM0P5BeVgGSTLSipLecnvnlOg+x+d4hCrxMlZO61gQ8HM1lDU7k+9KhUQgS5GlO
	 0zueOi2nSF1ghzlOA9QQpqLtapJ/PmluAAAC4njE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 401/935] soc: samsung: exynos-pmu: fix of_node refcount leak in exynos_get_pmu_regmap()
Date: Sat, 12 Sep 2026 08:57:11 +0200
Message-ID: <20260912065536.019592888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a18c93a4646c8..13b33a96b7236 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -104,8 +104,8 @@ static const struct mfd_cell exynos_pmu_devs[] = {
 
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



