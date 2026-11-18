Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037808;
	b=3AY+Sb9/ojAv/Pf0iwlvQkIuDTbgCFDCHhuuBhfCCCy/RDzI3Uz5021idiBT4dX/nyld
	 RrXRiZ6ttdcsJz/S8bF01vr6MJahtSueE/9Q4YXuy9Gpw0ColVxvc8B2tF45jMFA2atFJ
	 6L66eou/ky28rk8SPexp+J4WukhGmHzoB8aOAQi3scW0qrGR9sNX15R5rhAYBS++ms4vv
	 fyvGP2VDes+uOWS/rziDtGUJIjjUCiE2u1GcNbS/ACtIfzZkR3umajfFfAImzqCn3QfDl
	 Sz86NunXWQNWk9h208U6YEGQlbRgQaD3cmfPy9AhmYTjvbQVe5iqS8fms3+7E/vfUPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V0ZHzhct95hj3hQlxZyjVTbygHNSywWH8U+BkyPgqdk=;
	b=ZdZNyac2nXZ5IOCoHaTZU96qC5+bsaU4PxYkpKqfHUXpN7Tq12Hnk1Ck9tkz7nOSs82T
	 Yiv0tUeR5FOZk+smtq2BhzZFD+4eq6E4lh/edhZPBlxzioq6a0wceshwoOul6DZDozpyi
	 6N36/aL3pABPzTo9aodzoRPpV9JuWQqCvwTp6BnoiF97xU2KAcyxpuqXr52q03HnjfCgC
	 uL6OWv3lt23kgi061rn20bikj0+e5ay/Hd+WRS6S7Vghl2ys7E0iOTOmQtSKA0CPY3q+u
	 Lvxb/idFISevyoqgTJxvCh3ac7Co3LD78nIljaCBflwjOTlEMLow3/ZsN+5baV3gSgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tG2d1djb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795CC606A31C;
	Wed, 18 Nov 2026 21:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tG2d1djb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09A61F000C7;
	Wed, 18 Nov 2026 21:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037808;
	bh=V0ZHzhct95hj3hQlxZyjVTbygHNSywWH8U+BkyPgqdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tG2d1djbYp63HsR4LNkVg5hUzXRnTnHIIYMPB2NXEL+PirQX0jru0XvBMaYK+eAqw
	 +0Oe6CTt5EVLuzzsvoO3mZJIYcVx53zDqcYHOfolNntTxLys1luAMA5O5Cc+6u5TaU
	 q23rX6Uw1qPqiHj7+RVbAWkHKOFbIDsYlflzywHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1526/3318] drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at
Date: Wed, 18 Nov 2026 15:35:48 +0100
Message-ID: <20261118150406.744906140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6709041c4b94a..3150b9d064235 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1084,7 +1084,7 @@ static int amdgpu_cs_patch_ibs(struct amdgpu_cs_parser *p,
 		if (r)
 			return r;
 
-		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE);
+		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE) + m->offset;
 
 		if (ring->funcs->parse_cs) {
 			memcpy(ib->ptr, kptr, ib->length_dw * 4);
-- 
2.53.0



