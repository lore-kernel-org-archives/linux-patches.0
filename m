Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A5F2FFDE2;
	Tue, 12 Aug 2025 18:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023954; cv=none; b=Hwv5AxmxmsMqoOjjLfcqp2+HymduGVEzacPcSmjMWrx1V3ePBEmJrxnvZY1dysyoIRpzo5OBV3cN9Y45Nop6CpdL0aBT6RvjpCX13fu4osRdMAbLggwqlJjXL155kQcjX63ku+1idRFelJGZrIZ0PzBxSqr7kxpVqz0u5RjGv2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023954; c=relaxed/simple;
	bh=UeNVcIGmarNEPVrbIeCoNzxP/qSHyYSbSDSzg1buTW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=evnzuW0Ph+WerVLFcQgvt2/Y6tu3KCowWojg2oL2Z46viIJAkaYW9I5nfsHXVc7jG/C/RRhT9ErIN3BJwk9qoXF5jVSDpVzRJPKfFFQqnJNxERxTT2VzoBuNqcKTM1QLnSN7aDKrA8re44QRUuDd8zQhTZ0CalWp0h+mcdT76w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DW0+zNfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DW0+zNfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D93FC4CEF0;
	Tue, 12 Aug 2025 18:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023953;
	bh=UeNVcIGmarNEPVrbIeCoNzxP/qSHyYSbSDSzg1buTW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DW0+zNfPoBhjyMtR6a+aQPLMdU8XskJHQ22rB275ZJ3t61G0Eq/uNhIeIM8PqnrhJ
	 NuUGgRijhllQlCB0r0HzlkN5BDOXusNaFIVypTiMJWdH1N0jixR0tkAgqygOnlOX0R
	 aZUuKhfbKaBJoA1RIetA/gD+qAY/B3Q1RDgrewyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 230/627] drm/amdgpu/gfx10: fix kiq locking in KCQ reset
Date: Tue, 12 Aug 2025 19:28:45 +0200
Message-ID: <20250812173428.043795504@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index e7df0487eaae..961d5e0af052 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -9617,9 +9617,8 @@ static int gfx_v10_0_reset_kcq(struct amdgpu_ring *ring,
 	kiq->pmf->kiq_unmap_queues(kiq_ring, ring, RESET_QUEUES,
 				   0, 0);
 	amdgpu_ring_commit(kiq_ring);
-	spin_unlock_irqrestore(&kiq->ring_lock, flags);
-
 	r = amdgpu_ring_test_ring(kiq_ring);
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r)
 		return r;
 
@@ -9655,9 +9654,8 @@ static int gfx_v10_0_reset_kcq(struct amdgpu_ring *ring,
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



