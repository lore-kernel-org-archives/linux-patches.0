Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4FB45038;
	Sat,  3 Feb 2024 04:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933678; cv=none; b=TNBqVtR8jHeUQwe6To8bkkjVLefUPEdKFvAIlMJdY+1cwMBiLRPEiFHQ6UPj6kyh2t3p926H8qbVN5Igvf9+8EcXKdNbO1FHMnmVWrCwVI2PFVnlvAQwSN3xc4HueVraDz2GVw+gOtlHc0XriBYdbnQlyARhh5Qva76Q9QqRs1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933678; c=relaxed/simple;
	bh=/ZwteFnr0H2DFblfA7918EAgnA5+BpxLS3vSL1mtadk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C181KQBFImGYYTFrEXhAOTWtav3G5HJwEqULgJtns5JgO3yVaS4dyhyHAWuvg8HUssjNDup5JTOjKjciXSAgw4bVVkcciZaYoVkq9I2irSTB65pzFPCJnxxpMkLF6CvQ6wQlqlF7oruO4BD4N1pOHaMBQG79SjOxY1futrn/jhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWAIpXeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWAIpXeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6401C43390;
	Sat,  3 Feb 2024 04:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933677;
	bh=/ZwteFnr0H2DFblfA7918EAgnA5+BpxLS3vSL1mtadk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWAIpXeBtI3Sp3ug04JA6WLXZjFpg7qcuFw2q/n7XxeGXY5/Df+8olzUxq3IyCflj
	 bfTHwxoV4WQJ8w/wvKfP95JcTimqSE6tLnH+iyF2Ixf2uLQRJ0nXu0S5G1PEw9d34g
	 q2SJVbAwfn7XEJERszgiWU2ve39eNU4bWDl4GQrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/322] drm/amdkfd: only flush mes process context if mes support is there
Date: Fri,  2 Feb 2024 20:05:59 -0800
Message-ID: <20240203035407.601979406@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Kim <jonathan.kim@amd.com>

[ Upstream commit 24149412dfc71f7f4a54868702e9145e396263d3 ]

Fix up on mes process context flush to prevent non-mes devices from
spamming error messages or running into undefined behaviour during
process termination.

Fixes: bd33bb1409b4 ("drm/amdkfd: fix mes set shader debugger process management")
Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Eric Huang <jinhuieric.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 8e55e78fce4e..43eff221eae5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -87,7 +87,8 @@ void kfd_process_dequeue_from_device(struct kfd_process_device *pdd)
 		return;
 
 	dev->dqm->ops.process_termination(dev->dqm, &pdd->qpd);
-	amdgpu_mes_flush_shader_debugger(dev->adev, pdd->proc_ctx_gpu_addr);
+	if (dev->kfd->shared_resources.enable_mes)
+		amdgpu_mes_flush_shader_debugger(dev->adev, pdd->proc_ctx_gpu_addr);
 	pdd->already_dequeued = true;
 }
 
-- 
2.43.0



