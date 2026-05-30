Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AAE26738C;
	Sat, 30 May 2026 18:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166348; cv=none; b=juu1SaSVZenw1EOKZ+ymEMZmjmxg7w8Lrj6nqpY+4PrHh/QdADzxlBJl/C/WkuAetvrINUlM7LZwa0Mo26NzIDZCS/mt/LqwsqI19MWgA0wd+mPOemqEXQpXRPF5AqmssgJ1zm5i2QajzIOVn3dtMbWbj0DpYKBCno4aWSmtYNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166348; c=relaxed/simple;
	bh=8JPkAeIMEtXnt8IqPLlYPftTPe0HYtijXZahRjAfRAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9UrLPjrxtJMyfMej9g02qxbwe830CoMUnZ9I4+CaDLRyQJj3MAMWZDwqaC/qkEmp7YjfMPi2+30Mu+ltOiRxEVykXmmTLgnxwtuRnO6y7KBn43SeQHMc+xTUMnAIo7CZFjJWNzHxnROaGiR89it3gzFqTZdd7VgPto7OG78DGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8ly5C0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8ly5C0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DAD1F00893;
	Sat, 30 May 2026 18:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166347;
	bh=YkCy1jMaY8U+Q2I4n0Ou37DrRjy5s9U4v+DcH837RZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8ly5C0yl1IT2CwryC5v9pVz6+C4YWEQn3B4/rPL+8YGuk6GQKB4K+gGC9w3SdOrh
	 k6xZy9Q1uuS44YAKMiTH9PJQqkG0sG53ZMNat61HDOSNcGaIVORfMMtlJR7hd1Khy6
	 2f7rB9ITwgDnH33jG7wtCeAIrn5DtCWNIw3x/RI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 346/589] pmdomain: ti: omap_prm: Fix a reference leak on device node
Date: Sat, 30 May 2026 18:03:47 +0200
Message-ID: <20260530160233.973101236@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
index 2ce8a8f4f0052..240426aceca4e 100644
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -345,6 +345,7 @@ static int omap_prm_domain_attach_dev(struct generic_pm_domain *domain,
 	if (pd_args.args_count != 0)
 		dev_warn(dev, "%s: unusupported #power-domain-cells: %i\n",
 			 prmd->pd.name, pd_args.args_count);
+	of_node_put(pd_args.np);
 
 	genpd_data = dev_gpd_data(dev);
 	genpd_data->data = NULL;
-- 
2.53.0



