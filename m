Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E432A36A02E;
	Wed, 20 May 2026 18:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300495; cv=none; b=ZFf00cvwzjrLk3RxswSwXR9CSbTFjW2YALhfkD+wpmlMwP8Xtc7jkrT4t7nbFvOLoQy/P5jtRX2oYLVJ9RxGO+DftadjAIYGi71vlVz9NA0k0qTKUewqkiGdZNtwRCETmVYmA6/peJmflxEa8h/BJZWUzNd/O9fmz3vEQIOnv8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300495; c=relaxed/simple;
	bh=pelow93vsq8E872PIih/Xa67i/4bN+Ul/FyC8FzUc6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcUwYSUcbRWHHnJcMKyGdVx/sq34MAmBTo4rsrBW+KSp4JXLtCQVVoZlTPmoVwvGyKUWQhZfZoFIBMtQqgqlbducPCa1fmZqB6llPpVHVlqhYlLDelsw9TVk5xLjAcoFldfVngLGBXeOTDTkz7VVUFqvLx/Sv1vK+H8SnI1TCuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyDCbfQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyDCbfQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9661F000E9;
	Wed, 20 May 2026 18:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300493;
	bh=+uPNBo80AEP9zpfJdRuGaoRT1jPzATVrbFVq7bv33Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IyDCbfQI171+AdV9k2cCzE5YBeIC+m+N0gNfKsBkfiZad4ONfppYZWpPql+/CTYQ+
	 nXWVPgNXxfasGSdXYIYA4htqyRzyk26BwzpRhOaJOKjgUCJ4V+z0RaiP/b/BoZKXbi
	 OCH7YKgZuTE6iCUx8x/gaYNy3upAlYmGmyiBhN+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/666] pmdomain: ti: omap_prm: Fix a reference leak on device node
Date: Wed, 20 May 2026 18:16:46 +0200
Message-ID: <20260520162115.427401430@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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



