Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D7F26ED46;
	Sat, 12 Sep 2026 19:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242434; cv=none; b=IKtKhCvhRFARfnEkBRLSJ7vLTF7mM/NPhtklp/eKYybiUd9l1z+l1a4LTTA2lvusKIkETsjbEtN8/ZvBpODmvu2WH9FZ1TSrzmPrht6kI9nHFVuFwoCfNTjAokfnj1iqNYcrdpIHw/sbjf1lDdfqIZZh+e55uUL1fjYgSvkwAhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242434; c=relaxed/simple;
	bh=jX7wAia6zNSJEcPsCppXmRNHR2/y8VTbws24y532S6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBE82qmfgDx2J4NQfXgvfksnETXFj9EJQjpBF94d84heqHG55m8EDgm2+ayyb6Re2gKEtk3Bvxut1AHeTZdq4LxqA3drq5GvcKhaZ6NxNkpRYQER4fTSzCWx9s4Y7zIMQuvAodvDnrDakez9PAxM6OAEp2j4owJ6xj5zSdJKUfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWBiLXfs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWBiLXfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1421F000FF;
	Sat, 12 Sep 2026 19:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242433;
	bh=XLg0eeJKzgc2IPGXD2HWp1/2/mOmMuOkVbcHWOlVO0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWBiLXfs/xPEmNn9JKeKdY7cUEzb4rDJ6+OeHHYUK42Q7omaLc10iLoZc+y1uRRS3
	 W1cxHNPD0si9Xx851otgb8B+KlZKft/xTtEsQL96ou0tswcX+1Us4OZjS09bILMAfw
	 M9Yy3yxe3T6oPwBOwZovgQEXP8L8vINlmQPUBUKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 402/798] clk: qcom: gdsc: tear down per-domain genpds in gdsc_unregister()
Date: Sat, 12 Sep 2026 09:00:30 +0200
Message-ID: <20260912065526.362458845@linuxfoundation.org>
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
index e8b2c365e75f3..4b6dcb0aade11 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -558,10 +558,18 @@ int gdsc_register(struct gdsc_desc *desc,
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



