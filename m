Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966F130DEAC;
	Wed, 20 May 2026 18:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302086; cv=none; b=DEYA0s++RCTjmHKllg7V8D0QxVsT8SxEmvy5Gwtmh9TXPJC73q1KFaFYuLGZ6agN21IS/80dlXkUFxsPPWyXvTketY/FmwR8x4VCJ1fxGE4dsE3QPm9lNjvxAdXGAOA9yovtekAjO1oXvzxDqBfcqomXr7wnzT+t0vz24xgnelY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302086; c=relaxed/simple;
	bh=Zn+80+r0P9W9fUrark2bSeBjiUMI8Im3uXEJAtGZyX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jvk93aBmiUxJ7xeFCot+GXTWq0uOflsAqejgcMeAH0YpTprSGzc26t94hENUVhzkKR84WMOXgOZfZqnpEo8oSFtiT3AGAOLcqnNEsDn6PJLjMzP2EBCM17Q4YsOcaIDPHrvoBFhP37mS3KNmBnO+K67R4/H/plmj02nX+JwGgBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ne5xU0zH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ne5xU0zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020511F0089B;
	Wed, 20 May 2026 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302085;
	bh=KmN7Mp3G6NQr77U+IIw/WDZwg/4yxFdFe2B/0vIjZoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ne5xU0zHRr9iTOTiAfdNRzWi4af7li31X2fvR3Q8ohzU8uDQFWgzJPB56+vK21Neo
	 I8EH5ow2A1GLxEddukYWYagnuuDyQ4mnDStGxo69H/A0KFrUXDVyh+h/2SgrvHBn/8
	 fEv7nKIa/wUYKmz0CUUaab3SEY5VPAmih00Sr6lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/508] pmdomain: ti: omap_prm: Fix a reference leak on device node
Date: Wed, 20 May 2026 18:19:17 +0200
Message-ID: <20260520162101.533514883@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Felix Gu <gu_0233@qq.com>

[ Upstream commit 44c28e1c52764fef6dd1c1ada3a248728812e67f ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In omap_prm_domain_attach_dev, it does not release the reference.

Fixes: 58cbff023bfa ("soc: ti: omap-prm: Add basic power domain support")
Signed-off-by: Felix Gu <gu_0233@qq.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/ti/omap_prm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pmdomain/ti/omap_prm.c b/drivers/pmdomain/ti/omap_prm.c
index b8ceb3c2b81c2..f4e52e92dcbf6 100644
--- a/drivers/pmdomain/ti/omap_prm.c
+++ b/drivers/pmdomain/ti/omap_prm.c
@@ -651,6 +651,7 @@ static int omap_prm_domain_attach_dev(struct generic_pm_domain *domain,
 	if (pd_args.args_count != 0)
 		dev_warn(dev, "%s: unusupported #power-domain-cells: %i\n",
 			 prmd->pd.name, pd_args.args_count);
+	of_node_put(pd_args.np);
 
 	genpd_data = dev_gpd_data(dev);
 	genpd_data->data = NULL;
-- 
2.53.0



