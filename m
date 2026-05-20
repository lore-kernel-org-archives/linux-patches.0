Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040983D8137;
	Wed, 20 May 2026 17:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297979; cv=none; b=aLB5iIiYcn0xTrMQvQFQoPkpBFY2IjN/5Pqwb1kUXubqQaCFWdBfG3rZD+Tv4A2Vzg9mVSQciF/8GTNfxoSp0AC+pSFxRXpLoZBUXBFcCBOwudRfIbqADYmrt6uUDHs1bJ3Gc0F7cd3hs6q60hpGV3mX0XtMIr4SV5AQRzAM++A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297979; c=relaxed/simple;
	bh=pvp1G6ZKjghRWFGXZwwS7/YYqHvppmgtTMCliNR5hmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D6WVWBshNylbbJCbBrX70CbvgG8ks5/IRROpP0bxJ7ygqP6GiF/4zmW1eosNLpmLHUjdUMCZ482LOMCTtplQE3JrgMwrWPTh0TBw1rUPNllW5N301b4UYXB5UVHvvZe232pksKnLcpez7mxUItVLm9KANvFfjL7+oevLUl9Vmi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXqzNchR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXqzNchR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA9B1F00897;
	Wed, 20 May 2026 17:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297977;
	bh=4zymeRgvzqrl6dopgkM5230m6bYhEot458M/LuPON8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXqzNchRpbkNRVpOU3SpTlrKHbeA6RnAthI9BkhuHTWnIO25WV9kx5rbN5x4CXT2s
	 szGuGLzZsRdiEFshfQOtSWN40onY/zJbEbmlWSI+JLC4YhRPwuyIzE86HveF9tT0Iw
	 fR5Dl228R4LUL2lPpMC4kDjszpNiACvmTSYqR5Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 236/957] drm/amdgpu/gfx11: look at the right prop for gfx queue priority
Date: Wed, 20 May 2026 18:11:59 +0200
Message-ID: <20260520162139.660215269@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit f9a4e81bcbd04e6f967d851f9fe69d8bb3cc08b3 ]

Look at hqd_queue_priority rather than hqd_pipe_priority.
In practice, it didn't matter as both were always set for
kernel queues, but that will change in the future.

Fixes: 2e216b1e6ba2 ("drm/amdgpu/gfx11: handle priority setup for gfx pipe1")
Reviewed-by：Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index feb56b6b31c9c..cf23b5da6dbbb 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4080,7 +4080,7 @@ static void gfx_v11_0_gfx_mqd_set_priority(struct amdgpu_device *adev,
 	/* set up default queue priority level
 	 * 0x0 = low priority, 0x1 = high priority
 	 */
-	if (prop->hqd_pipe_priority == AMDGPU_GFX_PIPE_PRIO_HIGH)
+	if (prop->hqd_queue_priority == AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM)
 		priority = 1;
 
 	tmp = regCP_GFX_HQD_QUEUE_PRIORITY_DEFAULT;
-- 
2.53.0



