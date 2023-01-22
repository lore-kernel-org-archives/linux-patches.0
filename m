Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E2F2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1737C433EF;
	Sun, 22 Jan 2023 15:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400522;
	bh=eem0Bdn4KFz79WGXzpuQsalDJq5a9GQ82AjgP/GbNEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yW7j1pBfodcM3zqu3V9opubl0q8fo7S01hKzsxg0UN5NBlhB+XbQTIdeuVYqz82w3
	 Tvkv7a5HvbUd6NuPR0H2RYoGh9EaEC+H7Bixw3cornLvo7rgy3Ue4aqsQz72vcQLea
	 y9PVEkwCExrEpvcBqSK1VYgjpV3Z2JcENmE2p1PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Joshua Ashton <joshua@froggi.es>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 78/98] drm/amd/display: Calculate output_color_space after pixel encoding adjustment
Date: Sun, 22 Jan 2023 16:04:34 +0100
Message-Id: <20230122150232.738845971@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joshua Ashton <joshua@froggi.es>

commit 79601b894849cb6f6d6122e6590f1887ac4a66b3 upstream.

Code in get_output_color_space depends on knowing the pixel encoding to
determine whether to pick between eg. COLOR_SPACE_SRGB or
COLOR_SPACE_YCBCR709 for transparent RGB -> YCbCr 4:4:4 in the driver.

v2: Fixed patch being accidentally based on a personal feature branch, oops!

Fixes: ea117312ea9f ("drm/amd/display: Reduce HDMI pixel encoding if max clock is exceeded")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Joshua Ashton <joshua@froggi.es>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4567,8 +4567,6 @@ static void fill_stream_properties_from_
 	timing_out->pix_clk_100hz = mode_in->crtc_clock * 10;
 	timing_out->aspect_ratio = get_aspect_ratio(mode_in);
 
-	stream->output_color_space = get_output_color_space(timing_out);
-
 	stream->out_transfer_func->type = TF_TYPE_PREDEFINED;
 	stream->out_transfer_func->tf = TRANSFER_FUNCTION_SRGB;
 	if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A) {
@@ -4579,6 +4577,8 @@ static void fill_stream_properties_from_
 			adjust_colour_depth_from_display_info(timing_out, info);
 		}
 	}
+
+	stream->output_color_space = get_output_color_space(timing_out);
 }
 
 static void fill_audio_info(struct audio_info *audio_info,


