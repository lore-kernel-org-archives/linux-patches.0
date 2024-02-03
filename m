Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8346171D4;
	Sat,  3 Feb 2024 04:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933931; cv=none; b=nH/n1Uxo79q5ZnYPpQWRPXpYMM1ZSCTvy9/FbiC4Ssb0yKLWQOTYsXv0N0/hh6fm0JMKSJoRBXHMuA39/sw/Z50dHbn87OGt6e9sF8YKk2gXTFybluIwderUagTAFxxnmxODcw1mutztc47kGJQ18Vvg/LZDzJ5Q+wWgZOPKL6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933931; c=relaxed/simple;
	bh=/62yqVNuudGnu7FwdAXeveetHMmMuTky6S2J5wATPwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftJ9z4et19QqphUwa9r9IjjGcL6jEOZfzfR4iWaeGJxAB+KdBCQYi9yXY8zsjIpMB48axOwD52hWvRcViS30EI/dnaTTlitvg6eVHBTKEygAbcd8jc9WfOpq2BKO+XnE33ou4EPzfcTL50PNyfj0U98uH5Yv2lPPCEtCZJ3n88Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uo4Jshwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uo4Jshwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E47AC433F1;
	Sat,  3 Feb 2024 04:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933931;
	bh=/62yqVNuudGnu7FwdAXeveetHMmMuTky6S2J5wATPwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uo4JshwnTVA5iAL6Ti0ylwA/oZtp/pNXUZlTqh0RA9VmyMaXo03+EKBBzRFflUfPX
	 C3U4Mt7wFlztJ3dJ9r+QA6QeCv/MAtse7m3IKYfQLuc0Pn1JZvKzC+krMpTZ5RF6pJ
	 5EY0LRlo9++zvaPqBa4b3ejcitpC77W/Uyzta/3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 291/353] drm/amdkfd: only flush mes process context if mes support is there
Date: Fri,  2 Feb 2024 20:06:49 -0800
Message-ID: <20240203035413.002299785@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



