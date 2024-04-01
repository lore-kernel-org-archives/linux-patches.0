Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6200C446AC;
	Mon,  1 Apr 2024 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987194; cv=none; b=Hg8GqR6bAvk0MEINiuuY4w75Xy1z/rAy1mvmSbVqp2KtZDl2QLG42ENw/YumMeVFG/ONS7pkIWvadxIcvYuvaziyfIc5x7VFHehUMX6ZfoJohiEDJpbDULTrj4Aa0S3UQY/XfgfnOWy8YiDuFi4wIJGr5dDaVrUIQeRVFN0ff8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987194; c=relaxed/simple;
	bh=aJ9Hcu5pMOUYZt4G3vOO8Ui4xYVAcIOd8iqZsH7mY2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWqgXOyoiJszjLvuUF51rxIpSY3Dz24gOW94+3cPX4/1JSdB0oRoEyf82/4nywZdRPVA0mEHZ8/e1Lr/Wf2kcqiYl/8ps+1Qjq6rIQNv0HfV6rxGTAWdv8oVvuEoy7aquPcbslxICwtmqIaSPP1qFiejTIVphTmhjuTnT5qhZ9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okHkIkS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okHkIkS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9310C433F1;
	Mon,  1 Apr 2024 15:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987194;
	bh=aJ9Hcu5pMOUYZt4G3vOO8Ui4xYVAcIOd8iqZsH7mY2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okHkIkS2C+p623Vj8SVn71VZdLQ+5aiW15LJGnIJIJLr846Pek9ltrrAPwUqowEuA
	 vsqZgkdjJbYkM0pRhPX1sjeYqv773OjD/nXHy4EfFJFwDfFhe3vtp9R1BHYZJLfDWB
	 I+dma7MeCeKQrp2g9dYbgtu+tfFiPQkzPnf7Lw2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Duncan Ma <duncan.ma@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 213/399] drm/amd/display: Fix idle check for shared firmware state
Date: Mon,  1 Apr 2024 17:42:59 +0200
Message-ID: <20240401152555.541569948@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 3d066f9547dd58329b526db44f42c487a7974703 ]

[WHY]
We still had an instance of get_idle_state checking the PMFW scratch
register instead of the actual idle allow signal.

[HOW]
Replace it with the SW state check for whether we had allowed idle
through notify_idle.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Duncan Ma <duncan.ma@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 75b8a0fff48f1..fdff99a1dff7a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -4834,22 +4834,16 @@ void dc_allow_idle_optimizations(struct dc *dc, bool allow)
 
 bool dc_dmub_is_ips_idle_state(struct dc *dc)
 {
-	uint32_t idle_state = 0;
-
 	if (dc->debug.disable_idle_power_optimizations)
 		return false;
 
 	if (!dc->caps.ips_support || (dc->config.disable_ips == DMUB_IPS_DISABLE_ALL))
 		return false;
 
-	if (dc->hwss.get_idle_state)
-		idle_state = dc->hwss.get_idle_state(dc);
-
-	if (!(idle_state & DMUB_IPS1_ALLOW_MASK) ||
-		!(idle_state & DMUB_IPS2_ALLOW_MASK))
-		return true;
+	if (!dc->ctx->dmub_srv)
+		return false;
 
-	return false;
+	return dc->ctx->dmub_srv->idle_allowed;
 }
 
 /* set min and max memory clock to lowest and highest DPM level, respectively */
-- 
2.43.0



