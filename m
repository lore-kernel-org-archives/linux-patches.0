Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB1C39768F;
	Tue, 13 Oct 2026 12:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893981; cv=none; b=UQalesGgskk3ntdrfBXV19NApH9Ut7HDf6rNhd4sz0LDejutIkmhHskEU5t0ZyIoviFjJWWn2R/oabM9vxLV1ahgnbRxZFjrwNbg43+32JOf48iYevHBCWKpF74I6ugm2GoE69eW9UMyZYViWZ521sYXZMmsVmY4U9gg0Nb2MWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893981; c=relaxed/simple;
	bh=iNBrhsM4TIOAIij6wBDXaxLdz0A0dlayIyJdo4USbbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irgTdex4R5B9trcrGCMComZfNlWklSaIT9lllQ1yVcw6lcHD2ZyfJgzqPdCmErdLqvxH0o/AOczbQkoBZvBIMRYSs9P+NBzcMRcVKM9Hnw46M5sbu5bmhKL6GZhR+VpRQ1GMalExL5q/OcloAf+NPixXZoht8m7AhR1n5vPtubI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmOVwVtW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmOVwVtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B5F1F000FF;
	Tue, 13 Oct 2026 12:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893980;
	bh=gu6SHJFwYer93kDf9Eq34bciMskh5JJZWCn4PwatL88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zmOVwVtWhaI9vx3XbYjo9veHZ8ubYCMnq+P5vmSExKW4fzv2PEkd3mi1QTi4ZQZcg
	 HmamgqZ0NgMiFLJTycVbVbcmAY6mwXNAcZa1QhrFPqjLK6Auf2mshDBOSAERl1nhJA
	 fx7QsGAKDozdcdnGpM6UdWrFV9sJAsvexP/tvhTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/621] drm/amdgpu: force complete the KIQ ring fences on reset
Date: Tue, 13 Oct 2026 13:36:25 +0200
Message-ID: <20261013112930.098287896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index ccb14ca65c497..88dda7dd2cd1c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5933,6 +5933,18 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 			amdgpu_fence_driver_force_completion(mes_ring, fence);
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
+			amdgpu_fence_driver_force_completion(kiq_ring, fence);
+	}
+
 	amdgpu_fence_driver_isr_toggle(adev, false);
 
 	if (job && job->vm)
-- 
2.53.0



