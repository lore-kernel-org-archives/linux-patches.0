Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A432080FC;
	Thu, 12 Dec 2024 15:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016687; cv=none; b=Ak+SqClVarabAEjctgx0EubwPeUea7sVTVsk2ZCDBkxX1s+Cl5NwPhNhv58YTBu4PXKs+9guPllf0Zmeeq/DxaTCPZqHNOvl1LfWcypiDSSyhYpnN7l3FBk32msIAtZEylxKzDigxz7Bw6rtoue0FLZTRO6lmGKeTmrV0o0XFBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016687; c=relaxed/simple;
	bh=pk6cTvR6zpwrwDaVhgq2T2foRoAFMLJOtuuT5zfHT1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpvEVjqVpWXNkwJ71IyflFjpiCmIeGkckVOk17rEiJBLziVItezRNrPkCpisoaadAKPW2cxSNgirgUbwXcrfWdAuFR9BebmwoOZ+4S5alrsr6jfzJWIF34gA78unHu5l9ef1edXx5vX2sZTfgE7ancaNl6cpHp/4wHeCaOqdHq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILm2uIjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILm2uIjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42246C4CECE;
	Thu, 12 Dec 2024 15:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016686;
	bh=pk6cTvR6zpwrwDaVhgq2T2foRoAFMLJOtuuT5zfHT1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILm2uIjROq9Ler9maX5qlU+mq85XzWX3ILAqMRECJs6YMI8JPYmtNS2LRtcpR8w/Z
	 INQrE9uuUABwJsucVvA8Nn3M5z1lZeUY+9zeyRm7snjoCoAMN+ERvH7xSn8dGrM3fT
	 3W2rMRpE8fiK5gn8xuOSE+fLj9Ot2eRiLMRZh7zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Fudongwang <Fudong.Wang@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/466] drm/amd/display: skip disable CRTC in seemless bootup case
Date: Thu, 12 Dec 2024 15:57:19 +0100
Message-ID: <20241212144317.453655554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fudongwang <Fudong.Wang@amd.com>

[ Upstream commit 0e37e4b9afbd08df1f00a70bbb4d1ec273d18c9e ]

Resync FIFO is a workaround to write the same value to
DENTIST_DISPCLK_CNTL register after programming OTG_PIXEL_RATE_DIV
register, in case seemless boot, there is no OTG_PIXEL_RATE_DIV register
update, so skip CRTC disable when resync FIFO to avoid random FIFO error
and garbage.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Fudongwang <Fudong.Wang@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
index 4e93eeedfc1bb..a8e04a39a19e5 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
@@ -371,7 +371,9 @@ void dcn314_resync_fifo_dccg_dio(struct dce_hwseq *hws, struct dc *dc, struct dc
 		if (pipe->top_pipe || pipe->prev_odm_pipe)
 			continue;
 
-		if (pipe->stream && (pipe->stream->dpms_off || dc_is_virtual_signal(pipe->stream->signal))) {
+		if (pipe->stream && (pipe->stream->dpms_off || dc_is_virtual_signal(pipe->stream->signal)) &&
+			!pipe->stream->apply_seamless_boot_optimization &&
+			!pipe->stream->apply_edp_fast_boot_optimization) {
 			pipe->stream_res.tg->funcs->disable_crtc(pipe->stream_res.tg);
 			reset_sync_context_for_pipe(dc, context, i);
 			otg_disabled[i] = true;
-- 
2.43.0



