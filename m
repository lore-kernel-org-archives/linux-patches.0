Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760493AEF2D;
	Thu, 17 Sep 2026 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668271; cv=none; b=jJJbcgqxF5BsJ0rJCEn4Gk6fEz0ttJGdRUWCnDRUbGOKZY1hHjmQKsxtQUDSI7SvO9Gs8ZxNygc6XtJ1WlsFPHGcseW0Or4Vy/J48gj0ew3REA3Oi/VmSDmOp7K9J36zAB/Kq8UZaWtRZ2FuEs2FurH/ls+4r7+XnklyinGLYaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668271; c=relaxed/simple;
	bh=Im96O+z4wqkJ5Fa/BcMRQQsdS98CJ12DKgxi00RI/1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pUoU5awI7sEL1eEX0W9Y5s2LDL3rb9GJInWEV9NTuzEd5/ElOgXyhw5H3SQefjzIQLyq6/HsqoFeIMUhq7INW5F4llEUvT50YcBQRsHtlKUhxSHW8jcK/CiCCEImgKiXZ9IxV+PMX8+sf7pKG6SOo5/rE5qdUpGHrprIjsam6uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryCaTgFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryCaTgFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C821F000FF;
	Thu, 17 Sep 2026 18:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668270;
	bh=xGBVLDrp9j5lJaIlL2w55fo0xzp85Kgqo+0pPSrB/Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ryCaTgFL6XR0SiBABHoDhuE//YSN3fcUF/FIyhkMylLXeRR6HaVMs7kOs+oMg8yet
	 +y5dsaB+uM/Toa1aO8fXetu7Svy2zR6uDu1ofFDAyloO62FWsafRMcK7XVPVnGLfia
	 6otoIN3cBn2Qcy36S8w2QqU1/+oUZYTAAxC/ppk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0331/1102] drm/amdgpu: Use system unbound workqueue for soft IH ring
Date: Thu, 17 Sep 2026 16:04:34 +0100
Message-ID: <20260917151547.942648480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit ba2977dcce72127986fbad76c4c67f134e2f69ae ]

Allow the kernel to dispatch the soft IH work on other CPUs.

Otherwise it can happen that the soft IH ring fills up
before it actually starts processing anything, which
can easily happen with retry page faults, in which case
the CP repeatedly spams the CPU with a lot of interrupts.

This significantly improves retry page fault handling on
GPUs that don't have the filter CAM and must rely on
software based filtering.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3cdff3c8b93c2834977224d9c2b201fc334dd184)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index b718cc4fbfd40..01349429291b9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -508,7 +508,7 @@ void amdgpu_irq_delegate(struct amdgpu_device *adev,
 			 unsigned int num_dw)
 {
 	amdgpu_ih_ring_write(adev, &adev->irq.ih_soft, entry->iv_entry, num_dw);
-	schedule_work(&adev->irq.ih_soft_work);
+	queue_work(system_unbound_wq, &adev->irq.ih_soft_work);
 }
 
 /**
-- 
2.53.0



