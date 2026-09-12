Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA3541835E;
	Sat, 12 Sep 2026 08:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202210; cv=none; b=PfWZUTxxwI8oWtUe8TtQ/CqwVzTf5ul2vwp+sHDokday+A+5ZrSDHKswKX0gqrpEnijHZOgp5q8xscn8X/W+tUCz8Z3Ab1MebKPXU568Fz08Nx0IxZNKkaKlu7ZCsh4Dh1avMzkFga1KF/eR6jtW/pTcWZZMcOebhF/xRPZnYxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202210; c=relaxed/simple;
	bh=RQxR0bnsjiCKX1BSzvSEaq+ytCRP7KED5cKYDnyIRnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/+qfKXTzyWGSav4jOkzipTUAsHZDai6e0SD8cWklfxolomC/n+jem8FEV/WkfWrJwM0dtsYQ7jC5224iSBQnkuRrwpUvPage21uCSyZLkni5yhD4qZ0hB308dcYpdx1dq7eojkdL1cseqeah1GLYo8UIq0KrH5ZiqKoTCdQznM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcOR6LQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcOR6LQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C778C1F00898;
	Sat, 12 Sep 2026 08:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202207;
	bh=1iXX2qmrDhBNoUSWPlBJ7dXJVVhOlh3Ui2IDyGO9uxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QcOR6LQYPb9/zF6qmnk5dl1PK915gMMa0UnGJ8CfSKK8U8WGoePpcKYloeFYdWQYe
	 SonttDzpkV8lDFDK15j3qcr/rh/H/+WFotRbkI5zmJ8gC2W2bHZruEqeXLTnY1jvN/
	 Hew03m2qF0s2ur0gbMegQSjbEAid+GMsolMMtx5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <Qiang.Yu@amd.com>,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1156/1815] drm/amdgpu: read TRUNCATE_COORD_MODE on gfx12
Date: Sat, 12 Sep 2026 08:48:26 +0200
Message-ID: <20260912065716.150596923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <Qiang.Yu@amd.com>

[ Upstream commit 4261cbc7b03f1f56e95aeaf1492b8690fa5a253e ]

TA_CNTL2.TRUNCATE_COORD_MODE selects whether texture coordinate
truncation is D3D9/GL/Vulkan conformant. gfx11 reads it and reports it to
userspace via AMDGPU_IDS_FLAGS_CONFORMANT_TRUNC_COORD, but gfx12 never
read it, so the flag was always reported as 0 and userspace fell back to
the non-conformant path.

Read it in gfx_v12_0_constants_init() like gfx11 does.

Fixes: 52cb80c12e8a ("drm/amdgpu: Add gfx v12_0 ip block support (v6)")
Signed-off-by: Qiang Yu <Qiang.Yu@amd.com>
Reviewed-by: Marek Olšák <maraeo@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index 6c37e760fdfae..e55c9002113c7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -1822,6 +1822,12 @@ static void gfx_v12_0_constants_init(struct amdgpu_device *adev)
 	gfx_v12_0_get_cu_info(adev, &adev->gfx.cu_info);
 	gfx_v12_0_get_tcc_info(adev);
 	adev->gfx.config.pa_sc_tile_steering_override = 0;
+
+	/* Set whether texture coordinate truncation is conformant. */
+	tmp = RREG32_SOC15(GC, 0, regTA_CNTL2);
+	adev->gfx.config.ta_cntl2_truncate_coord_mode =
+		REG_GET_FIELD(tmp, TA_CNTL2, TRUNCATE_COORD_MODE);
+
 	/* Program DB_RING_CONTROL for multiple GFX pipes
 	 * Default power up value is 1.
 	 * Possible values:
-- 
2.53.0



