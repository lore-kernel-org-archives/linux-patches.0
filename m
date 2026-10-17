Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CED03A640C;
	Sat, 17 Oct 2026 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254871; cv=none; b=lNgwSTeu3UZGE2tHeEp0sDgPM5q4g+SjrjDPcQlztpQjYsrqufOoVupo3JPXD2iOYKxc7BUMgTLkcG43vXeCPBhDMIQy5hjk7YWU+Uu6jkkKRjQzHlMQ8baa7IeMxPZ2xMi25BXkJzk7XAAHDO9Nw6kyfKWpADKpO+ghaObJsjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254871; c=relaxed/simple;
	bh=ys0eTd3B3BH83pI7OJLatHKe3u9Pt1m5P1GJzf1xuis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kk6DlLoygALiMYWWqe+YmavaHW3HVraMNZEp0APk8v8OD8OW5soByN1Xo9f169Ma0LbL8JSQSDnqHWfjkYE7ItcjwlI1eQ0WZBiVy36O1Yf0ADUCdHD/z4IQW/3lQFwsUyRsGKtXtWNCt5a8XsWg4IduX4lyiM9GsSsJ8mtpc1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyHOjS20; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyHOjS20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D6E1F000C4;
	Sat, 17 Oct 2026 16:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254869;
	bh=xHgKCRgpgjIB8phThdQdqEtaoUpV7dfsSG15aDY3Y1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyHOjS20SGp/Jn7jX7RSFFXdkc+PRHlVfGN9uiMvhoQ9emH0V7RAQFfZEg+TV0pIt
	 4cLPIkvS3Nck4hUmB+nKOYSx5kQ7WZw55or7ONFP65zM1g4Y86htzPwe3cAjNWuXhF
	 swTT224+00kdWS6yILwXiP1KgY+QEF5POUrPl1vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 588/869] drm/amdgpu: force complete the KIQ ring fences on reset
Date: Sat, 17 Oct 2026 17:57:09 +0200
Message-ID: <20261017160052.130577307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit fd65d1742992361fc2201ecb4e43411e6e417fcb ]

Like the MES scheduler ring, the KIQ ring sets no_scheduler = true and uses a
polling fence, so it is skipped by the force-completion loop in
amdgpu_device_pre_asic_reset(). Its hw fence value lives in wb (GTT) memory and
survives a MODE1 reset while fence_drv.sync_seq keeps advancing, so after a
reset the first KIQ submission can poll forever on a seq that is never written
back.

Force complete the KIQ ring fences too so their hw fence is realigned to
sync_seq.

Cc: stable@vger.kernel.org
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index ef0f6e75d718b..692c8883a0364 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5511,6 +5511,18 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 			amdgpu_fence_driver_force_completion(mes_ring, fence);
 	}
 
+	/*
+	 * KIQ rings are polling-fence/no_scheduler like MES, so realign their
+	 * fence too (one ring per XCC), otherwise the first post-reset KIQ
+	 * submission polls forever on a stale seq.
+	 */
+	for (i = 0; i < AMDGPU_MAX_GC_INSTANCES; i++) {
+		struct amdgpu_ring *kiq_ring = &adev->gfx.kiq[i].ring;
+
+		if (kiq_ring->fence_drv.initialized && kiq_ring->sched.ready)
+			amdgpu_fence_driver_force_completion(kiq_ring, fence);
+	}
+
 	amdgpu_fence_driver_isr_toggle(adev, false);
 
 	if (job && job->vm)
-- 
2.53.0



