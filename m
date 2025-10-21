Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2131A3029;
	Tue, 21 Oct 2025 20:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077448; cv=none; b=GtP9Q03acwejnEVfrpLvO6zSPkngQuQbceyaOJGbJUzcqB9Vsw/b6+ia2WZ5+6BXRdWefl0o2HFxjNn1LbTqTRgzjwzvWW/1g354L3WgBvoxsu5YFtLoshxCf4gR9cjOU0+bgRXANGjmJMvBHR1Bxl2rnoFMHaPZJ+fZDkYL6IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077448; c=relaxed/simple;
	bh=P5VN19pZKtJX1y+/NT0R8KReeQm0aV5sPx+Hyy+EgCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rHUhXx5r4dE5sbVGVI44iBvBPTZzNu3OkzfI7TkQKrbojUCmxACLP55CxFq3X76D/RG5z8Q0TGw8eTIFb4Z+zP3837mG6YL5ppp8JvjDs79JvJq2bAL8mSKld6bK4HbHkSc5L/8MO2auo9sKhw+MFLjpXavf1m3JhkqQsIdlVoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKabGVQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKabGVQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B47C4CEF7;
	Tue, 21 Oct 2025 20:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077446;
	bh=P5VN19pZKtJX1y+/NT0R8KReeQm0aV5sPx+Hyy+EgCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKabGVQ8m3UU+b5VKRwcc9l5Von7YQHJGxg8fUlyB6cXf3HiuhTw23WRzt7t/6/YP
	 65YSxKfVles3emd2JZXlf8jnbnPAjpb4RfT12Q0KJZZin6TwsHvMxQ+9gGJ9gmfgV0
	 5KzNR2zKxSueteVeDILZJyIukcHITEzHloMgWTWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 108/159] drm/amdgpu: handle wrap around in reemit handling
Date: Tue, 21 Oct 2025 21:51:25 +0200
Message-ID: <20251021195045.772267103@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 1f22fcb88bfef26a966e9eb242c692c6bf253d47 ]

Compare the sequence numbers directly.

Fixes: 77cc0da39c7c ("drm/amdgpu: track ring state associated with a fence")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index 9e7506965cab2..bb17af79c24a6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -791,14 +791,19 @@ void amdgpu_ring_backup_unprocessed_commands(struct amdgpu_ring *ring,
 	struct dma_fence *unprocessed;
 	struct dma_fence __rcu **ptr;
 	struct amdgpu_fence *fence;
-	u64 wptr, i, seqno;
+	u64 wptr;
+	u32 seq, last_seq;
 
-	seqno = amdgpu_fence_read(ring);
+	last_seq = amdgpu_fence_read(ring) & ring->fence_drv.num_fences_mask;
+	seq = ring->fence_drv.sync_seq & ring->fence_drv.num_fences_mask;
 	wptr = ring->fence_drv.signalled_wptr;
 	ring->ring_backup_entries_to_copy = 0;
 
-	for (i = seqno + 1; i <= ring->fence_drv.sync_seq; ++i) {
-		ptr = &ring->fence_drv.fences[i & ring->fence_drv.num_fences_mask];
+	do {
+		last_seq++;
+		last_seq &= ring->fence_drv.num_fences_mask;
+
+		ptr = &ring->fence_drv.fences[last_seq];
 		rcu_read_lock();
 		unprocessed = rcu_dereference(*ptr);
 
@@ -814,7 +819,7 @@ void amdgpu_ring_backup_unprocessed_commands(struct amdgpu_ring *ring,
 			wptr = fence->wptr;
 		}
 		rcu_read_unlock();
-	}
+	} while (last_seq != seq);
 }
 
 /*
-- 
2.51.0



