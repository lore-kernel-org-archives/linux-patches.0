Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2142AE68;
	Mon, 30 Dec 2024 15:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573905; cv=none; b=kVxl3ibcQs5dFBdGJhvbxHGF80IABYg6No+R2Yu1Ji49jnH28it4iOPbYqnzZY2Ydy9oR/S9UT7/rG4DHsmtyMYbqZzVWjz+GpelkJ+s/dO1YlhB5odiLY3YCbgjMShuUIuDj0oJxqdp2pec/39tfh3ziMYy/l5n8cYGf9YkgL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573905; c=relaxed/simple;
	bh=i3ggnAFa8dDU8k11124IWhdlwV5QNoHs+LX475gCT0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VajyHKoT5ELEy09rW4JPRmdfMUHmuOoYPjpTP67KU45M6FpMBACXXZJv+kCAAE11K9T9Ad6mTxulzspWzUvyCNjye5kdJdB1mAQm+YPqiOCvZvWfG/rspatYN4OCVYwqWUsqrVKhSiN1d7SdJ8dphovepyM4gyKPr03mbI5cWYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7apvNZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7apvNZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C895C4CED0;
	Mon, 30 Dec 2024 15:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573904;
	bh=i3ggnAFa8dDU8k11124IWhdlwV5QNoHs+LX475gCT0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7apvNZ50tQ3FtDBJes1QGptBqMIZlR58D8kmlz+N20Xx5C8bDzQskRQzelZNTccF
	 42uopv4WvrBnH0QiiwGt0uHd8tV2epKTXyDv83MhOgFZ89IQWvphMsZOEHzXwTmaIW
	 rsEhRKeETTUBP2dxB+WwiFJZby5wDcA0VKPxg7Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Frank Min <frank.min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 61/86] drm/amdgpu/hdp6.0: do a posting read when flushing HDP
Date: Mon, 30 Dec 2024 16:43:09 +0100
Message-ID: <20241230154214.038794803@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit abe1cbaec6cfe9fde609a15cd6a12c812282ce77 ]

Need to read back to make sure the write goes through.

Cc: David Belanger <david.belanger@amd.com>
Reviewed-by: Frank Min <frank.min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c b/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c
index 53ad93f96cd9..b6d71ec1debf 100644
--- a/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c
@@ -31,10 +31,12 @@
 static void hdp_v6_0_flush_hdp(struct amdgpu_device *adev,
 				struct amdgpu_ring *ring)
 {
-	if (!ring || !ring->funcs->emit_wreg)
+	if (!ring || !ring->funcs->emit_wreg) {
 		WREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
-	else
+		RREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2);
+	} else {
 		amdgpu_ring_emit_wreg(ring, (adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
+	}
 }
 
 static void hdp_v6_0_update_clock_gating(struct amdgpu_device *adev,
-- 
2.39.5



