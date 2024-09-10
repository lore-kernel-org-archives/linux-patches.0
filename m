Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20BF18CC11;
	Tue, 10 Sep 2024 09:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961652; cv=none; b=J3WOC2BhEgDdVkkinrNLerRSAtq6pNxStw9S2wffLONGp48sgNCFWQmSVJQDCLfNrWeEQ/+1gwtNwsqw839NxoBJffxDdRTTwmebtgPx4wJQ9jIyZ4v0+Xmf6hcaKgZes4VPxpn9VgdjsKK4h8tY0LT0twO2TA8T2NCeQ9Re04Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961652; c=relaxed/simple;
	bh=BJDH3we9FEVckWaDEOnuVOhFPQxCBLwVwxDj9vtmtFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qdm0YacaCFL+kT5ZIFhJhCVX8TqMeW3gaO8VjPHEm4ryef/+T2VA/tYgsftEhnEwPCQQh/8W0sVBntLWZMje+z5vbEXcJInI5095cSSqxKnqGFD4DKhNAI2iHKuaECTWFbmtUqK2YGG9kPJtjB9fFqIDMOMvjkc/9PRd2FwF3wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvR7d+wS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvR7d+wS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280CDC4CEC3;
	Tue, 10 Sep 2024 09:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961652;
	bh=BJDH3we9FEVckWaDEOnuVOhFPQxCBLwVwxDj9vtmtFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvR7d+wSKYn9FVjBEX94GNIiuRTNtcWBoO8xPbT1nfBNPEmWUUndXY/QZbtkR5asP
	 YWjkEGYMQISq/y6FdldhMn7oOP7iFiGGT+HLEKNDftVAr/UBPD+Wc49ObvWAaIGqXg
	 wS6gf9DUVuLXo3U+puGZR764c/fiAJo7HWDZ1f70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 143/375] drm/amdgpu: check for LINEAR_ALIGNED correctly in check_tiling_flags_gfx6
Date: Tue, 10 Sep 2024 11:29:00 +0200
Message-ID: <20240910092627.267581568@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Olšák <marek.olsak@amd.com>

[ Upstream commit 11317d2963fa79767cd7c6231a00a9d77f2e0f54 ]

Fix incorrect check.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 3ecc7ef95172..4fcc227db00b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -917,8 +917,7 @@ static int check_tiling_flags_gfx6(struct amdgpu_framebuffer *afb)
 {
 	u64 micro_tile_mode;
 
-	/* Zero swizzle mode means linear */
-	if (AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) == 0)
+	if (AMDGPU_TILING_GET(afb->tiling_flags, ARRAY_MODE) == 1) /* LINEAR_ALIGNED */
 		return 0;
 
 	micro_tile_mode = AMDGPU_TILING_GET(afb->tiling_flags, MICRO_TILE_MODE);
-- 
2.43.0



