Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D8B2110E;
	Tue, 27 May 2025 17:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365480; cv=none; b=Ck0n3EFw+4K2AZouQgxpIfRNRIafJ1+yFEBh7yBruAZrZjTdpiQY8ZMVDfkSpsx7QHmgrUR5naEwAuOusR1yNN/JBuyPaUTzkhWGaJsn+2ohpkcW1vJG21tWIL2lohndO+eczipI54xvfOmbWX6cSO3L5S/foUqo46trgSi5p2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365480; c=relaxed/simple;
	bh=7253E2RrfOft0XUutUrltqWI0rfF6z88Q/5LG464Tik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSOvbpnuakaTS2F9sSH2xTLxOiW9olyiYZ74Hy1uuA2mYEWBdbuYlP7fV7wrU0GG4WV+2XJWZz1QDpfZNa8mSwpZoIYoyCmAKX5d8DL2wQg3W0wwaTyhR5naLRGdaGxplvSI+sZCBEZ/Hg1Tsq7LwQSEsJmZ7b//ZXyK0ZdtNR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGLJXpzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGLJXpzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D22C4CEE9;
	Tue, 27 May 2025 17:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365480;
	bh=7253E2RrfOft0XUutUrltqWI0rfF6z88Q/5LG464Tik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGLJXpzH61hOJLO+1aeNvIsJqQvk1VG9YyB3INGYeo7IiidAAVne8Tsrnxo3HXk2V
	 PUEwUnSbWWs6SnX+TxF1CMOsm8FOMt/zhotGi2sKg3/HrrYZho/gEqw/PI951wfD4k
	 gGUuzmcpW+yf1kCq2fjOSwz8cyhPH4SL3aqaPAbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <Charlene.Liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 390/626] drm/amd/display: pass calculated dram_speed_mts to dml2
Date: Tue, 27 May 2025 18:24:43 +0200
Message-ID: <20250527162500.869506312@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit b40d022ec06ade9f6c809091dc188422a0f0946d ]

[why]
currently dml2 is using a hard coded 16 to convert memclk to dram_speed_mts.
for apu, this depends on wck_ratio.

change to pass the already calculated dram_speed_mts from fpu to dml2.

v2: use existing calculation of dram_speed_mts for now to avoid regression

Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c   | 2 ++
 drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c | 1 +
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h     | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
index beed7adbbd43e..c90dee4e9116a 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
@@ -367,6 +367,8 @@ void dcn35_update_bw_bounding_box_fpu(struct dc *dc,
 				clock_limits[i].socclk_mhz;
 			dc->dml2_options.bbox_overrides.clks_table.clk_entries[i].memclk_mhz =
 				clk_table->entries[i].memclk_mhz * clk_table->entries[i].wck_ratio;
+
+			dc->dml2_options.bbox_overrides.clks_table.clk_entries[i].dram_speed_mts = clock_limits[i].dram_speed_mts;
 			dc->dml2_options.bbox_overrides.clks_table.clk_entries[i].dtbclk_mhz =
 				clock_limits[i].dtbclk_mhz;
 			dc->dml2_options.bbox_overrides.clks_table.num_entries_per_clk.num_dcfclk_levels =
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c
index a201dbb743d79..79d921adc2153 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c
@@ -401,6 +401,7 @@ void dcn351_update_bw_bounding_box_fpu(struct dc *dc,
 				clock_limits[i].socclk_mhz;
 			dc->dml2_options.bbox_overrides.clks_table.clk_entries[i].memclk_mhz =
 				clk_table->entries[i].memclk_mhz * clk_table->entries[i].wck_ratio;
+			dc->dml2_options.bbox_overrides.clks_table.clk_entries[i].dram_speed_mts = clock_limits[i].dram_speed_mts;
 			dc->dml2_options.bbox_overrides.clks_table.clk_entries[i].dtbclk_mhz =
 				clock_limits[i].dtbclk_mhz;
 			dc->dml2_options.bbox_overrides.clks_table.num_entries_per_clk.num_dcfclk_levels =
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
index 0f944fcfd5a5b..785226945699d 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
@@ -159,6 +159,7 @@ struct dml2_clks_table_entry {
 	unsigned int dtbclk_mhz;
 	unsigned int dispclk_mhz;
 	unsigned int dppclk_mhz;
+	unsigned int dram_speed_mts; /*which is based on wck_ratio*/
 };
 
 struct dml2_clks_num_entries {
-- 
2.39.5



