Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB15412BFA;
	Fri,  4 Sep 2026 05:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499832; cv=none; b=hQZe80L1Wv30QLLGj0hPJT1VHN1rjtNGzvd9PmC8Oi9o2W7mJwkfQeyKxmBWnz2V5s9dMlFnhizV0CP4ztERB0ZAysfiL9U6QFE1pCwPPXedVprYt20oSA3jyAhNP0ipATMX8AHghrJMELobhb67iQ4UM2PsRplxiv5+iPq26Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499832; c=relaxed/simple;
	bh=IkEz3rCT9iYZEMb/3dkzjt9MNKldMRwOsdOT/bBZ2Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LBEPZkG6qBUkvnyJiesRlc/T0orKbX1A7H/Zam33S75j/wQlQu94ft3JAYOAjOzejlt1jueNCLf1w9Fc/y0Ed+eNMYQt28MZEzbgX24pyzqjANljUKXSf8h0DdEujZb801DBLc5twd7OCrLPibuW3y2dhQSNSEsqVIZKqLd5mfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ygtz8Ii5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ygtz8Ii5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CE91F00A3D;
	Fri,  4 Sep 2026 05:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499830;
	bh=5nNltpzz9LWUWP7rZEr1KDUzDl9hqAzDkfpV8sYp/7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ygtz8Ii5xAXahjImyhZt3mPpsg6bEY2CT63oWMJEh4/Aw4tc/dmw3jP//JQwYi9by
	 DkyEbny0zphyRaBs/YdXLr8Z2MRv1tVrxyU0ORfjPOO+wNSK4qHo5Vt4zlGObnA8l0
	 PsT/lozY30HUz+75seWlxGBVsoei/abMWnDZhVQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 557/713] platform/x86: ISST: Use PP level enable mask
Date: Fri,  4 Sep 2026 06:58:45 +0200
Message-ID: <20260904045816.305090183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -880,7 +883,7 @@ static int isst_if_get_perf_level(void _
 		      SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH, SST_MUL_FACTOR_NONE)
 	perf_level.enabled = !!(power_domain_info->sst_header.cap_mask & BIT(1));
 
-	level_mask = perf_level.level_mask;
+	level_mask = perf_level.level_mask & power_domain_info->pp_header.level_en_mask;
 	perf_level.sst_bf_support = 0;
 	for_each_set_bit(level, &level_mask, BITS_PER_BYTE) {
 		/*
@@ -1318,6 +1321,9 @@ static int isst_if_get_base_freq_info(vo
 	if (base_freq.level > power_domain_info->max_level)
 		return -EINVAL;
 
+	if (!(power_domain_info->pp_header.level_en_mask & BIT(base_freq.level)))
+		return -EINVAL;
+
 	_read_bf_level_info("p1_high", base_freq.high_base_freq_mhz, base_freq.level,
 			    SST_BF_INFO_0_OFFSET, SST_BF_P1_HIGH_START, SST_BF_P1_HIGH_WIDTH,
 			    SST_MUL_FACTOR_FREQ)
@@ -1357,6 +1363,9 @@ static int isst_if_get_base_freq_mask(vo
 	if (cpumask.level > power_domain_info->max_level)
 		return -EINVAL;
 
+	if (!(power_domain_info->pp_header.level_en_mask & BIT(cpumask.level)))
+		return -EINVAL;
+
 	_read_bf_level_info("BF-cpumask", mask, cpumask.level, SST_BF_INFO_1_OFFSET,
 			    P1_HI_CORE_MASK_START, P1_HI_CORE_MASK_WIDTH,
 			    SST_MUL_FACTOR_NONE)
@@ -1454,6 +1463,9 @@ static int isst_if_get_turbo_freq_info(v
 	if (turbo_freq.level > power_domain_info->max_level)
 		return -EINVAL;
 
+	if (!(power_domain_info->pp_header.level_en_mask & BIT(turbo_freq.level)))
+		return -EINVAL;
+
 	turbo_freq.max_buckets = TRL_MAX_BUCKETS;
 	turbo_freq.max_trl_levels = TRL_MAX_LEVELS;
 	turbo_freq.max_clip_freqs = SST_TF_MAX_LP_CLIP_RATIOS;


