Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135DB1DE89D;
	Tue,  8 Oct 2024 12:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391819; cv=none; b=IcBiZKjDdnAod4WUN6XVw+ldmsEC13jkKfKQ/rE/18fSJSZxIFMheGDrNVInD3gv9G15flAgfY38Yo2CYGwNAUOLjH5M8SsnokFEbRcpuWcduR0e4OF86Y47q3xCdpK3vQ5Yu1+rj5Tod/8Uq/6eIZJcr4ird5HORK2l30nOVmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391819; c=relaxed/simple;
	bh=48VcooHjkvA1uQQ0gEeuaEK9z2aOdTm1Gb4lMIuO+80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxGQ6ocL1R0Nnv8nhUA8ibhiG7jQMBLGuonp9eunzLi9FXqRnOt4wkXioko09vUNb7JHSqVPaUMQfBX60yZvDPnZxyyZwmgRrho3TwL7EO1Imy3nt/8aZbNB4Agje7WA0KYHUeUXLdrUUROSNx/Gdj04Ql9pBrnWqd2T/EhgAl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=si94sSXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="si94sSXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7520EC4CEC7;
	Tue,  8 Oct 2024 12:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391818;
	bh=48VcooHjkvA1uQQ0gEeuaEK9z2aOdTm1Gb4lMIuO+80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=si94sSXt770OZyrkaAq1I6UBLyqKNY5+QiwN3rXkiA7zKmcxie0DGWRC/humX6miW
	 05xps58yktyHFI5327hxZdWJpNpBJKDEr3awWiGfXWuYWuOHPVewoRa/EFhth3D72x
	 OONwTrIKQpsvi/tM+q0eljtPCaj2HXMk8WDvfB8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 231/558] drm/amd/display: Check null pointer before try to access it
Date: Tue,  8 Oct 2024 14:04:21 +0200
Message-ID: <20241008115711.432898639@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 1b686053c06ffb9f4524b288110cf2a831ff7a25 ]

[why & how]
Change the order of the pipe_ctx->plane_state check to ensure that
plane_state is not null before accessing it.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c   | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 7ca0da88290af..936c0ec076bc4 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -1931,6 +1931,11 @@ static void dcn20_program_pipe(
 	    (pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.bits.hdr_mult))
 		hws->funcs.set_hdr_multiplier(pipe_ctx);
 
+	if ((pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.bits.hdr_mult) ||
+	    pipe_ctx->update_flags.bits.enable)
+		hws->funcs.set_hdr_multiplier(pipe_ctx);
+
+
 	if (hws->funcs.populate_mcm_luts) {
 		if (pipe_ctx->plane_state) {
 			hws->funcs.populate_mcm_luts(dc, pipe_ctx, pipe_ctx->plane_state->mcm_luts,
@@ -1938,13 +1943,13 @@ static void dcn20_program_pipe(
 			pipe_ctx->plane_state->lut_bank_a = !pipe_ctx->plane_state->lut_bank_a;
 		}
 	}
-	if (pipe_ctx->update_flags.bits.enable ||
-	    (pipe_ctx->plane_state &&
+	if ((pipe_ctx->plane_state &&
 	     pipe_ctx->plane_state->update_flags.bits.in_transfer_func_change) ||
 	    (pipe_ctx->plane_state &&
 	     pipe_ctx->plane_state->update_flags.bits.gamma_change) ||
 	    (pipe_ctx->plane_state &&
-	     pipe_ctx->plane_state->update_flags.bits.lut_3d))
+	     pipe_ctx->plane_state->update_flags.bits.lut_3d) ||
+	     pipe_ctx->update_flags.bits.enable)
 		hws->funcs.set_input_transfer_func(dc, pipe_ctx, pipe_ctx->plane_state);
 
 	/* dcn10_translate_regamma_to_hw_format takes 750us to finish
-- 
2.43.0



