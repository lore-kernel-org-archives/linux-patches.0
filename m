Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC34D18DB2A;
	Wed, 25 Feb 2026 01:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983134; cv=none; b=PQA7eFTRCD/Ch2Nf2i2EX2Xztztuy0A7c1A9SsxPvHfcMlXl+jImkj0nwmkITF+uOjlFDHXeXfhUGqoYHWSW1sGflvwiO7xLz8lexQG+HYtkEBl95WQ8cm7U3k9PUUqNHgSppnvUuA15bbe6yqDMd0lUb4YvcC9oWATO5Z1cF98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983134; c=relaxed/simple;
	bh=eVWDnI2UtVnWHxT8SezOz9A4dhV7hcdy59pcdeQzhNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrifN9iwP7/IXw+ejrmnd0Eic6HjIB7HiF84AwWDo1W2JX7h6HwGRC653csjwiKb9kWllRs6Df4OdJ4T8OvpCTUcuhQaKGXqpSqb+JbLHhK6Bo+3sChnt2YdufApa6cM4xNAalZhyTvu4YBCob05pHLdUyn5LzbnlanUSKAJFZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rv6io3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rv6io3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3CAC116D0;
	Wed, 25 Feb 2026 01:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983134;
	bh=eVWDnI2UtVnWHxT8SezOz9A4dhV7hcdy59pcdeQzhNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rv6io3/Mj62++XudQSeGQ5UvuQlTNiKI1V3KaBG7knvy04ffmcwgAOUiU91sa26Z
	 Yqx9+dT2GXwXNLOR4shX0n4FDcCKyvYL+fv6XckUCjIdsFfAGyPGTNmIKk5cDt2HW+
	 Sjev5+IW9+eGhzNozZ/+0dFCshnJq85sGVsGMHk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 291/781] ASoC: tegra: Add AHUB writeable_reg for RX holes
Date: Tue, 24 Feb 2026 17:16:40 -0800
Message-ID: <20260225012406.844335416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheetal <sheetal@nvidia.com>

[ Upstream commit 0ba6286a71581aaf8413a55b9bd90ea3463fd23b ]

Add writeable_reg callbacks for Tegra210/186 AHUB RX registers so the
flat cache only treats valid RX locations as writable, avoiding holes
in the register map.

Fixes: 16e1bcc2caf4 ("ASoC: tegra: Add Tegra210 based AHUB driver")
Signed-off-by: Sheetal <sheetal@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260123095346.1258556-2-sheetal@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_ahub.c | 57 +++++++++++++++++++++++++++++++++
 sound/soc/tegra/tegra210_ahub.h | 30 +++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/sound/soc/tegra/tegra210_ahub.c b/sound/soc/tegra/tegra210_ahub.c
index e795907a3963a..fc5892056f832 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -2049,6 +2049,61 @@ static const struct snd_soc_component_driver tegra264_ahub_component = {
 	.num_dapm_routes	= ARRAY_SIZE(tegra264_ahub_routes),
 };
 
+static bool tegra210_ahub_wr_reg(struct device *dev, unsigned int reg)
+{
+	int part;
+
+	if (reg % TEGRA210_XBAR_RX_STRIDE)
+		return false;
+
+	for (part = 0; part < TEGRA210_XBAR_UPDATE_MAX_REG; part++) {
+		switch (reg & ~(part * TEGRA210_XBAR_PART1_RX)) {
+		case TEGRA210_AXBAR_PART_0_ADMAIF_RX1_0 ... TEGRA210_AXBAR_PART_0_ADMAIF_RX10_0:
+		case TEGRA210_AXBAR_PART_0_I2S1_RX1_0 ... TEGRA210_AXBAR_PART_0_I2S5_RX1_0:
+		case TEGRA210_AXBAR_PART_0_SFC1_RX1_0 ... TEGRA210_AXBAR_PART_0_SFC4_RX1_0:
+		case TEGRA210_AXBAR_PART_0_MIXER1_RX1_0 ... TEGRA210_AXBAR_PART_0_MIXER1_RX10_0:
+		case TEGRA210_AXBAR_PART_0_SPDIF1_RX1_0 ... TEGRA210_AXBAR_PART_0_SPDIF1_RX2_0:
+		case TEGRA210_AXBAR_PART_0_AFC1_RX1_0 ... TEGRA210_AXBAR_PART_0_AFC6_RX1_0:
+		case TEGRA210_AXBAR_PART_0_OPE1_RX1_0 ... TEGRA210_AXBAR_PART_0_OPE2_RX1_0:
+		case TEGRA210_AXBAR_PART_0_SPKPROT1_RX1_0:
+		case TEGRA210_AXBAR_PART_0_MVC1_RX1_0 ... TEGRA210_AXBAR_PART_0_MVC2_RX1_0:
+		case TEGRA210_AXBAR_PART_0_AMX1_RX1_0 ... TEGRA210_AXBAR_PART_0_ADX2_RX1_0:
+			return true;
+		default:
+			break;
+		}
+	}
+
+	return false;
+}
+
+static bool tegra186_ahub_wr_reg(struct device *dev, unsigned int reg)
+{
+	int part;
+
+	if (reg % TEGRA210_XBAR_RX_STRIDE)
+		return false;
+
+	for (part = 0; part < TEGRA186_XBAR_UPDATE_MAX_REG; part++) {
+		switch (reg & ~(part * TEGRA210_XBAR_PART1_RX)) {
+		case TEGRA210_AXBAR_PART_0_ADMAIF_RX1_0 ... TEGRA186_AXBAR_PART_0_I2S6_RX1_0:
+		case TEGRA210_AXBAR_PART_0_SFC1_RX1_0 ... TEGRA210_AXBAR_PART_0_SFC4_RX1_0:
+		case TEGRA210_AXBAR_PART_0_MIXER1_RX1_0 ... TEGRA210_AXBAR_PART_0_MIXER1_RX10_0:
+		case TEGRA186_AXBAR_PART_0_DSPK1_RX1_0 ... TEGRA186_AXBAR_PART_0_DSPK2_RX1_0:
+		case TEGRA210_AXBAR_PART_0_AFC1_RX1_0 ... TEGRA210_AXBAR_PART_0_AFC6_RX1_0:
+		case TEGRA210_AXBAR_PART_0_OPE1_RX1_0:
+		case TEGRA186_AXBAR_PART_0_MVC1_RX1_0 ... TEGRA186_AXBAR_PART_0_MVC2_RX1_0:
+		case TEGRA186_AXBAR_PART_0_AMX1_RX1_0 ... TEGRA186_AXBAR_PART_0_AMX3_RX4_0:
+		case TEGRA210_AXBAR_PART_0_ADX1_RX1_0 ... TEGRA186_AXBAR_PART_0_ASRC1_RX7_0:
+			return true;
+		default:
+			break;
+		}
+	}
+
+	return false;
+}
+
 static bool tegra264_ahub_wr_reg(struct device *dev, unsigned int reg)
 {
 	int part;
@@ -2076,6 +2131,7 @@ static const struct regmap_config tegra210_ahub_regmap_config = {
 	.reg_bits		= 32,
 	.val_bits		= 32,
 	.reg_stride		= 4,
+	.writeable_reg		= tegra210_ahub_wr_reg,
 	.max_register		= TEGRA210_MAX_REGISTER_ADDR,
 	.cache_type		= REGCACHE_FLAT,
 };
@@ -2084,6 +2140,7 @@ static const struct regmap_config tegra186_ahub_regmap_config = {
 	.reg_bits		= 32,
 	.val_bits		= 32,
 	.reg_stride		= 4,
+	.writeable_reg		= tegra186_ahub_wr_reg,
 	.max_register		= TEGRA186_MAX_REGISTER_ADDR,
 	.cache_type		= REGCACHE_FLAT,
 };
diff --git a/sound/soc/tegra/tegra210_ahub.h b/sound/soc/tegra/tegra210_ahub.h
index f355b2cfd19b2..acbe640dd3b57 100644
--- a/sound/soc/tegra/tegra210_ahub.h
+++ b/sound/soc/tegra/tegra210_ahub.h
@@ -68,6 +68,36 @@
 #define TEGRA210_MAX_REGISTER_ADDR (TEGRA210_XBAR_PART2_RX +		\
 	(TEGRA210_XBAR_RX_STRIDE * (TEGRA210_XBAR_AUDIO_RX_COUNT - 1)))
 
+/* AXBAR register offsets */
+#define TEGRA186_AXBAR_PART_0_AMX1_RX1_0	0x120
+#define TEGRA186_AXBAR_PART_0_AMX3_RX4_0	0x14c
+#define TEGRA186_AXBAR_PART_0_ASRC1_RX7_0	0x1a8
+#define TEGRA186_AXBAR_PART_0_DSPK1_RX1_0	0xc0
+#define TEGRA186_AXBAR_PART_0_DSPK2_RX1_0	0xc4
+#define TEGRA186_AXBAR_PART_0_I2S6_RX1_0	0x54
+#define TEGRA186_AXBAR_PART_0_MVC1_RX1_0	0x110
+#define TEGRA186_AXBAR_PART_0_MVC2_RX1_0	0x114
+#define TEGRA210_AXBAR_PART_0_ADMAIF_RX10_0	0x24
+#define TEGRA210_AXBAR_PART_0_ADMAIF_RX1_0	0x0
+#define TEGRA210_AXBAR_PART_0_ADX1_RX1_0	0x160
+#define TEGRA210_AXBAR_PART_0_ADX2_RX1_0	0x164
+#define TEGRA210_AXBAR_PART_0_AFC1_RX1_0	0xd0
+#define TEGRA210_AXBAR_PART_0_AFC6_RX1_0	0xe4
+#define TEGRA210_AXBAR_PART_0_AMX1_RX1_0	0x140
+#define TEGRA210_AXBAR_PART_0_I2S1_RX1_0	0x40
+#define TEGRA210_AXBAR_PART_0_I2S5_RX1_0	0x50
+#define TEGRA210_AXBAR_PART_0_MIXER1_RX10_0	0xa4
+#define TEGRA210_AXBAR_PART_0_MIXER1_RX1_0	0x80
+#define TEGRA210_AXBAR_PART_0_MVC1_RX1_0	0x120
+#define TEGRA210_AXBAR_PART_0_MVC2_RX1_0	0x124
+#define TEGRA210_AXBAR_PART_0_OPE1_RX1_0	0x100
+#define TEGRA210_AXBAR_PART_0_OPE2_RX1_0	0x104
+#define TEGRA210_AXBAR_PART_0_SFC1_RX1_0	0x60
+#define TEGRA210_AXBAR_PART_0_SFC4_RX1_0	0x6c
+#define TEGRA210_AXBAR_PART_0_SPDIF1_RX1_0	0xc0
+#define TEGRA210_AXBAR_PART_0_SPDIF1_RX2_0	0xc4
+#define TEGRA210_AXBAR_PART_0_SPKPROT1_RX1_0	0x110
+
 #define MUX_REG(id) (TEGRA210_XBAR_RX_STRIDE * (id))
 
 #define MUX_VALUE(npart, nbit) (1 + (nbit) + (npart) * 32)
-- 
2.51.0



