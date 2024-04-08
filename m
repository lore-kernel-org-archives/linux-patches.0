Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B1E823A8;
	Mon,  8 Apr 2024 13:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584081; cv=none; b=ivAzVdHuliFkEuUiwKJyI47Kps4CyDWmDfvkS7mmQfVhgn+Ap4fZnzxUxBRoMiIV23b6BZyk2EkMO3FsFGp6oFNdJ4eTAcIWK0SGEXZav1LGdevMX+lm0rFcqgh3gI1Q4kfLPGfURM652y38fw63EvrF/uN3uBKkyzFDV3RJKn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584081; c=relaxed/simple;
	bh=wMo6FpBTf9J+JmB7orybW2Ctq9t9J4YpN9nSS+CBIzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVjWO+WCb8Wml8/qnVnoo17DqcqsJbD+o0GO06Bbqe0aeyg3rmTubVhygIzAAuSgMR8+721kM2Y6QfSypilGmdyWem/YEXq1gsGzq4aYyhpJHRb5SZ/wzGyu/WaWPTrv5psFLCWpCDe/Z5ka/WMaq1T8Pdxdeeg1DUR/JLPDzCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x26aO29Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x26aO29Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1880BC43390;
	Mon,  8 Apr 2024 13:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584080;
	bh=wMo6FpBTf9J+JmB7orybW2Ctq9t9J4YpN9nSS+CBIzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x26aO29Z+NxuvuocOM/e5uCQ3ZdgottHcXEJs0JgQeV4xmIJxh3ant/3WtUbCymoM
	 pRGoUIwdMT0qRoNhPJBiA/dU9ioKVl30RRK2d2Y+ZuP3KokPK+SFlAtrvYvu3oWjYj
	 85BqYFSDIyn+iMFe7iZXmqUiK/kj6dbOaiqqax0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uma Shankar <uma.shankar@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 258/273] drm/i915/mst: Limit MST+DSC to TGL+
Date: Mon,  8 Apr 2024 14:58:53 +0200
Message-ID: <20240408125317.481385068@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 51bc63392e96ca45d7be98bc43c180b174ffca09 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_device.h |    1 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c         |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_display_device.h
+++ b/drivers/gpu/drm/i915/display/intel_display_device.h
@@ -47,6 +47,7 @@ struct drm_printer;
 #define HAS_DPT(i915)			(DISPLAY_VER(i915) >= 13)
 #define HAS_DSB(i915)			(DISPLAY_INFO(i915)->has_dsb)
 #define HAS_DSC(__i915)			(DISPLAY_RUNTIME_INFO(__i915)->has_dsc)
+#define HAS_DSC_MST(__i915)		(DISPLAY_VER(__i915) >= 12 && HAS_DSC(__i915))
 #define HAS_FBC(i915)			(DISPLAY_RUNTIME_INFO(i915)->fbc_mask != 0)
 #define HAS_FPGA_DBG_UNCLAIMED(i915)	(DISPLAY_INFO(i915)->has_fpga_dbg)
 #define HAS_FW_BLC(i915)		(DISPLAY_VER(i915) >= 3)
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -1338,7 +1338,7 @@ intel_dp_mst_mode_valid_ctx(struct drm_c
 		return 0;
 	}
 
-	if (DISPLAY_VER(dev_priv) >= 10 &&
+	if (HAS_DSC_MST(dev_priv) &&
 	    drm_dp_sink_supports_dsc(intel_connector->dp.dsc_dpcd)) {
 		/*
 		 * TBD pass the connector BPC,


