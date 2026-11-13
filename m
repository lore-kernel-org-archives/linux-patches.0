Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585755;
	b=wl9007IvrF2DdNttcyCBq0R8SQG9IkDrtXXFNuCNxzd2bVc0/Z8oz7fizSGs6dNoVNo2
	 KL2spyMhIEOCv0AwLiH+7iL+qy2scuDUcENFh7zt3TxLkYdbPtL6XjdlKkY08Ni+wJoYy
	 Aai6PLXvRaIYh2OkHiluMDxg1m+ELo7/EmJ6DHe+vyxifA9gzsRLVLVRK3SEMG1acpW5n
	 hMW9ps2RIuxV8xb5pLu8DZW8vCWcc1VqNuG9RR5ktpypnoUXXQdnp/662SKcfnZ5WIUeR
	 3Td+Sf8yu9BdUgZ8N40+5tFUTKTKiJPNfj2Kf9i8R2bAZ5lqg3GNM9fojDtvpbaNCvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4yI/f8xy2pFpL1ihJ7nvJDJ8GErhAZJKAM5m/RNSrVs=;
	b=o+xuFPMpPFxHrKPHsFYWfoqrEzKKWnnz1RLkqOYYCPoUjxPq5vjCTPMmME4sC3N+KDCX
	 M98bvSoZ9/VXfQTcj3mNKLZ0Aqu9Su8VpVaW8BwrgE8DfhXBI/en99pq1O6TWLveBvINT
	 ncJvHTvYV2dxe3HMAM3VTf+OgGFTWNkEV1RuT1TTcsQtcxMjg62jjpMW0OTimrscvT1Ls
	 SCDkGATvEMRSPDvnNLM+b+/6vPyfxIB9DP3Z7zb4wJUd7B/VT6SHe6cCsm4NoqzwMwoaY
	 dywHoKRzYksAbIoFgVP2bmAEDU6g0iaMU1luqINtOOTcH1s/cXHFdlZUkEExMrRsw2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Je9eNW6b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FB6606AE33;
	Fri, 13 Nov 2026 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Je9eNW6b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4291F000C5;
	Fri, 13 Nov 2026 16:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585755;
	bh=4yI/f8xy2pFpL1ihJ7nvJDJ8GErhAZJKAM5m/RNSrVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Je9eNW6bN9FnyWpXQZIWaEzkTcLMrtcbpVx5E3Pw8dO7GMhH8ldoLpIHX2UHNcsNp
	 dQr0Y50yZMwNW7DxgTdDatikuawSd+YodeRV12Dmzbi6mggdPebiiWt2LkKsnrLNKH
	 15amYlQE4r8scXnvvSr6tAXwVzw1U9eIDSrc2ihk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 350/507] drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at
Date: Fri, 13 Nov 2026 10:50:54 -0500
Message-ID: <20261113153807.292045464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 63a59637517682a920f86da1a189a3e639dd4fb3 ]

For rings which parse or patch the IBs on the CPU, like JPEG and VCN,
the CS looks the IB up through its VA mapping and maps the BO, but
ignores the offset in the BO the mapping starts at. It then parses
other data than the GPU executes. On navi31, an IB of JPEG NOPs in the
second page of a BO, mapped with offset_in_bo 4096, is parsed from the
zeros in the first page and rejected:

  amdgpu 0000:03:00.0: Invalid packet [0x00000000]!

while the same IB submitted through a mapping of the whole BO works.

Add the mapping offset when locating the IB in the BO.

Fixes: 4802ce117786 ("drm/amdgpu: fix UVD/VCE VM emulation")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 74ba1d87d67d0a38d8248928241c3e1c73d0d53b)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 40c71332d9746..bb039ed938939 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1074,7 +1074,7 @@ static int amdgpu_cs_patch_ibs(struct amdgpu_cs_parser *p,
 		if (r)
 			return r;
 
-		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE);
+		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE) + m->offset;
 
 		if (ring->funcs->parse_cs) {
 			memcpy(ib->ptr, kptr, ib->length_dw * 4);
-- 
2.53.0



