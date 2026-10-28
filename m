Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209045;
	b=gGkOULMx6Nz0neardRU8bbW97LGNOcWjTWaZbnIupQpq8ro+fR0RIXvBxK71dwwrxNP0
	 vJ268yapP0x85HGlzXGUY2sbANlZ1GlU0NDP+t5yJ+4jMYuiL0YXx86znlRE1tRtm5YFZ
	 +JrUMKLmYC+3hQM8LZk1SFNZVvJP/ZEel7HiBwGbQm6ZSiMF/Pi8J9yNPUc8TjZ1/JyKB
	 i7qe09pDW4Cjz3+K4GglyyGKzsOoML3h3RZ3xw+iFiL4Uc6FEyXJa19BpLqd5HFg2cYXE
	 5uVFv8LS/0ltt8YMe9RrRjfyTC1dLK9KOnDVba0GFTKVdq0XNJ7JgDY3jlRAhd3ohKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qu2+pNeIxsADi79K+CqqOqNO9OtXVsQ2qZPsBWesk3k=;
	b=nVPOY+PYSjqPuGBUrT/XytcFmBUqPsvyMy6vM/S52fZp5O9fCMjkHffMn6XaDPDEGTQu
	 VeHaX5u6Zf53r5Ydc/ZXIWiK1C2UHy/YdcG3vIC9YXrKg72rhGCoR/0DtSZs+cOxmHVw5
	 EZehNzz1Iz6EOksBTbpQAyfY3ccgi26CUPq6KDnMAwHQAhqEHFT8nRpFJYFFyRxLatLH2
	 AMi52V0zbZMXG4woV9yG0jZngjBS4BNI8yGHNRcHi38MehgvB3YyO6QRx72gMOnMpblK1
	 67AvVinKfqxGu0JC6eM2P0cBKnhuHvHK49YwnlNLwH+g3MOPwDy1S6gW8Y8ElI32HuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZ0GoGgO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D38606A339;
	Wed, 28 Oct 2026 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZ0GoGgO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5131F031F4;
	Wed, 28 Oct 2026 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209045;
	bh=Qu2+pNeIxsADi79K+CqqOqNO9OtXVsQ2qZPsBWesk3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZ0GoGgOFSm93xv4AQdMB1AYI8Ii2zcq4BrOUrjbOFFW3z7uix7M4ZKNFxshsh+/f
	 v/v+fzEY3Zriwi0PijpFPKznVABW986yQdt8dD/i+yoR6BAepHs3MaM3LO13ktogWf
	 u+HZiXC1TSEQGRYL20xJH3UK9wQI2naCrjxoaB6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willian Oliveira <williandossantosdeoliveira287@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 280/516] drm/amdgpu/gfx6: fix firmware leak on teardown
Date: Wed, 28 Oct 2026 17:57:12 +0100
Message-ID: <20261028170010.124161250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willian Oliveira <williandossantosdeoliveira287@gmail.com>

[ Upstream commit cc172e177795c5f87bc2d71768d077e1c10633e8 ]

The firmware requested in gfx_v6_0_init_microcode() is not released
when the GFX block is torn down, leaking the firmware resources.

Add gfx_v6_0_free_microcode() and call it from gfx_v6_0_sw_fini()
to release the PFP, ME, CE and RLC firmware.

Signed-off-by: Willian Oliveira <williandossantosdeoliveira287@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 386e81346f95ab0be5a82c5535de932e7a456924)
Cc: stable@vger.kernel.org
[ sashal: Replaced unavailable amdgpu_ucode_release() calls with inline release_firmware() calls and NULL assignments. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index 37592cc9f2c50..c0e513f5b6220 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -3219,6 +3219,15 @@ static int gfx_v6_0_sw_fini(void *handle)
 
 	amdgpu_gfx_rlc_fini(adev);
 
+	release_firmware(adev->gfx.pfp_fw);
+	adev->gfx.pfp_fw = NULL;
+	release_firmware(adev->gfx.me_fw);
+	adev->gfx.me_fw = NULL;
+	release_firmware(adev->gfx.ce_fw);
+	adev->gfx.ce_fw = NULL;
+	release_firmware(adev->gfx.rlc_fw);
+	adev->gfx.rlc_fw = NULL;
+
 	return 0;
 }
 
-- 
2.53.0



