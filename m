Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1493770838;
	Mon, 23 Jun 2025 21:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712815; cv=none; b=OrY7h6VKtjNdIXv9Apb/jkK8mq7PFGGa0w/oooC+ulV+vVBf9KSSQ5Iki9kZOQndNSaR9KwsH54VHELluttY5bU3e1pol509306n14wDB61XTlkmgCKfexXHljw8fJORau7xaFncnrFHv0Yc77G/g5myk97+sNZ1MHdRpYXKQsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712815; c=relaxed/simple;
	bh=B40L8W4q2bgS4r66ArFSWmVPk03JUK2efWedYqa13ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHiHWSci72ZVZQ5liiKfp5BkpmVeZP4NoQwKrCBfrY7Zmy+s+RnWdpDea+xV4Jkk06lVf/QiBEOu5bqWY769ynfmeY027eabsQ9HpKH930Wih+NNzi3uUqVPFiW0nZZ58Ltxto9B2kBWPiJa4T4mhdXfTgQBOvqzLfALEzgabPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEcqE8o1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEcqE8o1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D40C4CEEA;
	Mon, 23 Jun 2025 21:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712815;
	bh=B40L8W4q2bgS4r66ArFSWmVPk03JUK2efWedYqa13ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEcqE8o1RpvO25DFo+0JI1Q7YvYLbpYYLQvbQJ2T2OBjObyRkPvoZaHH2TNyYgt43
	 im2Ku9YJvCSP7PhLDhyAOvmOzldyhrWelhIbO3AC5LDW8L2Lnk27K05Pnlxe4nBtAY
	 0oAQhO+Ep26XSsRJGC0CDy/2i12WH05J1w5xonaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 295/592] drm/amd/pm: Reset SMU v13.0.x custom settings
Date: Mon, 23 Jun 2025 15:04:13 +0200
Message-ID: <20250623130707.397317834@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 923406e74ec66364b829b7f8b6b67d46200567a6 ]

On SMU v13.0.2 and SMU v13.0.6 variants user may choose custom min/max
clocks in manual perf mode. Those custom min/max values need to be
reset once user switches to auto or restores default settings.
Otherwise, they may get used inadvertently during the next operation.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h        |  1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c  | 13 +++++++++++--
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c      | 10 ++++++++++
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c    |  4 ++--
 4 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index cd03caffe3173..21589c4583e6b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -310,6 +310,7 @@ int smu_v13_0_get_boot_freq_by_index(struct smu_context *smu,
 				     uint32_t *value);
 
 void smu_v13_0_interrupt_work(struct smu_context *smu);
+void smu_v13_0_reset_custom_level(struct smu_context *smu);
 bool smu_v13_0_12_is_dpm_running(struct smu_context *smu);
 int smu_v13_0_12_get_max_metrics_size(void);
 int smu_v13_0_12_setup_driver_pptable(struct smu_context *smu);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index 83163d7c7f001..5cb3b9bb60898 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1270,6 +1270,7 @@ static int aldebaran_set_performance_level(struct smu_context *smu,
 	struct smu_13_0_dpm_table *gfx_table =
 		&dpm_context->dpm_tables.gfx_table;
 	struct smu_umd_pstate_table *pstate_table = &smu->pstate_table;
+	int r;
 
 	/* Disable determinism if switching to another mode */
 	if ((smu_dpm->dpm_level == AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) &&
@@ -1282,7 +1283,11 @@ static int aldebaran_set_performance_level(struct smu_context *smu,
 
 	case AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM:
 		return 0;
-
+	case AMD_DPM_FORCED_LEVEL_AUTO:
+		r = smu_v13_0_set_performance_level(smu, level);
+		if (!r)
+			smu_v13_0_reset_custom_level(smu);
+		return r;
 	case AMD_DPM_FORCED_LEVEL_HIGH:
 	case AMD_DPM_FORCED_LEVEL_LOW:
 	case AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD:
@@ -1423,7 +1428,11 @@ static int aldebaran_usr_edit_dpm_table(struct smu_context *smu, enum PP_OD_DPM_
 			min_clk = dpm_context->dpm_tables.gfx_table.min;
 			max_clk = dpm_context->dpm_tables.gfx_table.max;
 
-			return aldebaran_set_soft_freq_limited_range(smu, SMU_GFXCLK, min_clk, max_clk, false);
+			ret = aldebaran_set_soft_freq_limited_range(
+				smu, SMU_GFXCLK, min_clk, max_clk, false);
+			if (ret)
+				return ret;
+			smu_v13_0_reset_custom_level(smu);
 		}
 		break;
 	case PP_OD_COMMIT_DPM_TABLE:
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index ba5a9012dbd5e..075f381ad311b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2595,3 +2595,13 @@ int smu_v13_0_set_wbrf_exclusion_ranges(struct smu_context *smu,
 
 	return ret;
 }
+
+void smu_v13_0_reset_custom_level(struct smu_context *smu)
+{
+	struct smu_umd_pstate_table *pstate_table = &smu->pstate_table;
+
+	pstate_table->uclk_pstate.custom.min = 0;
+	pstate_table->uclk_pstate.custom.max = 0;
+	pstate_table->gfxclk_pstate.custom.min = 0;
+	pstate_table->gfxclk_pstate.custom.max = 0;
+}
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index c478b3be37af1..b8feabb019cf8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -1927,7 +1927,7 @@ static int smu_v13_0_6_set_performance_level(struct smu_context *smu,
 				return ret;
 			pstate_table->uclk_pstate.curr.max = uclk_table->max;
 		}
-		pstate_table->uclk_pstate.custom.max = 0;
+		smu_v13_0_reset_custom_level(smu);
 
 		return 0;
 	case AMD_DPM_FORCED_LEVEL_MANUAL:
@@ -2140,7 +2140,7 @@ static int smu_v13_0_6_usr_edit_dpm_table(struct smu_context *smu,
 				smu, SMU_UCLK, min_clk, max_clk, false);
 			if (ret)
 				return ret;
-			pstate_table->uclk_pstate.custom.max = 0;
+			smu_v13_0_reset_custom_level(smu);
 		}
 		break;
 	case PP_OD_COMMIT_DPM_TABLE:
-- 
2.39.5



