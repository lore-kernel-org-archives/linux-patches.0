Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3434E3EEAC7;
	Tue, 21 Jul 2026 19:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661639; cv=none; b=c+s23bi5zqlVIHkQ5Fzg+QNWlN0rKBR518I6a0ypK0MmMT+OrLOCGcFpuEAC7IN9pG8m3p30tKOZ0wHzlYZGimm8NZ+ryng3tMXWubzXLDcojtfIKWy/TE1ezgiZ7gr2UzpaagTXS7fzabSGgOYIS7JUdmDWlST71UO0Ay7MMdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661639; c=relaxed/simple;
	bh=11uKoWHwvTjjDHGpO3gTLvVyVewTQbaIuINsLnOrPXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz7vyLFMKfPpZVjGGSmMh92ezM1+/PEhIEuyjwbVLB3VC7ZpeA78jmKIecg59yE5pbhqQDhqzUr6jJjO9mgDX94+bxXLIltE2Cl741vr6MI/nrZeLMwGdOpHzTJoGKS5Zq/kaT6Nu3YfBlg260WeTUPg1bPibMWWxKhDgFarJIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUI7O1FU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUI7O1FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA251F000E9;
	Tue, 21 Jul 2026 19:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661638;
	bh=JGywkNRYDiCX1AxttgmtdLM/ZxhiIn/8s4Azo6H7ziU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUI7O1FUfe+v0nSTxEVMnG8hPLBoP4iPHf1Je8TURTFl65ZHsWA7Wb5WIKJcJpKDq
	 d2dRSqMzDcPU7ucaNHFkwVausfQbtlUn2eqlRUWG8/Vv3iXjWiy8EARqrTAhySkAJh
	 fpgbRAiIyrPPn3ri/8Gzhv6mKZc1AbqqXlJeTpaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Mhetre <amhetre@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0089/1276] memory: tegra: Wire up system sleep PM ops
Date: Tue, 21 Jul 2026 17:08:52 +0200
Message-ID: <20260721152448.087255837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Ashish Mhetre <amhetre@nvidia.com>

[ Upstream commit 2411c8d1e3e09910e94bab0d0a2c071fbc8a9e7b ]

The tegra-mc platform driver does not register any dev_pm_ops, so the
SoC-specific ->resume() is never invoked (e.g. tegra186_mc_resume) on
system wake. On Tegra186 and later this means MC client Stream-ID
override registers are not reprogrammed, and clients behind the ARM
SMMU fault on the first DMA after resume.

Register a dev_pm_ops on the tegra-mc driver and route the system
resume callback into mc->soc->ops->resume() so the existing SID
restore path runs again on wake.

No suspend callback is needed as the resume path reprograms all MC
state from the static SoC tables, so there is nothing to save.

Fixes: fe3b082a6eb8 ("memory: tegra: Add SID override programming for MC clients")
Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260430095202.1167651-3-amhetre@nvidia.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/mc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
index bd5b58f1fd4294..7a18d6e3b36871 100644
--- a/drivers/memory/tegra/mc.c
+++ b/drivers/memory/tegra/mc.c
@@ -13,6 +13,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/tegra-icc.h>
@@ -986,10 +987,23 @@ static void tegra_mc_sync_state(struct device *dev)
 		icc_sync_state(dev);
 }
 
+static int tegra_mc_resume(struct device *dev)
+{
+	struct tegra_mc *mc = dev_get_drvdata(dev);
+
+	if (mc->soc->ops && mc->soc->ops->resume)
+		mc->soc->ops->resume(mc);
+
+	return 0;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(tegra_mc_pm_ops, NULL, tegra_mc_resume);
+
 static struct platform_driver tegra_mc_driver = {
 	.driver = {
 		.name = "tegra-mc",
 		.of_match_table = tegra_mc_of_match,
+		.pm = pm_sleep_ptr(&tegra_mc_pm_ops),
 		.suppress_bind_attrs = true,
 		.sync_state = tegra_mc_sync_state,
 	},
-- 
2.53.0



