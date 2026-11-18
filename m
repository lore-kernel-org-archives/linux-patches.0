Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054555;
	b=IeXAAP8cVKHN2JzGfYIbWEnN9mAJK/pzzGKbkyy+xPX690wIBjpB0ppQkbK4G26RDhLc
	 UCO953hZN18HuRewPM+pMkVoW2B89QztbLKWOIoDWPBng3Dr3HdI5Vc4TCXNzJroWUdly
	 HgLwwEnIlvUTcjoXQPf++JEimNW/jlMsDKo5TDOAl9Omfgvix8xk6bNe6H0p79zSHidF0
	 iLTc0drT0x5ojVuykkBuu5bDmoL7C/SxULC2l6w9mrIBP/2loetphJb6BGlbZmMcSRLVT
	 RqlNbaV9XkHCQREKQxDmosdm20KN09k2s3yLL/YY50BAfNCNAeYGMkm7+zDYgli293g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C+Q3wzZLA/b0Vbi9VvPyw5opX402srWyvjpaBQw2NmE=;
	b=OqI8qdQEMdJODIJ3VjYjS34NINEtTiMOeMlqo7euVtHFYX43IIuvl9+yiWNfNZ6G7OmI
	 Q99XpQ6cQ93gaFGltgVGTqNi+/SXS8Z/FXwqh2MwG3jSzbVM31n0a5Zf3hp3wauMj8DxV
	 uVzQtPO+W268Kmz+Y/LMclR2qa/di3A/SKmVPrFZg8DMCIuFGLlKN0+dxukzs5V5ZXAd3
	 gMw6oL3rPnoafB0RmchYyXs6K9jAUMXJuGacI2tnL3UI3mDSDWLLdMzASdjhxyomfB/pA
	 uYp026marCaQUhn0yTYNHaZJRU+5BnDfTkTxxsP4rj799crebOgVD77vlesvw+xdf4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRUKAkNn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DA2606A320;
	Thu, 19 Nov 2026 02:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRUKAkNn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C0C1F000C5;
	Thu, 19 Nov 2026 02:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054555;
	bh=C+Q3wzZLA/b0Vbi9VvPyw5opX402srWyvjpaBQw2NmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRUKAkNnRk3+g4tf8Ss7wq9ry4QxhEnUrvMMItZrOm2KC9l5q6MNh4BJegdiH8Ztg
	 crPozH9EuIXZzOsgQVN8InVA5qWNuhg/ucdpkywTIFGy1mA4mbHj2jv/lLesPTA2Po
	 h+dzvPiNS3iUpa0W18r+6EvBzSuFt76TVi30MoE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1316/2214] drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at
Date: Wed, 18 Nov 2026 15:49:52 +0100
Message-ID: <20261118150104.125886631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
[ sashal: Adapted amdgpu_cs_patch_ibs() changes to amdgpu_cs_vm_handling() using the existing offset variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index f2050d657dcd5..a87dbd3173d6a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -773,7 +773,7 @@ static int amdgpu_cs_vm_handling(struct amdgpu_cs_parser *p)
 			}
 
 			offset = m->start * AMDGPU_GPU_PAGE_SIZE;
-			kptr += va_start - offset;
+			kptr += va_start - offset + m->offset;
 
 			if (ring->funcs->parse_cs) {
 				memcpy(ib->ptr, kptr, chunk_ib->ib_bytes);
-- 
2.53.0



