Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64EC33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE50C433EF;
	Mon, 16 Jan 2023 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884623;
	bh=rHBu8Dj6Z3tNqDguWD72F/yqqFaZkK23yTDZVV5DM9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eQm4XQcaLZ6o+KztYgUiXtsmukH7MZBhQarHEP5Y+Y+okXmhfqPQb5stFbO+3EO3
	 ahSK1Yo60dffZdpsMyUuuGvqOtDO+3HeYTsPoYz9V+/L5cOJhABKkPIh5OyN/65Ec+
	 Qh0xDkGF/+uEP9j17OsGmbH91b8AfRHts6WYs7uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Ao Zhong <hacc1225@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 036/183] drm/amd/display: move remaining FPU code to dml folder
Date: Mon, 16 Jan 2023 16:49:19 +0100
Message-Id: <20230116154804.903390554@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ao Zhong <hacc1225@gmail.com>

commit 58ddbecb14c792b7fe0d92ae5e25c9179d62ff25 upstream.

pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;
pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_chroma = 0;
these two operations in dcn32/dcn32_resource.c still need to use FPU,
This will cause compilation to fail on ARM64 platforms because
-mgeneral-regs-only is enabled by default to disable the hardware FPU.
Therefore, imitate the dcn31_zero_pipe_dcc_fraction function in
dml/dcn31/dcn31_fpu.c, declare the dcn32_zero_pipe_dcc_fraction function
in dcn32_fpu.c, and move above two operations into this function.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Ao Zhong <hacc1225@gmail.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c |    5 +++--
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c  |    8 ++++++++
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h  |    3 +++
 3 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1919,8 +1919,9 @@ int dcn32_populate_dml_pipes_from_contex
 		timing = &pipe->stream->timing;
 
 		pipes[pipe_cnt].pipe.src.gpuvm = true;
-		pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;
-		pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_chroma = 0;
+		DC_FP_START();
+		dcn32_zero_pipe_dcc_fraction(pipes, pipe_cnt);
+		DC_FP_END();
 		pipes[pipe_cnt].pipe.dest.vfront_porch = timing->v_front_porch;
 		pipes[pipe_cnt].pipe.src.gpuvm_min_page_size_kbytes = 256; // according to spreadsheet
 		pipes[pipe_cnt].pipe.src.unbounded_req_mode = false;
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2546,3 +2546,11 @@ void dcn32_update_bw_bounding_box_fpu(st
 	}
 }
 
+void dcn32_zero_pipe_dcc_fraction(display_e2e_pipe_params_st *pipes,
+				  int pipe_cnt)
+{
+	dc_assert_fp_enabled();
+
+	pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;
+	pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_chroma = 0;
+}
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h
@@ -73,4 +73,7 @@ int dcn32_find_dummy_latency_index_for_f
 
 void dcn32_patch_dpm_table(struct clk_bw_params *bw_params);
 
+void dcn32_zero_pipe_dcc_fraction(display_e2e_pipe_params_st *pipes,
+				  int pipe_cnt);
+
 #endif


