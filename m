Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED492BB17;
	Tue, 11 Nov 2025 01:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824966; cv=none; b=VtnYRRN+yea87EAq51fX8BeFPTKoGYpe817qe1dppL4IcqHP/lRiHVmodQvq/2jkcPD4kaPfHNkFRoCstrrhlWhn4qWvXny/RTHRvZ0gTiOcHK2Th9VVtsr6CAFRW+nMIpL+qcUIyMOBHbYQSp5TQGE2zA1v3f0lXqCYNkhRt64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824966; c=relaxed/simple;
	bh=NtGn3ftw8d8bViADqzHou2TV6NpC4TUs1fObCMqdK4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCvcMvfPY3zqUQCCpZwJP4MjXFPEH9DS4UYNazc57Iaco0gqmgt6dIgSeTSqzYdCcD5wiGcHnuWr2d6la7Ld75m5f1QY+hcryDBs6k3g0zM9eUc9YtU6itAtnU/NCbXN8haDmavGN2wKVYAywGAVm/erWWJ/19XB7m9l9Q+u7Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G10eBUGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G10eBUGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A39DC113D0;
	Tue, 11 Nov 2025 01:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824966;
	bh=NtGn3ftw8d8bViADqzHou2TV6NpC4TUs1fObCMqdK4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G10eBUGhOFa3tM1O4rgI/bp2BjsDXIutD4gFPZaxVHboAzNvql3z5mD5QeUrnRMoP
	 YEiqr5vmHhfK2BSgWp5ZYSMp5klqqNGhq0PKLTIJ4MsEvJzZd7kjeSYDV5A8Olz9h/
	 hdq5tL3IcTL9pRdZkjZnjXSJsNb5OVNuD2L3gU+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 559/565] drm/amd/display: update color on atomic commit time
Date: Tue, 11 Nov 2025 09:46:55 +0900
Message-ID: <20251111004539.586214064@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Melissa Wen <mwen@igalia.com>

commit 2f9c63883730a0bfecb086e6e59246933f936ca1 upstream.

Use `atomic_commit_setup` to change the DC stream state. It's a
preparation to remove from `atomic_check` changes in CRTC color
components of DC stream state and prevent DC to commit TEST_ONLY
changes.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/4444
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   36 +++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -235,6 +235,7 @@ static int amdgpu_dm_encoder_init(struct
 
 static int amdgpu_dm_connector_get_modes(struct drm_connector *connector);
 
+static int amdgpu_dm_atomic_setup_commit(struct drm_atomic_state *state);
 static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state);
 
 static int amdgpu_dm_atomic_check(struct drm_device *dev,
@@ -3509,7 +3510,7 @@ static const struct drm_mode_config_func
 
 static struct drm_mode_config_helper_funcs amdgpu_dm_mode_config_helperfuncs = {
 	.atomic_commit_tail = amdgpu_dm_atomic_commit_tail,
-	.atomic_commit_setup = drm_dp_mst_atomic_setup_commit,
+	.atomic_commit_setup = amdgpu_dm_atomic_setup_commit,
 };
 
 static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
@@ -9902,6 +9903,39 @@ static void dm_set_writeback(struct amdg
 	drm_writeback_queue_job(wb_conn, new_con_state);
 }
 
+static int amdgpu_dm_atomic_setup_commit(struct drm_atomic_state *state)
+{
+	struct drm_crtc *crtc;
+	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
+	struct dm_crtc_state *dm_old_crtc_state, *dm_new_crtc_state;
+	int i, ret;
+
+	ret = drm_dp_mst_atomic_setup_commit(state);
+	if (ret)
+		return ret;
+
+	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
+		dm_old_crtc_state = to_dm_crtc_state(old_crtc_state);
+		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
+		/*
+		 * Color management settings. We also update color properties
+		 * when a modeset is needed, to ensure it gets reprogrammed.
+		 */
+		if (dm_new_crtc_state->base.active && dm_new_crtc_state->stream &&
+		    (dm_new_crtc_state->base.color_mgmt_changed ||
+		     dm_old_crtc_state->regamma_tf != dm_new_crtc_state->regamma_tf ||
+		     drm_atomic_crtc_needs_modeset(new_crtc_state))) {
+			ret = amdgpu_dm_update_crtc_color_mgmt(dm_new_crtc_state);
+			if (ret) {
+				drm_dbg_atomic(state->dev, "Failed to update color state\n");
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
 /**
  * amdgpu_dm_atomic_commit_tail() - AMDgpu DM's commit tail implementation.
  * @state: The atomic state to commit


