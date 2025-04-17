Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD5C255E23;
	Thu, 17 Apr 2025 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912956; cv=none; b=JGLcDVC56Og78DKs8RK5S2bZBNKhOn3IzXRnZD6uDUf9e/Jb+kyxcBwoBMPhZGNS4lAG4qNIrCahzglO8j0PeC4JR5gwbWBOBJ611KZ1y8tcOw/yJkNLL4awFlWr4fG+cM9H/GR1AYdoVPdPBKtIQZDRSRlC5jL2fi9MfcMf+Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912956; c=relaxed/simple;
	bh=0OHMr7tBK4uMQ3rXUlbzc8Uz3TUiVUhitG4lewu97fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ALnA2GjwlJVeCcVhZZQn4tl+v1Wf/UBxFzi+gLL7gZYgQo2qpeMGYpdUowD8fygJ0/fQ8JuYebybjgRLWfPtAP1dVUu3zMpNz3+Ws8xCwBF1ycyFg2b5IJ5kprbWPppVVZCW3yESzcJaclkTlWWgECUuH2YIsYnnyAAIJLwwGLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v572PcJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v572PcJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E168FC4CEE7;
	Thu, 17 Apr 2025 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912955;
	bh=0OHMr7tBK4uMQ3rXUlbzc8Uz3TUiVUhitG4lewu97fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v572PcJivATH7k9ZsthI7Jw34U4zNK9o4ZDCG4Vqlpc0b4WRfRtE/RrfwrQ/gKt4v
	 cAvAI1szDBB2r6UIdzzsKe0ZJ98tYoK6p3UpwyGWvHR/gyoksVHu1i8MkhlHIztYQL
	 9DgYzyw1nCkS5sN5i9mNTKjY75aXxfhNAjbLzHEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 180/449] drm/amdgpu: grab an additional reference on the gang fence v2
Date: Thu, 17 Apr 2025 19:47:48 +0200
Message-ID: <20250417175125.220788596@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index f5909977eed4b..9a8f6cb2b8360 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6851,18 +6851,26 @@ struct dma_fence *amdgpu_device_switch_gang(struct amdgpu_device *adev,
 {
 	struct dma_fence *old = NULL;
 
+	dma_fence_get(gang);
 	do {
 		dma_fence_put(old);
 		old = amdgpu_device_get_gang(adev);
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



