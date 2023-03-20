Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD641C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42165C433EF;
	Mon, 20 Mar 2023 15:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325890;
	bh=IvoQRO8aJSiilef6YAwJXeLVKe9kE3tn576/sb9v0Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKIz/H+JaU3sEK/IGHIoUJZGdU+Lv3Jx/ZS02RoBfYB9uBozBrwX3zjLF9Wi8niCo
	 qxZkEUIDfYVHdPv89b0pTlGXYBpfxYBtu8xisK1AG8+do8b+F5ngowhKIggCeqY8y4
	 3lsgVMQtOOGmR5rCAhIwG6ldsx9pNDeYeg6ke0d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Ayush Gupta <ayugupta@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 163/198] drm/amd/display: disconnect MPCC only on OTG change
Date: Mon, 20 Mar 2023 15:55:01 +0100
Message-Id: <20230320145514.377165421@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ayush Gupta <ayugupta@amd.com>

commit 7304ee979b6b6422f41a1312391a5e505fc29ccd upstream.

[Why]
Framedrops are observed while playing Vp9 and Av1 10 bit
video on 8k resolution using VSR while playback controls
are disappeared/appeared

[How]
Now ODM 2 to 1 is disabled for 5k or greater resolutions on VSR.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Ayush Gupta <ayugupta@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1883,6 +1883,7 @@ int dcn32_populate_dml_pipes_from_contex
 	bool subvp_in_use = false;
 	uint8_t is_pipe_split_expected[MAX_PIPES] = {0};
 	struct dc_crtc_timing *timing;
+	bool vsr_odm_support = false;
 
 	dcn20_populate_dml_pipes_from_context(dc, context, pipes, fast_validate);
 
@@ -1900,12 +1901,15 @@ int dcn32_populate_dml_pipes_from_contex
 		timing = &pipe->stream->timing;
 
 		pipes[pipe_cnt].pipe.dest.odm_combine_policy = dm_odm_combine_policy_dal;
+		vsr_odm_support = (res_ctx->pipe_ctx[i].stream->src.width >= 5120 &&
+				res_ctx->pipe_ctx[i].stream->src.width > res_ctx->pipe_ctx[i].stream->dst.width);
 		if (context->stream_count == 1 &&
 				context->stream_status[0].plane_count == 1 &&
 				!dc_is_hdmi_signal(res_ctx->pipe_ctx[i].stream->signal) &&
 				is_h_timing_divisible_by_2(res_ctx->pipe_ctx[i].stream) &&
 				pipe->stream->timing.pix_clk_100hz * 100 > DCN3_2_VMIN_DISPCLK_HZ &&
-				dc->debug.enable_single_display_2to1_odm_policy) {
+				dc->debug.enable_single_display_2to1_odm_policy &&
+				!vsr_odm_support) { //excluding 2to1 ODM combine on >= 5k vsr
 			pipes[pipe_cnt].pipe.dest.odm_combine_policy = dm_odm_combine_policy_2to1;
 		}
 		pipe_cnt++;


