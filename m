Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0173753C3DB;
	Wed, 30 Sep 2026 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790063; cv=none; b=tAlhKVHYu6uC2wBwrst0nBoJ62KZHVVJhpxxfqFJecHPgkG971m48khjWKPqOTeFvuN/yAGrE0ok2p+sqZn0Epo1nNPPs20sATeuF/yBRlWYV+6hoH77xYAgkF0vVjKAesRsleSCp9JHH95BcUh+ICkrE4syulhX4iNjnAsXC6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790063; c=relaxed/simple;
	bh=o4vxk0DrtNkcrmF3stgs0bHj23pBayD0GcSVN06ZwHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oo2GKwWW1O71+s/ftonp+wuvWBqSlSHvyX1ZPRXZ8pjAaCASBAPRljPLN0oS5U4X/iVlvPsEUmeLwjTrbuxBPR2zQpWJvumltdJpgTukcPyNIDeofDitQTe7NfEQpxKVd5CiT65eiVYcdtrYTVV61f0h0haA/eeWp9lF9Nv2gCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqOf+RxQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqOf+RxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB871F000FF;
	Wed, 30 Sep 2026 17:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790061;
	bh=3sxRkYDNnFrIEAkB5dh7zvclq62apPWJ/pQbRop3/0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AqOf+RxQkrLRp+c9x3B7nix3Ca63F6AoS+pHHs0rKwaeCs/UyAWxWXFyMztycc5aX
	 2RSVBV5h0fFtNwQ4C7qloDWCOAcENVa8Wl6Glxtc3e+dyaVUBaYNrHJ2W3rD9enqLo
	 +f92rXOS6XBA+yViVs7sujA4bvG8/rjHOiw2OsyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 698/877] drm/amdgpu: add a helper to calculate ring distance
Date: Wed, 30 Sep 2026 17:26:49 +0200
Message-ID: <20260930152429.740598766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 08e7d6c3cee880bd3ec3eb14c478f9fa805b0bdc ]

Add a helper to calculate the distance in DWs between
two wptrs.

Reviewed-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6760f5cb12d2 ("drm/amdgpu: avoid force-completing uninitialized UVD rings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -431,6 +431,17 @@ static inline void amdgpu_ring_write_mul
 	ring->count_dw -= count_dw;
 }
 
+static inline unsigned int amdgpu_ring_get_dw_distance(struct amdgpu_ring *ring,
+						       u64 start_wptr, u64 end_wptr)
+{
+	unsigned int start = start_wptr & ring->buf_mask;
+	unsigned int end = end_wptr & ring->buf_mask;
+
+	if (end < start)
+		end += ring->ring_size >> 2;
+	return end - start;
+}
+
 /**
  * amdgpu_ring_patch_cond_exec - patch dw count of conditional execute
  * @ring: amdgpu_ring structure
@@ -441,18 +452,13 @@ static inline void amdgpu_ring_write_mul
 static inline void amdgpu_ring_patch_cond_exec(struct amdgpu_ring *ring,
 					       unsigned int offset)
 {
-	unsigned cur;
-
 	if (!ring->funcs->init_cond_exec)
 		return;
 
 	WARN_ON(offset > ring->buf_mask);
 	WARN_ON(ring->ring[offset] != 0);
 
-	cur = (ring->wptr - 1) & ring->buf_mask;
-	if (cur < offset)
-		cur += ring->ring_size >> 2;
-	ring->ring[offset] = cur - offset;
+	ring->ring[offset] = amdgpu_ring_get_dw_distance(ring, offset, ring->wptr - 1);
 }
 
 #define amdgpu_mes_ctx_get_offs_gpu_addr(ring, offset)			\


