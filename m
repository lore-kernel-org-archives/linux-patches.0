Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207722;
	b=TuIA9ilJYB0VnQIzvuaqRAViWPA4WnRsAy5dyUO5kwYOmvMLXHkjwPdJdCR4C0Tj/FGz
	 S4Lc7TUlMjV3B9nDgx2FVtZjQtz3hjOMmd1cNIMqeAq+FlxKW3biOnEQqBODm67zCIewm
	 ODSbmYDfHdixSCEnf3XTB6jdbWt+3SQ/zmsB39mJerTACbV+ONpxhqci5RcqoN6t8r/7j
	 QkBeuAZyUwQH/igdFEY0JsdvX3VmYqZEaOEjbnpstkY6JkHvd577kwm69/EYejco4EInW
	 QohP6ABnPts747IqZF4xt/XgoOiETImHRDrHFJEtF+JM2vMuiI1wciJRmad3cT7sUow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o753nF6aMzGI1LnOYIwyQ7OZh3xaulhQ060Tz0Y4BmQ=;
	b=PLgi5D/UBkC/nNVzk5U0uMKY31dfwPQht1DwkDu1nqmb39T2Fbn4hYOwVaNiwxC/dRWU
	 1Ac2/uqDWUsBwhoq28gtsFBZZaW1a56URYkulxd2JSmfGQotlch1zNEgCeJP1xFPJ9wNj
	 dKse2IF+zNdE4xxmVl49mmAFh9a6+EGGZQITsW2qjQqH3ylOgGiP1gmGbIFmnAaq9tArD
	 JVJPQwKUknx07yPr0rxRbyLImFr3NsMeXHkEuLwP54o6QAG1CijyNM5vzAmcK4LXee7Ie
	 DOlya2DAt/OKv8rZuwN84iw+yKShFZgcX9zh8LglPErkNTPGGrLezhns84QlUs64LwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qs9h9obS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4913606A32A;
	Wed, 28 Oct 2026 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qs9h9obS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B651F031E5;
	Wed, 28 Oct 2026 17:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207721;
	bh=o753nF6aMzGI1LnOYIwyQ7OZh3xaulhQ060Tz0Y4BmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qs9h9obSzqH2CJ3q4Rldrsx6K9Z0ogYjrCD8D3uJkH4FtzADixmuhuAR6Z8O2P9Az
	 Vc6ogu8UYHYWTEZTD57N9+vmwooGkTStMbg4QFlU043DkdiXkLN6NFfz1WaltLiFw2
	 wKHfvOh/wETWPe9iIcNHdbzDcUQHCAH+g/J2s/Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	David Rosca <david.rosca@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/247] drm/amdgpu: Fix VCE 3 ring align_mask
Date: Wed, 28 Oct 2026 17:58:38 +0100
Message-ID: <20261028165950.123261768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
index ff0b7438ac76f..4c7f6c2e1adee 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -959,7 +959,7 @@ static const struct amdgpu_ring_funcs vce_v3_0_ring_phys_funcs = {
 
 static const struct amdgpu_ring_funcs vce_v3_0_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCE,
-	.align_mask = 0xf,
+	.align_mask = 0x1f,
 	.nop = VCE_CMD_NO_OP,
 	.support_64bit_ptrs = false,
 	.no_user_fence = true,
-- 
2.53.0



