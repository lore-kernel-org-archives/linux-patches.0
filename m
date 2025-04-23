Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955E82918F5;
	Wed, 23 Apr 2025 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421568; cv=none; b=bGxZEOcSq+FJ+rSZTuQhmf4uWsH+DlVJogHJqwfs8IFIFaOgDiZhzdn7D2LbU3V1jKEnv045CTiyjsUOI1iAoDWpN4v46Ry8RcvMLvddS6W4SB+UVKvwRrhwCZcXT+OoMYyt9PpaekIMuCx5nbXw19dnv7Lww8EfXLBQ+NbhRss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421568; c=relaxed/simple;
	bh=Fm0jhXmib3qO1+S1Ru5C9IBoXWaweqQNn+hDHhNQ9cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIgumjVZL7RIiRsDxWGIkrIL2h6SLX6Y467gzsDWY0E99tzv9FJtxJ6S/t7+EeBYoCIIrqWxIRyRqbM92TIoRitOrdLAdyek62xp7d04Y88JJFWKlV7rsykl7PVJ862d0SNUUsFa5MhcrAXTzbOocrU1qvnfjaWSF161X8kqFgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5qMVGjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5qMVGjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E202C4CEE2;
	Wed, 23 Apr 2025 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421568;
	bh=Fm0jhXmib3qO1+S1Ru5C9IBoXWaweqQNn+hDHhNQ9cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5qMVGjyDVT1GDfwjrnby2Z251oONVunk28jITNl1gjXXw7ROHWxhbHxUs462+R8o
	 JVMnSKsS2nURKC3LiWe1HdnJFVOEOl1/5K06hLnrDANeo/e9UB91QM9hSxLiIvvbfo
	 c03F+AW3FEr13OTVjkD3JStBuAaaY1tgXzyUW6bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.14 206/241] drm/i915/xe2hpd: Identify the memory type for SKUs with GDDR + ECC
Date: Wed, 23 Apr 2025 16:44:30 +0200
Message-ID: <20250423142628.956945156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Kasireddy <vivek.kasireddy@intel.com>

commit bc1feb8174b7e46c1806a6f684d89a47508f3a53 upstream.

Some SKUs of Xe2_HPD platforms (such as BMG) have GDDR memory type
with ECC enabled. We need to identify this scenario and add a new
case in xelpdp_get_dram_info() to handle it. In addition, the
derating value needs to be adjusted accordingly to compensate for
the limited bandwidth.

Bspec: 64602
Cc: Matt Roper <matthew.d.roper@intel.com>
Fixes: 3adcf970dc7e ("drm/xe/bmg: Drop force_probe requirement")
Cc: stable@vger.kernel.org
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Acked-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250324-tip-v2-1-38397de319f8@intel.com
(cherry picked from commit 327e30123cafcb45c0fc5843da0367b90332999d)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bw.c |   14 +++++++++++++-
 drivers/gpu/drm/i915/i915_drv.h         |    1 +
 drivers/gpu/drm/i915/soc/intel_dram.c   |    4 ++++
 drivers/gpu/drm/xe/xe_device_types.h    |    1 +
 4 files changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_bw.c
@@ -244,6 +244,7 @@ static int icl_get_qgv_points(struct drm
 			qi->deinterleave = 4;
 			break;
 		case INTEL_DRAM_GDDR:
+		case INTEL_DRAM_GDDR_ECC:
 			qi->channel_width = 32;
 			break;
 		default:
@@ -398,6 +399,12 @@ static const struct intel_sa_info xe2_hp
 	/* Other values not used by simplified algorithm */
 };
 
+static const struct intel_sa_info xe2_hpd_ecc_sa_info = {
+	.derating = 45,
+	.deprogbwlimit = 53,
+	/* Other values not used by simplified algorithm */
+};
+
 static int icl_get_bw_info(struct drm_i915_private *dev_priv, const struct intel_sa_info *sa)
 {
 	struct intel_qgv_info qi = {};
@@ -740,10 +747,15 @@ static unsigned int icl_qgv_bw(struct dr
 
 void intel_bw_init_hw(struct drm_i915_private *dev_priv)
 {
+	const struct dram_info *dram_info = &dev_priv->dram_info;
+
 	if (!HAS_DISPLAY(dev_priv))
 		return;
 
-	if (DISPLAY_VERx100(dev_priv) >= 1401 && IS_DGFX(dev_priv))
+	if (DISPLAY_VERx100(dev_priv) >= 1401 && IS_DGFX(dev_priv) &&
+		 dram_info->type == INTEL_DRAM_GDDR_ECC)
+		xe2_hpd_get_bw_info(dev_priv, &xe2_hpd_ecc_sa_info);
+	else if (DISPLAY_VERx100(dev_priv) >= 1401 && IS_DGFX(dev_priv))
 		xe2_hpd_get_bw_info(dev_priv, &xe2_hpd_sa_info);
 	else if (DISPLAY_VER(dev_priv) >= 14)
 		tgl_get_bw_info(dev_priv, &mtl_sa_info);
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -306,6 +306,7 @@ struct drm_i915_private {
 			INTEL_DRAM_DDR5,
 			INTEL_DRAM_LPDDR5,
 			INTEL_DRAM_GDDR,
+			INTEL_DRAM_GDDR_ECC,
 		} type;
 		u8 num_qgv_points;
 		u8 num_psf_gv_points;
--- a/drivers/gpu/drm/i915/soc/intel_dram.c
+++ b/drivers/gpu/drm/i915/soc/intel_dram.c
@@ -687,6 +687,10 @@ static int xelpdp_get_dram_info(struct d
 		drm_WARN_ON(&i915->drm, !IS_DGFX(i915));
 		dram_info->type = INTEL_DRAM_GDDR;
 		break;
+	case 9:
+		drm_WARN_ON(&i915->drm, !IS_DGFX(i915));
+		dram_info->type = INTEL_DRAM_GDDR_ECC;
+		break;
 	default:
 		MISSING_CASE(val);
 		return -EINVAL;
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -559,6 +559,7 @@ struct xe_device {
 			INTEL_DRAM_DDR5,
 			INTEL_DRAM_LPDDR5,
 			INTEL_DRAM_GDDR,
+			INTEL_DRAM_GDDR_ECC,
 		} type;
 		u8 num_qgv_points;
 		u8 num_psf_gv_points;


