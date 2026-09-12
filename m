Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71042F531B;
	Sat, 12 Sep 2026 12:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216322; cv=none; b=jXBmNHniMSXios+PoGjzPdToq8Hidcj0PB5TD8NAZhw7TnpDFEjvFevfalhfqZnsUDAdYWUu7/kveb2kRJFpOAd1TCM/3zuzDLVCqAO8NeWIDP4nuYNpOBIZYZpGsnyEDGSeT6A3RhI8uFKFSx/rHwPKWGEij0Mpz2bbhgmEfuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216322; c=relaxed/simple;
	bh=wtYGgF8sUQFGXrk4OMrNXXQTjz2UyXXBZreGP7MigQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIR85vG8oF1lhLynVLxskY1o9qRx02x6XBD6qiUdhP4TbnuRwULtHI7baMZK6PDikzMiIjMjDzxxbwcp8mlaCAJpX+bk7R9mI11fW+N3b7Z/nsS7mxIRocHP2gskdLt/81rm3TtnDSnBuxTQIJ6QtJNZ4QfgDZtEyIxiepqgP0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbN/QIQm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbN/QIQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4341F000FF;
	Sat, 12 Sep 2026 12:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216321;
	bh=b9E/ja0uS3pc3LKKuYdrm7xitJkLmJlJ9/D+NgWJmfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbN/QIQm9+ZqjDw4ki3N+kctIwQBAK214o1rHUgU6cbFI0qitW6gGHkCJ6ii/RHU3
	 hCxhhHwyE1+uRQsnhOKZlifxGAqb5ipIS598DtZXwO8N+7FRqc5ZvFubptvU+T9DgG
	 LSex7GTbDPJb5JvxITPDBeYlB+FMfRcjk+j8MC3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0714/1376] clk: tegra: tegra124-emc: put EMC node on register failure
Date: Sat, 12 Sep 2026 08:52:20 +0200
Message-ID: <20260912065623.455586991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 5f1af6dfe7154..674aef2785394 100644
--- a/drivers/clk/tegra/clk-tegra124-emc.c
+++ b/drivers/clk/tegra/clk-tegra124-emc.c
@@ -539,6 +539,7 @@ struct clk *tegra124_clk_register_emc(void __iomem *base, struct device_node *np
 
 	clk = clk_register(NULL, &tegra->hw);
 	if (IS_ERR(clk)) {
+		of_node_put(tegra->emc_node);
 		kfree(tegra);
 		return clk;
 	}
-- 
2.53.0



