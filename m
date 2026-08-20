Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14820379EDA;
	Thu, 20 Aug 2026 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238749; cv=none; b=PMz3ediBPKg4wBRta5tKhnQh04CmbtRhacyiDvxmv301rVmOpzjQ51YvgxlLsR+4kYB72BWD5qrtVc8dkUH9uZ1q1Prdm3TnHgQs5F3UGomGZyoi8BQKBj5kOsJvVfnHDWdxPD6H/+rTDV1D0QUlERclr0M/7ULJqeF+WCZwYAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238749; c=relaxed/simple;
	bh=QsB9oWbkjff8Mnhf+OigLPIKpOPvAev7V7toa0i3dbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tD9VY13pwiAPjyX2Y+eblAr/sFHY+6z9e4/i+rKk6KJeBOdOIBjoMpGmwQ/rDMQfRUDtb77gpWN3ptqP/F0A3IwLDgqdvU25Q5SvZ0qIOFVvS0z084Erd1mhTy6cJoGYzHmagVBY1OFIkepo7s35bGCqzTw7OjwKdGTlpZkz6Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQN/JtRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQN/JtRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710D61F000E9;
	Thu, 20 Aug 2026 15:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238748;
	bh=wWMCARy9yMyUfMKWYOqdjjkswK2No8LY1U6KA80FqJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQN/JtRKv1dDo5cVnUyR7TeT6R8gchMDcsf82z6WSMdA5KsVqHLffGR0wlz9TbrI4
	 l6wqK1vtt9Ofcy2Wvxwi+j0qA34fDmwT3OVyVtMEv02EpGZKsQeqo8SveM8nT70oMo
	 H82rLf3GVPCm3tBg8Zk82B7DccTgHw3YbUqwDLvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <Qiang.Yu@amd.com>,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 027/217] drm/amdgpu: read TRUNCATE_COORD_MODE on gfx12
Date: Thu, 20 Aug 2026 16:53:15 +0200
Message-ID: <20260820145238.434817759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <Qiang.Yu@amd.com>

commit 2d69604b4d0b9c0c0ac71624b5fafb36cf249729 upstream.

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
(cherry picked from commit 4261cbc7b03f1f56e95aeaf1492b8690fa5a253e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -1810,6 +1810,11 @@ static void gfx_v12_0_constants_init(str
 	gfx_v12_0_get_tcc_info(adev);
 	adev->gfx.config.pa_sc_tile_steering_override = 0;
 
+	/* Set whether texture coordinate truncation is conformant. */
+	tmp = RREG32_SOC15(GC, 0, regTA_CNTL2);
+	adev->gfx.config.ta_cntl2_truncate_coord_mode =
+		REG_GET_FIELD(tmp, TA_CNTL2, TRUNCATE_COORD_MODE);
+
 	/* XXX SH_MEM regs */
 	/* where to put LDS, scratch, GPUVM in FSA64 space */
 	mutex_lock(&adev->srbm_mutex);


