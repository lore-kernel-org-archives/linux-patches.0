Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCB83EAC83;
	Wed, 20 May 2026 17:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298095; cv=none; b=M3X3x1UdYE5ev3WIu7qL60PLn8uf22KExRzN4mdqL4jgPQIfL17M/o9F+Yyj9TlD5fUu0q4ybPCr9oiEE1UH25qayg+tZLea7jAKZT4zS6Tm4HEiExcqQx9Pu1AXnEGWetTseqCAGXH+wY95a2Z/jgQBwcBwUikizJUXfUJsBZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298095; c=relaxed/simple;
	bh=ul9IEcf+goZL06I4V58bpibCH7XXAPTfwqESEYV881w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwMU2xRg+3mpaljf3t7T34TTibzmJbBARB9zKGY6O3y3u0VWLlu05WHGmG/QLQS6vCne1QwINlOud57o0SeoQjryL7neOghXHykBQRDWMmnMnrqBTDKH+PcCxAm3YVC3sjkSDUBi6YXtEHdD+1AC8zxxsz7Gq83qbYvctzzyWY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDl29f5r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDl29f5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF461F00897;
	Wed, 20 May 2026 17:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298094;
	bh=GkNPnKgjV2CvtwRux0oP/ny6rsAUm9Cop8190kWlrfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDl29f5rwUAfwjLJ7Ptikm3ZBZM/DBr88AqHl/lTEweydLiSxLo4SvPDNfvSKZwaE
	 KJtTfaJCwcTAdvWjGe4kJWulzrVO+l7JEa+M77rNp7G020oaUAriRy5PxcER7eqI/P
	 wjkjiP2CiHeNkkPKObqurrRSglPT4sk4GBrclAmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 280/957] pmdomain: ti: omap_prm: Fix a reference leak on device node
Date: Wed, 20 May 2026 18:12:43 +0200
Message-ID: <20260520162140.612085152@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 5142f064bf5cd..64a187f79a1a7 100644
--- a/drivers/pmdomain/ti/omap_prm.c
+++ b/drivers/pmdomain/ti/omap_prm.c
@@ -655,6 +655,7 @@ static int omap_prm_domain_attach_dev(struct generic_pm_domain *domain,
 	if (pd_args.args_count != 0)
 		dev_warn(dev, "%s: unusupported #power-domain-cells: %i\n",
 			 prmd->pd.name, pd_args.args_count);
+	of_node_put(pd_args.np);
 
 	genpd_data = dev_gpd_data(dev);
 	genpd_data->data = NULL;
-- 
2.53.0



