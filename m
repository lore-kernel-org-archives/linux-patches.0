Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF95B1D0488;
	Wed,  2 Oct 2024 14:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878678; cv=none; b=sZapJBm0zEtZjJS0ZSVySxjbk8LN8KthQG3NA4MBoU97jG+frTYAUJpnGjk2MZ0/iowrCRbt92U9apCUYRAZVzwS1hj8g3zz9qdry8lsVEvEl28YuQhdcb0TAA9//mO2Tgv2mcVAeaQt0t9PqAr3kbhjuszHov6ZD1r+c6s4xUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878678; c=relaxed/simple;
	bh=Ic8trJeLeQwOvNugt14e2igm6N5ZasAjaWQY32AlnoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZpn9H4eQ4QWIAw+4hQu7L4KnrL58ohMUXOJvIW10cWaeyuMn+LBFJTArWRrThy8oMvPCAuAoQ7sPxwn67y7qMrJDNWSU46oEA9V8nw8/7olFmv+5KTaqpJXu6piEMbGXXpqGoXdHszkfLcCFj9FRO6jItHFunPyT8ib3T1fB88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHEEQRlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHEEQRlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FB9C4CEC2;
	Wed,  2 Oct 2024 14:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878678;
	bh=Ic8trJeLeQwOvNugt14e2igm6N5ZasAjaWQY32AlnoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHEEQRlZ5KRAJgXHirQidLp4Id9yiV6OiqzfcFRhKSvwynk+s8Yv/nyan3HUQueOY
	 +u4MtDEA5Uec/CxppFguAefXPk7/yMx6PBZmUwAQZ0S/LCK5oK86cmSttY3qian5O2
	 zVFWCz8Fxzg1Aomu99wnR01ebhdqeKul9yzHhLlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 495/634] drm/amd/display: Validate backlight caps are sane
Date: Wed,  2 Oct 2024 14:59:55 +0200
Message-ID: <20241002125830.637581358@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 327e62f47eb57ae5ff63de82b0815557104e439a upstream.

Currently amdgpu takes backlight caps provided by the ACPI tables
on systems as is.  If the firmware sets maximums that are too low
this means that users don't get a good experience.

To avoid having to maintain a quirk list of such systems, do a sanity
check on the values.  Check that the spread is at least half of the
values that amdgpu would use if no ACPI table was found and if not
use the amdgpu defaults.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3020
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4149,6 +4149,7 @@ static int amdgpu_dm_mode_config_init(st
 
 #define AMDGPU_DM_DEFAULT_MIN_BACKLIGHT 12
 #define AMDGPU_DM_DEFAULT_MAX_BACKLIGHT 255
+#define AMDGPU_DM_MIN_SPREAD ((AMDGPU_DM_DEFAULT_MAX_BACKLIGHT - AMDGPU_DM_DEFAULT_MIN_BACKLIGHT) / 2)
 #define AUX_BL_DEFAULT_TRANSITION_TIME_MS 50
 
 static void amdgpu_dm_update_backlight_caps(struct amdgpu_display_manager *dm,
@@ -4163,6 +4164,21 @@ static void amdgpu_dm_update_backlight_c
 		return;
 
 	amdgpu_acpi_get_backlight_caps(&caps);
+
+	/* validate the firmware value is sane */
+	if (caps.caps_valid) {
+		int spread = caps.max_input_signal - caps.min_input_signal;
+
+		if (caps.max_input_signal > AMDGPU_DM_DEFAULT_MAX_BACKLIGHT ||
+		    caps.min_input_signal < AMDGPU_DM_DEFAULT_MIN_BACKLIGHT ||
+		    spread > AMDGPU_DM_DEFAULT_MAX_BACKLIGHT ||
+		    spread < AMDGPU_DM_MIN_SPREAD) {
+			DRM_DEBUG_KMS("DM: Invalid backlight caps: min=%d, max=%d\n",
+				      caps.min_input_signal, caps.max_input_signal);
+			caps.caps_valid = false;
+		}
+	}
+
 	if (caps.caps_valid) {
 		dm->backlight_caps[bl_idx].caps_valid = true;
 		if (caps.aux_support)


