Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95873269B07;
	Wed, 23 Apr 2025 15:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420751; cv=none; b=mBtnltoWoBOUHyVj8ZCDLljDtDrsRFDlqbGhIpt9GYy8nzeq+GyqCKiZru1yyUQznwUoTGDkfOHCHgokaTMh1UbPAz+5bLcwltTHGwvOLbWDgY5FoudmRJAtPorkYT15Ierh0mgvs+aGh5kWOUPcyB1t42hWLatl5DClBdrBy5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420751; c=relaxed/simple;
	bh=K5SKCB1K0F2HL7aA00Il6ku5cJQPThLArLBy3ayDQew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=onwblubE+nhG/qqDGdx6OVmalDrNMmn26mvvKNzO1WYD6WtW3Yj7gHnSl7VkgwymQx+LeIfKI3JA7aIdjVIL5dMH108LdQGz2H9zvkgi84Bgzye2pLhncFvL2YKf01KXeii8w4+sdPZ2enq8fZJu/QLCVFVnA3mOXt0XvWqWo64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3VRYlcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3VRYlcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270C8C4CEE2;
	Wed, 23 Apr 2025 15:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420751;
	bh=K5SKCB1K0F2HL7aA00Il6ku5cJQPThLArLBy3ayDQew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3VRYlcSaxocbfdWkmX6g5HjToUSgnlXnh7lecUms6Ugws1Y6C7YceeGOaagn0kt5
	 fL3UJaY+apqz6pUSOOhe8NSfdgwXTAYvUQw2BrXNVexB7o1Xpy1vSlFn8dUIR3Me5S
	 2a6j4QCByT96DvpcDogV2TLzMtcGG4QzHOpORFWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/393] drm/amdgpu: grab an additional reference on the gang fence v2
Date: Wed, 23 Apr 2025 16:40:05 +0200
Message-ID: <20250423142647.784728803@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 0d9a95099dcb05b5f4719c830d15bf4fdcad0dc2 ]

We keep the gang submission fence around in adev, make sure that it
stays alive.

v2: fix memory leak on retry

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 45dd6cbad81e7..10f5a3d0f5916 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6015,6 +6015,7 @@ struct dma_fence *amdgpu_device_switch_gang(struct amdgpu_device *adev,
 {
 	struct dma_fence *old = NULL;
 
+	dma_fence_get(gang);
 	do {
 		dma_fence_put(old);
 		rcu_read_lock();
@@ -6024,12 +6025,19 @@ struct dma_fence *amdgpu_device_switch_gang(struct amdgpu_device *adev,
 		if (old == gang)
 			break;
 
-		if (!dma_fence_is_signaled(old))
+		if (!dma_fence_is_signaled(old)) {
+			dma_fence_put(gang);
 			return old;
+		}
 
 	} while (cmpxchg((struct dma_fence __force **)&adev->gang_submit,
 			 old, gang) != old);
 
+	/*
+	 * Drop it once for the exchanged reference in adev and once for the
+	 * thread local reference acquired in amdgpu_device_get_gang().
+	 */
+	dma_fence_put(old);
 	dma_fence_put(old);
 	return NULL;
 }
-- 
2.39.5



