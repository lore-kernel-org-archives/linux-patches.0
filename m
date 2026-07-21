Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6776546A610;
	Tue, 21 Jul 2026 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649504; cv=none; b=Bvve2ncGsDQAnP31MYAiu6y0LfftH0mFFEVR9s7RYcdcC9gOaT5YI4svqJJJfxXrH+M8oHGFwQIueHY4Goyd/yKP67uFjwiAJHzDX6GCkYVc7djT1IYlzbYYnDloWUoSJUVyr3Nks82gPpyKyHdgS1M2sVKYJ68gVos0TG6llbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649504; c=relaxed/simple;
	bh=LWRIke1nQ+nmJqYhR0cyKxscJTTAPqcjmtCKQxxFZas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJqKmX1OxEhcTNDNrGoNXspPco1gDv67RV81lijiy2hyKrAoTJGkGWmS1Wkup7seVarJGqElntJ/9sjL5jrI8KE3jnWcObul246y+NLIcgbKqAjk+Hgou7yW9ffH4Ruy6WXfGJtKiovYBQguBVIupGX7E/5SoeFQ/6P3CYDvrWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVvlpwL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVvlpwL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF6B1F000E9;
	Tue, 21 Jul 2026 15:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649503;
	bh=8QZdw6+KQ1OlyjvbkJF0+diT+GFfDZbZIf5o4/SslAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVvlpwL3FIlpD3BzhzkY61ddl2/aIg9SqmYdDqxOASHcyl8zhp2xA0cPSvC22vDzX
	 5BTJO8AbrhBcPyy3oiCpat/ydYmMthpEW2TJkcf5GSrmZOCTzq81MAOU7GWJ8iby8O
	 UvbRUcuR2C87ncvEFeinNfEIrm7jHv3LefR+XDEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0604/2077] memory: tegra186-emc: stop borrowing MC aggregate hook for EMC
Date: Tue, 21 Jul 2026 17:04:37 +0200
Message-ID: <20260721152607.056065436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit 2e05f3d6005d9aa3e2e423d2471f290d9ccbe3d2 ]

tegra186_emc_interconnect_init() copies the MC's ICC aggregate hook
into the EMC provider.  That hook (tegra234_mc_icc_aggregate /
tegra264_mc_icc_aggregate) uses container_of() to recover 'mc',
which is only valid when the icc_provider is embedded in struct
tegra_mc.  For an EMC node the provider is embedded in struct
tegra186_emc, so 'mc' points into unrelated memory.

This stayed harmless until commit faafd6ca7e6e ("memory: tegra:
make icc_set_bw return zero if BWMGR not supported") added an
unconditional read of mc->bwmgr_mrq_supported at the top of the
hook.  UBSAN catches the stray load on every EMC aggregation:

  UBSAN: invalid-load in drivers/memory/tegra/tegra234.c:1104:9
  load of value 112 is not a valid value for type '_Bool'

No functional impact in practice, since the hook's only other mc
dereference (mc->num_channels) sits inside a
TEGRA_ICC_MC_CPU_CLUSTER* branch that EMC nodes never enter.

Fix this by setting the EMC provider's aggregate hook to
icc_std_aggregate, instead of borrowing the MC's hook.  The MC
providers continue using their own aggregate hooks, where
container_of() correctly resolves to struct tegra_mc.

Reported-by: Jon Hunter <jonathanh@nvidia.com>
Fixes: 9a38cb27668e ("memory: tegra: Add interconnect support for DRAM scaling in Tegra234")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260527140127.49172-2-sumitg@nvidia.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra186-emc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/memory/tegra/tegra186-emc.c b/drivers/memory/tegra/tegra186-emc.c
index 03ebab6fbe68fe..f71265b303b976 100644
--- a/drivers/memory/tegra/tegra186-emc.c
+++ b/drivers/memory/tegra/tegra186-emc.c
@@ -258,15 +258,13 @@ static int tegra186_emc_icc_get_init_bw(struct icc_node *node, u32 *avg, u32 *pe
 
 static int tegra186_emc_interconnect_init(struct tegra186_emc *emc)
 {
-	struct tegra_mc *mc = dev_get_drvdata(emc->dev->parent);
-	const struct tegra_mc_soc *soc = mc->soc;
 	struct icc_node *node;
 	int err;
 
 	emc->provider.dev = emc->dev;
 	emc->provider.set = tegra186_emc_icc_set_bw;
 	emc->provider.data = &emc->provider;
-	emc->provider.aggregate = soc->icc_ops->aggregate;
+	emc->provider.aggregate = icc_std_aggregate;
 	emc->provider.xlate = tegra186_emc_of_icc_xlate;
 	emc->provider.get_bw = tegra186_emc_icc_get_init_bw;
 
-- 
2.53.0



