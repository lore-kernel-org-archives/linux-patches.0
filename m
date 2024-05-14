Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E05613D50C;
	Tue, 14 May 2024 11:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685908; cv=none; b=RZBE4wjmv7ceBxerK/B1yztFwiK/mnABDhmxGhwuYdKeS07mVfY1Buw6apXGnr/ULd+6Q2Uavbp1g5n7caj/YjhWa/BPIWqa+72pwRw/SO9lp2KO9uOdwcpIKz+1winv2cg1+Xeldpn5MKcMKEWKON7TaPA4LQauPrhhLbcadDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685908; c=relaxed/simple;
	bh=vpBrGLXfYAruUlpauA8xWgNTJJ5e4Ni0K5eVsZ9hfRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wj/3wb7LJG2bV/EzvwN6+qffVLszmGt0R5+iKRPRlGZ5YL/MmjUiQpRW1PBoVydAJncu7xdidhb4lKpOG/skMV+h/VoIHBInPkmO7XbPoYyf6vz4xyN5BrS0WZxie56/iN5O7CAjG4aAAgRTaAbNCbmFiu89Px3PHYQl4VvC/5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDWsPdec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDWsPdec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225DEC2BD10;
	Tue, 14 May 2024 11:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685908;
	bh=vpBrGLXfYAruUlpauA8xWgNTJJ5e4Ni0K5eVsZ9hfRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDWsPdecAIIXLOVZvNXAzHMs/KM2sgURtTF1fTH6/UKl8LaWUxTsz0u0ZgH0pGLVW
	 SPcnq/PfmmMA+RguaK2z02ISbemeIdkJxt+S5RJZLiPcwJY9z5ig2wKMcKlTeD2j+a
	 SOkYEfMdZB2+97XJmGm+IY883bgi/eqB3uhYESWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Karthikeyan Ramasubramanian <kramasub@chromium.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.6 274/301] drm/i915/bios: Fix parsing backlight BDB data
Date: Tue, 14 May 2024 12:19:05 +0200
Message-ID: <20240514101042.612492377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Ramasubramanian <kramasub@chromium.org>

commit 43b26bdd2ee5cfca80939be910d5b23a50cd7f9d upstream.

Starting BDB version 239, hdr_dpcd_refresh_timeout is introduced to
backlight BDB data. Commit 700034566d68 ("drm/i915/bios: Define more BDB
contents") updated the backlight BDB data accordingly. This broke the
parsing of backlight BDB data in VBT for versions 236 - 238 (both
inclusive) and hence the backlight controls are not responding on units
with the concerned BDB version.

backlight_control information has been present in backlight BDB data
from at least BDB version 191 onwards, if not before. Hence this patch
extracts the backlight_control information for BDB version 191 or newer.
Tested on Chromebooks using Jasperlake SoC (reports bdb->version = 236).
Tested on Chromebooks using Raptorlake SoC (reports bdb->version = 251).

v2: removed checking the block size of the backlight BDB data
    [vsyrjala: this is completely safe thanks to commit e163cfb4c96d
     ("drm/i915/bios: Make copies of VBT data blocks")]

Fixes: 700034566d68 ("drm/i915/bios: Define more BDB contents")
Cc: stable@vger.kernel.org
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Karthikeyan Ramasubramanian <kramasub@chromium.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240221180622.v2.1.I0690aa3e96a83a43b3fc33f50395d334b2981826@changeid
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
(cherry picked from commit c286f6a973c66c0d993ecab9f7162c790e7064c8)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c     |   19 ++++---------------
 drivers/gpu/drm/i915/display/intel_vbt_defs.h |    5 -----
 2 files changed, 4 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -1035,22 +1035,11 @@ parse_lfp_backlight(struct drm_i915_priv
 	panel->vbt.backlight.type = INTEL_BACKLIGHT_DISPLAY_DDI;
 	panel->vbt.backlight.controller = 0;
 	if (i915->display.vbt.version >= 191) {
-		size_t exp_size;
+		const struct lfp_backlight_control_method *method;
 
-		if (i915->display.vbt.version >= 236)
-			exp_size = sizeof(struct bdb_lfp_backlight_data);
-		else if (i915->display.vbt.version >= 234)
-			exp_size = EXP_BDB_LFP_BL_DATA_SIZE_REV_234;
-		else
-			exp_size = EXP_BDB_LFP_BL_DATA_SIZE_REV_191;
-
-		if (get_blocksize(backlight_data) >= exp_size) {
-			const struct lfp_backlight_control_method *method;
-
-			method = &backlight_data->backlight_control[panel_type];
-			panel->vbt.backlight.type = method->type;
-			panel->vbt.backlight.controller = method->controller;
-		}
+		method = &backlight_data->backlight_control[panel_type];
+		panel->vbt.backlight.type = method->type;
+		panel->vbt.backlight.controller = method->controller;
 	}
 
 	panel->vbt.backlight.pwm_freq_hz = entry->pwm_freq_hz;
--- a/drivers/gpu/drm/i915/display/intel_vbt_defs.h
+++ b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
@@ -897,11 +897,6 @@ struct lfp_brightness_level {
 	u16 reserved;
 } __packed;
 
-#define EXP_BDB_LFP_BL_DATA_SIZE_REV_191 \
-	offsetof(struct bdb_lfp_backlight_data, brightness_level)
-#define EXP_BDB_LFP_BL_DATA_SIZE_REV_234 \
-	offsetof(struct bdb_lfp_backlight_data, brightness_precision_bits)
-
 struct bdb_lfp_backlight_data {
 	u8 entry_size;
 	struct lfp_backlight_data_entry data[16];


