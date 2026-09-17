Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34652518131;
	Thu, 17 Sep 2026 17:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666965; cv=none; b=KTi/Zg2UQ7nM78v3z6L4pf0lfNsytL051nMMQiRyUwZSpy7skimcdoJNMAGfNSZNlRqIsu6UXZUOXiqCItPVIcL+1OSRXnSpz/1yVTwErURtjU5Ix2BCXKSkVnh1ZPSFA4kFytLM0w0Uz1z5oH+T2leNEMEYwHh8ynfUoc5bHLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666965; c=relaxed/simple;
	bh=J8rVMWIcfHRCL9OlWheg6Bb3itCtRt0QueDpHM1uqmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7y8QWhVHZ8Xz2T+PO6Ea5ek2LkOVZD5aZuqRyXd/TzW2YsI8XY4hPemRz1AJhnND2iWnB3BJxAyHwAynQ8GyQTp04pzCFY5hXUc/4q+rlMK6UIu12JteWXjglP4s9wxfACOPAa7uLju0TzjUshrrE1yuj3e+luuyGAlTf4ZOJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laASk6E4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laASk6E4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1D21F000FF;
	Thu, 17 Sep 2026 17:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666964;
	bh=/Xt1w24fCgn9TYpQhWm46gO9YhtBd4gT6el/btWJQ6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=laASk6E4fEW4ycWNUEBLXMJnLgadMgrP0kmY0Dw7/0fzYSDOE1C5igXIeMa9JpAQp
	 7dItzZOFG2d8H0pM2i9leIzfIR7TzKLtWy7HKn3ZKn+zFgZhpQ4Z8P8NIrDS7K4x1t
	 19qw7mGoUIRpQot/25UYUsMhCfliPslrxqDNn6Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1182/1250] drm/amdgpu: add a helper to calculate ring distance
Date: Thu, 17 Sep 2026 16:16:17 +0100
Message-ID: <20260917151624.320223845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -516,6 +516,17 @@ static inline void amdgpu_ring_write_mul
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
@@ -526,18 +537,13 @@ static inline void amdgpu_ring_write_mul
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
 
 int amdgpu_ring_test_helper(struct amdgpu_ring *ring);


