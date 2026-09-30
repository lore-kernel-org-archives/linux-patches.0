Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4216327BEC;
	Wed, 30 Sep 2026 18:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794524; cv=none; b=VGvslScJKCc8k6O2PnBNA7HqowsVfOy+Y6tmEFGHje0hP2Ndbn4OjCl+OEz8uc42jYfXVYvwhn8Qxyv54EfvBGgIajoaEjaXLjiX4Y93uB6bXDL5eCcRVXbCe8/VtNLuey+mr6xW8guHcouYMkkB8i+GeN6Az1YHemv8eFL2Iyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794524; c=relaxed/simple;
	bh=WjHfxgT1VK6s0Kklj3wUJV0MpkU9ccGx54g60ixGi64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=se2M3imfkCt0Go3s+WJto211V4QDbu4rECYZXRFOPgRwfw5ls4/SEVWJkhJBGA0yIXxW7++PbpVDRX5I7A+tpfq2iCcuNH77s+RBGsB9DaHj08pwBzFhIgVhn/zbn9Qx4vwoTVvHFGW5pnzK5ZOmdz08t1NGB9fjckuHEupr/ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEXdjRrc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEXdjRrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A751F000FF;
	Wed, 30 Sep 2026 18:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794523;
	bh=WVpIE+flzfoyM+R7tEQFHc3foh54u+QL6yw4rt1TvJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bEXdjRrcVZn3VqbS+LYw1dCRM/TjWhZ+PE14zSxL2mgnFvPKwP9XxbEocr0Gq8dpM
	 dJSayi0gKOmlcrM1H66z4uzJIQazTKAMP6/HmPiPBwSTNFFJbp3Vnr+xlCb2ucKcGe
	 AWSO0u0Rll+EQwvOsKZdm9K2xAX4Q9HsYJwkUAKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0242/1193] drm/amdgpu: Use system unbound workqueue for soft IH ring
Date: Wed, 30 Sep 2026 17:15:26 +0200
Message-ID: <20260930152439.569700024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 79b053dc17334..8805d9338bf6b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -500,7 +500,7 @@ void amdgpu_irq_delegate(struct amdgpu_device *adev,
 			 unsigned int num_dw)
 {
 	amdgpu_ih_ring_write(adev, &adev->irq.ih_soft, entry->iv_entry, num_dw);
-	schedule_work(&adev->irq.ih_soft_work);
+	queue_work(system_unbound_wq, &adev->irq.ih_soft_work);
 }
 
 /**
-- 
2.53.0



