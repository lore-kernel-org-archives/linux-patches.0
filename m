Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5BE1DDC2B;
	Wed, 19 Mar 2025 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394959; cv=none; b=Zk7VTUKxHET477rnNxcccQVUec+Nj6RQnOExDWlr3OXXug3zslPI/gDU6Qps/qi76cqj96wwHkBBEDY2vU6rZ1RiQug9lP8F1J2xhL58ROqp6N5IH+qwAkWuglF6Wt92QvyeZETkeshDGT5YVV+VovvEs1HS72VTxzWzjNPzgyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394959; c=relaxed/simple;
	bh=/1wxIbI7iYKHrk4JO9i9+1CQWT7u1ZLQv1jCqWGSCWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p812LanNge+/GKrMrNkqXAd6pPuvaOhJosMOx5sNLC113vcSSbxaa/TMY9C1Hf7nZngzdg2bkS9tBgyjIGvwB654F6vs/tDoRSQFtcE9xCvva5fO9przUzMFyuF1/8cZsK8HPod+Q+MG59GdwHBq2YbCB5aDQOWP/y4gjGffiFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnA270TA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnA270TA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC329C4CEE4;
	Wed, 19 Mar 2025 14:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394958;
	bh=/1wxIbI7iYKHrk4JO9i9+1CQWT7u1ZLQv1jCqWGSCWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnA270TAIIdIx5jjAEcegPnLBoWKKkvlLBxSjx03bTMdSuo4jRVtfKiev7n9d9W0h
	 q5neM3vuyWCu1T9qLnjWNMydlkL+Cv426UKXvGRusVFsl0MPUuSfJvqBcWHWZzhegi
	 h2+JDsNanu3piTc7Vn77WVlOSABktFA6kIFCB/kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 186/241] drm/amd/display: Restore correct backlight brightness after a GPU reset
Date: Wed, 19 Mar 2025 07:30:56 -0700
Message-ID: <20250319143032.324080048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -244,6 +244,10 @@ static int amdgpu_dm_atomic_check(struct
 static void handle_hpd_irq_helper(struct amdgpu_dm_connector *aconnector);
 static void handle_hpd_rx_irq(void *param);
 
+static void amdgpu_dm_backlight_set_level(struct amdgpu_display_manager *dm,
+					 int bl_idx,
+					 u32 user_brightness);
+
 static bool
 is_timing_unchanged_for_freesync(struct drm_crtc_state *old_crtc_state,
 				 struct drm_crtc_state *new_crtc_state);
@@ -3318,6 +3322,12 @@ static int dm_resume(struct amdgpu_ip_bl
 
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


