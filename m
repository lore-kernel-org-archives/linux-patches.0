Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C561D5CE5;
	Thu,  3 Jul 2025 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556202; cv=none; b=tz+1lydrr+jsvaweSaNipY3brWct/z9eSwBlive9ISWamQQIXwDWJRqgLvlnl2Coc8Bf7XIPcLg36qo9TT8it7Rs9odab0YaBEZPRmLPE/1s2WC7GXWcv56QYoeVt0qq2cwQEeWSp/ht32qiBETUZdscr1C7raR2mL7LuNhNBhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556202; c=relaxed/simple;
	bh=lrsPQqSfGfT/fcGujVDJPsouzO7JwtyfeGVpTSE98z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXjjm2IbTKfkWGm9XXL8BF1fYi2XYDZJ2nsjS13VwimTq7fVt5kiILPKGFVd8jgMX2ewU2mBISL9MiOpWMpUtiHXv00T7wDHfnw8z/1U9XPg3j84VTw2BWc7mFD/SuBhYr4DhVDu6XWhMvlMhpQCyefGUBNzEZW+0Dtki44X5RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uulp0mM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uulp0mM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31535C4CEED;
	Thu,  3 Jul 2025 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556202;
	bh=lrsPQqSfGfT/fcGujVDJPsouzO7JwtyfeGVpTSE98z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uulp0mM6XHvN7XsD442gq64yrJGz8mGqdSIXg6bRuSdx5DMSSpWuNAALUka/xyTuY
	 sWYnRcb3RLHuW/R+3xiu8EQX0vyrFBvlzY+vukfB0Q+7TCbqSr0RaN25OM4QqSusQt
	 Rmb7qSRBtivfJCaxZll60qyavPnyoq1Wt8nl0ts8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 107/132] drm/amdkfd: Fix race in GWS queue scheduling
Date: Thu,  3 Jul 2025 16:43:16 +0200
Message-ID: <20250703143943.589440413@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Cornwall <jay.cornwall@amd.com>

commit cfb05257ae168a0496c7637e1d9e3ab8a25cbffe upstream.

q->gws is not updated atomically with qpd->mapped_gws_queue. If a
runlist is created between pqm_set_gws and update_queue it will
contain a queue which uses GWS in a process with no GWS allocated.
This will result in a scheduler hang.

Use q->properties.is_gws which is changed while holding the DQM lock.

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b98370220eb3110e82248e3354e16a489a492cfb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c
@@ -201,7 +201,7 @@ static int pm_map_queues_v9(struct packe
 
 	packet->bitfields2.engine_sel =
 		engine_sel__mes_map_queues__compute_vi;
-	packet->bitfields2.gws_control_queue = q->gws ? 1 : 0;
+	packet->bitfields2.gws_control_queue = q->properties.is_gws ? 1 : 0;
 	packet->bitfields2.extended_engine_sel =
 		extended_engine_sel__mes_map_queues__legacy_engine_sel;
 	packet->bitfields2.queue_type =


