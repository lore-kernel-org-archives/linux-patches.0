Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E38479863;
	Sat, 12 Sep 2026 16:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229299; cv=none; b=rkR9lb74XtYAin+NWEN5v+qIgv8r7AdnLoLzUxsZ2UAyF/wd+loEienAxa79mlgU3aPDQMGsaUu4bF6z+RzU4OHZDCr6bvvCbmVsnPqX+xb9l6Q2sCiCKErZb5iyq/RY39LGM3+5PCIc+Dp08wQyn38Di5fs2yWiHPup+kAqajQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229299; c=relaxed/simple;
	bh=Tjzecg9TXmPooAhFYY9GvPFvIJcRtXDEHXpL5ASukmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2Wk/M4grFtFbg70fjtqHNs4WEakof0XjoowqGc8Qf1aKUXOh9IEghut5v6c/FoHUIkyvqYyJVbYcYKDM6dhwy6vQMao5WPJ46fkMNtjYVJdeKzTVPSj/2lMISFD9rdlIWbVnX1pAj/mMHmZNz6QsVlGHEv1Tl0UWNO8utESuXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kpn9imJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kpn9imJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513811F000FF;
	Sat, 12 Sep 2026 16:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229295;
	bh=6gomxGrnjtyjckOvwfHE9bTNyZ5aoBIoz537cNMrqZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kpn9imJmbBPjW5I10SMI2xr/x4Kdrc0WkzkSz+Qh8/udPe0GqUsQo1ajnE1C/3Qtq
	 d8/VE+pafBiZLYqeNg+4BTayanMtYJ+o8Hp5uAhoZoVc2fO2j24TgtdCyE7flP+UbL
	 a3rp+CQglfgmU+secx4oZQRnSnGfPu0r/Zpa4y+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0554/1191] clk: qcom: gdsc: tear down per-domain genpds in gdsc_unregister()
Date: Sat, 12 Sep 2026 08:54:42 +0200
Message-ID: <20260912065600.686771659@linuxfoundation.org>
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
index ecc7c67207e0a..d95b90ab91ab9 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -552,10 +552,18 @@ int gdsc_register(struct gdsc_desc *desc,
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



