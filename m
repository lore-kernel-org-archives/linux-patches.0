Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302683BCD38;
	Fri,  7 Aug 2026 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117060; cv=none; b=R+Pc3lq/NG2gwfgva0J2YoPNuTFPu+BauSSOHS1fDmXzISGo0JaXQ/8m2gapKh7JQkpQvyYqJCDHyTSaeVpOY8Nf85bgas6aiTddkwGypFhaL/oJwXFlU2v6hd+/FysX42Pg4gx1s3SmVNbyoikWE3WrPKUAORg7EcMgLjI2QEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117060; c=relaxed/simple;
	bh=uECO0W9CC2bG07cYRTT+BaR507n/IrXojrLegUodOQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsxpqhUtMeCbCD5bquAKjpNJ3rD8X57lEhPQ08kwCJ/cU8oLXhobu9EclkfVrfvIqawVnXV8MyJ2dTymtynKFn8w+shrALx8PhyXkQOwIQ4HvEn2pvp3lmvEO0ahZ3pIaoars7Ve9+/GfJMADhu+QaO/CjV2u27qmqbnF5P/flE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaFHW94p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaFHW94p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8938D1F000E9;
	Fri,  7 Aug 2026 15:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117059;
	bh=k3N33c3uWhZdEZKPdgBjHPZaplDIIIL7cF6Yvf55w9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaFHW94p5fwXubC2F6AvCp6cu8ZmHWI6VsoEYjdx8q51eOX+C6BD9ICGpS4sY0m5x
	 lBUgTlCs3F19QsnLXNL9j39Cs/7TnxFDy0PC7ZfL18CoH22O+lF+Wlp4KIqYIgL7kj
	 VMIrFqA4ng5bA2mU8QRiemOlld88W5O1qq/5wyZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Tollet <jtollet@cisco.com>,
	Jerome Tollet <jerome.tollet@gmail.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 186/438] drm/i915/hdmi: Poll for 200 msec for TMDS_Scrambler_Status
Date: Fri,  7 Aug 2026 16:36:22 +0200
Message-ID: <20260807143431.997242114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Tollet <jerome.tollet@gmail.com>

[ Upstream commit 1afb8eaeec44fd011f2b93ccd9fd426d753d963b ]

HDMI 2.0 section 6.1.3.1 specifies that after enabling
Scrambling_Enable and starting scrambled video transmission, the source
should poll Scrambling_Status until it reads 1 or until a timeout of
200 ms expires.

Add a polling step after enabling the HDMI port to check the scrambling
status when HDMI scrambling is enabled.

On some HDMI 2.0 sinks, omitting this check can result in 4K@60Hz
(594 MHz) failing to come up correctly because the sink has not yet
finished its scrambling setup. In practice, waiting for the scrambling
status here fixes such sinks.

While this synchronous polling is not itself explicitly required for
correct modeset sequencing, HDMI 2.0 section 6.1.3.1 does recommend it
as the way for the source to verify that the TMDS link is functioning
correctly with scrambling enabled.

v3:
 - Add explicit HDMI 2.0 section reference in code comment
 - Clarify commit message around the observed sink fix

v2:
 - Poll TMDS_Scrambler_Status for up to 200 ms instead of using a fixed
   delay

Reported-by: Jerome Tollet <jtollet@cisco.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6868
Link: https://lore.kernel.org/dri-devel/20251230091037.5603-1-jerome.tollet@gmail.com/
Signed-off-by: Jerome Tollet <jerome.tollet@gmail.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Arun R Murthy <arun.r.murthy@intel.com>
Link: https://patch.msgid.link/20260520022544.3097252-1-ankit.k.nautiyal@intel.com
(cherry picked from commit b7d51d65e4f12a48392d260613108ec262bc7774)
Fixes: 15953637886d ("drm/i915: enable scrambling")
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c  |  2 ++
 drivers/gpu/drm/i915/display/intel_hdmi.c | 26 +++++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_hdmi.h |  2 ++
 3 files changed, 30 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 0987eee38bd13..a3bfb1be51de8 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3502,6 +3502,8 @@ static void intel_ddi_enable_hdmi(struct intel_atomic_state *state,
 	}
 
 	intel_ddi_buf_enable(encoder, buf_ctl);
+
+	intel_hdmi_poll_for_scrambling_enable(crtc_state, connector);
 }
 
 static void intel_ddi_enable(struct intel_atomic_state *state,
diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
index 05e898d10a2be..234866310c14d 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -2693,6 +2693,32 @@ intel_hdmi_add_properties(struct intel_hdmi *intel_hdmi, struct drm_connector *_
 		drm_connector_attach_max_bpc_property(&connector->base, 8, 12);
 }
 
+/*
+ * HDMI 2.0 spec, section 6.1.3.1 (Scrambling Control): after
+ * enabling Scrambling_Enable and starting scrambled video
+ * transmission, poll Scrambling_Status for up to 200 ms.
+ */
+void
+intel_hdmi_poll_for_scrambling_enable(const struct intel_crtc_state *crtc_state,
+				      struct drm_connector *_connector)
+{
+	struct intel_connector *connector = to_intel_connector(_connector);
+	struct intel_display *display = to_intel_display(crtc_state);
+	bool scrambling_enabled = false;
+	int ret;
+
+	if (!crtc_state->hdmi_scrambling)
+		return;
+
+	/* Poll for a max of 200 msec as per HDMI spec */
+	ret = poll_timeout_us(scrambling_enabled = drm_scdc_get_scrambling_status(&connector->base),
+			      scrambling_enabled, 1000, 200 * 1000, false);
+	if (ret)
+		drm_dbg_kms(display->drm,
+			    "[CONNECTOR:%d:%s] Timed out waiting for scrambling enable\n",
+			    connector->base.base.id, connector->base.name);
+}
+
 /*
  * intel_hdmi_handle_sink_scrambling: handle sink scrambling/clock ratio setup
  * @encoder: intel_encoder
diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.h b/drivers/gpu/drm/i915/display/intel_hdmi.h
index be2fad57e4ad0..0fa3661568e86 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.h
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.h
@@ -70,5 +70,7 @@ void hsw_read_infoframe(struct intel_encoder *encoder,
 			const struct intel_crtc_state *crtc_state,
 			unsigned int type,
 			void *frame, ssize_t len);
+void intel_hdmi_poll_for_scrambling_enable(const struct intel_crtc_state *crtc_state,
+					   struct drm_connector *_connector);
 
 #endif /* __INTEL_HDMI_H__ */
-- 
2.53.0



