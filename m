Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B358A13AD3F;
	Thu,  5 Sep 2024 09:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529561; cv=none; b=NXaESDrg56Q1SOwMMNkT49Snd3kx4kgFYL/Yke7He3m5XGGFXuuCC4iARSG5nve/hij0IqI/4WdG/qOBQMP6Pab+ZHrd4rfoJcsR8YLK2fj8UsTc/QeB77gVuYuc/BQ5SbwFcleXet+H1kgDZhhP+z4tfR0pqGAxLOdw7AhcW6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529561; c=relaxed/simple;
	bh=yUkr/xid9/Ql63oiqOezeowIiLjPygvK6tH45N4/LdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZOmiR0GcQLAx1Pprl+OX384ox+XcOSzI0kL8yy53ERmTV3mrmiC9+FGhjcRt06LOjlJx8naikCPP1e8cd/m2errqM4MqjIYNJlfXUllltnqWB8gRZ2/tVZK1ap41R7Mqcsp3hId73IVJ7CcOqgMrOY0rhWMWdQk/Yut5+rdRKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CK45pDuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CK45pDuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7707C4CEC3;
	Thu,  5 Sep 2024 09:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529561;
	bh=yUkr/xid9/Ql63oiqOezeowIiLjPygvK6tH45N4/LdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CK45pDuFNGnXvxzLO+DO0vWrPD9o0RsxslZ6h5dsoN4jT3xk/lCTM46RQcpWlDnUV
	 PkX8fh0r02YQ8BzNPIM2mGxj0shDQeXZuprqaSPcLZLVGp5JGKWLXLzVr0qFve7i/z
	 QL7oNuJSi+pS4noOrXiO/zVyIDPL3BqvAu/0kW70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 073/184] drm/amd/display: Spinlock before reading event
Date: Thu,  5 Sep 2024 11:39:46 +0200
Message-ID: <20240905093735.091967887@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

[ Upstream commit ae13c8a5cff92015b9a3eb7cee65ebc75859487f ]

[WHY & HOW]
A read of acrtc_attach->base.state->event was not locked so moving it
inside the spinlock.

This fixes a LOCK_EVASION issue reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index c00d96ec8be4..e3662f646baa 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8645,15 +8645,13 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 				bundle->stream_update.vrr_infopacket =
 					&acrtc_state->stream->vrr_infopacket;
 		}
-	} else if (cursor_update && acrtc_state->active_planes > 0 &&
-		   acrtc_attach->base.state->event) {
-		drm_crtc_vblank_get(pcrtc);
-
+	} else if (cursor_update && acrtc_state->active_planes > 0) {
 		spin_lock_irqsave(&pcrtc->dev->event_lock, flags);
-
-		acrtc_attach->event = acrtc_attach->base.state->event;
-		acrtc_attach->base.state->event = NULL;
-
+		if (acrtc_attach->base.state->event) {
+			drm_crtc_vblank_get(pcrtc);
+			acrtc_attach->event = acrtc_attach->base.state->event;
+			acrtc_attach->base.state->event = NULL;
+		}
 		spin_unlock_irqrestore(&pcrtc->dev->event_lock, flags);
 	}
 
-- 
2.43.0



