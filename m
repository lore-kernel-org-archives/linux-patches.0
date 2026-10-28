Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211847;
	b=feEqDomVlAvt2/60IcSRF1yp6eqSvzmkGcjZgNvMPSPiEM00LniZwvQqcQeO1JDv2Y0Q
	 fgv6K67SJxuDRIMPgBJZ5ba4hgmlVtRQ/fmKKoyngQoT+FOD6TD/1dkLKd5vJDmrkLYEO
	 HvMN66G4qhosLXnk8RAynXdmsfWEXy5Bu3gR80nTLGDbhE9VwqgbRxhFhG29riei0cA5/
	 KmJVb8gHzMmOKXSVJ3pbcsgxfDtgYyZa/weSXD77NjlUIcY51gSYFiLIOA7mTt51tyDY2
	 Ngo8OYzQEtrMUuEuaHuZQWOnii1zQHHZzL4qhx1dbGQ0As8iQD0ke8zzaagtwP/XyIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4XTt/mxi5XP94v5k1i7B6DTZtZrrh1neCaDzmF0i3PE=;
	b=VKPoVzIp+aBPTVMeLwLuUbuCbT5zfE6RxDsCbz8PapLCjylnMki3A+xzc5Zc3S6M6khD
	 +MHf9ceKd1hHHoygyo0ZMy/027tb6D2KtuZNBmTZjL0vrmI85y1fWJ2pX0LGJ5b/a9Poe
	 CecCCUrL7kdsoZGIuk9BqtMWW0B+kCUfcGvwoCp7EeqnmZy3F81CZal92//fyKKyNDhs2
	 s5DGLspzHL4A4TCG/CNpu73ChboMPwlPWMCh2PMRL16cLjzaJgsU6O18xBUJP6DlDFvoi
	 lXrLqeNprRTglF6H2zEI38Ld6shHuIds62AXdyalzNQJasMVkngEukU4hfAtpP+3lfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jA3xcgkC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42D7606A31D;
	Wed, 28 Oct 2026 18:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jA3xcgkC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAA51F01825;
	Wed, 28 Oct 2026 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211846;
	bh=4XTt/mxi5XP94v5k1i7B6DTZtZrrh1neCaDzmF0i3PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jA3xcgkCQVcwMVzns1wYUAnPfbsm2NEaGZdlIEfyiwAjMrmVxpqho/k+mTRZVE8Wr
	 QZqtFmW6fef+QjkdMeNvOAi3MaI9f24GNkiFWe6MWIr2Q5jQUs9jiK9kinOcJ/dHIy
	 pIUVmLCCMIKivzghfViWAdShaJqQ+uuTktyOvR+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	David Rosca <david.rosca@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 522/571] drm/amdgpu: Fix VCE 3 ring align_mask
Date: Wed, 28 Oct 2026 18:01:09 +0100
Message-ID: <20261028170020.417725840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 96e13896ad1ba..6095ddf1d7b79 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -957,7 +957,7 @@ static const struct amdgpu_ring_funcs vce_v3_0_ring_phys_funcs = {
 
 static const struct amdgpu_ring_funcs vce_v3_0_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCE,
-	.align_mask = 0xf,
+	.align_mask = 0x1f,
 	.nop = VCE_CMD_NO_OP,
 	.support_64bit_ptrs = false,
 	.no_user_fence = true,
-- 
2.53.0



