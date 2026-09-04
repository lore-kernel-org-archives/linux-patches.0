Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F107A18D636;
	Fri,  4 Sep 2026 05:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501468; cv=none; b=ryLSaRNaBQ91Jw6/ENIAvT7UoKypHS2YKMqxMhRa/aV1k/2iSM3vG4GnpuPE9YLgjRApp8yoQVSMyN6MeQnin0lFpS9jiPIbCI+YmRRRg2BFjSqTVM0u2J6Lh0uebAriWzrEVeWDaSQHwzaaFuJLapwtt7Cr+ZLlFJBxpN0Ctg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501468; c=relaxed/simple;
	bh=RKUsXJSWIBw23NT5HQpY/qtTy4jHJ8hYvbwqqTN62tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MUyymJU/9y/bpi4CR7hBrp4cnL5FQt6NqfhvnOjsRNhNbrFASNEcVVeL740otk3yJao5lXqKUXwz7H5rqIuKKxNnt6F57F6SbRNVmjYL+9/hoozXMdH6+Ld0b4sgC6ukVGI9mqp3X1mPEASvs42H5FajZ/vscCFeYLjr35xPMTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWOzCfFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWOzCfFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A431F00A3D;
	Fri,  4 Sep 2026 05:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501466;
	bh=8lK1hGES/M6V0EmXlbYhtmyQGYXgergVb8H8bbkQeJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWOzCfFw/bNXuhfbmBPtaKbPLiyqA2Gt+YRs/YRNpv/Zu5lNs8Hus95ZN4eqciPmb
	 XIEB4+NNMsgfgspiiht7L6xF/+jHiO/cXF7pxJV474g1rsPgRKM33qa1creE3jCFRo
	 adfcYLqKPHuGmrjDjCGFztvi1gp/XaG7yQ6U6NDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 420/552] platform/x86: ISST: Use PP level enable mask
Date: Fri,  4 Sep 2026 06:59:37 +0200
Message-ID: <20260904045800.131358851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 9b9026943b19d06ebf520b1f4786621947cf43c8 upstream.

Add check for enabled levels only when reading MMIO. Some levels can be
disabled by BIOS. If the level is not enabled, return an error.

Reset the enable and allowed level masks if there is a failure to add a
perf level.

Fixes: ea009e4769fa3 ("platform/x86: ISST: Add SST-PP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-6-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |   16 ++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -336,8 +336,11 @@ static int sst_add_perf_profiles(struct
 	int i;
 
 	pd_info->perf_levels = devm_kcalloc(dev, levels, sizeof(struct perf_level), GFP_KERNEL);
-	if (!pd_info->perf_levels)
+	if (!pd_info->perf_levels) {
+		pd_info->pp_header.allowed_level_mask = 0;
+		pd_info->pp_header.level_en_mask = 0;
 		return 0;
+	}
 
 	pd_info->ratio_unit = pd_info->pp_header.ratio_unit;
 	pd_info->avx_levels = SST_MAX_AVX_LEVELS;
@@ -879,7 +882,7 @@ static int isst_if_get_perf_level(void _
 		      SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH, SST_MUL_FACTOR_NONE)
 	perf_level.enabled = !!(power_domain_info->sst_header.cap_mask & BIT(1));
 
-	level_mask = perf_level.level_mask;
+	level_mask = perf_level.level_mask & power_domain_info->pp_header.level_en_mask;
 	perf_level.sst_bf_support = 0;
 	for_each_set_bit(level, &level_mask, BITS_PER_BYTE) {
 		/*
@@ -1317,6 +1320,9 @@ static int isst_if_get_base_freq_info(vo
 	if (base_freq.level > power_domain_info->max_level)
 		return -EINVAL;
 
+	if (!(power_domain_info->pp_header.level_en_mask & BIT(base_freq.level)))
+		return -EINVAL;
+
 	_read_bf_level_info("p1_high", base_freq.high_base_freq_mhz, base_freq.level,
 			    SST_BF_INFO_0_OFFSET, SST_BF_P1_HIGH_START, SST_BF_P1_HIGH_WIDTH,
 			    SST_MUL_FACTOR_FREQ)
@@ -1356,6 +1362,9 @@ static int isst_if_get_base_freq_mask(vo
 	if (cpumask.level > power_domain_info->max_level)
 		return -EINVAL;
 
+	if (!(power_domain_info->pp_header.level_en_mask & BIT(cpumask.level)))
+		return -EINVAL;
+
 	_read_bf_level_info("BF-cpumask", mask, cpumask.level, SST_BF_INFO_1_OFFSET,
 			    P1_HI_CORE_MASK_START, P1_HI_CORE_MASK_WIDTH,
 			    SST_MUL_FACTOR_NONE)
@@ -1453,6 +1462,9 @@ static int isst_if_get_turbo_freq_info(v
 	if (turbo_freq.level > power_domain_info->max_level)
 		return -EINVAL;
 
+	if (!(power_domain_info->pp_header.level_en_mask & BIT(turbo_freq.level)))
+		return -EINVAL;
+
 	turbo_freq.max_buckets = TRL_MAX_BUCKETS;
 	turbo_freq.max_trl_levels = TRL_MAX_LEVELS;
 	turbo_freq.max_clip_freqs = SST_TF_MAX_LP_CLIP_RATIOS;


