Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5324015FD07;
	Mon, 27 May 2024 19:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837542; cv=none; b=BGs3wQAb2Db8EXiajNnMHG/Cd67ESja4lc2D20NQJZodeUiZdf8OkOErmcx6IAd8Pl5laTfonXl0/mAW1HPd+HIpg8ly/wksAO8iNQ7VAzdzk9u7B0wPlAV/w1buvJNCH/HuvonvraDtCnPoBajbzr7B22tEo98h7HoLYxyOK7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837542; c=relaxed/simple;
	bh=nBbpsGyElEmHzHyVTgMdDR8X/2Ij9qIJun/Pn8jwEW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFtdyKWH9wgw4qFaCOquDSBaarMJk25IZ213pVnV0VcvMP1fyApi8wD9hkmKPTTHKD3V/t/N36b+eIvXbm7dU95agO0M0GNZAMqsNVmdFI5VOWxzuZjGUC1Y3IzitPzBqx+cODNdi1zyrV0Q1JIEqkIaVkzThHQUrNeS26zQjcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkkEWSrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkkEWSrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A6BC32782;
	Mon, 27 May 2024 19:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837542;
	bh=nBbpsGyElEmHzHyVTgMdDR8X/2Ij9qIJun/Pn8jwEW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkkEWSrBxWqQRVvEW10j56YfeVCcvNRSDSJ/Msh+rFbP6Rm62LMqMfZ1LWA0Y39EH
	 Uwdaj3m97fnjo9ISN3AHleXpgCQUJ96eQWWLjmG+vvFGUECQFpXsOwESJBYqgjviNQ
	 Tp+IIEGSghE+qTxA/HZr+dqGyWrHK+dlGZcffWfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 052/493] drm/amdgpu/mes: fix use-after-free issue
Date: Mon, 27 May 2024 20:50:54 +0200
Message-ID: <20240527185630.907694016@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Xiao <Jack.Xiao@amd.com>

[ Upstream commit 948255282074d9367e01908b3f5dcf8c10fc9c3d ]

Delete fence fallback timer to fix the ramdom
use-after-free issue.

v2: move to amdgpu_mes.c

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index da48b6da01072..420e5bc44e306 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -1129,6 +1129,7 @@ void amdgpu_mes_remove_ring(struct amdgpu_device *adev,
 		return;
 
 	amdgpu_mes_remove_hw_queue(adev, ring->hw_queue_id);
+	del_timer_sync(&ring->fence_drv.fallback_timer);
 	amdgpu_ring_fini(ring);
 	kfree(ring);
 }
-- 
2.43.0



