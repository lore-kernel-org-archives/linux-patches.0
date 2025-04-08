Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B25925FA13;
	Tue,  8 Apr 2025 11:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112412; cv=none; b=oJcTDCfrC2PNoSpKQ6b5Hh9zwr7j6kvnCk40S5VjS86x2Tc/H6K3zngHvw1xK1GbZ/MDOebnI8g4mF7XcSozxBjchxJAIeJjRBGTjGB+6mDQJlrr4RlIfNiEw5icJJh+IdJUCXLgbNFLMVSqymA75SCRHfHVg0M2TH+2KX2FbYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112412; c=relaxed/simple;
	bh=1Y68D0vMYuzQNgr7ul9er/8oMOqG/qQnqSdYIJytpNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8rxcJjzt1Rs42IYjTT1HPcVxtSzsKUoCBKfFVU/SuDd1zBoTm1+4aZvFhfiVilUYTVggoheDz3LNkQH1qgWWROJmiISVHZkM7LB6lL533eWaYB+K1GzQ7Np5qIIpb6nddI8G8e58RvDDpkmVxEjM3sfQJTGKTnLTK3EdeZ6jLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLccFvi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLccFvi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBADC4CEE7;
	Tue,  8 Apr 2025 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112412;
	bh=1Y68D0vMYuzQNgr7ul9er/8oMOqG/qQnqSdYIJytpNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLccFvi/OcUFn+ReL5xiEXUP/kiqlhsvKvZLMAC+lfU/0aAGgeIGK3bZN1iPkrCFD
	 VLpeYUem5L669pe+Q1WTSV/kVQj7LMEVOFKJS89suLFdBZ218/FKYTBAGuckB30riU
	 n/iZjNTn1w+vLgnUxzAJc0xj6h9ubPFXkRaNXXgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 059/279] drm/amd/display: Restore correct backlight brightness after a GPU reset
Date: Tue,  8 Apr 2025 12:47:22 +0200
Message-ID: <20250408104827.946741039@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 5760388d9681ac743038b846b9082b9023969551 upstream.

[Why]
GPU reset will attempt to restore cached state, but brightness doesn't
get restored. It will come back at 100% brightness, but userspace thinks
it's the previous value.

[How]
When running resume sequence if GPU is in reset restore brightness
to previous value.

Acked-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5e19e2b57b6bb640d68dfc7991e1e182922cf867)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -218,6 +218,10 @@ amd_get_format_info(const struct drm_mod
 
 static void handle_hpd_irq_helper(struct amdgpu_dm_connector *aconnector);
 
+static void amdgpu_dm_backlight_set_level(struct amdgpu_display_manager *dm,
+					 int bl_idx,
+					 u32 user_brightness);
+
 static bool
 is_timing_unchanged_for_freesync(struct drm_crtc_state *old_crtc_state,
 				 struct drm_crtc_state *new_crtc_state);
@@ -2698,6 +2702,12 @@ static int dm_resume(void *handle)
 
 		mutex_unlock(&dm->dc_lock);
 
+		/* set the backlight after a reset */
+		for (i = 0; i < dm->num_of_edps; i++) {
+			if (dm->backlight_dev[i])
+				amdgpu_dm_backlight_set_level(dm, i, dm->brightness[i]);
+		}
+
 		return 0;
 	}
 	/* Recreate dc_state - DC invalidates it when setting power state to S3. */


