Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2F7242D65;
	Sat, 12 Sep 2026 14:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223019; cv=none; b=I7l85IPis7pbck4LJyp1HuJMY42kK9BnUe6vzwVGwp1Pjmd9Y3wRwPy+AFjiCiRETZYpExCE5P1Dwky+VOlmegYS7Z4u0vfHmWAuDv9MWkCSNZxZP1wIPTbKcTvtMaSRqF0SSuhkIdxyVWBK5CIHvx9+ryg7h4dCA6KisU2B+gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223019; c=relaxed/simple;
	bh=/9OjfVh6grx4MA60PIrBofOi0OELR03DQfJP8o6nWc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5TwMbURX5Tqbi6mlCsDPIwKufc5GVRJvTL63Eq0Pjyq8ky35NwG7NYcfOGVxZ4Se/m++iMNNy9IQLUnO5Oe/ZkxDaiH2R/JYE6qsReSP996jrhoMVeSeb+rDjw6jVaCF9AKxTqCY7RaPdT7mTy/w3NHPMgZRiIs6xmcJRqZe2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buT2t4hb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buT2t4hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917421F000FF;
	Sat, 12 Sep 2026 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223018;
	bh=Xk2QKkmvro6rYY9czoAPP55CkYezaBOrrpnEjfhqlbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=buT2t4hbGdYBRyXMfsi7R5U+QPyUFrZF3sUJ4ZLPBGCZUGauZl1exRiBp4DznP/Y+
	 v5Xv/Q0zasFF7Nc5kUzXvLA4b1HG1R1oVJUg+r/0CcDUyK3FflhcelY5M5dw+se8XA
	 UZ2OC0CX67Yu9Sr5gHYn23nIxrDsARAIQKmUdy+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0677/1424] clk: qcom: gdsc: tear down per-domain genpds in gdsc_unregister()
Date: Sat, 12 Sep 2026 08:51:49 +0200
Message-ID: <20260912065622.461050264@linuxfoundation.org>
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

From: Herman van Hazendonk <github.com@herrie.org>

[ Upstream commit 86b23609d5e17a770d03037e53c6a443e742a6e6 ]

gdsc_unregister() removes the OF provider entry and tears down the
parent/subdomain wiring, but never calls pm_genpd_remove() on the
individual generic_pm_domain structures registered by gdsc_init():

	void gdsc_unregister(struct gdsc_desc *desc)
	{
		struct device *dev = desc->dev;
		size_t num = desc->num;

		gdsc_pm_subdomain_remove(desc, num);
		of_genpd_del_provider(dev->of_node);
	}

That leaves dangling entries on the global gpd_list. After a provider
unbind/rebind cycle (deferred-probe replay during early boot, real
module unload of a clk driver that owns GDSCs, or an OF-overlay tear-
down) the next gdsc_init() will end up trying to re-register a name
that is still in the list and pm_genpd_init() returns -EEXIST.

While we are here, flip the order so the consumer-facing OF provider
entry is the first thing removed -- otherwise a fresh
of_genpd_get_from_provider() call racing with the teardown could
attach to a domain that is mid-removal.

Iterate the scs[] array and pm_genpd_remove() each registered domain
after the subdomain links are torn down. The regulators stay devm-
managed (devm_regulator_get_optional() in gdsc_register()), so the
release happens automatically when the underlying device is unbound;
just the genpd accounting needs to be undone explicitly.

Signed-off-by: Herman van Hazendonk <github.com@herrie.org>
Fixes: 45dd0e55317c ("clk: qcom: Add support for GDSCs")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260602140934.796697-4-github.com@herrie.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 7d1fc7a2f678b..e564bde202e2d 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -554,10 +554,18 @@ int gdsc_register(struct gdsc_desc *desc,
 void gdsc_unregister(struct gdsc_desc *desc)
 {
 	struct device *dev = desc->dev;
+	struct gdsc **scs = desc->scs;
 	size_t num = desc->num;
+	int i;
 
-	gdsc_pm_subdomain_remove(desc, num);
 	of_genpd_del_provider(dev->of_node);
+	gdsc_pm_subdomain_remove(desc, num);
+
+	for (i = 0; i < num; i++) {
+		if (!scs[i])
+			continue;
+		pm_genpd_remove(&scs[i]->pd);
+	}
 }
 
 /*
-- 
2.53.0



