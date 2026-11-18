Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018269;
	b=39cdgP4YG+Ohf1675ys1ajQq86TKce1AWMJ8Q/6AhUJaoMdEKhWkPKFwFXE2JWm+6Rap
	 OCVsyoPOz0hs0zA0HwNDf3gmySHc+gs0nTjeZZPxvoMYJL5khE7ma/j+JgHUNPjVswaK/
	 JJ6BZoEsLDsETkr6IovotKIIU/x7IgOlaNmtPyifvC65LXK5N9w3nMz7JzOl/1vMkPp9R
	 MRYfIYU9G76KN7M6dxV+AtZaj4rV1ZhLGAMTWvLFuLsYP1XX3vxvZufKW9FP2WdZX5XbL
	 zsvvH+B0lUHKD7MM5yP3QIFcqRDC5vry2cOW4txsy0aniKi6VeDoPsRIpYnBlyBzkUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DOhLEw0HUOnjBhbRLqXAxCKAJSv0MfdQuK7q5F2b9uk=;
	b=z6lRroQsWeKfLonXhKvWnHc0STh8Wui8HSAfjrTOU+SNyMaW0Ufh/QPxy04TC/oGf4In
	 nd/+AAAYoSeZmNMww/wDaCFMjMPQLz/dfsRuwxGdRSqADORg70c17IeDzAYPlG9ww6cyO
	 QCTkac3eXSuW3wQ9E/htaZoKDWeAvop8jug0NgO6Z/du/5D1HcZqPMmwOoF17AUYHrO6H
	 rjrLJoP5gHdnbVKuMjKXXELZuzCtWJ0MXC+pNO0fZ33VJDxldmjV5l5ai0Xm1aZPPUbfc
	 E01dpJZyASch8/85ROPyLEF3kJODCkosFRyFTL0FXmuv95BO65bEi1HZkYKI9N7K1zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DY5wDESX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9962606A325;
	Wed, 18 Nov 2026 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DY5wDESX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3531F000C4;
	Wed, 18 Nov 2026 16:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018268;
	bh=DOhLEw0HUOnjBhbRLqXAxCKAJSv0MfdQuK7q5F2b9uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DY5wDESXN0PbIsDI80iwrYlN3jsE4BtK+GRZaVfgErtSRNbmiwWmJLWMPsBiDN7rp
	 8PRSngNTrq6La4yMSs/+mAP4hphA2KomlTBvY1eOGVgx3lVg5wk7sOcT2IXXSTOKpJ
	 7MsAgsz8265en1dUx8cg7KerirhbPyUyu4RWd2KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1129/2651] drm/amdgpu/userq: fix reading the WPTR at a non-zero BO offset
Date: Wed, 18 Nov 2026 15:39:29 +0100
Message-ID: <20261118150328.658391080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit c7ae3b2043282da8de92bd925c8f6bb614633181 ]

The user queue UAPI permits the WPTR at any 8-byte aligned offset within a
BO. amdgpu_userq_fence_read_wptr() locates the mapping containing the WPTR
address, but amdgpu_bo_kmap() returns the start of the BO, so the code read
the first u64 regardless of the WPTR offset. USERQ_SIGNAL uses this value as
the exported fence seqno, so a wrong read makes the fence signal early (or
never), breaking dependency synchronization.

Translate the WPTR GPU address to a byte offset within the BO, accounting
for the VA mapping start and the mapping's BO offset, before reading it.

Fixes: a292fdecd728 ("drm/amdgpu: Implement userqueue signal/wait IOCTL")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index 743b41db5b7cb..d29581f84535e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -370,7 +370,7 @@ static int amdgpu_userq_fence_read_wptr(struct amdgpu_device *adev,
 	struct amdgpu_bo_va_mapping *mapping;
 	struct amdgpu_bo *bo;
 	struct drm_exec exec;
-	u64 addr, *ptr;
+	u64 addr, offset, *ptr;
 	int ret;
 
 	addr = queue->userq_prop->wptr_gpu_addr;
@@ -402,7 +402,10 @@ static int amdgpu_userq_fence_read_wptr(struct amdgpu_device *adev,
 		goto lock_error;
 	}
 
-	*wptr = le64_to_cpu(*ptr);
+	/* The WPTR can be anywhere within the BO's VA mapping. */
+	offset = addr - (mapping->start << AMDGPU_GPU_PAGE_SHIFT);
+	offset += mapping->offset;
+	*wptr = le64_to_cpu(ptr[offset / sizeof(*ptr)]);
 
 	amdgpu_bo_kunmap(bo);
 	drm_exec_fini(&exec);
-- 
2.53.0



