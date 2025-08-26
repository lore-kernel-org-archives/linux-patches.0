Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6A2350851;
	Tue, 26 Aug 2025 14:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218109; cv=none; b=p/bi4PjQyA33ddavASwvloDOTdJQkY7vcvEBLctc26DXSxFbMbPlfDVy4H08fRIDLKoE0ianFI9NA75GZOTQHiHXB9JR6Tey1uYARN5hOw6K3mqP5yRoaasdDzLEZj38STGRdRGsFx0ezrLiDBP7bacZSVh5GYeQlIU8aNv6nog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218109; c=relaxed/simple;
	bh=Q3YSVWJc+zWFz4jmXmVxr5dkMu2iHJsepne/JfgAFTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TeV5NrgxvclcpaQbKViOM+zcEyy6N1k+mqDEhJS1YndElpB8rg4RvhOq1ej8TC8nT3fd7LbY1MLG2NX8eE4tkDg0UqfFE6yB99w0H/DISxWB96pyKPtFvQjjjV5Z/3G18NrWOj5pHvezkD+9FGOCZnu5lDIIAwr/NdrbK7hTH7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYsw2u80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYsw2u80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C769CC113CF;
	Tue, 26 Aug 2025 14:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218109;
	bh=Q3YSVWJc+zWFz4jmXmVxr5dkMu2iHJsepne/JfgAFTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYsw2u806Mzk1O1oeWVdVZgfyrFsWrKAeifMFA3W8ywemZ4LIkfna2MazrdLzHFmY
	 Ykkinmi0ar+WU/rS4GRVzOdlLj4fSCKZAjR1klyz6FryIzdAIsIBJwhcFZ5UR91+gA
	 mRM1+nGciGViuGlyPDIDLDg04qmNECBql5P8mVcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 5.10 396/523] drm/amd/display: Fix fractional fb divider in set_pixel_clock_v3
Date: Tue, 26 Aug 2025 13:10:06 +0200
Message-ID: <20250826110934.229812754@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


