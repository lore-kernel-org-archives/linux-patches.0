Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046514;
	b=PYnm7iVD8zlvbIIYHxY/ec81gIeUiOuaab/IUza21mk1TMznK1VPR/fVjkGbrtAtmWOE
	 qv0XBcZLlQj7UKqonLYh0cqM94v7Qw51ArGN9VYe4k7b98FMpRht4i3FvlSzSH5oEunEN
	 3a+QnhaWyN20OohArNGfuLjA85401uT7LV4V5gxuAfJPVjkNV4gSzZT+DQBVK23qL14N6
	 9hPPQAFAtHyv+qYFwixmiVxdpUGpZbOkFyUg5tPm6pe5jUZNga77uHxtQkAjDcEJBdnes
	 0k7h/18Z43jEc1S0BzCbwtK0Hgxwf5LFVqJRs2YqanU9m4INOxRejXCHUfWQdKQo49Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zbOAU/F832iE/KNivGnre/HeRXIkCEwL+smzvGcM6vo=;
	b=YeMKRvovdhrpvYbdw/01a751KYdc0SCR/l4BNMu+ADEHs/ludEi0cwjW/d7QtLccg4L6
	 JFRO/+PtGRODdPxshCcFLlDIwDFfYbuokCU/YwURC1++n20Pw/G5mcovqubdBqEQ2H6p9
	 fffcdLFQ5IUXT1pK+BJSnoVhiwnfOj/eeDn4X7yvBNRa96m8x3ykeW4YsfqaxmeatxbdO
	 CTAoK7xK0SdCWyRTq5jqBOD6XVXP64flt5xOLB23J+5/eejyEwCvmnX0J9M3rzQDkQCID
	 joRrRKjtIrJOcF6ombJHu8xpT++YqA0EstxmWaJyAOKFCniZ9vo7jUk/DLVIyoua3xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G5ASqpuu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763B1606A325;
	Thu, 19 Nov 2026 00:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G5ASqpuu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80291F000C4;
	Thu, 19 Nov 2026 00:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046514;
	bh=zbOAU/F832iE/KNivGnre/HeRXIkCEwL+smzvGcM6vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5ASqpuuEj8orJJ/3iOqPNSYspUz9MYkOH2zoD05jgavUGnzN5KL+XSekedI2enxe
	 BUlP1OPpN6s9thyQu6knQIdSHhsbEcDeybvGBhs6UctRXbc+gAqPbXXKn2/JogXCw8
	 1hgOCUBfW5/4QyXAG+0S/4fqCP/h8UqYvBJy1ufo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1291/2857] drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at
Date: Wed, 18 Nov 2026 15:38:45 +0100
Message-ID: <20261118150247.974914318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index a9e046576f7ef..0a5fa026d595e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1071,7 +1071,7 @@ static int amdgpu_cs_patch_ibs(struct amdgpu_cs_parser *p,
 		if (r)
 			return r;
 
-		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE);
+		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE) + m->offset;
 
 		if (ring->funcs->parse_cs) {
 			memcpy(ib->ptr, kptr, ib->length_dw * 4);
-- 
2.53.0



