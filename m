Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E35155756;
	Wed,  5 Feb 2025 14:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764447; cv=none; b=nsxh/7hsEBP6oddrStW2/Pb4ujrqDTLqQWoOCNS1g9p2lMGeChHRdMyGuzLmz7jstgcAfC2BX+5B1Gztq2KyMdMPEKdYSOx51G2TCCZZgm8IXEQcLP0nquzCz5q1eOgVXSZr0JkKYH+G9O1DopT97eV2vZoGljMBfa491WQGfa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764447; c=relaxed/simple;
	bh=llkXQNKsEWJ9SQwIrhYyb04wZlHxQYxDv5xIijveFNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1ary1mAlU4SgGQYRQyedKNtSW8VBcPVeYqQzHLO3Tk1V7FG5ZOG7BZnVXMQwIdhnbis11aYDSBcmMSgOr+szDXgbg/aNoRI0av1k7U/7ynSPW1YF8Y4+kEwtX2H1pEjl7KGEBPI+cJgWn8yw1brWK/n4bzGVJu/knKiQ1GyiwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoGAjVNh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoGAjVNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F40C4CED6;
	Wed,  5 Feb 2025 14:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764447;
	bh=llkXQNKsEWJ9SQwIrhYyb04wZlHxQYxDv5xIijveFNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoGAjVNhMCijUsLr5UEn9b+eoL4rSWhP5HnGkl/7CsKS0ZrvpWrhAlshEbRIw88U1
	 Si7xwfk2b2LL8679GmLmp+xayyNzQhKjIbZecB1jG+3zbwTA6QcziqYAdckjc5wn/2
	 CrLEwPPZ9dg7LIGmuQiJFsV/1nj7tOfHKkxqzwW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 079/623] drm/amdgpu: Fix shift type in amdgpu_debugfs_sdma_sched_mask_set()
Date: Wed,  5 Feb 2025 14:37:01 +0100
Message-ID: <20250205134459.247799441@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6ec6cd9acbaa844391a1f75a824a3a9d18978fcb ]

The "mask" and "val" variables are type u64.  The problem is that the
BIT() macros are type unsigned long which is just 32 bits on 32bit
systems.

It's unlikely that people will be using this driver on 32bit kernels
and even if they did we only use the lower AMDGPU_MAX_SDMA_INSTANCES (16)
bits.  So this bug does not affect anything in real life.

Still, for correctness sake, u64 bit masks should use BIT_ULL().

Fixes: d2e3961ae371 ("drm/amdgpu: add amdgpu_sdma_sched_mask debugfs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/d39a9325-87a4-4543-b6ec-1c61fca3a6fc@stanley.mountain
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
index 113f0d2426187..f40531fea11ad 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
@@ -358,13 +358,13 @@ static int amdgpu_debugfs_sdma_sched_mask_set(void *data, u64 val)
 	if (!adev)
 		return -ENODEV;
 
-	mask = (1 << adev->sdma.num_instances) - 1;
+	mask = BIT_ULL(adev->sdma.num_instances) - 1;
 	if ((val & mask) == 0)
 		return -EINVAL;
 
 	for (i = 0; i < adev->sdma.num_instances; ++i) {
 		ring = &adev->sdma.instance[i].ring;
-		if (val & (1 << i))
+		if (val & BIT_ULL(i))
 			ring->sched.ready = true;
 		else
 			ring->sched.ready = false;
-- 
2.39.5



