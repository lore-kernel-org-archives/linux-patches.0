Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F582FABF4;
	Tue, 12 Aug 2025 18:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022295; cv=none; b=eRFLBcZ2itnW/XRjNmTKJtB6zD4B/mBagB/n7JzbPAlmI04BNRAFKSLPK9IyeuRgMonyrL7JHj5/X+GXuomvsi+eTgs5QhDRjq6nxbN4aJcSJyMaEp02t3/pkMnFMen+ccj+2MdSSe9M2YhwxTTQ6pWAepjp3OLOyKkTVXJu/GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022295; c=relaxed/simple;
	bh=Ds2xPNJq/B4TILZYadCg6cPeLaDHVpPpWmz0Oy6w+bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7PABKhyGunl/2kgzKLX7Xw/JMIqeX60pQTddinP4a3pXJfskk27a64hUTaScx3mb1IE8uH6znnD1pXhCRLhwU13WU7J2Jqlg4RGaxjQpKN2c+9QcKUOJuxaMH2Mk8Uaj3ccqZ/FZBulaMCZRodzLoKpqUYLQi9XutOzGGqfu+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/ZZc9/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/ZZc9/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18ADFC4CEF7;
	Tue, 12 Aug 2025 18:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022295;
	bh=Ds2xPNJq/B4TILZYadCg6cPeLaDHVpPpWmz0Oy6w+bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/ZZc9/IF+gCQO+PWzkFrDNBXsQLraLOPBfU+UqbNF+vFqYlFRa9cRLHg2dwbLT90
	 aPZ+nVlTE5DlNwfV/863yKnFy3JRLO4P3hm+MGMWINIV8oAlbMECbHQsYjq+kLnfz9
	 d5Olm3xraoTF2U75furLQjcZNocoxgjpebNneY2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/369] drm/amdgpu/gfx9.4.3: fix kiq locking in KCQ reset
Date: Tue, 12 Aug 2025 19:26:51 +0200
Message-ID: <20250812173019.059985508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 08f116c59310728ea8b7e9dc3086569006c861cf ]

The ring test needs to be inside the lock.

Fixes: 4c953e53cc34 ("drm/amdgpu/gfx_9.4.3: wait for reset done before remap")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jiadong Zhu <Jiadong.Zhu@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index 5dc3454d7d36..f27ccb8f3c8c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -3640,9 +3640,8 @@ static int gfx_v9_4_3_reset_kcq(struct amdgpu_ring *ring,
 	}
 	kiq->pmf->kiq_map_queues(kiq_ring, ring);
 	amdgpu_ring_commit(kiq_ring);
-	spin_unlock_irqrestore(&kiq->ring_lock, flags);
-
 	r = amdgpu_ring_test_ring(kiq_ring);
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r) {
 		dev_err(adev->dev, "fail to remap queue\n");
 		return r;
-- 
2.39.5



