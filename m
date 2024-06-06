Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B29B19E7FA;
	Thu,  6 Jun 2024 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683113; cv=none; b=aiS1VHiryKbcW2HB4U9GcjcyQ4fZSpN4m8OyDKnUy2mzPmNqsr3HOmMMlpgym9B4amHNIs30ewjrIv95q3IrNM/5Ee3q85QkbVphlEpwO67MReHo6Ia91DLxS5Yu4SkTP6++gK15UAuZlVlLFLajzklPW4IphJXVAevwKbtUtnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683113; c=relaxed/simple;
	bh=ojO8yfccFC3JYxBu1VuWeDOUVsaADzUCVlsVT0IEoA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I97GbQauYa/qzrtD8z7TdKeM9PAsJ7P3VRbnoFJ0ePQ1pIcaEcDDmkht8oLbJGyhwKOeUUoH/mFPrTByQEEoFZ07h0R/GGEhMRiGPQmB95kPmVEglDXL1YYoovsxgAfEB3Ts4spL3ko9kaDJnwEYNOguG/wY3PkovcDYE8aTdHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnwcHEVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnwcHEVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBCBC2BD10;
	Thu,  6 Jun 2024 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683113;
	bh=ojO8yfccFC3JYxBu1VuWeDOUVsaADzUCVlsVT0IEoA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnwcHEVrfO+TaQz3lXX0CS23k9VDWhC5lE+GrWZqUyrMgtI9yoYb+Ava3S663SYyh
	 RHrlLGGMj6PC6AL5UW46AzoiU2+h9xD5vKzo/j4aKEYBalDQQP/+Odn7E6Knl663n2
	 HBR0vjwSC+SePwh13/hOlQ68bEyZCXY8pLYa/gh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/744] drm/amdgpu/mes: fix use-after-free issue
Date: Thu,  6 Jun 2024 15:55:17 +0200
Message-ID: <20240606131733.899042120@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 15c67fa404ff9..c5c55e132af21 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -1098,6 +1098,7 @@ void amdgpu_mes_remove_ring(struct amdgpu_device *adev,
 		return;
 
 	amdgpu_mes_remove_hw_queue(adev, ring->hw_queue_id);
+	del_timer_sync(&ring->fence_drv.fallback_timer);
 	amdgpu_ring_fini(ring);
 	kfree(ring);
 }
-- 
2.43.0



