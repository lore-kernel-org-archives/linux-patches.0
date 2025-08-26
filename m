Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028B9352067;
	Tue, 26 Aug 2025 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216933; cv=none; b=bRG0Fvito9Lj960lQSMEFWg5Rycsdkv8KURhaWqjiTGF6+wZnpk6BInzvJ+6AjzFXee8H/nPxwWrhC4CaOsAifPL8oPuilwU1IyUSamSAa5V+/YayQrAHyQ++FywTemp0L2qdd2Rl7XKXQDLi4vyLSuDRpox3qmOWjzfggkV36A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216933; c=relaxed/simple;
	bh=qbLUZMlzg6jo8SOvZVGSJ0zYnm9cykDswXO2UHlK5Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kj7pxVF+NXcIE3EgHmFUWzdd+mYHPwMjIAHaIH3qU+myQVZy9s+vQUpFcYkG0qXS3mLb1/Oz6N4Xo08U5r31ZrhksVNN+QCgIkvUpwFCJKVbxPbSgOCs9f5t6PpWGLfzdTqNHw9zKh1BLxd+cmFutyXtxKaaC7jaixsNgIGPl5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIRwnTTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIRwnTTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DBEC113D0;
	Tue, 26 Aug 2025 14:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216932;
	bh=qbLUZMlzg6jo8SOvZVGSJ0zYnm9cykDswXO2UHlK5Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIRwnTTR3yo64kTdRRY4AoBewPT2+iPb+Rn0rEII06UNLK03/QxsRwwAo/uqYcbxQ
	 wl8Uc/PNqTtsoOP2/FEZrz5UVVwAfcr4WYVxgo1LcR3lqJbJMOZKFBsanmeKmlahn7
	 P+VL53oUgKj+xEjIugIp2rCS1z3q1ZMFyQEUesrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 5.15 570/644] drm/amd/display: Fix fractional fb divider in set_pixel_clock_v3
Date: Tue, 26 Aug 2025 13:11:01 +0200
Message-ID: <20250826111000.656718193@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 10507478468f165ea681605d133991ed05cdff62 upstream.

For later VBIOS versions, the fractional feedback divider is
calculated as the remainder of dividing the feedback divider by
a factor, which is set to 1000000. For reference, see:
- calculate_fb_and_fractional_fb_divider
- calc_pll_max_vco_construct

However, in case of old VBIOS versions that have
set_pixel_clock_v3, they only have 1 byte available for the
fractional feedback divider, and it's expected to be set to the
remainder from dividing the feedback divider by 10.
For reference see the legacy display code:
- amdgpu_pll_compute
- amdgpu_atombios_crtc_program_pll

This commit fixes set_pixel_clock_v3 by dividing the fractional
feedback divider passed to the function by 100000.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 027e7acc7e17802ebf28e1edb88a404836ad50d6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/command_table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/bios/command_table.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/command_table.c
@@ -992,7 +992,7 @@ static enum bp_result set_pixel_clock_v3
 	allocation.sPCLKInput.usFbDiv =
 			cpu_to_le16((uint16_t)bp_params->feedback_divider);
 	allocation.sPCLKInput.ucFracFbDiv =
-			(uint8_t)bp_params->fractional_feedback_divider;
+			(uint8_t)(bp_params->fractional_feedback_divider / 100000);
 	allocation.sPCLKInput.ucPostDiv =
 			(uint8_t)bp_params->pixel_clock_post_divider;
 


