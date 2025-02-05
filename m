Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01FD15530B;
	Wed,  5 Feb 2025 13:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763915; cv=none; b=Ked8fXKn7wHUhIN7XJ1CcF/12LcKtPo0hQBJVg1m+tLslZBroXiP0bWAV1G/qrtEzHFgTv8ElFY7zlNoYz9/LwqZU9IwUekHgUxNibq+UW2bTcj1CleTbIwkR2JPONrcClqXfDXk2dP1MqlbdAUYgKXSh7NV50P2eoJroadR71M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763915; c=relaxed/simple;
	bh=rtdL4mw/DBg5MaYrAF2M5Tb5bo7XFcrV6Kr7U4lXnis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJrFvJmET2xhxKy+tFl54p5A3oGCpHEeSbDCxE2Hx3CNPnG3Rsjc+AMkPWeMitMGSZJ0fCEfGDb/Frc5Wdbuh/1hjOATPJW1S3FOl6XajbzLdzmBubMpShA1n3p1T3m3tRKfP1oM13adBDMa9q/AChQKltYrGRVooJYgHXQOs3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2nB/T8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2nB/T8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92EEC4CEE2;
	Wed,  5 Feb 2025 13:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763914;
	bh=rtdL4mw/DBg5MaYrAF2M5Tb5bo7XFcrV6Kr7U4lXnis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2nB/T8/rvXYHCHNjWv9NnMFoj5k4FUX594XNmPMTJxWT9ycDNQ7dvXJplcSR5+6l
	 H+FRr89GkjjOQskyc+m8Z251vKsue4vbu81QQcMPMsqMHm/uGVbe1x5/Pw+NJfRXFu
	 /9LfKVF5WRgEBcmVl26cK3VEWjkZBvsK971t6pl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/590] drm/amdgpu: fix gpu recovery disable with per queue reset
Date: Wed,  5 Feb 2025 14:37:07 +0100
Message-ID: <20250205134458.010263528@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Kim <jonathan.kim@amd.com>

[ Upstream commit 86bde64cb7957be393f84e5d35fb8dfc91e4ae7e ]

Per queue reset should be bypassed when gpu recovery is disabled
with module parameter.

Fixes: ee0a469cf917 ("drm/amdkfd: support per-queue reset on gfx9")
Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
index 353ac458c834b..a46d6dd6de32f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
@@ -1133,6 +1133,9 @@ uint64_t kgd_gfx_v9_hqd_get_pq_addr(struct amdgpu_device *adev,
 	uint32_t low, high;
 	uint64_t queue_addr = 0;
 
+	if (!amdgpu_gpu_recovery)
+		return 0;
+
 	kgd_gfx_v9_acquire_queue(adev, pipe_id, queue_id, inst);
 	amdgpu_gfx_rlc_enter_safe_mode(adev, inst);
 
@@ -1181,6 +1184,9 @@ uint64_t kgd_gfx_v9_hqd_reset(struct amdgpu_device *adev,
 	uint32_t low, high, pipe_reset_data = 0;
 	uint64_t queue_addr = 0;
 
+	if (!amdgpu_gpu_recovery)
+		return 0;
+
 	kgd_gfx_v9_acquire_queue(adev, pipe_id, queue_id, inst);
 	amdgpu_gfx_rlc_enter_safe_mode(adev, inst);
 
-- 
2.39.5



