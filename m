Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F38D1D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWMbVy3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55C1C433C7;
	Wed,  4 Oct 2023 18:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444047;
	bh=9XXd2alymtARDSzIaooiYglf5KCdO5HVartHd5iAy/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWMbVy3OKN/Vlag0/vydOcJFqTyOgjhHFoRIbOdf+wpBHKBa9Lh88v8x6o6pMRwWM
	 teZy5c92rva71bORHFBDbuI5mFdduPYQqVZVbUxR4P2vITyUFGPLnt9ViY2dbsD9np
	 0jqIupM9/HdhC0Oqh1RqdsB3D40ppQ/yFh5+yC38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 111/321] drm/amdgpu: set completion status as preempted for the resubmission
Date: Wed,  4 Oct 2023 19:54:16 +0200
Message-ID: <20231004175234.366944342@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiadong Zhu <Jiadong.Zhu@amd.com>

[ Upstream commit 8cbbd11547f61b90b33a4ef70c4614eb2e789c49 ]

The driver's CSA buffer is shared by all the ibs. When the high priority ib
is submitted after the preempted ib, CP overrides the ib_completion_status
as completed in the csa buffer. After that the preempted ib is resubmitted,
CP would clear some locals stored for ib resume when reading the completed
status, which causes gpu hang in some cases.

Always set status as preempted for those resubmitted ib instead of reading
everything from the CSA buffer.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2535
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2717
Signed-off-by: Jiadong Zhu <Jiadong.Zhu@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring_mux.h | 9 +++++++++
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c        | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring_mux.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring_mux.h
index b22d4fb2a8470..d3186b570b82e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring_mux.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring_mux.h
@@ -56,6 +56,15 @@ enum amdgpu_ring_mux_offset_type {
 	AMDGPU_MUX_OFFSET_TYPE_CE,
 };
 
+enum ib_complete_status {
+	/* IB not started/reset value, default value. */
+	IB_COMPLETION_STATUS_DEFAULT = 0,
+	/* IB preempted, started but not completed. */
+	IB_COMPLETION_STATUS_PREEMPTED = 1,
+	/* IB completed. */
+	IB_COMPLETION_STATUS_COMPLETED = 2,
+};
+
 struct amdgpu_ring_mux {
 	struct amdgpu_ring      *real_ring;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 65577eca58f1c..372ae2fc42e0c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -5230,6 +5230,9 @@ static void gfx_v9_0_ring_patch_de_meta(struct amdgpu_ring *ring,
 		de_payload_cpu_addr = adev->virt.csa_cpu_addr + payload_offset;
 	}
 
+	((struct v9_de_ib_state *)de_payload_cpu_addr)->ib_completion_status =
+		IB_COMPLETION_STATUS_PREEMPTED;
+
 	if (offset + (payload_size >> 2) <= ring->buf_mask + 1) {
 		memcpy((void *)&ring->ring[offset], de_payload_cpu_addr, payload_size);
 	} else {
-- 
2.40.1



