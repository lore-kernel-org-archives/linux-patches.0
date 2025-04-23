Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB4928B4E7;
	Wed, 23 Apr 2025 15:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420664; cv=none; b=Lc9sxRi2pxQQkbNTtXRSV1cf9uV1WPVU4YzpAyFVxcMJktXYaR1nhanRiBeuMRrzzdnpC4b+ulrHzKX/RS2PSH8bA5AuTw+9LpwxkXloHWp5VSDius92UabMddcUF0qzh3Rm9efgPjgurAG7D26W3tbkuOuQG+rZ7igEgK82x+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420664; c=relaxed/simple;
	bh=Rd2erbfVisegTEEUnyybyE3hMFI7rElNMq27a4F+T4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kk7ZqSvhhACqBN0Lhb0uhjCCteyPsbTbeWw9Nl0HhNiXL8Gx+HmhV7EZODd8eGlGaHZjCQ3HQ7c4u9EX80z3yaJ6k5Tbto+mYiAokYi7sjXBTvW3K9Ljq5Fi3RduJ6Aj5fYDCkTla+4q6HfrI6qnwXMglVybsG/2q06JOjj6waI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2UPApee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2UPApee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC3FC4CEE2;
	Wed, 23 Apr 2025 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420664;
	bh=Rd2erbfVisegTEEUnyybyE3hMFI7rElNMq27a4F+T4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2UPApeeTl3Dyrjyo6lFlClmab6jI6+OMC5PUa9WCDBA3SWN3bVRh5NwGSGPBFxIS
	 AqvZBJP7stWuPyX0xQhgBnJEnlsOLX9tEEX0QLRZanHqxnTHUodtvGabDIsMPnHGoT
	 +d9JGJ3kna2Q0cloG43hwYSjttq9bazmx0hqhfBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/291] drm/amdgpu: grab an additional reference on the gang fence v2
Date: Wed, 23 Apr 2025 16:40:58 +0200
Message-ID: <20250423142627.191704344@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b41a97185823a..fcd0c61499f89 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6186,6 +6186,7 @@ struct dma_fence *amdgpu_device_switch_gang(struct amdgpu_device *adev,
 {
 	struct dma_fence *old = NULL;
 
+	dma_fence_get(gang);
 	do {
 		dma_fence_put(old);
 		rcu_read_lock();
@@ -6195,12 +6196,19 @@ struct dma_fence *amdgpu_device_switch_gang(struct amdgpu_device *adev,
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



