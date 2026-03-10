Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9871E38A70B;
	Tue, 10 Mar 2026 11:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141983; cv=none; b=mlcoYIG032vLqTqLM9L8Sz4YGDqBr1f8lEsOsClSjB3x9HAQgWAOiLF5PWSS1GvR1KLUqdLpiudFLQ9jdRqHlQuv0XjXxTmyBFKy5aSIzi2UHmvS5ZbfPRGlLUGQnhPOiZW7QxxD7sRN1hQe7SsSmlqVr2DxtwUuEbb5nFCLP5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141983; c=relaxed/simple;
	bh=0MEsXN5AH0lIkGP598z4YSPXisf20/DS+OzSmpQsEhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIlmjWWM9m2deVbhDUwWSjNlZT+17Ls0VFaWu4pTv2jlP3Uee4+go5sfBa12S2Afr9kUjcgj1lOFe8WrVoP7luJCDzmAF17qncqkS4dcLjyc5OHZ6Kf3HYOs+N8gE2Td0q1oMhKubUc28SWWPFI+PebXB8jOj4T1aOGmyv2t8CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=or/zn9+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="or/zn9+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5E0C2BC9E;
	Tue, 10 Mar 2026 11:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141983;
	bh=0MEsXN5AH0lIkGP598z4YSPXisf20/DS+OzSmpQsEhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=or/zn9+IIjrY0Kgf+36Ewjakldc11j6GchHb17RvSAKIhRUs3NitP/CsV3cgCjDKG
	 Ehw5IaPja/gxVuvH+rNuPIzUs+LIwIh24fdYKQVizWbaoe4B9+lh4PQY6Ph+2Vdp36
	 uOt977fTvjABjM+nBw/1VyYVDqhwbiMsc09tEbqlKDade5Z3osy434hIOzY4ftzIV0
	 DqMtEzuMcSHgz6iZX1RX3zKnKyQFHslgaSBO3MqPJx9jbLSqIYD0KAM4d7WozeNBLT
	 M6q7Cabg2eI9ONO7ZNEfOpOiboIkDhp0V4smd4N3gAnkSFw8qPR1lvswlwiCd0hdTy
	 EHK9WzoXa8VpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johan Hovold <johan@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/314] clk: tegra: tegra124-emc: fix device leak on set_rate()
Date: Tue, 10 Mar 2026 07:16:07 -0400
Message-ID: <921b0a49c7860bddbc0b0b2cddeb0237f5c98c72.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan@kernel.org>

[ Upstream commit da61439c63d34ae6503d080a847f144d587e3a48 ]

Make sure to drop the reference taken when looking up the EMC device and
its driver data on first set_rate().

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: 2db04f16b589 ("clk: tegra: Add EMC clock driver")
Fixes: 6d6ef58c2470 ("clk: tegra: tegra124-emc: Fix missing put_device() call in emc_ensure_emc_driver")
Cc: stable@vger.kernel.org	# 4.2: 6d6ef58c2470
Cc: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra124-emc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra124-emc.c b/drivers/clk/tegra/clk-tegra124-emc.c
index 0f6fb776b2298..5f1af6dfe7154 100644
--- a/drivers/clk/tegra/clk-tegra124-emc.c
+++ b/drivers/clk/tegra/clk-tegra124-emc.c
@@ -197,8 +197,8 @@ static struct tegra_emc *emc_ensure_emc_driver(struct tegra_clk_emc *tegra)
 	tegra->emc_node = NULL;
 
 	tegra->emc = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!tegra->emc) {
-		put_device(&pdev->dev);
 		pr_err("%s: cannot find EMC driver\n", __func__);
 		return NULL;
 	}
-- 
2.51.0

