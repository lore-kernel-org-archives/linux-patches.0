Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C9F36D4E1;
	Wed, 20 May 2026 18:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300544; cv=none; b=X1egxMpWXtKi24pxflQaurinAfZA7Vpe0zZ1QFEvwDq/VAQSKVJRiPN0aiTzkDVbCJe4xLwuIWrfKTzfcfhigb+uvV/KE/iz72A/ocOOy1Klw4yVyQxfdeePHg69uTorm63r655NMtJXXiqcujbNkD9o3Iy7tyhseKeU+Cq5nNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300544; c=relaxed/simple;
	bh=K3KOXlqQ5tSHPsP8srbxe0qL/cnV/rAPRFbZwBBMuqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EiFmHqRhMq9gMCkoiDgJSeSC+0A3TEBzo6bnsF+fmh0+dUxvXjusoKlKXtDYpjaUia8jeHxoyx+dDFsCn1MOHGyF7aPEPaugrDjP5FoZ52ypDcgY53uJND8Iw2bsJZoXurDqXjRHQHL2ATrQIWPNhzKLozrAj5JT/6yrpAW6V+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNCYRI5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNCYRI5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A18C1F00894;
	Wed, 20 May 2026 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300543;
	bh=krjA3d/dEKfE2IvBb44ebeb2h9100cUP47Mgqhw9A7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNCYRI5dKgCfe0CJCS6/PfxNOAdMWuSlWpFqy8XbzYr0hyyK98kaERsuPCftDtBry
	 OoF11QxflI3pK9/4aRSLzf/S1r910vQF2EncrLkaLdTPR4quZQj5jPjJzFqG6sBiMK
	 QvG9X5r2Lhbh/+7gu7SOfk05r2FL+6HnlaGHWTew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/666] drm/amdgpu/gfx11: look at the right prop for gfx queue priority
Date: Wed, 20 May 2026 18:16:14 +0200
Message-ID: <20260520162114.740625381@linuxfoundation.org>
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
index 3c91c30edf2be..7cb6b11257199 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -3919,7 +3919,7 @@ static void gfx_v11_0_gfx_mqd_set_priority(struct amdgpu_device *adev,
 	/* set up default queue priority level
 	 * 0x0 = low priority, 0x1 = high priority
 	 */
-	if (prop->hqd_pipe_priority == AMDGPU_GFX_PIPE_PRIO_HIGH)
+	if (prop->hqd_queue_priority == AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM)
 		priority = 1;
 
 	tmp = regCP_GFX_HQD_QUEUE_PRIORITY_DEFAULT;
-- 
2.53.0



