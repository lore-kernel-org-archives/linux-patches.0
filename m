Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7962F363F;
	Wed, 20 May 2026 17:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299402; cv=none; b=maOzEOniTn7FdUQ22Av9/4tfZOnHWuvfG32bTSkNdLg9QJ4rm4kno8v62HiMSHl1dqZJH0rwyW6IiPq0IYHGnwTZ11NxCp4rQiotUBzPiJHGYTn2H4pB3j9t1Pn40fDnAVcaqfVHD7FZErXuABN00aAnUaXL+I0oNjj1Fk2OUCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299402; c=relaxed/simple;
	bh=m6DWW14a0q8Hl0L4IBGuLktmVVKnDUHtzXPHIP8RMDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uXtlDdREGmiN3Mftw8YXFLG4q6YK8UvavgA/cVy1G5h+7Qh8WCQWvZ+tC7o8/LtSCJ/LB54WRiAQ4VaXtBWN0uTNoOdO3hL9EoU6HXUgUXmnzvSo86aoIxX/BKqOnys8iPe+CSWTRVIt7CknH7grD1RTJ4QArHOU5QWGPv94s18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SPhhXnq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SPhhXnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6A01F000E9;
	Wed, 20 May 2026 17:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299400;
	bh=TURVtVnFtSJl6n7TRN55JE/nLKka6qgb4VU9rugtxvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SPhhXnqYjPogidvh0nVi2h9E5xOPwhjEGmW9RZgI3U2BkNJJG95FH7rR18pTju0k
	 rrnNPKjZCUC33iknTdo9MckqPcJh3GSORSam16rABaqgklUJKBQS/Mj2YmKSytkm/j
	 t3tHdNjFGBwbWGykfy0KAuyoUYXTy1CnLCP/glQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 751/957] drm/amdgpu/gfx6: Support harvested SI chips with disabled TCCs (v2)
Date: Wed, 20 May 2026 18:20:34 +0200
Message-ID: <20260520162150.850136358@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 80565392313f1..066cdf6863e11 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -1571,6 +1571,71 @@ static void gfx_v6_0_setup_spi(struct amdgpu_device *adev)
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
@@ -1729,6 +1794,7 @@ static void gfx_v6_0_constants_init(struct amdgpu_device *adev)
 	gfx_v6_0_tiling_mode_table_init(adev);
 
 	gfx_v6_0_setup_rb(adev);
+	gfx_v6_0_setup_tcc(adev);
 
 	gfx_v6_0_setup_spi(adev);
 
-- 
2.53.0



