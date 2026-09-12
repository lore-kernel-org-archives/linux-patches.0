Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7F93909A5;
	Sat, 12 Sep 2026 19:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242883; cv=none; b=VI3VJbs/IelSYwo2WdRxIWMuIHvIFjLbMrsPYlOQtfg9uaBB4KzMMI3ZigzXsLXl1FPemT2h+8YUQYEiGlZy74HRnKaaLcy64hj/5C5LR8sMQs3lawzgfGhHbfXMrQXC55wlMMWrDGl+Pu/FmdWgw+WH21UZXjsV4vpLKoEvLDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242883; c=relaxed/simple;
	bh=mt3IQVMp1JIicnzxielR1PkBnawJVzhfH8bDuhU3gO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4Tx9pG6sLc9QlEty5hIDCJ/r5DjByCTculJb/Sqc025cZ4twqoK19+oWMss573TvRjDCXZzPYsRVHitK6+HRdw/Onfn36+QyGdZDcHTvq1n6TUr8o5zf6GbWnUj448j8u+FlyyqYzijunQNK2YsPU3R3dqlwHeYvsXnnuJbai4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiZdT1bT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiZdT1bT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772EC1F000FF;
	Sat, 12 Sep 2026 19:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242882;
	bh=pdNFOJ5Tk/UbVTKgY1J7aCBMEijt1oCRtXirxwrULKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiZdT1bTf2xdeIS7JtIkEM98GuZ5fFtz6be2TyE3D1t1sNiCv8RvJ3I2WLe/X2K2d
	 hyLFhd4imfHIFmpvyhKztz0gh7HRlSDg+fFWLH9O6mbgniu96vQZ9C5Kup+35vYqE7
	 BTNFN196tdzFV+tlWhyhZfjD9CnXhPGQOM4r8WtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 529/798] clk: tegra: tegra124-emc: put EMC node on register failure
Date: Sat, 12 Sep 2026 09:02:37 +0200
Message-ID: <20260912065529.257409068@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit f726279f5eab813f9a8b6f38ddf2a4b062d038ff ]

tegra124_clk_register_emc() stores a device node reference returned by
of_parse_phandle() in tegra->emc_node.

If clk_register() fails, the function returns an error before that
reference can be consumed and released by the normal runtime path. The
tegra_clk_emc object is freed on this failure path, but freeing the
object does not drop the OF node reference stored in it.

Drop the EMC node reference before freeing the tegra_clk_emc object.
of_node_put() is safe for a NULL node, so this also covers the case where
the phandle is absent.

Fixes: 2db04f16b589 ("clk: tegra: Add EMC clock driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra124-emc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/tegra/clk-tegra124-emc.c b/drivers/clk/tegra/clk-tegra124-emc.c
index 4e2fc9ba2b211..89192148b8c43 100644
--- a/drivers/clk/tegra/clk-tegra124-emc.c
+++ b/drivers/clk/tegra/clk-tegra124-emc.c
@@ -530,6 +530,7 @@ struct clk *tegra_clk_register_emc(void __iomem *base, struct device_node *np,
 
 	clk = clk_register(NULL, &tegra->hw);
 	if (IS_ERR(clk)) {
+		of_node_put(tegra->emc_node);
 		kfree(tegra);
 		return clk;
 	}
-- 
2.53.0



