Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804EC143889;
	Tue, 23 Apr 2024 21:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908596; cv=none; b=CCl4BJHUgkDxOuqqw0ICwu57jN7otaEk4kH2fdGwCETaCVOPujAfMUuVvTmmsGApRwkl3u7bjwqofL1uxY//c/oGWc2rEdCrZco8WK4os6RXfzqxvvWy4eO3WXXOkSn40Zrfm1fR3PSOuLIFhzjHVxdEd4yh01k0e7J1Y0LZWxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908596; c=relaxed/simple;
	bh=uAB7luWq9qUBiZ0VzaXdLGK5xInKmkD1/KbZmZ4q2Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EvHGCEeXsl8Blj9WF3kaAfAYFCte1ZkIVv/zUnvt2hDoNFaM/6yxTZzUJ2KLLHFnhRq7AWKe++ZC10wMG9WzdjSipk3XMzBv8B7OnRQJQiiVgsWQ4JTk6dlrNTMOIq950BfVrbo/k0upzsLg3ieQ5Rbh5yCccvxNRuq+BJrfXYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiEePytd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiEePytd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9DDC116B1;
	Tue, 23 Apr 2024 21:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908596;
	bh=uAB7luWq9qUBiZ0VzaXdLGK5xInKmkD1/KbZmZ4q2Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiEePytdsNsxSfF1Lrzoj2Dvfw6VLkXvDdyyadKs7vFbXNCM+bbgc+4xLKx/Ze0lK
	 1Zxcc4ao2HPyhhlwtquKK7823CuxlUpAt51wGIJbVYWHdYeDWEZtyMqaRmzJQWm8X9
	 yDwXA77mcGHOmZKdoHvYc2BtteRv8jkPeUgKAf5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uma Shankar <uma.shankar@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/158] drm/i915/mst: Limit MST+DSC to TGL+
Date: Tue, 23 Apr 2024 14:38:16 -0700
Message-ID: <20240423213857.694321759@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 51bc63392e96ca45d7be98bc43c180b174ffca09 ]

The MST code currently assumes that glk+ already supports MST+DSC,
which is incorrect. We need to check for TGL+ actually. ICL does
support SST+DSC, but supposedly it can't do MST+FEC which will
also rule out MST+DSC.

Note that a straight TGL+ check doesn't work here because DSC
support can get fused out, so we do need to also check 'has_dsc'.

Cc: stable@vger.kernel.org
Fixes: d51f25eb479a ("drm/i915: Add DSC support to MST path")
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402135148.23011-6-ville.syrjala@linux.intel.com
(cherry picked from commit c9c92f286dbdf872390ef3e74dbe5f0641e46f55)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_device.h | 1 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c         | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_device.h b/drivers/gpu/drm/i915/display/intel_display_device.h
index 215e682bd8b7a..5fd07c1817766 100644
--- a/drivers/gpu/drm/i915/display/intel_display_device.h
+++ b/drivers/gpu/drm/i915/display/intel_display_device.h
@@ -46,6 +46,7 @@ struct drm_printer;
 #define HAS_DPT(i915)			(DISPLAY_VER(i915) >= 13)
 #define HAS_DSB(i915)			(DISPLAY_INFO(i915)->has_dsb)
 #define HAS_DSC(__i915)			(DISPLAY_RUNTIME_INFO(__i915)->has_dsc)
+#define HAS_DSC_MST(__i915)		(DISPLAY_VER(__i915) >= 12 && HAS_DSC(__i915))
 #define HAS_FBC(i915)			(DISPLAY_RUNTIME_INFO(i915)->fbc_mask != 0)
 #define HAS_FPGA_DBG_UNCLAIMED(i915)	(DISPLAY_INFO(i915)->has_fpga_dbg)
 #define HAS_FW_BLC(i915)		(DISPLAY_VER(i915) > 2)
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index f104bd7f8c2a6..d2f8f20722d92 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -964,7 +964,7 @@ intel_dp_mst_mode_valid_ctx(struct drm_connector *connector,
 		return 0;
 	}
 
-	if (DISPLAY_VER(dev_priv) >= 10 &&
+	if (HAS_DSC_MST(dev_priv) &&
 	    drm_dp_sink_supports_dsc(intel_dp->dsc_dpcd)) {
 		/*
 		 * TBD pass the connector BPC,
-- 
2.43.0



