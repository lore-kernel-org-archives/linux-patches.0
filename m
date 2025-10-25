Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939EE30100D;
	Sat, 25 Oct 2025 16:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409214; cv=none; b=dITe34+OxsIgQYIjQ0uS58335H/dSkaeYgYd6efFyDxF+fkceS069Hv7cwAbO/HSQ77Jdk4/GCYMDwkOZFXimxPNP7mLqcPCp1sXW4s6UvurzY01ZgZKyxclpSRngw0EvLoOzmPkjWEvxDG9x1hLP4h1fUyi8QDYuq45O9fPAYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409214; c=relaxed/simple;
	bh=Ivqf6B06RLQJ75RU1eKMgPmPo0bxsOmzuxLQdcmvNqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MSo456wKhFiG3oHohcbUiIaTRTw4mUCMy2PE5r1JzQy4iCAvnWUHLOTldbqjCdnnNwO8vwvnqknu4tld0OFxRjxgyjzbL8d1+tQaTfzosgd5rPnLAou19NbcXL+G6rPMFJGfh4mKYLOUZzLMy9IVgbfE42gF/hWv06xexVD9jcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZT9Pj2pY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZT9Pj2pY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F707C4CEF5;
	Sat, 25 Oct 2025 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409214;
	bh=Ivqf6B06RLQJ75RU1eKMgPmPo0bxsOmzuxLQdcmvNqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZT9Pj2pYM4geut9A5VgktL1f/jk1N+Dv7t695vlPFfE5KhuZ21teAizFG6BwdUsaQ
	 bPO43YHjxikRlq8UsUWcSb5RVZH3Q2XSrfPwXF2vS3o74RvjMkE0sft1zfulBcUHfO
	 SE2vifEY3ccDO4C0g5ywCcaNMKo/hswMRG/8St+89Jtc0bC8wRuX1w2C8u4ue8g3BB
	 LNPFH/yKUHACCtFUG03zXlU9Vn53NAIBIbSLrRhQ6ZF7kQCP9LoCQOsmSS8G2u2Kov
	 HSgYrm6SDU+fbHd0Bz0kesUHxKyQ/y4B9Tus9UUHAL7kAA+2m+ie8fKCUW9XnMWRoB
	 rnmMmx50rOTqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Jesse.Zhang" <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Hawking.Zhang@amd.com,
	christian.koenig@amd.com,
	sunil.khatri@amd.com,
	xiang.liu@amd.com,
	alexandre.f.demers@gmail.com,
	shiwu.zhang@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Add fallback to pipe reset if KCQ ring reset fails
Date: Sat, 25 Oct 2025 11:57:55 -0400
Message-ID: <20251025160905.3857885-244-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Jesse.Zhang" <Jesse.Zhang@amd.com>

[ Upstream commit 7469567d882374dcac3fdb8b300e0f28cf875a75 ]

Add a fallback mechanism to attempt pipe reset when KCQ reset
fails to recover the ring. After performing the KCQ reset and
queue remapping, test the ring functionality. If the ring test
fails, initiate a pipe reset as an additional recovery step.

v2: fix the typo (Lijo)
v3: try pipeline reset when kiq mapping fails (Lijo)

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The patch makes `gfx_v9_4_3_reset_kcq()` retry with a pipe-level reset
  when queue-level recovery fails: it tracks the current mode
  (`reset_mode` at drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c:3563), flips
  it when `gfx_v9_4_3_reset_hw_pipe()` runs
  (drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c:3600), and now re-enters the
  reset logic if the KIQ queue remap or the final ring validation still
  fail while only a per-queue reset was attempted
  (drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c:3623 and :3631). This plugs
  the hole where the earlier pipe-reset support never triggered on those
  later failure points.
- Without this fallback, a KCQ reset that cannot revive the ring bubbles
  up as an error, sending the scheduler down the full GPU reset path in
  `amdgpu_job.c` (drivers/gpu/drm/amd/amdgpu/amdgpu_job.c:132-170); that
  is a user-visible functional failure. The new logic keeps recovery
  local to the ring, exactly as the original pipe-reset series intended.
- The change is confined to GC 9.4.3’s compute reset path, only
  exercises when recovery is already failing, and relies solely on the
  pipe-reset infrastructure that has shipped since v6.12 (e.g., commit
  ad17b124). Risk of regression is therefore minimal for stable trees
  carrying this IP block. Branches that lack the earlier pipe-reset
  support simply wouldn’t take this patch.

 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index 51babf5c78c86..f06bc94cf6e14 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -3562,6 +3562,7 @@ static int gfx_v9_4_3_reset_kcq(struct amdgpu_ring *ring,
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_kiq *kiq = &adev->gfx.kiq[ring->xcc_id];
 	struct amdgpu_ring *kiq_ring = &kiq->ring;
+	int reset_mode = AMDGPU_RESET_TYPE_PER_QUEUE;
 	unsigned long flags;
 	int r;
 
@@ -3599,6 +3600,7 @@ static int gfx_v9_4_3_reset_kcq(struct amdgpu_ring *ring,
 		if (!(adev->gfx.compute_supported_reset & AMDGPU_RESET_TYPE_PER_PIPE))
 			return -EOPNOTSUPP;
 		r = gfx_v9_4_3_reset_hw_pipe(ring);
+		reset_mode = AMDGPU_RESET_TYPE_PER_PIPE;
 		dev_info(adev->dev, "ring: %s pipe reset :%s\n", ring->name,
 				r ? "failed" : "successfully");
 		if (r)
@@ -3621,10 +3623,20 @@ static int gfx_v9_4_3_reset_kcq(struct amdgpu_ring *ring,
 	r = amdgpu_ring_test_ring(kiq_ring);
 	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r) {
+		if (reset_mode == AMDGPU_RESET_TYPE_PER_QUEUE)
+			goto pipe_reset;
+
 		dev_err(adev->dev, "fail to remap queue\n");
 		return r;
 	}
 
+	if (reset_mode == AMDGPU_RESET_TYPE_PER_QUEUE) {
+		r = amdgpu_ring_test_ring(ring);
+		if (r)
+			goto pipe_reset;
+	}
+
+
 	return amdgpu_ring_reset_helper_end(ring, timedout_fence);
 }
 
-- 
2.51.0

