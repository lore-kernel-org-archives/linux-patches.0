Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45BA3191D0;
	Sat, 30 May 2026 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161049; cv=none; b=fk/oGsGNM8iBRpgTuGCMk2u9TyWMbpjvWefBPnIsSeoa4I91uWQi8IMxMIc74S7VVglPpfNuU9IpRLParlRRTij80aawe6+pNPKisHNTgVUpILlQZKa1EraqVfrEZvzMCDkxTCI3ffWLgwE+PWe8RmgebdFhv96Nww/sYtC/x/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161049; c=relaxed/simple;
	bh=2BDkywFzFhLnecd4U24lQfpnSNukOACnbjy2+Jb8vQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eX8c4GIOMOUKcfcr9XWCi1hzSVaMJ0LyTGxAtQIaA5tLA+GHVYF4i1qvch86BbpG5OKMzBqP3+Ki00/1JgHGoiPI0TrKOUalmlt4vYSwL0eXTaJYcf4l6DF3GyUF6b6C8MwLUjKh7mWpGd6UseGdroCmWCvHTFyZVSiDM9fjWfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrErXivb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrErXivb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7FF1F00893;
	Sat, 30 May 2026 17:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161048;
	bh=U9lLW0BNiVfhKwMDjpqJQ7k1GUpVvpzxqnAha2G+epA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrErXivbE9YUj3JFrWLAlLw5EAlWjzqynrJlehWvIE9f7ieom+ksAUph+4/zztVeL
	 VCQNPsJjGwNMxTvBh4yXK7+F/YsHCbeCYjz0hoWMqF5HGpfbT/u+03CnmR4EiSzIgW
	 RqKeCgTozelS4OLZhJkizTItZ8sbEUdQlxgY38KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 511/969] drm/amdgpu/gfx10: look at the right prop for gfx queue priority
Date: Sat, 30 May 2026 18:00:35 +0200
Message-ID: <20260530160314.445186786@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 355d96cdec5c61fd83f7eb54f1a28e38809645d6 ]

Look at hqd_queue_priority rather than hqd_pipe_priority.
In practice, it didn't matter as both were always set for
kernel queues, but that will change in the future.

Fixes: b07d1d73b09e ("drm/amd/amdgpu: Enable high priority gfx queue")
Reviewed-by：Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 48462beddccf0..8953f093b9617 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -6411,7 +6411,7 @@ static void gfx_v10_0_gfx_mqd_set_priority(struct amdgpu_device *adev,
 	/* set up default queue priority level
 	 * 0x0 = low priority, 0x1 = high priority
 	 */
-	if (prop->hqd_pipe_priority == AMDGPU_GFX_PIPE_PRIO_HIGH)
+	if (prop->hqd_queue_priority == AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM)
 		priority = 1;
 
 	tmp = RREG32_SOC15(GC, 0, mmCP_GFX_HQD_QUEUE_PRIORITY);
-- 
2.53.0



