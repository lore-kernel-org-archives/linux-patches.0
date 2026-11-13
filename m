Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590440;
	b=ZnvnWBPZC2jgXQvMSDjsYkqVm8Ui1C+JwcrTZGsXA59xP02r9TsxaglOte6LgzIuJk6B
	 H9xGXB/aqPnxCmDAFJFRq3MWabsqhWCnfv0EEeNHhiNRM95SAojaPPhSZ8HbLhR6KQqCV
	 5W5+Yq8AtQP3A9W3sMK3sqAPw+H5r02SHg03kFb7AZNVnIO/50jLE4yIYMDhqs0Zl/v5S
	 Ns4c4PjZGkxIPfaSHM/BxNBY/DzvCqVWWf1WpRVEObxewf1LckZqCGVYYp6F8qmroyKwQ
	 53Gtr6CBP1E44i8Bh4RLSyWvODX4ypQcKgKBqymnAgoBQPOU0+qmIx2oqYT5TiwQDzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4/j6btRXGJbPNndu7o8tsZ/tmmZg3/zImJaMWvWP54M=;
	b=3oAtVkUCytJQjtTy8j858dZ1LDIo1/HiGxqq1oMiCRiZChadhjfuqKAetlxH7YDPGpii
	 BVbCJG1+InHfGvmOGSAmzkorCiFiU3UzaA6+TstYsLizR0daM9pmtRNab3DKVurdnER7n
	 5xcaFflSI4W+3Zx730pQBIg4T9gwHMS5W3OQzku8WM4EqP+oIpd4vqLP4botfiRF6apYz
	 xXdNp4VOIwsiNkBtofI79K+QCwK0pRom6zRceg+Loh/yykksKr+RknA37IpP6+hS34n4s
	 gAP8UXf++jncoPbV+ciPCMd7m4XhwlsSZpgoZ9a4aocLAgAIcsQ7TPQKc3ojFfqWpaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yPz7MXhC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F33D60703D0;
	Fri, 13 Nov 2026 17:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yPz7MXhC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2B01F000C7;
	Fri, 13 Nov 2026 17:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590440;
	bh=4/j6btRXGJbPNndu7o8tsZ/tmmZg3/zImJaMWvWP54M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPz7MXhCeKcskiJDSEqcSNsPzx3CP6S51dZ7N7tbImOQRUDybYHAN1jEaf3HKNhqY
	 /+arL7x+8aZXWYrtS1d43EqVTIH4cnCivddgPAUPWOtKoIvN9DD5ajEnDUZhg6TS+o
	 CzTUcqQ0QOXbb0wj4GOA6CU+kGDVVYLxFVsiix7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 399/686] drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at
Date: Fri, 13 Nov 2026 10:48:52 -0500
Message-ID: <20261113153834.514716928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6e15b759ef135..87305df456239 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1091,7 +1091,7 @@ static int amdgpu_cs_patch_ibs(struct amdgpu_cs_parser *p,
 		if (r)
 			return r;
 
-		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE);
+		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE) + m->offset;
 
 		if (ring->funcs->parse_cs) {
 			memcpy(ib->ptr, kptr, ib->length_dw * 4);
-- 
2.53.0



