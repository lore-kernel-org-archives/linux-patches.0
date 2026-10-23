Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774944;
	b=bX7pfgtgf6ojygnUoBmkx8vH/4WVelodWTiWbDH/mjmnw2KmE8UXIXNzbtJb0odGSgE1
	 rA71gngb1amP24EgQXz4RNu8sXGnPb6Jr5VPSrBfOOZxedANLa6WxCKugfKW4JNmdQRTg
	 3pOzAoBqtMRdPtR3CHhCXVQuHoO4rBmeZCoxVpDvd0udWci1xw06TG3UT947Vz2YkNVTF
	 6Fl2fhxm98Ez7NiNeCx6kLbLRk5S+PtATsx7BBbqrrY24G5JUDm90S+DjNhyFC4aXT5AK
	 2wAvqfpXmaBFigoHkYVFX1cq+yjp1RjymuedIOQ4s/Wz0i0mSwW/5e8wSAQvLpCa5PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uNf/w3r1KVeuJz4Mmijj6Udghkbilrdice0PNH5G46E=;
	b=EMO+8936nOp6yEHzQzaSbIpA0JOuoOvbuzAp3VFDxWw97jjvB88+L2bv4Vng0mnwP7iL
	 jWmTqj6i+8W8mKcsgtCDnE6Ptu1S7ATsKI2VToinamiY689m3wQgm/PtCdY7k8lC9dt05
	 JA9Zc7EU7vm5fgsUIINtgOGy0GZa32eFiqi13sDhFT5Q3U25Fcd71AmLFzWkDMKBhcMGE
	 4mgot4D7XFHGLD6rB4JsKYLl7Z+jCqAXh0ZgxyhnpLqUPGKjP60Vqr03IdaqsSVmpZzVO
	 SfszpSSHXGG5rxSgtatsXouTXvJHOMZYj2u7pKaADmiGTntKfCPjCGwOilqcCl8P4Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=svyZj9ou;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95251606A31A;
	Fri, 23 Oct 2026 17:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=svyZj9ou
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4DA1F01825;
	Fri, 23 Oct 2026 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774944;
	bh=uNf/w3r1KVeuJz4Mmijj6Udghkbilrdice0PNH5G46E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svyZj9ousQFjrQMdDsyFoxmGNG465tZbVGSlK0fJH9aGOFGzNvx5QGn9BQVqJof6q
	 n0Zl1x/Li9iK73KT054fsEZdTnDzKguomfn3BldFObxg3h0fsR/okI6bgurHGa/ueS
	 2ll6eXtye9wMl0+ihWQD2YHpewtlCsJ7ZvvV6AkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	David Rosca <david.rosca@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 208/242] drm/amdgpu: Fix VCE 3 ring align_mask
Date: Fri, 23 Oct 2026 18:40:50 +0200
Message-ID: <20261023163718.714946135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

[ Upstream commit 2ee9836545e690c9e66ec203445d7705959fd7a8 ]

The largest frame is 20 dwords, so 0xf mask is too small.
This was always wrong, but we were lucky with the VCE_CMD_END
commands inserted after fence and vm_flush.

Fixes: 8897ea8c761b ("drm/amdgpu: Implement insert_end for VCE 3")
Cc: stable@vger.kernel.org
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: David Rosca <david.rosca@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
index a3eae7d4b57ed..0bceedadfa3fd 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -960,7 +960,7 @@ static const struct amdgpu_ring_funcs vce_v3_0_ring_phys_funcs = {
 
 static const struct amdgpu_ring_funcs vce_v3_0_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCE,
-	.align_mask = 0xf,
+	.align_mask = 0x1f,
 	.nop = VCE_CMD_NO_OP,
 	.support_64bit_ptrs = false,
 	.no_user_fence = true,
-- 
2.53.0



