Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417B03F660B;
	Wed, 20 May 2026 18:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300410; cv=none; b=XApbpIxI7g6PY93v5+j8D/wNKV7n47sp0BS7yn1rUiQCgSPPQBruPewKndJivObwjOFKGeLfSSYvlo6uxZsaziDnTaofUvu9CIV2XwRhqgzBK0pZJKtxbJ2v/SviZvSKneCZnBM2h5ddA0WYnz9SXQFCNDend1QayBSHvg4wasM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300410; c=relaxed/simple;
	bh=AgQByXSC8o57M+SQFY1iPZuoFY7i3mgqwdpMNOQvK9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OVVw4c6Rwbb4oRKjammGdfVNwT+P3dLj0U5IChSDxzTfUgQqApjasKM+UpErZa2oEcBpi4K9fKwokkuDtrZtfb8B+Ap5/DMo8HjIYtXaFlNiX645SByuUY1RqhDZy98pVIAO7JMwFpCkgyWeC7lx/rKDd/gAgIEE3PcGfOZR4R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNA3LUIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNA3LUIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CCA1F000E9;
	Wed, 20 May 2026 18:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300409;
	bh=j+SchdRXBJ5Xf7hynU0As2D9a6AX0G4p+GYV3bEoxZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNA3LUIwfEvMdCFt4QpJEYmZbK/U+QShERHl8HKmkCVwyS/2Z4iV3M08B67pCdhUd
	 sKIOkfMYShGYn5gtnbtW6S9ChiSQ0+hIHv0AzN7h/eo+aVJ1tbAyxnwusMluo3so2P
	 kH194HiSfQi0sX1yS1RjWeKHhZnJfw/aGHncBJ1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/666] drm/amdgpu/gfx10: look at the right prop for gfx queue priority
Date: Wed, 20 May 2026 18:16:13 +0200
Message-ID: <20260520162114.718873673@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7babb74caf6fc..7d5609e3dd412 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -6601,7 +6601,7 @@ static void gfx_v10_0_gfx_mqd_set_priority(struct amdgpu_device *adev,
 	/* set up default queue priority level
 	 * 0x0 = low priority, 0x1 = high priority
 	 */
-	if (prop->hqd_pipe_priority == AMDGPU_GFX_PIPE_PRIO_HIGH)
+	if (prop->hqd_queue_priority == AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM)
 		priority = 1;
 
 	tmp = RREG32_SOC15(GC, 0, mmCP_GFX_HQD_QUEUE_PRIORITY);
-- 
2.53.0



