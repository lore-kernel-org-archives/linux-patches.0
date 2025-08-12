Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15639305E08;
	Tue, 12 Aug 2025 18:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022299; cv=none; b=o/1j0r31TAp6W/XIC0nwI1oLrQ0THfxF+Bg+sFL3qrs19jMwH2q23bNSJJmmpyUh6sBIzdn90EHEPw6M+49E7Mnf0QaQCwBHzegZynPZKtLe3PfRMdRuA8KWIoPt7UMcHgWe6aldkO/cfjk7hgJO2AKH7UkAhdPybuV7l9SW1OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022299; c=relaxed/simple;
	bh=4ZQCb/uhPfe4SVjIFYLhS2/caHgf5yMJPRhWNGj17uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qpcwh0rVW7PHcBpRs3tBrMwO3H4WqR62TaEglNeRr5KeocCPpH1zXhbnAcz8rIV1GpQQEGB4paEdFprkuotLehSaJwX+kHr2DgtlidQ1j959ZZUxDnhZV/id2sE7/ojT9x/gz9ikmkUIlOVwVnbCHsZKiYszhjAor6gEOYICVWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNCoJ+vQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNCoJ+vQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BCCC4CEF0;
	Tue, 12 Aug 2025 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022298;
	bh=4ZQCb/uhPfe4SVjIFYLhS2/caHgf5yMJPRhWNGj17uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNCoJ+vQlr7rRqeJkueUj81I86qeFGSL4gdzP43X3EzA1vcKAiYM2qeBJJmeE+BNA
	 sMz37KCT7E/pVBy+6vvr3RYa6KgXdwgbQR5jLSNqmNt2xx3rbaTeRNUQoT1pZlUvV8
	 sje126AchCESFOuYOAgFKddtDoIGs7ca8R4W/wV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/369] drm/amdgpu/gfx10: fix kiq locking in KCQ reset
Date: Tue, 12 Aug 2025 19:26:52 +0200
Message-ID: <20250812173019.095359817@linuxfoundation.org>
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

[ Upstream commit a4b2ba8f631d3e44b30b9b46ee290fbfe608b7d0 ]

The ring test needs to be inside the lock.

Fixes: 097af47d3cfb ("drm/amdgpu/gfx10: wait for reset done before remap")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jiadong Zhu <Jiadong.Zhu@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 24d711b0e634..9a1c9dbad126 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -9510,9 +9510,8 @@ static int gfx_v10_0_reset_kcq(struct amdgpu_ring *ring,
 	kiq->pmf->kiq_unmap_queues(kiq_ring, ring, RESET_QUEUES,
 				   0, 0);
 	amdgpu_ring_commit(kiq_ring);
-	spin_unlock_irqrestore(&kiq->ring_lock, flags);
-
 	r = amdgpu_ring_test_ring(kiq_ring);
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r)
 		return r;
 
@@ -9559,9 +9558,8 @@ static int gfx_v10_0_reset_kcq(struct amdgpu_ring *ring,
 	}
 	kiq->pmf->kiq_map_queues(kiq_ring, ring);
 	amdgpu_ring_commit(kiq_ring);
-	spin_unlock_irqrestore(&kiq->ring_lock, flags);
-
 	r = amdgpu_ring_test_ring(kiq_ring);
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r)
 		return r;
 
-- 
2.39.5



