Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10846515961;
	Wed, 30 Sep 2026 16:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787586; cv=none; b=H9AEQLJhXH9c8LZnMOXoI7uiQ6rQh3b3az5YL+Xi5JandQwF2P+xdAOV1hgU8gI6Zw2QRDXw8EyN4oAVTtK6n47WriIUdrCeS8VhhneBPT22E8kT3cCyE+Lfstz83tnxY9onUWGc0LZcjnesiBjwLLWyQiJ382OyrYAkFnfcUsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787586; c=relaxed/simple;
	bh=g/o5dYgzYVgBkIlbc2J+FhZXvWkCqui4lZ84t314/YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeA+JW59a55MzRD3EwDUJfPNy+JNu3bfzvuJdcddxS44QGxZlJI5dBOSjhDgQLJ/nif10scRxzKjYWPoo+Og1NdiT5cpnRKIsnzYbd9VyyrKN4PSthjOqCWrYCibiFUc42UIn4F+JnrJnp+y+ObVEIS93gr1Aj5JWLLsEDUlH1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXYBd7M8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXYBd7M8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666DB1F000FF;
	Wed, 30 Sep 2026 16:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787584;
	bh=YnBoYMSBOjj2eeAQ7O8Aoqq8CukA4lvTBCpVEz0GigI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXYBd7M8ZzJA1JhigXK+beyrt/7EMyr9qlQDdGLjnzHyVE8MaSK3TszKnH8vvpRPg
	 rO0b0mVqggqKHvvycObaR8YlvZHysFnRYsttsGHNvi5yn6BZRQgo6d9ER9/973Ba9Z
	 olrLBVFkdhA1eZbLFTlHj7Ch0jZocPjMU/Aue7dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Coelho <luciano.coelho@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 7.2 281/457] drm/i915/dp_mst: Fix configuring TUs for a disconnected stream
Date: Wed, 30 Sep 2026 17:26:26 +0200
Message-ID: <20260930152352.100292043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit a443e0b8d647c1401b110d9f919d8c6cb8607260 upstream.

During an atomic commit after all the MST stream CRTC state is computed
the driver ensures that the sum of TUs of all the streams on a given MST
topology link is within limits (63 for 8b10 and 64 for 128b132b). For a
disconnected stream the DRM MST core's BW verification doesn't ensure
this, because the topology state it uses for this is destroyed as soon
as the stream (i.e. MST connector/port) is disconnected. The driver
should keep the link state valid even for such disconnected streams, as
userspace may disable them one-by-one only in a deferred way. Ensure the
link's sum of TUs stays within limits in this case by simply reusing the
maximum link BPP limit from the stream's (i.e. CRTC's) old state.

The disconnection can happen either via the whole topology getting
disconnected or via only the given stream's port getting disconnected.
Check for both of these conditions separately, as a connector gets
unregistered after a link disconnect event only in a deferred way.

Cc: stable@vger.kernel.org # v6.10+
Link: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16073
Link: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16384
Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260907174413.741851-2-imre.deak@intel.com
(cherry picked from commit ee00f8fbb2b202002ab90834e02e9ba372773a36)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c  |   21 +++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_dp_mst.h  |    2 ++
 drivers/gpu/drm/i915/display/intel_link_bw.c |    3 ++-
 3 files changed, 25 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -2122,6 +2122,27 @@ bool intel_dp_mst_crtc_needs_modeset(str
 	return false;
 }
 
+bool intel_dp_mst_stream_disconnected(struct intel_atomic_state *state,
+				      const struct intel_crtc *crtc)
+{
+	struct intel_connector *connector;
+
+	connector = get_connector_in_state_for_crtc(state, crtc);
+	if (!connector)
+		return false;
+
+	if (!connector->mst.dp)
+		return false;
+
+	if (!connector->mst.dp->mst.mgr.mst_state)
+		return true;
+
+	if (drm_connector_is_unregistered(&connector->base))
+		return true;
+
+	return false;
+}
+
 /**
  * intel_dp_mst_prepare_probe - Prepare an MST link for topology probing
  * @intel_dp: DP port object
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.h
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.h
@@ -28,6 +28,8 @@ int intel_dp_mst_atomic_check_link(struc
 				   struct intel_link_bw_limits *limits);
 bool intel_dp_mst_crtc_needs_modeset(struct intel_atomic_state *state,
 				     struct intel_crtc *crtc);
+bool intel_dp_mst_stream_disconnected(struct intel_atomic_state *state,
+				      const struct intel_crtc *crtc);
 void intel_dp_mst_prepare_probe(struct intel_dp *intel_dp);
 bool intel_dp_mst_verify_dpcd_state(struct intel_dp *intel_dp);
 
--- a/drivers/gpu/drm/i915/display/intel_link_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_link_bw.c
@@ -64,7 +64,8 @@ void intel_link_bw_init_limits(struct in
 			intel_atomic_get_new_crtc_state(state, crtc);
 		int forced_bpp_x16 = get_forced_link_bpp_x16(state, crtc);
 
-		if (state->base.duplicated && crtc_state) {
+		if ((state->base.duplicated && crtc_state) ||
+		    intel_dp_mst_stream_disconnected(state, crtc)) {
 			limits->max_bpp_x16[pipe] = crtc_state->max_link_bpp_x16;
 			if (intel_dsc_enabled_on_link(crtc_state))
 				limits->link_dsc_pipes |= BIT(pipe);


