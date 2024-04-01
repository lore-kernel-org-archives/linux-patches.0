Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84976383BA;
	Mon,  1 Apr 2024 15:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987184; cv=none; b=Xr3OUtnFbY+we4oVZUGM8yKcfSiVwUrrwCXLhIlfxYUXOB/qLfkUPARls3jQqTiC92AFJ/l0aTxH25zCErB+ajIy0IUtDNQeTBBl5tjXw8WuCx5bJWZvo8uhCaF62GVtQp4xU6kCMKNzkbwvicbDY4nfIiYgDG3DP/DRwc2daDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987184; c=relaxed/simple;
	bh=8oc3uqn1IZrNAj0qQDTBS2Vbv4w+YyyDrO2zyQfIp6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWzHuPxyyUV0Y1AwQeCz2mxxm8jZJrZQfTfQu28sMBiZV8spDigC0YcTnP2ssqbx4vziMt6psdK8w4HymrG3U475iRqL1OT40bb57CT05MFegNxRNQttclq9LXx7lE7fy6CASbQ8OEEdCs5u0CBOiCnEh8741Ru6wjFAEg2t3mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEF8oyRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEF8oyRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A08C433F1;
	Mon,  1 Apr 2024 15:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987184;
	bh=8oc3uqn1IZrNAj0qQDTBS2Vbv4w+YyyDrO2zyQfIp6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEF8oyRRxLREelGy4nOLtZZVn9dotk8RGm86NTKw95xkBuSpg+gNqEejjAqyJUayu
	 /cyuvVsxYw261BeQnnuMcM3ZcunxgsuKgk35t71ZOEVaVK0+6Xh+QIqjJBy3G2jZBk
	 zWEM6svr6LCsqNsZVz4kTDzWORfAuwyHGnKqthRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Anthony Koo <anthony.koo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Josip Pavic <josip.pavic@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 210/399] drm/amd/display: Allow dirty rects to be sent to dmub when abm is active
Date: Mon,  1 Apr 2024 17:42:56 +0200
Message-ID: <20240401152555.454241122@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josip Pavic <josip.pavic@amd.com>

[ Upstream commit 7fb19d9510937121a1f285894cffd30bc96572e3 ]

[WHY]
It's beneficial for ABM to know when new frame data are available.

[HOW]
Add new condition to allow dirty rects to be sent to DMUB when ABM is
active. ABM will use this as a signal that a new frame has arrived.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Josip Pavic <josip.pavic@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 2c424e435962d..75b8a0fff48f1 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3223,6 +3223,9 @@ static bool dc_dmub_should_send_dirty_rect_cmd(struct dc *dc, struct dc_stream_s
 	if (stream->link->replay_settings.config.replay_supported)
 		return true;
 
+	if (stream->ctx->dce_version >= DCN_VERSION_3_5 && stream->abm_level)
+		return true;
+
 	return false;
 }
 
-- 
2.43.0



