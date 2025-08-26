Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B0A199935;
	Tue, 26 Aug 2025 11:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208623; cv=none; b=WLMD6VtZDMiPIwSHKNG2wLqt2ALoXqWfQMV51mfDsVGoPHVXIyfwtVvu3MolQWyNkaMiqirkkSo6/b82ZXmUt1SDMVuA8pb9L6VbpxgXd/j+48iNEUVsJvanZ+Q7TiedfdTfcKe4bFZEN25TH3MTenfyCjNx9e9UVCZPD9XiQJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208623; c=relaxed/simple;
	bh=nYC8nL4sNFI2sP5w7c03ZEAUxSp3C2z9XTaEMptK+VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nry5LKDhwV+zsQU3jtV0Lz2yb6trRk5uVRsUOWgmcj96GeLkJWzC/gvMDj9zDxnbMwhzbbGGMOiVAAn0zG3yZ2jTnPwBDd+EjN8q6LRfpopLQOegK+t+kmnDoZV2vnRa1+rZ88x7rMMmKGbBgdfBYSFAUJGXRdDLe+5h3IWaFXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KHygSOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KHygSOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D073C4CEF1;
	Tue, 26 Aug 2025 11:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208622;
	bh=nYC8nL4sNFI2sP5w7c03ZEAUxSp3C2z9XTaEMptK+VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KHygSOIvCtygfo/AG21UzDg3F2KPLlibysx/m6QnTmnyBcFpR9iqJxKRsu4ot7vh
	 f/6XPRX38HMDEET/if3MjBmONb7eOzhF6uVG/88Ts+n4jbq90mpENbcK56Hgsp0JWF
	 IxXCJDx5opOT5LVDTSk8p4tkizJTrGIKaPwTqCFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 6.12 183/322] drm/amd/display: Fix fractional fb divider in set_pixel_clock_v3
Date: Tue, 26 Aug 2025 13:09:58 +0200
Message-ID: <20250826110920.384444661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -993,7 +993,7 @@ static enum bp_result set_pixel_clock_v3
 	allocation.sPCLKInput.usFbDiv =
 			cpu_to_le16((uint16_t)bp_params->feedback_divider);
 	allocation.sPCLKInput.ucFracFbDiv =
-			(uint8_t)bp_params->fractional_feedback_divider;
+			(uint8_t)(bp_params->fractional_feedback_divider / 100000);
 	allocation.sPCLKInput.ucPostDiv =
 			(uint8_t)bp_params->pixel_clock_post_divider;
 


