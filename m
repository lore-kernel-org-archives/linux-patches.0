Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591259;
	b=DqwmAmshpmIZEQLy3JUXKIeEBjJTHUH0u5n3oDTHBhb6HpAegECA7zj/1nXBT5U3f41G
	 S4mgYBhcq8jwg81Xo63isOYazPJSZlGMOWGObI9+7nVL3TQdRc1FUe8CWaZdeUQO13WV2
	 SK1EH63ZBT9/CRZiDn/58xG0URVrlLu/eElyQ/8ZdV48HVHE4M3XINjG/YLmB/qYO9BRU
	 VkzPwHhhIfRmAVnFrL8RWC+Pt1DJp3soveX9wtOF34pGWQZdicCo8pIWCLpjJtJ7JChNS
	 GQ57cjjPBtYb8oAK20P+f4D/BYzDMQRNUMCJbVljBMhipINztcRru8fp1HFDDfD/H/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SJYhmUrDh9Sxh/OqkKndqaa76pwVB/toffTyOMSDxZ0=;
	b=iiMbXq5ZEHu87mPkT8/+Ql19C3ITTcCmBPHm/ds9qTXWuVmGbHQeUZtfGaMKedOQKD0P
	 ADr370XqdwYrjaAle1JZujOxE936IvDpZz2cikFStNQZlMu78aIM0qZiAf/GocbgdEH7Q
	 KkM+MT1qiqjDvDPTaGUpgorgvbzr9yhH92FT3lAHfqa7ugGu271WU5+cPvpkfAj40psvD
	 vapMB2eCVhEsP9JwpeFREOfSsvTTo35Hg4l4Vk5M0yJxj2z15pOlFgEkuI6OE+79iHirk
	 dYBWZEqDv3RHNcSKqnXHSvmVZcYdf2Sw6wczdvdENHIVwnSCGogE+WVzD1tmQFWIRag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="laZw7/KT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BA56076F86;
	Fri, 13 Nov 2026 17:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=laZw7/KT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066711F000C4;
	Fri, 13 Nov 2026 17:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591259;
	bh=SJYhmUrDh9Sxh/OqkKndqaa76pwVB/toffTyOMSDxZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=laZw7/KTpkGoCRS1g21Pb6Z5qf6UgA4C41d9HLRBJMbn8z3uC+I/2Poa1DWVorIeV
	 7xHKytQsptT+J65Q6F+bT7eUcfS0KK1i55tzbDl5dUbxcNuF56uGSDXWBDXuxS7TEY
	 /v2x2RmvSRjMDQR+iSznWWhoCmYKGjd0+O+TXljA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/670] drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at
Date: Fri, 13 Nov 2026 10:48:25 -0500
Message-ID: <20261113153823.405859659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 528f0aeac36c6..c8e1d2251efcc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1086,7 +1086,7 @@ static int amdgpu_cs_patch_ibs(struct amdgpu_cs_parser *p,
 		if (r)
 			return r;
 
-		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE);
+		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE) + m->offset;
 
 		if (ring->funcs->parse_cs) {
 			memcpy(ib->ptr, kptr, ib->length_dw * 4);
-- 
2.53.0



