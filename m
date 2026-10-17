Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70903B19B9;
	Sat, 17 Oct 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259832; cv=none; b=pSnaRvUQ4e8XrI1QAJv7ZFou84sHVQu59xlh2ZU2Z4oGlMZVgH1qOeeP22S3RgsfxLbcfpG+YvFTeJ7zIl2PUYfbaskHMWhafCf51MklfiRQ+ZBc0U8/q0++Uni9QfaB5lN40aH3pcVeALO4bHWMKmCIxTS2mDOm16313s+8kfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259832; c=relaxed/simple;
	bh=a0b8NfSWbR0P3iQdadeleUq9qrk7TyjFIc0rNUPRhoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aY0WnwjvZJpf9FGWG4n2cGqln3EgHiJkq+AVi5v9ockpKSYs6f1ZVtbiyVzOPqrtV49cxuH4GA7aT91JXCyMYmSHGXFq01yItsmHJdMRR8hWkc+3SbIQ3qqadzYK/WzEzCrnt1YxOUuaDoTTl7pY3QbiO+7RhJBM4LCkNAcXESE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0PemfFt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0PemfFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247871F000C4;
	Sat, 17 Oct 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259831;
	bh=J1DFMnLRYz83cJrYeE1n3b/X6wAmnssDt7JROpF/vU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0PemfFtRF7BHUHokobaVYhtZniuiWT+Y9QGbZqhqpIoXIzW5GnvS+S9QnbbcRwDu
	 O5pW+1msaNwGMqJJ/1RO+JUGzD4H56mMc4Wp/+HwUzDKzsV5LjaoonxBLtguVvoub4
	 qevbobxXp3QIFGJcyWyVMh7JQBxIjcDMB8XWUonc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1345/1674] drm/amdgpu: force complete the KIQ ring fences on reset
Date: Sat, 17 Oct 2026 18:00:17 +0200
Message-ID: <20261017160505.681894946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit fd65d1742992361fc2201ecb4e43411e6e417fcb ]

Like the MES scheduler ring, the KIQ ring sets no_scheduler = true and uses a
polling fence, so it is skipped by the force-completion loop in
amdgpu_device_pre_asic_reset(). Its hw fence value lives in wb (GTT) memory and
survives a MODE1 reset while fence_drv.sync_seq keeps advancing, so after a
reset the first KIQ submission can poll forever on a seq that is never written
back.

Force complete the KIQ ring fences too so their hw fence is realigned to
sync_seq.

Cc: stable@vger.kernel.org
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 52eba24656c9d..473ff6b666e36 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4931,6 +4931,18 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 		amdgpu_fence_driver_force_completion(ring);
 	}
 
+	/*
+	 * KIQ rings are polling-fence/no_scheduler like MES, so realign their
+	 * fence too (one ring per XCC), otherwise the first post-reset KIQ
+	 * submission polls forever on a stale seq.
+	 */
+	for (i = 0; i < AMDGPU_MAX_GC_INSTANCES; i++) {
+		struct amdgpu_ring *kiq_ring = &adev->gfx.kiq[i].ring;
+
+		if (kiq_ring->fence_drv.initialized && kiq_ring->sched.ready)
+			amdgpu_fence_driver_force_completion(kiq_ring);
+	}
+
 	amdgpu_fence_driver_isr_toggle(adev, false);
 
 	if (job && job->vm)
-- 
2.53.0



