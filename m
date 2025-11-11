Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A098F4086A;
	Tue, 11 Nov 2025 00:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822421; cv=none; b=svG5tKtMwR3tzcXQwwj2UMb+9JNj+ZgJC/A3AFyGLFzXpsWT3VKHOIigDIxmGES3goNZrV34HFOLRmIe+o+tNaoqDemLRTpiMZk41hg0W1IJ3D2vRaGmoIuXcjXisAePrG1VzMtLN9A9Y7vcb81nXtfZbcSej28G1RocmwgUz9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822421; c=relaxed/simple;
	bh=I8Q1X5df1t3CSLz9nXGQlHOlYKDJ844Ql4ClmvfCmPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YI1TF5wJjgCuCtNHdCcSZeE5NWOc+0jnBHDKgcbcN8h+5fl8v2HVveYOWO8fdRjG4am0p47mPPV44otmvZtuVWGS5mjryq0J7ODOoHHe8a3b51PBMAFpUngnMuGEtk635R28VNr0edYm+l8oGxwigmHdj/9YtiN0kriPNsiZ6zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PqnCpx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PqnCpx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B31C116B1;
	Tue, 11 Nov 2025 00:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822421;
	bh=I8Q1X5df1t3CSLz9nXGQlHOlYKDJ844Ql4ClmvfCmPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PqnCpx04YTGKeYoVLH57k6zhSsJgQIIq+ZGLJDW/3hCoXvnKi9iqrkuo1JXiNzr+
	 9TKZJiH4Kwmz4Q/ZtwfWgRUyEPk/fiVCTngmyxDj6NG32GUpOBk6Lyq6JnHKQGpOP7
	 hGAsQDw85MTRdnsShFPUk0DbaJ1t47QtM0QAQ18E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.17 104/849] drm/i915/dmc: Clear HRR EVT_CTL/HTP to zero on ADL-S
Date: Tue, 11 Nov 2025 09:34:34 +0900
Message-ID: <20251111004538.916093587@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit dc8aa0cb87a7836b59422cc02d969c8df849ee39 upstream.

On ADL-S the main DMC HRR event DMC_EVT_CTL/HTP are never
restored to their previous values during DC6 exit. This
angers assert_dmc_loaded(), and basically makes the HRR
handler unusable because we don't rewrite EVT_HTP when
enabling DMC events.

Let's just clear the HRR EVT_CTL/HTP to zero from the
beginnning so that the expected value matches the post-DC6
reality.

I suppose if we ever had actual use for HRR we'd have to both,
reject HRR+PSR, and reprogram EVT_HTP when enabling the event.
But for now we don't care about HRR so keeping both registers
zeroed is fine.

Cc: stable@vger.kernel.org
Tested-by: Petr Vorel <pvorel@suse.cz>
Fixes: 43175c92d403 ("drm/i915/dmc: Assert DMC is loaded harder")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/15153
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20251022100718.24803-2-ville.syrjala@linux.intel.com
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Tested-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit 4df3b340ff6e9f499735d8b52b96a9257fde3918)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dmc.c | 55 +++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c b/drivers/gpu/drm/i915/display/intel_dmc.c
index 77a0199f9ea5..4a4cace1f879 100644
--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -546,6 +546,36 @@ static bool is_event_handler(struct intel_display *display,
 		REG_FIELD_GET(DMC_EVT_CTL_EVENT_ID_MASK, data) == event_id;
 }
 
+static bool fixup_dmc_evt(struct intel_display *display,
+			  enum intel_dmc_id dmc_id,
+			  i915_reg_t reg_ctl, u32 *data_ctl,
+			  i915_reg_t reg_htp, u32 *data_htp)
+{
+	if (!is_dmc_evt_ctl_reg(display, dmc_id, reg_ctl))
+		return false;
+
+	if (!is_dmc_evt_htp_reg(display, dmc_id, reg_htp))
+		return false;
+
+	/* make sure reg_ctl and reg_htp are for the same event */
+	if (i915_mmio_reg_offset(reg_ctl) - i915_mmio_reg_offset(DMC_EVT_CTL(display, dmc_id, 0)) !=
+	    i915_mmio_reg_offset(reg_htp) - i915_mmio_reg_offset(DMC_EVT_HTP(display, dmc_id, 0)))
+		return false;
+
+	/*
+	 * On ADL-S the HRR event handler is not restored after DC6.
+	 * Clear it to zero from the beginning to avoid mismatches later.
+	 */
+	if (display->platform.alderlake_s && dmc_id == DMC_FW_MAIN &&
+	    is_event_handler(display, dmc_id, MAINDMC_EVENT_VBLANK_A, reg_ctl, *data_ctl)) {
+		*data_ctl = 0;
+		*data_htp = 0;
+		return true;
+	}
+
+	return false;
+}
+
 static bool disable_dmc_evt(struct intel_display *display,
 			    enum intel_dmc_id dmc_id,
 			    i915_reg_t reg, u32 data)
@@ -1064,9 +1094,32 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 	for (i = 0; i < mmio_count; i++) {
 		dmc_info->mmioaddr[i] = _MMIO(mmioaddr[i]);
 		dmc_info->mmiodata[i] = mmiodata[i];
+	}
 
+	for (i = 0; i < mmio_count - 1; i++) {
+		u32 orig_mmiodata[2] = {
+			dmc_info->mmiodata[i],
+			dmc_info->mmiodata[i+1],
+		};
+
+		if (!fixup_dmc_evt(display, dmc_id,
+				   dmc_info->mmioaddr[i], &dmc_info->mmiodata[i],
+				   dmc_info->mmioaddr[i+1], &dmc_info->mmiodata[i+1]))
+			continue;
+
+		drm_dbg_kms(display->drm,
+			    " mmio[%d]: 0x%x = 0x%x->0x%x (EVT_CTL)\n",
+			    i, i915_mmio_reg_offset(dmc_info->mmioaddr[i]),
+			    orig_mmiodata[0], dmc_info->mmiodata[i]);
+		drm_dbg_kms(display->drm,
+			    " mmio[%d]: 0x%x = 0x%x->0x%x (EVT_HTP)\n",
+			    i+1, i915_mmio_reg_offset(dmc_info->mmioaddr[i+1]),
+			    orig_mmiodata[1], dmc_info->mmiodata[i+1]);
+	}
+
+	for (i = 0; i < mmio_count; i++) {
 		drm_dbg_kms(display->drm, " mmio[%d]: 0x%x = 0x%x%s%s\n",
-			    i, mmioaddr[i], mmiodata[i],
+			    i, i915_mmio_reg_offset(dmc_info->mmioaddr[i]), dmc_info->mmiodata[i],
 			    is_dmc_evt_ctl_reg(display, dmc_id, dmc_info->mmioaddr[i]) ? " (EVT_CTL)" :
 			    is_dmc_evt_htp_reg(display, dmc_id, dmc_info->mmioaddr[i]) ? " (EVT_HTP)" : "",
 			    disable_dmc_evt(display, dmc_id, dmc_info->mmioaddr[i],
-- 
2.51.2



