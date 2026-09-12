Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA073A7F47;
	Sat, 12 Sep 2026 18:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239191; cv=none; b=vGNpL6WucIOxzEHbCPYvUaxCZI5OgFYwlsftWGKVQMBC97gxa6AZs3n/OkYVqFFo5KX8TtEvh9qidaApjDGPj2AArk1jnWhbtUAVJuuwJ/rK5HvZVIteksZBJRWaTGBCnMMwIAtTatl41T6divwVgBmntxatQtmZg0BypEteC/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239191; c=relaxed/simple;
	bh=XVh2/UI153+yVebIXvuYd90DpjX4fc8DqngwLXrBg4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoKglCEKUNknFnPWaANO9vErpbKSDXYojlv2ScrEpKob6J7Cznfu1sNVsOsZvVyA7SlQ55hyr9sB8/lFPBsixFPv/N5iVHJdEdBb2NJNS8WMkfz4NAzhGOXFaklUCVXP0XD0AaRl4jrvQYWcx5mLgUTG2G/4GIOhkMhJiNva4CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAAkJwDF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAAkJwDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A231F000FF;
	Sat, 12 Sep 2026 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239189;
	bh=zMsVTHcwjG4mzkT7jXCQxzXdiYh7ul0yGl3IpJEW7Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAAkJwDFbWIrKr+7LzCTg6Ch9848EKr2Wu9bcp4UC5jf+gArxuFnRLZUUZ2oDn6zl
	 /CJZvEF3+N+1X6UnCRNbZhdFkrwKDylhd1ooLvWHyVi7MVHaVDruXBir7EKe9fxLaU
	 b+Atd+D4xX4joNkYxCH8tJInyIRZzjNPojJwXiuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 613/935] clk: tegra: tegra124-emc: put EMC node on register failure
Date: Sat, 12 Sep 2026 09:00:43 +0200
Message-ID: <20260912065540.901488612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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



