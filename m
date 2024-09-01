Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539C817E900;
	Sun,  1 Sep 2024 16:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208289; cv=none; b=DaIWTVsfh09swHiqRw7T6m6v7ksPAiQsG/WZqN7xNbzP+bNLyMgaT9nbhTR6is3YJKbFXXawzjYCh7k83JXCWOZMAObc5Fp49xwyAXs2sWfelJ2pL0FxwLt5lMhMGekPyIYdMcZO3VUe9+MY1TR0xE2rrKC/9OWCV+Zbyy7T7uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208289; c=relaxed/simple;
	bh=ii6jbW5cLlPbgs4CBfSJ4BRbVLRJp9hSpo0msGPIR5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZpcYZha08HnDgAo5CG/JL8NsStyqLG8qddDsXi2JcPPTtbt2GDF49+BptqCSf7s/pCrqT9Obkia5zxhvqD6WvwcpilW3uUzMlj0ZoybSZ3FbXhhMiExAkWOacCH9IBw64Jg1/tbULafrzzqfdPqOn5Ww5MvhK9FOv7lliTdWec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dM5C9YxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dM5C9YxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5322C4CEC3;
	Sun,  1 Sep 2024 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208289;
	bh=ii6jbW5cLlPbgs4CBfSJ4BRbVLRJp9hSpo0msGPIR5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dM5C9YxMHmRmKJuEkZkqRwbR6NHQFWoiiD13By6gTZ73nUJygzzSyFM5aO6H3UzqU
	 Xj7AjMLjpa3gG2AdsLVnLPdwVxiwL6APYDdbVk+YGErQRv4gNUT3ZAZVZBc6dBAuSS
	 pCSmWrnmg6jPzLIDhmrMAZSfi2gXWOuJ5DIQ5lPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>
Subject: [PATCH 6.10 037/149] drm/i915/dp_mst: Fix MST state after a sink reset
Date: Sun,  1 Sep 2024 18:15:48 +0200
Message-ID: <20240901160818.857427720@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit a2ccc33b88e2953a6bf0b309e7e8849cc5320018 upstream.

In some cases the sink can reset itself after it was configured into MST
mode, without the driver noticing the disconnected state. For instance
the reset may happen in the middle of a modeset, or the (long) HPD pulse
generated may be not long enough for the encoder detect handler to
observe the HPD's deasserted state. In this case the sink's DPCD
register programmed to enable MST will be reset, while the driver still
assumes MST is still enabled. Detect this condition, which will tear
down and recreate/re-enable the MST topology.

v2:
- Add a code comment about adjusting the expected DP_MSTM_CTRL register
  value for SST + SideBand. (Suraj, Jani)
- Print a debug message about detecting the link reset. (Jani)
- Verify the DPCD MST state only if it wasn't already determined that
  the sink is disconnected.

Cc: stable@vger.kernel.org
Cc: Jani Nikula <jani.nikula@intel.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/11195
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com> (v1)
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240823162918.1211875-1-imre.deak@intel.com
(cherry picked from commit 594cf78dc36f31c0c7e0de4567e644f406d46bae)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c     |   12 ++++++++
 drivers/gpu/drm/i915/display/intel_dp_mst.c |   40 ++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_dp_mst.h |    1 
 3 files changed, 53 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -5860,6 +5860,18 @@ intel_dp_detect(struct drm_connector *co
 	else
 		status = connector_status_disconnected;
 
+	if (status != connector_status_disconnected &&
+	    !intel_dp_mst_verify_dpcd_state(intel_dp))
+		/*
+		 * This requires retrying detection for instance to re-enable
+		 * the MST mode that got reset via a long HPD pulse. The retry
+		 * will happen either via the hotplug handler's retry logic,
+		 * ensured by setting the connector here to SST/disconnected,
+		 * or via a userspace connector probing in response to the
+		 * hotplug uevent sent when removing the MST connectors.
+		 */
+		status = connector_status_disconnected;
+
 	if (status == connector_status_disconnected) {
 		memset(&intel_dp->compliance, 0, sizeof(intel_dp->compliance));
 		memset(intel_connector->dp.dsc_dpcd, 0, sizeof(intel_connector->dp.dsc_dpcd));
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -1986,3 +1986,43 @@ bool intel_dp_mst_crtc_needs_modeset(str
 
 	return false;
 }
+
+/*
+ * intel_dp_mst_verify_dpcd_state - verify the MST SW enabled state wrt. the DPCD
+ * @intel_dp: DP port object
+ *
+ * Verify if @intel_dp's MST enabled SW state matches the corresponding DPCD
+ * state. A long HPD pulse - not long enough to be detected as a disconnected
+ * state - could've reset the DPCD state, which requires tearing
+ * down/recreating the MST topology.
+ *
+ * Returns %true if the SW MST enabled and DPCD states match, %false
+ * otherwise.
+ */
+bool intel_dp_mst_verify_dpcd_state(struct intel_dp *intel_dp)
+{
+	struct intel_display *display = to_intel_display(intel_dp);
+	struct intel_connector *connector = intel_dp->attached_connector;
+	struct intel_digital_port *dig_port = dp_to_dig_port(intel_dp);
+	struct intel_encoder *encoder = &dig_port->base;
+	int ret;
+	u8 val;
+
+	if (!intel_dp->is_mst)
+		return true;
+
+	ret = drm_dp_dpcd_readb(intel_dp->mst_mgr.aux, DP_MSTM_CTRL, &val);
+
+	/* Adjust the expected register value for SST + SideBand. */
+	if (ret < 0 || val != (DP_MST_EN | DP_UP_REQ_EN | DP_UPSTREAM_IS_SRC)) {
+		drm_dbg_kms(display->drm,
+			    "[CONNECTOR:%d:%s][ENCODER:%d:%s] MST mode got reset, removing topology (ret=%d, ctrl=0x%02x)\n",
+			    connector->base.base.id, connector->base.name,
+			    encoder->base.base.id, encoder->base.name,
+			    ret, val);
+
+		return false;
+	}
+
+	return true;
+}
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.h
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.h
@@ -27,5 +27,6 @@ int intel_dp_mst_atomic_check_link(struc
 				   struct intel_link_bw_limits *limits);
 bool intel_dp_mst_crtc_needs_modeset(struct intel_atomic_state *state,
 				     struct intel_crtc *crtc);
+bool intel_dp_mst_verify_dpcd_state(struct intel_dp *intel_dp);
 
 #endif /* __INTEL_DP_MST_H__ */


