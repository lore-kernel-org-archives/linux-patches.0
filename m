Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B14A53B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1B3C433C7;
	Sun, 17 Sep 2023 19:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980535;
	bh=9xV51YyNchbEXU2n98xZshXrwpMRd5yP3n0HRY7YXsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rje/se81pNejwU7aN+T3/TswcZiPZ6A1AFi9iUYbpwXePvrmUxGGGZp5TBl5SkqND
	 15FBqhBbvYiZHvbonj9148IDKdq803GNoXbzoLwZmdgWvQ7CwIIiJXmt9eTKdijvfL
	 BddixfbNVsom3mj1YG0IS+aIy1fT5OZzHDKTeBtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 220/285] drm/amd/display: limit the v_startup workaround to ASICs older than DCN3.1
Date: Sun, 17 Sep 2023 21:13:40 +0200
Message-ID: <20230917191059.124100411@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit 47428f4b638d3b3264a2efa1a567b0bbddbb6107 upstream.

Since, calling dcn20_adjust_freesync_v_startup() on DCN3.1+ ASICs
can cause the display to flicker and underflow to occur, we shouldn't
call it for them. So, ensure that the DCN version is less than
DCN_VERSION_3_1 before calling dcn20_adjust_freesync_v_startup().

Cc: stable@vger.kernel.org
Reviewed-by: Fangzhi Zuo <jerry.zuo@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
@@ -1099,7 +1099,8 @@ void dcn20_calculate_dlg_params(struct d
 		context->res_ctx.pipe_ctx[i].plane_res.bw.dppclk_khz =
 						pipes[pipe_idx].clks_cfg.dppclk_mhz * 1000;
 		context->res_ctx.pipe_ctx[i].pipe_dlg_param = pipes[pipe_idx].pipe.dest;
-		if (context->res_ctx.pipe_ctx[i].stream->adaptive_sync_infopacket.valid)
+		if (dc->ctx->dce_version < DCN_VERSION_3_1 &&
+		    context->res_ctx.pipe_ctx[i].stream->adaptive_sync_infopacket.valid)
 			dcn20_adjust_freesync_v_startup(
 				&context->res_ctx.pipe_ctx[i].stream->timing,
 				&context->res_ctx.pipe_ctx[i].pipe_dlg_param.vstartup_start);


