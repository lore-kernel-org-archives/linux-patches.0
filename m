Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47E818952F;
	Tue, 30 Jul 2024 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355809; cv=none; b=Y12dphXJGDjM3V1+16CDTmYQn9WQMNC2sb9tyNwpZfmJrszgTexOkqqvVkC5IVXz8REQMBg1D0HHINC7jt9nXfoaCeVMtHngzL76dhO+ioysucMu0jroCnSQua/tNmhmGNZ21Al2ngDVzWOyPSBFkkDtd+j3cHbGoNU+ST97npI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355809; c=relaxed/simple;
	bh=08zS3mtTfmb3jYX7BYgkaayCv+xluqfjPIYi8L582iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VvHHhgmo5HXNwPMvTXABO4SA1Gxvhs7ON+QySeHZJiYC4wNGi1a+hZX4qB0cyVFN07jYvJOQXmYdtZzk9oulb/sXq3Uev5NQyrweXE7e+iL5GAMPdeAm8QezJssvOgqkK/lwWuxVzkPXaJ9QNNTYYJ/jBlT2vJfQ/5PiMIpzh+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEYu0Uex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEYu0Uex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452BAC32782;
	Tue, 30 Jul 2024 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355809;
	bh=08zS3mtTfmb3jYX7BYgkaayCv+xluqfjPIYi8L582iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEYu0UexY01w18eYQFQiyzoDuLmkba1t64pkajxHIYOINH3d7aSgZpIVTrk/HhM2F
	 RRQyo2/DG1HAqT4OgkToG/qPj3rHBImpjNzLunB9Q+4RPGPjKMzo9Igta8Kit07abr
	 iBUoQ9Y//OjdjHK5RbRnTzMAbiASZEuEnoVhUZ/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/440] drm/amdgpu: Check if NBIO funcs are NULL in amdgpu_device_baco_exit
Date: Tue, 30 Jul 2024 17:46:05 +0200
Message-ID: <20240730151621.038726681@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Friedrich Vock <friedrich.vock@gmx.de>

[ Upstream commit 0cdb3f9740844b9d95ca413e3fcff11f81223ecf ]

The special case for VM passthrough doesn't check adev->nbio.funcs
before dereferencing it. If GPUs that don't have an NBIO block are
passed through, this leads to a NULL pointer dereference on startup.

Signed-off-by: Friedrich Vock <friedrich.vock@gmx.de>
Fixes: 1bece222eabe ("drm/amdgpu: Clear doorbell interrupt status for Sienna Cichlid")
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 157441dd07041..d4faa489bd5fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5815,7 +5815,7 @@ int amdgpu_device_baco_exit(struct drm_device *dev)
 	    adev->nbio.funcs->enable_doorbell_interrupt)
 		adev->nbio.funcs->enable_doorbell_interrupt(adev, true);
 
-	if (amdgpu_passthrough(adev) &&
+	if (amdgpu_passthrough(adev) && adev->nbio.funcs &&
 	    adev->nbio.funcs->clear_doorbell_interrupt)
 		adev->nbio.funcs->clear_doorbell_interrupt(adev);
 
-- 
2.43.0



