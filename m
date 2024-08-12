Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2111494B8;
	Mon, 12 Aug 2024 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480669; cv=none; b=kKOaGWWfJxRv0PRt4iFI0qpfD8IlXdOAcnTg0CtsH0shvWr8rfnvz/YidCuiYL8Nds4GWRfMBmdFOzoRMC4qqZMPr8aYFgmACv4wwoMrq+JRjAuhLQTE/LkCQ30A+ZMvOkYcDswrQS7G29SwkNKjfkvhE0wATD4UdyCRjyqLjJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480669; c=relaxed/simple;
	bh=kCReIi4MVmu0ONbDIJ/plvRfSQ0w2Sang+JZgaKPwQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzdzBCHBCHJ4GnoxfStDSXJgBIoSfhuQfYvhvYE9HCkN+fT9PHlmQBNqrm5cqVnhypUH9ZHnM0Rm/N5c4Nvu0v9JtI9jgeq2UiBnTVBoieIdkcBv+ywioBQUlnPXzCuMVVXWVrzzv8KiFHTFWS7ldKZ/Cz/KpuOMkaXo3lrmFz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhdY5fmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhdY5fmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56B9C32782;
	Mon, 12 Aug 2024 16:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480669;
	bh=kCReIi4MVmu0ONbDIJ/plvRfSQ0w2Sang+JZgaKPwQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhdY5fmqHUSe4rX4d6n1tRMwsg5AQ8ery2SIqKdNm+arlp31Ntx0UxU7EPGLYaYYK
	 MZTHrYE/1yo8UQ5cdLPM6VHCdjW91hdax+oXMyeFKuzHfv7RmZieEbLO4WDdipNekt
	 y+gQc6ZxHRH7gc8v90m15vfcwzcBtRsdMskX5cyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Swapnil Patel <swapnil.patel@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 256/263] drm/amd/display: Change ASSR disable sequence
Date: Mon, 12 Aug 2024 18:04:17 +0200
Message-ID: <20240812160156.452367615@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Swapnil Patel <swapnil.patel@amd.com>

commit 2d696cc837eaf5394d79bfd2b0b0483c4778aa83 upstream.

[Why]
Currently disabling ASSR before stream is disabled causes visible
display corruption.

[How]
Move disable ASSR command to after stream has been disabled.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Swapnil Patel <swapnil.patel@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -2313,8 +2313,6 @@ void link_set_dpms_off(struct pipe_ctx *
 
 	dc->hwss.disable_audio_stream(pipe_ctx);
 
-	edp_set_panel_assr(link, pipe_ctx, &panel_mode_dp, false);
-
 	update_psp_stream_config(pipe_ctx, true);
 	dc->hwss.blank_stream(pipe_ctx);
 
@@ -2368,6 +2366,7 @@ void link_set_dpms_off(struct pipe_ctx *
 		dc->hwss.disable_stream(pipe_ctx);
 		disable_link(pipe_ctx->stream->link, &pipe_ctx->link_res, pipe_ctx->stream->signal);
 	}
+	edp_set_panel_assr(link, pipe_ctx, &panel_mode_dp, false);
 
 	if (pipe_ctx->stream->timing.flags.DSC) {
 		if (dc_is_dp_signal(pipe_ctx->stream->signal))


