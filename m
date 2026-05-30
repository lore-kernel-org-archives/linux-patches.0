Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B34023392B;
	Sat, 30 May 2026 18:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164144; cv=none; b=iE1Hhrk1nV1BQap6/x4jfaio2zMbkHElS+9llwZ2+lss7jXTBhO6cC9vDLi5SWWvZG02mblzSWrIHtO71SnYoOTxIb13T8SlfxtjioNx4/5oAgxEn1InNc3EUpPZeQ1QEf3kih853mM3uRkWE4LglAq1nVN/YSpkdAjZ1FFEEQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164144; c=relaxed/simple;
	bh=2Ospk2pu81np4t6CHbbHyOrldAb0crfEq886PDnQLJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2betnVAFY4T2Y4jB7vYipbxhpuPmB3riMy0JM46L9Y8I1iGpFN1eIuzNobw4W+5OqJcYsX+jrfAy9C9dnDavzQ9pqmTV6Jq4OStLZoUaBa5c4GiklU1bIDRLy3BmxST6Afu18rIAl9n1bgHUCRCXlqzHV+sjScMjzhe9i6tphw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQsJTaXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQsJTaXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E38F1F00893;
	Sat, 30 May 2026 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164143;
	bh=fjWWD1r0rEq3SDSSu5J2hBNR1+WfLEjhWHfQzM2qb48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQsJTaXhLcrTFRED7GWpSAXlwVYvh9Zwfli28qo2D14CYy/dVy3C3H7LWQ0McNBZC
	 Zi+dBgxxQLEFfujwGDlLwt2a3m78g6CXHwwLKlICliy7nRNFjdqK9hCTn4LrNGysJG
	 MeoBcVrwF9rhYGoN6slojl4Eo3paclXASS0hOGyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 460/776] pmdomain: ti: omap_prm: Fix a reference leak on device node
Date: Sat, 30 May 2026 18:02:54 +0200
Message-ID: <20260530160252.252439681@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
 drivers/soc/ti/omap_prm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
index 544e57fff96ca..f3e5eb8232314 100644
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -656,6 +656,7 @@ static int omap_prm_domain_attach_dev(struct generic_pm_domain *domain,
 	if (pd_args.args_count != 0)
 		dev_warn(dev, "%s: unusupported #power-domain-cells: %i\n",
 			 prmd->pd.name, pd_args.args_count);
+	of_node_put(pd_args.np);
 
 	genpd_data = dev_gpd_data(dev);
 	genpd_data->data = NULL;
-- 
2.53.0



