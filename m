Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40A018DF80;
	Tue, 11 Nov 2025 01:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825517; cv=none; b=Rklx87RqYRefMf/26ZO57z6K2hvG2JBDRwD+L5YG6Z5vv4bbCqYQrwLEmAJwCQPcc8cvDocMMLQze3K5vRNtrhV/Tt7R6HbiHjyvevDZ8dlziLljxgg5SKtj47DchB5LbFo4WaCN/xvc1+IIirBjz4pSZfJgnPOZ3cMRR7HX5ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825517; c=relaxed/simple;
	bh=uwR2xQDb4gsTiWabjuTa3jCEqu393FFSrUJMWPsalZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Or9AEmEvw04b8Z2/4Ie4rE5gp+b552f73usN3EmkZPDyfzt3jHcSDQtlrveyk2hoAwMItkL2F7jYF0Tix9cejqHUhR1lPe0bBkIZergCLREPB+PkmkiSYKwhN+gbMfnZYAegmq2mdyUjfHP0Zk4DLTamlhpcmuVFW55aZR5k2S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBmFrgt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBmFrgt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C13C4CEFB;
	Tue, 11 Nov 2025 01:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825517;
	bh=uwR2xQDb4gsTiWabjuTa3jCEqu393FFSrUJMWPsalZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBmFrgt4SQvY5Q2UKFc+kH25T/iAKyeTHO6WAAOKAB/1R+9yvWEHU0Jfb96n/47mX
	 KP+/aqbpp4TrodaDnDsQcvW64XCcEnB1bOjuGAeSwuCSdAgdgB8FAlNe4E4PuL2XMK
	 iZeCVj0uv9PdnjgBEWkS9E4KPVt1Yk4+X8YaJtAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 835/849] drm/amd/display: update color on atomic commit time
Date: Tue, 11 Nov 2025 09:46:45 +0900
Message-ID: <20251111004556.614051848@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -243,6 +243,7 @@ static int amdgpu_dm_encoder_init(struct
 
 static int amdgpu_dm_connector_get_modes(struct drm_connector *connector);
 
+static int amdgpu_dm_atomic_setup_commit(struct drm_atomic_state *state);
 static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state);
 
 static int amdgpu_dm_atomic_check(struct drm_device *dev,
@@ -3657,7 +3658,7 @@ static const struct drm_mode_config_func
 
 static struct drm_mode_config_helper_funcs amdgpu_dm_mode_config_helperfuncs = {
 	.atomic_commit_tail = amdgpu_dm_atomic_commit_tail,
-	.atomic_commit_setup = drm_dp_mst_atomic_setup_commit,
+	.atomic_commit_setup = amdgpu_dm_atomic_setup_commit,
 };
 
 static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
@@ -10208,6 +10209,39 @@ static void dm_set_writeback(struct amdg
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


