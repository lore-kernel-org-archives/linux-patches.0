Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE75431F98D;
	Sat, 30 May 2026 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164619; cv=none; b=VT6e8ZdZDVooTflEJsySiVmIIrqKjp7/3apc+r1ClRNl8xLwBjAUJWTUwbH6yUNb9aqY024Wa/bfjwWX8zgeU7CNWhAAEY0C0Q6s5jDAzFmDncIgc+kYSMp6b83QKHnepBx+sQaO0Mq//f8EowiEPBlS0szXNdRlx9HoOPhGmOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164619; c=relaxed/simple;
	bh=WvO2FsepkbpYJSaf643pAcO5atYTDs1JFFRUudZNHyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ftdEq9nJcbfRgLvZ12LCv7JT29PZJ34J0hd8etCVqVV8LYpFNg45XgypniZKPXE0gpvo/AVtEDq09Lr4phqmFDm2wZqYz1ip+xc6S0z5DWjSPtIzk2XsT1rJ1PzXFli9459XCFBHQb4W7olBuHdW6ztNb9sHgbqQcUGQ7hBHYbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETtZAffX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETtZAffX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB431F00893;
	Sat, 30 May 2026 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164617;
	bh=QeqSd8OeKfuP5j9h3ZoT0b2nN4w0rx+KYnQ/FO6Cblc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETtZAffXZyPxsHpLp7H5yz5fhUvS5lBJVHsdzlbBzQOZLgLmD6I6ojqdBHtvAZjNI
	 34Fgw2xohNsWDeAbG1jsSgVDsDx/iUYJBIpm66rhAy8e2Nr4h0Euozl1ideRrhdvSl
	 pJ6bBqZAbgn9mMKqQJTeO/v3ZchJ5Qq5tWv1hcII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 608/776] drm/amdgpu/gfx6: Support harvested SI chips with disabled TCCs (v2)
Date: Sat, 30 May 2026 18:05:22 +0200
Message-ID: <20260530160255.727114184@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit fe2b84f9228e2a0903221a4d0d8c350b018e9c0c ]

This commit fixes amdgpu to work on the Radeon HD 7870 XT
which has never worked with the Linux open source drivers before.

Some boards have "harvested" chips, meaning that some parts of
the chip are disabled and fused, and it's sold for cheaper and
under a different marketing name.
On a harvested chip, any of the following can be disabled:
- CUs (Compute Units)
- RBs (Render Backend, aka. ROP)
- Memory channels (ie. the chip has a lower bandwidth)
- TCCs (ie. less L2 cache)

Handle chips with harvested TCCs by patching the registers
that configure how TCCs are mapped.

If some TCCs are disabled, we need to make sure that
the disabled TCCs are not used, and the remaining TCCs
are used optimally.

TCP_CHAN_STEER_LO/HI control which TCC is used by TCP channels.
TCP_ADDR_CONFIG.NUM_TCC_BANKS controls how many channels are used.

Note that the TCC configuration is highly relevant to performance.
Suboptimal configuration (eg. CHAN_STEER=0) can significantly
reduce gaming performance.

For optimal performance:
- Rely on the CHAN_STEER from the golden registers table,
  only skip disabled TCCs but keep the mapping order.
- Limit NUM_TCC_BANKS to number of active TCCs to avoid thrashing,
  which performs better than using the same TCC twice.

v2:
- Also consider CGTS_USER_TCC_DISABLE for disabled TCCs.

Link: https://bugs.freedesktop.org/show_bug.cgi?id=60879
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/2664
Fixes: 2cd46ad22383 ("drm/amdgpu: add graphic pipeline implementation for si v8")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 00218d15528fab9f6b31241fe5904eea4fcaa30d)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 66 +++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index 79074d22959b9..eecc93f8c3cd5 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -1568,6 +1568,71 @@ static void gfx_v6_0_setup_spi(struct amdgpu_device *adev)
 	mutex_unlock(&adev->grbm_idx_mutex);
 }
 
+/**
+ * gfx_v6_0_setup_tcc() - setup which TCCs are used
+ *
+ * @adev: amdgpu_device pointer
+ *
+ * Verify whether the current GPU has any TCCs disabled,
+ * which can happen when the GPU is harvested and some
+ * memory channels are disabled, reducing the memory bus width.
+ * For example, on the Radeon HD 7870 XT (Tahiti LE).
+ *
+ * If some TCCs are disabled, we need to make sure that
+ * the disabled TCCs are not used, and the remaining TCCs
+ * are used optimally.
+ *
+ * TCP_CHAN_STEER_LO/HI control which TCC is used by TCP channels.
+ * TCP_ADDR_CONFIG.NUM_TCC_BANKS controls how many channels are used.
+ *
+ * For optimal performance:
+ * - Rely on the CHAN_STEER from the golden registers table,
+ *   only skip disabled TCCs but keep the mapping order.
+ * - Limit NUM_TCC_BANKS to number of active TCCs to avoid thrashing,
+ *   which performs better than using the same TCC twice.
+ */
+static void gfx_v6_0_setup_tcc(struct amdgpu_device *adev)
+{
+	u32 i, tcc, tcp_addr_config, num_active_tcc = 0;
+	u64 chan_steer, patched_chan_steer = 0;
+	const u32 num_max_tcc = adev->gfx.config.max_texture_channel_caches;
+	const u32 dis_tcc_mask =
+		amdgpu_gfx_create_bitmask(num_max_tcc) &
+		(REG_GET_FIELD(RREG32(mmCGTS_TCC_DISABLE),
+			       CGTS_TCC_DISABLE, TCC_DISABLE) |
+		 REG_GET_FIELD(RREG32(mmCGTS_USER_TCC_DISABLE),
+			       CGTS_USER_TCC_DISABLE, TCC_DISABLE));
+
+	/* When no TCC is disabled, the golden registers table already has optimal TCC setup */
+	if (!dis_tcc_mask)
+		return;
+
+	/* Each 4-bit nibble contains the index of a TCC used by all TCPs */
+	chan_steer = RREG32(mmTCP_CHAN_STEER_LO) | ((u64)RREG32(mmTCP_CHAN_STEER_HI) << 32ull);
+
+	/* Patch the TCP to TCC mapping to skip disabled TCCs */
+	for (i = 0; i < num_max_tcc; ++i) {
+		tcc = (chan_steer >> (u64)(4 * i)) & 0xf;
+
+		if (!((1 << tcc) & dis_tcc_mask)) {
+			/* Copy enabled TCC indices to the patched register value. */
+			patched_chan_steer |= (u64)tcc << (u64)(4 * num_active_tcc);
+			++num_active_tcc;
+		}
+	}
+
+	WARN_ON(num_active_tcc != num_max_tcc - hweight32(dis_tcc_mask));
+
+	/* Patch number of TCCs used by TCPs */
+	tcp_addr_config = REG_SET_FIELD(RREG32(mmTCP_ADDR_CONFIG),
+					TCP_ADDR_CONFIG, NUM_TCC_BANKS,
+					num_active_tcc - 1);
+
+	WREG32(mmTCP_ADDR_CONFIG, tcp_addr_config);
+	WREG32(mmTCP_CHAN_STEER_HI, upper_32_bits(patched_chan_steer));
+	WREG32(mmTCP_CHAN_STEER_LO, lower_32_bits(patched_chan_steer));
+}
+
 static void gfx_v6_0_config_init(struct amdgpu_device *adev)
 {
 	adev->gfx.config.double_offchip_lds_buf = 0;
@@ -1726,6 +1791,7 @@ static void gfx_v6_0_constants_init(struct amdgpu_device *adev)
 	gfx_v6_0_tiling_mode_table_init(adev);
 
 	gfx_v6_0_setup_rb(adev);
+	gfx_v6_0_setup_tcc(adev);
 
 	gfx_v6_0_setup_spi(adev);
 
-- 
2.53.0



