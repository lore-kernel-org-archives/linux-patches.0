Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8196713CA93;
	Thu, 12 Dec 2024 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023947; cv=none; b=Te966solRVW4WsRFPylH5B7OUBcBetDw5/MizCOQsG8wOukVJnZBb4OBkBmIZ/8HuUb3VZRFTFhGZnF4FA/nwIZskFN2eWrMDy6UQ04yzICA0TlyQTIyWB5DQxJENyTIvgSCPqcl1ezk9RWex5ujl1dmPj8egnKSlAJX7W7kTo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023947; c=relaxed/simple;
	bh=uDvShZ/13vp2HmeMVYencHZZvd9roOY/80omZy5Igd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMEdhvgDAqclhc7ScTK+kSCEeRgawswht9/nzESvogNx5teYgQKVbid1UgOy+pnHX19JVMeylwPYG/ilWJ4Ld1qGlsMtoZIH6Gm4onwJvjEmJLXQModt3phnMdItO72hWuAbeXeeQNEz8vQZf2NXAinGvd8zOyM7V/jd/Vvniao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wytz85Du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wytz85Du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E3CC4CECE;
	Thu, 12 Dec 2024 17:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023947;
	bh=uDvShZ/13vp2HmeMVYencHZZvd9roOY/80omZy5Igd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wytz85Dutn0jJaaMFBynXr2Ktcpve1kMRLt2Q32pKcAOIOOnt/Hd8guVv0LVH6oQE
	 0buxN2NYIrbc2skBwCpTotPhhheEvW+rUDTDT3vhsLDHsUPKXywqlywb1QDBTLsn1J
	 FACVCzJrXrWjFnIpVd/3LhOssvroDL4GKju9wj14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/459] drm/etnaviv: fix power register offset on GC300
Date: Thu, 12 Dec 2024 15:57:54 +0100
Message-ID: <20241212144258.884666312@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Doug Brown <doug@schmorgal.com>

[ Upstream commit 61a6920bb604df3a0e389a2a9479e1e233e4461d ]

Older GC300 revisions have their power registers at an offset of 0x200
rather than 0x100. Add new gpu_read_power and gpu_write_power functions
to encapsulate accesses to the power addresses and fix the addresses.

Signed-off-by: Doug Brown <doug@schmorgal.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Stable-dep-of: 37dc4737447a ("drm/etnaviv: hold GPU lock across perfmon sampling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_dump.c |  7 ++++++-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c  | 20 ++++++++++----------
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h  | 21 +++++++++++++++++++++
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_dump.c b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
index 0edcf8ceb4a78..898f84a0fc30c 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -83,10 +83,15 @@ static void etnaviv_core_dump_registers(struct core_dump_iterator *iter,
 {
 	struct etnaviv_dump_registers *reg = iter->data;
 	unsigned int i;
+	u32 read_addr;
 
 	for (i = 0; i < ARRAY_SIZE(etnaviv_dump_registers); i++, reg++) {
+		read_addr = etnaviv_dump_registers[i];
+		if (read_addr >= VIVS_PM_POWER_CONTROLS &&
+		    read_addr <= VIVS_PM_PULSE_EATER)
+			read_addr = gpu_fix_power_address(gpu, read_addr);
 		reg->reg = cpu_to_le32(etnaviv_dump_registers[i]);
-		reg->value = cpu_to_le32(gpu_read(gpu, etnaviv_dump_registers[i]));
+		reg->value = cpu_to_le32(gpu_read(gpu, read_addr));
 	}
 
 	etnaviv_core_dump_header(iter, ETDUMP_BUF_REG, reg);
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index 5fb1d62ec5950..e944bcd30a2ba 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -578,7 +578,7 @@ static void etnaviv_gpu_enable_mlcg(struct etnaviv_gpu *gpu)
 	u32 pmc, ppc;
 
 	/* enable clock gating */
-	ppc = gpu_read(gpu, VIVS_PM_POWER_CONTROLS);
+	ppc = gpu_read_power(gpu, VIVS_PM_POWER_CONTROLS);
 	ppc |= VIVS_PM_POWER_CONTROLS_ENABLE_MODULE_CLOCK_GATING;
 
 	/* Disable stall module clock gating for 4.3.0.1 and 4.3.0.2 revs */
@@ -586,9 +586,9 @@ static void etnaviv_gpu_enable_mlcg(struct etnaviv_gpu *gpu)
 	    gpu->identity.revision == 0x4302)
 		ppc |= VIVS_PM_POWER_CONTROLS_DISABLE_STALL_MODULE_CLOCK_GATING;
 
-	gpu_write(gpu, VIVS_PM_POWER_CONTROLS, ppc);
+	gpu_write_power(gpu, VIVS_PM_POWER_CONTROLS, ppc);
 
-	pmc = gpu_read(gpu, VIVS_PM_MODULE_CONTROLS);
+	pmc = gpu_read_power(gpu, VIVS_PM_MODULE_CONTROLS);
 
 	/* Disable PA clock gating for GC400+ without bugfix except for GC420 */
 	if (gpu->identity.model >= chipModel_GC400 &&
@@ -617,7 +617,7 @@ static void etnaviv_gpu_enable_mlcg(struct etnaviv_gpu *gpu)
 	pmc |= VIVS_PM_MODULE_CONTROLS_DISABLE_MODULE_CLOCK_GATING_RA_HZ;
 	pmc |= VIVS_PM_MODULE_CONTROLS_DISABLE_MODULE_CLOCK_GATING_RA_EZ;
 
-	gpu_write(gpu, VIVS_PM_MODULE_CONTROLS, pmc);
+	gpu_write_power(gpu, VIVS_PM_MODULE_CONTROLS, pmc);
 }
 
 void etnaviv_gpu_start_fe(struct etnaviv_gpu *gpu, u32 address, u16 prefetch)
@@ -677,11 +677,11 @@ static void etnaviv_gpu_setup_pulse_eater(struct etnaviv_gpu *gpu)
 	    (gpu->identity.features & chipFeatures_PIPE_3D))
 	{
 		/* Performance fix: disable internal DFS */
-		pulse_eater = gpu_read(gpu, VIVS_PM_PULSE_EATER);
+		pulse_eater = gpu_read_power(gpu, VIVS_PM_PULSE_EATER);
 		pulse_eater |= BIT(18);
 	}
 
-	gpu_write(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
+	gpu_write_power(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
 }
 
 static void etnaviv_gpu_hw_init(struct etnaviv_gpu *gpu)
@@ -1275,9 +1275,9 @@ static void sync_point_perfmon_sample_pre(struct etnaviv_gpu *gpu,
 	u32 val;
 
 	/* disable clock gating */
-	val = gpu_read(gpu, VIVS_PM_POWER_CONTROLS);
+	val = gpu_read_power(gpu, VIVS_PM_POWER_CONTROLS);
 	val &= ~VIVS_PM_POWER_CONTROLS_ENABLE_MODULE_CLOCK_GATING;
-	gpu_write(gpu, VIVS_PM_POWER_CONTROLS, val);
+	gpu_write_power(gpu, VIVS_PM_POWER_CONTROLS, val);
 
 	/* enable debug register */
 	val = gpu_read(gpu, VIVS_HI_CLOCK_CONTROL);
@@ -1308,9 +1308,9 @@ static void sync_point_perfmon_sample_post(struct etnaviv_gpu *gpu,
 	gpu_write(gpu, VIVS_HI_CLOCK_CONTROL, val);
 
 	/* enable clock gating */
-	val = gpu_read(gpu, VIVS_PM_POWER_CONTROLS);
+	val = gpu_read_power(gpu, VIVS_PM_POWER_CONTROLS);
 	val |= VIVS_PM_POWER_CONTROLS_ENABLE_MODULE_CLOCK_GATING;
-	gpu_write(gpu, VIVS_PM_POWER_CONTROLS, val);
+	gpu_write_power(gpu, VIVS_PM_POWER_CONTROLS, val);
 }
 
 
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
index 85eddd492774d..39f1e83d3cc7d 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -10,6 +10,7 @@
 #include "etnaviv_gem.h"
 #include "etnaviv_mmu.h"
 #include "etnaviv_drv.h"
+#include "common.xml.h"
 
 struct etnaviv_gem_submit;
 struct etnaviv_vram_mapping;
@@ -159,6 +160,26 @@ static inline u32 gpu_read(struct etnaviv_gpu *gpu, u32 reg)
 	return readl(gpu->mmio + reg);
 }
 
+static inline u32 gpu_fix_power_address(struct etnaviv_gpu *gpu, u32 reg)
+{
+	/* Power registers in GC300 < 2.0 are offset by 0x100 */
+	if (gpu->identity.model == chipModel_GC300 &&
+	    gpu->identity.revision < 0x2000)
+		reg += 0x100;
+
+	return reg;
+}
+
+static inline void gpu_write_power(struct etnaviv_gpu *gpu, u32 reg, u32 data)
+{
+	writel(data, gpu->mmio + gpu_fix_power_address(gpu, reg));
+}
+
+static inline u32 gpu_read_power(struct etnaviv_gpu *gpu, u32 reg)
+{
+	return readl(gpu->mmio + gpu_fix_power_address(gpu, reg));
+}
+
 int etnaviv_gpu_get_param(struct etnaviv_gpu *gpu, u32 param, u64 *value);
 
 int etnaviv_gpu_init(struct etnaviv_gpu *gpu);
-- 
2.43.0



