Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED3346C4AE;
	Tue, 21 Jul 2026 17:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655798; cv=none; b=QQXVeAlamsz7v9bOH8w6eDXf2MtZ7K7A+dyw65ZvlcRbCs2WERjAcediwnHsR5kOU/Ooo6QiylvR3LvPeEECdwzSpCDgPcGhP3R6uVo2+OGdaBaqaFDYhfFiyaYpU5pZft/wz9976W7UN8C8GmEG4ZVTX9EVybR/xk34ytGjup0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655798; c=relaxed/simple;
	bh=qrrOoRDPeuOs8By1oIENeZYLDhiHrKEyQkBzdRY/tms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYMCnqLLlTI08CH95NXBUKCJuHBQa/owbbDl0HygFVIw/eMnAmJCS5wYDxdy7+YEcSmnIZH8KVNCZqWRv4VMCOG0la+8zPMKzOB+oLVwzsIpjdNUjvxMVM2DVeoPbw7dQ3Nlz7umpcM1fmggD8Q1YQ0V4oA4OJhXHijGZszOGnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iy23AOX/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iy23AOX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE771F000E9;
	Tue, 21 Jul 2026 17:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655797;
	bh=TM93/Ua8Oa0lSMfUlszn/n+ANjg9BnDj7yJlWFBFOmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iy23AOX/0/2YeCJRuvP8k3ToMuw2U1x0YN/0fm9lw4Wot0Qi3RDdW/geDY5iVnBfB
	 LVGQaA3+DMP1ivpQxZMIA2PFSu62xA8C/rqWHCll1N8g45AYVlVkNmmZtgvpfldYf5
	 qgH/LllXi3km5LUGiEcff1I815nG04C/f71RHifo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Mhetre <amhetre@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0102/1611] memory: tegra: Wire up system sleep PM ops
Date: Tue, 21 Jul 2026 17:03:38 +0200
Message-ID: <20260721152517.138179461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6edb210287dcaa..c29df29920f467 100644
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
@@ -989,10 +990,23 @@ static void tegra_mc_sync_state(struct device *dev)
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



