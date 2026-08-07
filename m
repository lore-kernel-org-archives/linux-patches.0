Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3529F41837A;
	Fri,  7 Aug 2026 14:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114611; cv=none; b=am03v3v/YJ+QYeBfKGlrvG7Hm9xCyecrYXgkMdE6tfqFcAJ9pwzhS/9ujCKtil90FWnDDKB9ofw45UTgxpqLKeXnKB3i+1Ii65hkuEh8rpNq0hgm3WQAOZT+XmSBLdyDNC78mpZtpYO0b797bwciw99izRavgXVCugya0MbDxno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114611; c=relaxed/simple;
	bh=0JRUygIWrJyymD7ZIhSMeqcr2E8tSNgyh5hO2JpVzzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuexqzWYJ/pgjjJedwcBI8M9h5FJ1Y3tdTbUtljsf8iKcBQ0Wj71dsBy9vstQo3L9JQaZVzLHgB52OZDLeOJX2ZYRb4klYah+Xjg7AAwsqXybD2UtbjMfcAl0BxoBccojchc7TqFlMtDGutnSja0gCHr1m+0oJJ2fBSAlMPlcuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6IrbULR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6IrbULR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7974D1F000E9;
	Fri,  7 Aug 2026 14:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114608;
	bh=KMTrSUVfry6Xu8xhUbKClJFBYvA7yFlt0rzQZ4ZXvVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6IrbULRGVQcqA0uOY6KV3xhUmKtJ8DOkNb8JInCOGWtSQHi7IxIY9kRS657wsZRm
	 tqi/pnCIVTUXXviaI7pw4X0JFq+1C+UotLHuzcGEj4992JqSzphlPF6xWbnQkqTnz5
	 f/JjC/dQpg3Ir09bQka9gkA0Kl7mlyamSGGfyatU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Santhosh Reddy Guddati <santhosh.reddy.guddati@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/337] drm/i915/hdcp: Skip inactive MST connectors when building stream list
Date: Fri,  7 Aug 2026 16:38:47 +0200
Message-ID: <20260807143425.561506875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit 0161e2c2016337a2f22ef79dff0aee43c0841bce ]

intel_hdcp_required_content_stream() walks every connector on the
digital port to populate hdcp_port_data->streams[]. The only filter is
connector_status_disconnected, which reflects physical presence on the
MST topology, not whether the connector currently drives a stream.
On a multi-sink MST setup where only a subset of sinks are modeset,
the loop can pick a sibling MST connector that is connected but has
no active CRTC / VC payload. intel_conn_to_vcpi() then logs "MST
Payload not present" and returns 0, and the bogus StreamID=0 is
written to the repeater in RepeaterAuth_Stream_Manage (DPCD 0x693F0).
Authentication completes, but the repeater shortly raises
LINK_INTEGRITY_FAILURE (RxStatus 0x69493 bit4) because the StreamID
does not match any stream on its input. The HDCP check work then
tears the link down, the Content Protection property drops back to
DESIRED, and userspace observes a spurious HDCP enable failure.
Filter the connector iteration to only those with a CRTC assigned in
the new atomic state, so intel_conn_to_vcpi() is called for the
connector actually being enabled and reads its real VCPI from the MST
topology state.

Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Santhosh Reddy Guddati <santhosh.reddy.guddati@intel.com>
Link: https://patch.msgid.link/20260505094022.4064256-1-suraj.kandpal@intel.com
Stable-dep-of: bbb15a6b042d ("drm/i915/hdcp: check streams[] bounds before overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -97,6 +97,7 @@ intel_hdcp_required_content_stream(struc
 {
 	struct intel_display *display = to_intel_display(state);
 	struct drm_connector_list_iter conn_iter;
+	struct drm_connector_state *new_conn_state;
 	struct intel_digital_port *conn_dig_port;
 	struct intel_connector *connector;
 	struct hdcp_port_data *data = &dig_port->hdcp_port_data;
@@ -123,6 +124,11 @@ intel_hdcp_required_content_stream(struc
 		if (conn_dig_port != dig_port)
 			continue;
 
+		new_conn_state = drm_atomic_get_new_connector_state(&state->base,
+								    &connector->base);
+		if (!new_conn_state || !new_conn_state->crtc)
+			continue;
+
 		data->streams[data->k].stream_id =
 			intel_conn_to_vcpi(state, connector);
 		data->k++;


