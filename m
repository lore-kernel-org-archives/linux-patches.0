Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EB230B51F;
	Wed,  3 Dec 2025 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775998; cv=none; b=EmOCFWZuf467NfbykEr6oe2dr+SxA9FEsQNmRwVF9rv9u2KCfvmLWUKu1+3mLG+dmGPWmSGS6eD59C5qqr2B3xXsKino5trZk1CWdiwDFXiLfHpOmwEIW4sKsH0wFk5ezx2TlqXHXfnNhLFC3GqL4mmzGdOgdD+UmD5K7F8Wnig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775998; c=relaxed/simple;
	bh=S2o2Az80Pt9QEJ004utgUNTlS28xezLz+0QbN26+wS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+4ClIOQpql4Was9gOl+wdDqICHMb0ay81+Ru6Q5QqOARWmoKqFfqMlGDpI4dH4qKYcDXVZWkjPfVE9JFQ3aBt+dlct1pk2X7A4+BprfImFYSIsTPavrxkCHUxDezsy1bsKsCGVrzp4tgVyMn9hZ2xI+MV+uJMvO7gddTmvrsRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHpcKkOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHpcKkOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25ACC4CEF5;
	Wed,  3 Dec 2025 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775998;
	bh=S2o2Az80Pt9QEJ004utgUNTlS28xezLz+0QbN26+wS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHpcKkOQefciSP5OH3s+oErK2XU7gWwnL2XtMQeg3imj8gCitPEIHEXE9vuTnV6Hf
	 Vl/SUwh3X2CX7lL4WYOA1ZTl6hnWtV3YYa3+FNlSHU2jwROZbi5v6/wY9bORxJ/Hr6
	 a9K28Kj16NlBx6V8RGtixafpb+4G/9caFQndegKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/300] soc/tegra: fuse: Add Tegra114 nvmem cells and fuse lookups
Date: Wed,  3 Dec 2025 16:24:14 +0100
Message-ID: <20251203152402.472460147@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit b9c01adedf38c69abb725a60a05305ef70dbce03 ]

Add missing Tegra114 nvmem cells and fuse lookups which were added for
Tegra124+ but omitted for Tegra114.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/fuse-tegra30.c | 122 ++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/drivers/soc/tegra/fuse/fuse-tegra30.c b/drivers/soc/tegra/fuse/fuse-tegra30.c
index c1aa7815bd6ec..f7f1a73a52f3a 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra30.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra30.c
@@ -117,6 +117,124 @@ const struct tegra_fuse_soc tegra30_fuse_soc = {
 #endif
 
 #ifdef CONFIG_ARCH_TEGRA_114_SOC
+static const struct nvmem_cell_info tegra114_fuse_cells[] = {
+	{
+		.name = "tsensor-cpu1",
+		.offset = 0x084,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-cpu2",
+		.offset = 0x088,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-common",
+		.offset = 0x08c,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-cpu0",
+		.offset = 0x098,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "xusb-pad-calibration",
+		.offset = 0x0f0,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-cpu3",
+		.offset = 0x12c,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-gpu",
+		.offset = 0x154,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-mem0",
+		.offset = 0x158,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-mem1",
+		.offset = 0x15c,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-pllx",
+		.offset = 0x160,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	},
+};
+
+static const struct nvmem_cell_lookup tegra114_fuse_lookups[] = {
+	{
+		.nvmem_name = "fuse",
+		.cell_name = "xusb-pad-calibration",
+		.dev_id = "7009f000.padctl",
+		.con_id = "calibration",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-common",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "common",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-cpu0",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "cpu0",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-cpu1",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "cpu1",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-cpu2",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "cpu2",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-cpu3",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "cpu3",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-mem0",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "mem0",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-mem1",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "mem1",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-gpu",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "gpu",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-pllx",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "pllx",
+	},
+};
+
 static const struct tegra_fuse_info tegra114_fuse_info = {
 	.read = tegra30_fuse_read,
 	.size = 0x2a0,
@@ -127,6 +245,10 @@ const struct tegra_fuse_soc tegra114_fuse_soc = {
 	.init = tegra30_fuse_init,
 	.speedo_init = tegra114_init_speedo_data,
 	.info = &tegra114_fuse_info,
+	.lookups = tegra114_fuse_lookups,
+	.num_lookups = ARRAY_SIZE(tegra114_fuse_lookups),
+	.cells = tegra114_fuse_cells,
+	.num_cells = ARRAY_SIZE(tegra114_fuse_cells),
 	.soc_attr_group = &tegra_soc_attr_group,
 };
 #endif
-- 
2.51.0



