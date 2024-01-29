Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76CB1586CF;
	Mon, 29 Jan 2024 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548243; cv=none; b=bC9Ae6UswZg+31qiWwsUJthI+Kbzb7N7vgo7UxQhogC0NPInBaYWlEcg3NcxuplUcZPFa5oTF5DJSJPv89C8rY+AJEqB9RcCurtPW1Fog8XmwmN7fgjuMipTJek566AU3Djns0Or/7UArum+guMjR2mi7EqJjbWfxA4U02qHlOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548243; c=relaxed/simple;
	bh=2q22MhMgUBje1FXvBCmzs69AkgI3GDVoHj8l/cVH4HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2DdliciS6N4wu6RYIym8Z2IdyWjJG1sHunBQmzh5Bh6BiroL2S1pqMjpDukhO4q6kdUTRujCdXXT68ZxvKsq1e1h9V5u0/blS45w0vfpqEkpo3tsdPq33ARl5Qs9l7XWwMTgI+I3jFotszSygvkJtBZdCXHcC4+N2ZLunPp4xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sB8JwBBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sB8JwBBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F841C433C7;
	Mon, 29 Jan 2024 17:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548243;
	bh=2q22MhMgUBje1FXvBCmzs69AkgI3GDVoHj8l/cVH4HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sB8JwBBdZPZ5qt+ifbLS+FUX4oVfzmhP4OLL8890XssQJPonS0zSE308VBkawehOP
	 d6U8X8Sc2UdWwEBDBPYqEJolgEFRrehzRfXJRLgGP1EXd0LqNL7oVe8E7so47u2SOD
	 F5ZBTs5lfN1g+JkJ9wAwL2QobRh+gg/n9OwhFjc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.7 268/346] drm/amd/display: Fix DML2 watermark calculation
Date: Mon, 29 Jan 2024 09:04:59 -0800
Message-ID: <20240129170024.270362919@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Bunea <ovidiu.bunea@amd.com>

commit d3579f5df0536c2f0fabaa3ea80bb2d179884195 upstream.

[Why]
core_mode_programming in DML2 should output watermark calculations
to locals, but it incorrectly uses mode_lib

[How]
update code to match HW DML2

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -9446,13 +9446,13 @@ void dml_core_mode_programming(struct di
 		CalculateWatermarks_params->CompressedBufferSizeInkByte = locals->CompressedBufferSizeInkByte;
 
 		// Output
-		CalculateWatermarks_params->Watermark = &s->dummy_watermark; // Watermarks *Watermark
-		CalculateWatermarks_params->DRAMClockChangeSupport = &mode_lib->ms.support.DRAMClockChangeSupport[0];
-		CalculateWatermarks_params->MaxActiveDRAMClockChangeLatencySupported = &s->dummy_single_array[0][0]; // dml_float_t *MaxActiveDRAMClockChangeLatencySupported[]
-		CalculateWatermarks_params->SubViewportLinesNeededInMALL = &mode_lib->ms.SubViewportLinesNeededInMALL[j]; // dml_uint_t SubViewportLinesNeededInMALL[]
-		CalculateWatermarks_params->FCLKChangeSupport = &mode_lib->ms.support.FCLKChangeSupport[0];
-		CalculateWatermarks_params->MaxActiveFCLKChangeLatencySupported = &s->dummy_single[0]; // dml_float_t *MaxActiveFCLKChangeLatencySupported
-		CalculateWatermarks_params->USRRetrainingSupport = &mode_lib->ms.support.USRRetrainingSupport[0];
+		CalculateWatermarks_params->Watermark = &locals->Watermark; // Watermarks *Watermark
+		CalculateWatermarks_params->DRAMClockChangeSupport = &locals->DRAMClockChangeSupport;
+		CalculateWatermarks_params->MaxActiveDRAMClockChangeLatencySupported = locals->MaxActiveDRAMClockChangeLatencySupported; // dml_float_t *MaxActiveDRAMClockChangeLatencySupported[]
+		CalculateWatermarks_params->SubViewportLinesNeededInMALL = locals->SubViewportLinesNeededInMALL; // dml_uint_t SubViewportLinesNeededInMALL[]
+		CalculateWatermarks_params->FCLKChangeSupport = &locals->FCLKChangeSupport;
+		CalculateWatermarks_params->MaxActiveFCLKChangeLatencySupported = &locals->MaxActiveFCLKChangeLatencySupported; // dml_float_t *MaxActiveFCLKChangeLatencySupported
+		CalculateWatermarks_params->USRRetrainingSupport = &locals->USRRetrainingSupport;
 
 		CalculateWatermarksMALLUseAndDRAMSpeedChangeSupport(
 			&mode_lib->scratch,


