Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AE31DEFD6;
	Tue,  8 Oct 2024 12:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390171; cv=none; b=dKnx9KS9GS9I/mMDPL8+B8CAmgThhYFhVvNVe5QxBjH49CwRb6S5tGj6b9pClbhiGdwoAQWfkJ1IcodpjVHJPwHo/fJys/p7CceQcJ1oR4gYUtnzIARUep/nPy6H/DeshEqyZLGAN241ORncEnmK2V+OWsbQYfE1kFcmI9AkkZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390171; c=relaxed/simple;
	bh=Kj/mXpAgBANTQbw0yW2ZE/67T068smSePaZQxZLIoAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1hAV253cvCqW9CgeZDpZskYefgTt3g2LPQUtXiyt/tF/re2hlkcA/swsFBjv4U6fkXoJG9wWTZUlKIu+ntjecgEOSwA9OyZqsTM08Iapt06moOT4HV5ctDyVnkaHwznkl5rxLLROauKQeU1dNFONtnNhmhMWUyHq3+Q4/6I094=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFL4k1Sv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFL4k1Sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA19C4CEC7;
	Tue,  8 Oct 2024 12:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390171;
	bh=Kj/mXpAgBANTQbw0yW2ZE/67T068smSePaZQxZLIoAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFL4k1SvXU7Whg1uHiioc0jQxfwBhbovwO77CKx56Mm403FcXE6IP5G7yjgfv1UWi
	 j1vJN87ztRSQfUuzi1dAT9a6W5I0DZKpXFHMiqjpXvIC2y5VjYsisnrLEtYElJ9PvW
	 iaW1JYqoVU1DnvMr+7O/0mefl2vBTbqG+hAjVEo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 211/482] drm/amd/display: Check phantom_stream before it is used
Date: Tue,  8 Oct 2024 14:04:34 +0200
Message-ID: <20241008115656.613576120@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 3718a619a8c0a53152e76bb6769b6c414e1e83f4 ]

dcn32_enable_phantom_stream can return null, so returned value
must be checked before used.

This fixes 1 NULL_RETURNS issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index 9209bcad699a8..55fbe86383c04 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1714,6 +1714,9 @@ void dcn32_add_phantom_pipes(struct dc *dc, struct dc_state *context,
 	// be a valid candidate for SubVP (i.e. has a plane, stream, doesn't
 	// already have phantom pipe assigned, etc.) by previous checks.
 	phantom_stream = dcn32_enable_phantom_stream(dc, context, pipes, pipe_cnt, index);
+	if (!phantom_stream)
+		return;
+
 	dcn32_enable_phantom_plane(dc, context, phantom_stream, index);
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
-- 
2.43.0



