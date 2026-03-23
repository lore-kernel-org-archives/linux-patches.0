Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3E73AC0D2;
	Mon, 23 Mar 2026 13:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273871; cv=none; b=ii3nXzw2viWTccFVlkpqvJuPuQ8iYAiorKjv3vTQbvOQ9JvWI9VhoCEX3jtmHTYtnCmBqUP1KyOyUEA/W11UXN/bROmd4tlXxqTFI3mdDTZY3LFktnpHYjAsRn3KIZuG462UwNRwJr4j1KvH50xH/tDE69fwsZsW20BK8U2V6/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273871; c=relaxed/simple;
	bh=NjhYuGDG5ilikqW80UMNinCoJc5buKTUxKg1pLFVKqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FNc5IndM0GMWxLmusforxvuNsvFiI7PktZs3bL42qS1ZfjPZVgokfP/F7i32sq2qj30KC/6Wm/VIJQlPqfFLmF6193YuJbctlz/f1qfxCVv5Nxq7/fYqe/BsNJq1QRE+xEQXD0jcs6/2YLznR/qfwKQhiRzHfVnUUkclryZ3+SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w00V+NCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w00V+NCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E22C2BCB1;
	Mon, 23 Mar 2026 13:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273871;
	bh=NjhYuGDG5ilikqW80UMNinCoJc5buKTUxKg1pLFVKqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w00V+NCk3FIotCqmDWnDxbuwTcJxkbn3skvzVrNkBeu+6pX2CqnsYQ31hi14dsNfx
	 N4y/WXRDfhogvMpFW2Zpk4mUoQ/jFIO63cvni1a5Eic7OrZid850M4REEqXXhYxadJ
	 QAbS322N0USBi0CdWsCCOLZWS3yquEKfBupuJ1BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.19 028/220] drm/i915/dsc: Add helper for writing DSC Selective Update ET parameters
Date: Mon, 23 Mar 2026 14:43:25 +0100
Message-ID: <20260323134505.466343500@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit bb5f1cd10101c2567bff4d0e760b74aee7c42f44 upstream.

There are slice row per frame and pic height configuration in DSC Selective
Update Parameter Set 1 register. Add helper for configuring these.

v2:
  - Add WARN_ON_ONCE if vdsc instances per pipe > 2
  - instead of checking vdsc instances per pipe being > 1 check == 2

Bspec: 71709
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260304113011.626542-4-jouni.hogander@intel.com
(cherry picked from commit c8698d61aeb3f70fe33761ee9d3d0e131b5bc2eb)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
[tursulin: fixup forward declaration conflict]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vdsc.c |   23 +++++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_vdsc.h |    3 +++
 2 files changed, 26 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_vdsc.c
+++ b/drivers/gpu/drm/i915/display/intel_vdsc.c
@@ -767,6 +767,29 @@ void intel_dsc_dp_pps_write(struct intel
 				  sizeof(dp_dsc_pps_sdp));
 }
 
+void intel_dsc_su_et_parameters_configure(struct intel_dsb *dsb, struct intel_encoder *encoder,
+					  const struct intel_crtc_state *crtc_state, int su_lines)
+{
+	struct intel_display *display = to_intel_display(crtc_state);
+	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
+	const struct drm_dsc_config *vdsc_cfg = &crtc_state->dsc.config;
+	enum pipe pipe = crtc->pipe;
+	int vdsc_instances_per_pipe = intel_dsc_get_vdsc_per_pipe(crtc_state);
+	int slice_row_per_frame = su_lines / vdsc_cfg->slice_height;
+	u32 val;
+
+	drm_WARN_ON_ONCE(display->drm, su_lines % vdsc_cfg->slice_height);
+	drm_WARN_ON_ONCE(display->drm, vdsc_instances_per_pipe > 2);
+
+	val = DSC_SUPS0_SU_SLICE_ROW_PER_FRAME(slice_row_per_frame);
+	val |= DSC_SUPS0_SU_PIC_HEIGHT(su_lines);
+
+	intel_de_write_dsb(display, dsb, LNL_DSC0_SU_PARAMETER_SET_0(pipe), val);
+
+	if (vdsc_instances_per_pipe == 2)
+		intel_de_write_dsb(display, dsb, LNL_DSC1_SU_PARAMETER_SET_0(pipe), val);
+}
+
 static i915_reg_t dss_ctl1_reg(struct intel_crtc *crtc, enum transcoder cpu_transcoder)
 {
 	return is_pipe_dsc(crtc, cpu_transcoder) ?
--- a/drivers/gpu/drm/i915/display/intel_vdsc.h
+++ b/drivers/gpu/drm/i915/display/intel_vdsc.h
@@ -13,6 +13,7 @@ struct drm_printer;
 enum transcoder;
 struct intel_crtc;
 struct intel_crtc_state;
+struct intel_dsb;
 struct intel_encoder;
 
 bool intel_dsc_source_support(const struct intel_crtc_state *crtc_state);
@@ -31,6 +32,8 @@ void intel_dsc_dsi_pps_write(struct inte
 			     const struct intel_crtc_state *crtc_state);
 void intel_dsc_dp_pps_write(struct intel_encoder *encoder,
 			    const struct intel_crtc_state *crtc_state);
+void intel_dsc_su_et_parameters_configure(struct intel_dsb *dsb, struct intel_encoder *encoder,
+					  const struct intel_crtc_state *crtc_state, int su_lines);
 void intel_vdsc_state_dump(struct drm_printer *p, int indent,
 			   const struct intel_crtc_state *crtc_state);
 int intel_vdsc_min_cdclk(const struct intel_crtc_state *crtc_state);


