Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B7438F945;
	Wed, 20 May 2026 16:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295296; cv=none; b=Xoa+RQfvStTarnmUh0uk56gDDqNCO2ZzQAQVfDEe04ukr4qqU/jK268LVb2BU49NicHsREzfFFfpFhKRE+Z71yxPxDKJxy9MBNy0tJv/6BM7xFPseaWMhfMCtLO7u+5Oig+7NsLbO7EkoQABXj+rlR8q/CgxidO92sBgl0Fijmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295296; c=relaxed/simple;
	bh=t5Gxr/9B4lfcsBGrQa0Ca8uMEwjHsxDmVVvNGg5xMi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9VI+Xlezcr9DKDU/vLT96z22Hj1KlDTGarEpkmaRwqVicB1Jtqi7YIIQ8rakhSLrNF2yDj9k5It4VZSa2f+E7kjp5ibkdg1vq43UVvvW6rIEimrR2IlmEJ7TiM+9a5DPp1gT3ED0pIxrmizfD7/ToxMAv1ZAbo2kcDNjvFjTeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUakouNw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUakouNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FFA1F000E9;
	Wed, 20 May 2026 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295295;
	bh=/h9GuD8Ibyx0fh6OjNY3XRisXlLV7nLIogoP8y0rJbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUakouNwhciPa+IQbDNFrAdDg7OgsJrXOkgeqNttKniTUP3bCUNIBtI9P6J3/+rHr
	 mjWEuklKBvYhPUkpWpotNUCg/+fzucqesTmOmCV7tA51LTeF1jmITevS41sKDUADbS
	 EIHpoqi5Wu6El/SjXykwOvjd5FrV9vBpQ36yqXug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0365/1146] pmdomain: ti: omap_prm: Fix a reference leak on device node
Date: Wed, 20 May 2026 18:10:15 +0200
Message-ID: <20260520162156.460936744@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



