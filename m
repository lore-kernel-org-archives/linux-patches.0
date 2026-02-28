Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5AB47CC8B;
	Sat, 28 Feb 2026 17:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301365; cv=none; b=osPU+5Ay+I9ae3IvJAx3ULCWfp4dHTlTEmijGmxHekKMqlUQCBmAR3q5VipZ3tn9LHVD/+99bWbdPRZFJHyB2wuogBeSruF/zlFmNSXqx1qKggzp9t1ScmYZoXtyOiOlx84gtlSNxPJPuIVWMexne/kXLstTEllP8EDJ/IrqPzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301365; c=relaxed/simple;
	bh=4wwd9lAtfAx/5nuKfXxd7IZ69+OJygCwQdi19XSC14k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQUh5MlnxPBDGIUb3/iMMYsx6lIztKK5uPmgJBTBJNDGphW60TbouBjidXQU9LGKEWGKq4QWARGncIewk7jK2GdejhWHp9eS6iKfnTcJD0/2MzAhjAH74Scdwy0eitzH0zrZem6OiuhwGbFzpVQAxv7BzIO3xtpkUSF5ePqOa6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMItvBJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMItvBJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4DCC116D0;
	Sat, 28 Feb 2026 17:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301365;
	bh=4wwd9lAtfAx/5nuKfXxd7IZ69+OJygCwQdi19XSC14k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMItvBJoK0FQt6pN0shtNiTMLFMbkBGvcj2DLb9ARW+ZtaU4re/LdMS11ykNyG5uv
	 n6XzHr1OIEPRdF8Ni7hbQ4k1nKWfc8807ODihRWxBwVpzxxudGUcfzWGZNgHxFWBlz
	 kQ0aMEXYG8GL4qoi1c3ZfLEVvvZOYCG+Ql2/pdxFtC2DyUWhV5UBOjuUdhv7/kL7pu
	 7pDmf8JjmQa8lxMogyEO4JdND9MWeBWa0OArQCuZ5dvyKTXnuJefjQFp0rV617M/6X
	 CiZKYZA/s7pZvGnKgHIqJytevM+OOEDFJRCDrmiFVQrWW9GDupnBgN4SkOA2XfJz+o
	 NpSqpcVV9Ly8w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org,
	Brian Masney <bmasney@redhat.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 554/752] clk: tegra: tegra124-emc: Fix potential memory leak in tegra124_clk_register_emc()
Date: Sat, 28 Feb 2026 12:44:25 -0500
Message-ID: <20260228174750.1542406-554-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit fce0d0bd9c20fefd180ea9e8362d619182f97a1d ]

If clk_register() fails, call kfree to release "tegra".

Fixes: 2db04f16b589 ("clk: tegra: Add EMC clock driver")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra124-emc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra124-emc.c b/drivers/clk/tegra/clk-tegra124-emc.c
index 2a6db04342815..0f6fb776b2298 100644
--- a/drivers/clk/tegra/clk-tegra124-emc.c
+++ b/drivers/clk/tegra/clk-tegra124-emc.c
@@ -538,8 +538,10 @@ struct clk *tegra124_clk_register_emc(void __iomem *base, struct device_node *np
 	tegra->hw.init = &init;
 
 	clk = clk_register(NULL, &tegra->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
+		kfree(tegra);
 		return clk;
+	}
 
 	tegra->prev_parent = clk_hw_get_parent_by_index(
 		&tegra->hw, emc_get_parent(&tegra->hw))->clk;
-- 
2.51.0

