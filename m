Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216222;
	b=sSlSVMRrivzLNB3er4byzZRFKN9p89ZvSbb7uGgQ33uTroW+3lPN/KfCleovzgMLPgwo
	 KWV3zdvBkRiRLcZqUKHCKuuJsxDQkLFQGxb9SEYF0kpfzfCPbeBGLWtpysJCrnvRW0HOn
	 +m33QrwNylqOExj7SWf2+kuEPmQW2zY+QglPE2obu702fKYBHL9t8/AbGAU7feNhhplgw
	 ukztOxmFO/JiJb2yx4TfOSbSAmvOv/1WagfRIykCAT3FckV46htijMJlz5awZb87qAqtm
	 YtuIKZVKwabgDfyt2YHQLSWgtQ3TdY7LGiggvd51B/LzB9aE4AZF7mKtJl9KBrXEP7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h8g6uXKnZziSlwBrg0xVkJjRniwb5/s+K5oY3G4y9Pk=;
	b=vxKSK4Bkk49EzHemoeN1HxabKWZQnrg/F647J9bKlaPoIkC1ee22tY+ULY/NhzurnVJo
	 xxHIgEmrUzXaGv47VWDxeqWWUlYftgBD3BJ4d35gszMpqxOhtAGOwSMG9Wj1SZg8Hg4TO
	 tikyQysmFmFXdFYYn8a/x0qA5vIuxI/AnM5vTZK4NkcOusmXu4f/vhapGB184RK4r672u
	 VZALvNld1dJNgLDfFvZXgj7ZX+iuUO/srQjtdhsyu/OEllexsZA1O7djqAVPVmHgzXOUE
	 N7kXZK4zIZNZc8mAl6BOobZK0EXI3zOOBLHnoeQjMDH7QbZy+yjFAn3v0YwRY59txDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezJvK6ep;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981E3606A32A;
	Wed, 28 Oct 2026 19:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezJvK6ep
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FAD1F031E4;
	Wed, 28 Oct 2026 19:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216222;
	bh=h8g6uXKnZziSlwBrg0xVkJjRniwb5/s+K5oY3G4y9Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezJvK6epsF0BWDVv3L+nHGBo/R2/r1cN07EDAjVoXVi9bdPRDK5SaKGEbuwuZk06M
	 ms/6KTKMPrrUlkRXWjL7Wd120yWl2ad8G17cDo3u2fLZ0mXYpg54n70VFQq9wvjjz5
	 Z72fGVNKtCuixUGn7dYV7G7/BlneJrQ1M/9bd+uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1483/1887] drm/amdgpu: force complete the KIQ ring fences on reset
Date: Wed, 28 Oct 2026 17:59:39 +0100
Message-ID: <20261028170533.199254712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index fda32238cc6b3..87599141e9037 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4956,6 +4956,14 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 		amdgpu_fence_driver_force_completion(ring);
 	}
 
+	/*
+	 * KIQ rings are polling-fence/no_scheduler like MES, so realign their
+	 * fence too (one ring per XCC), otherwise the first post-reset KIQ
+	 * submission polls forever on a stale seq.
+	 */
+	if (adev->gfx.kiq.ring.fence_drv.initialized && adev->gfx.kiq.ring.sched.ready)
+		amdgpu_fence_driver_force_completion(&adev->gfx.kiq.ring);
+
 	amdgpu_fence_driver_isr_toggle(adev, false);
 
 	if (job && job->vm)
-- 
2.53.0



