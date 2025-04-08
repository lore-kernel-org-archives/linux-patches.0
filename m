Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCCA224F6;
	Tue,  8 Apr 2025 11:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111257; cv=none; b=h9vaP99126CF/eqXdErrW49v3VPBqCTf/9ROT3m3KDUiFBr8RxnSSrFR+226BnoDkw7xzP2TwTRMdgjKjTOSi6LL0MAsQGNL2M2D2/F/Bc9dPdWqQJZxYBg+GMqRxT1IdY5gTMboVmLSKq/iupmkisfw+zR25o8qwHvniNR3Y0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111257; c=relaxed/simple;
	bh=OUpLUgS5MchLGJphWnGDJU0TzJnWmdjo/5nXKV0Ymy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bH1SMHZBajt1m8cAXsd/zdl+f3zT4lq89ANVqPqOIo1sEqIrCexnVJBQTHAqQazXe+pJliPi6Qyk1rGmkaZjebSIotrKqvSu6qscsvKh8R881RuRzsRA0j4xinveZ+A5qz6pLg7qCo6hlabzvrS9apFu0YlV6Vmppx+GMtY98Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcgegerS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcgegerS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4463CC4CEE5;
	Tue,  8 Apr 2025 11:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111257;
	bh=OUpLUgS5MchLGJphWnGDJU0TzJnWmdjo/5nXKV0Ymy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcgegerSoMR8GysEsLVB3dgDD6kxEtXYLPB8ZVooeIq98uw0EXkQ5MHApRiyOJPU4
	 OkkhuCHwTLQ4j+zL82uDjvJNdcq+H4sgbrLBm0DwXE0EgTFrTUvqZA087rAqSwFki5
	 nX5VdL976a40njHaVpwogGEQJdqOsqQiZczLeDIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Shaoyun.liu" <Shaoyun.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 339/731] drm/amdgpu/mes: optimize compute loop handling
Date: Tue,  8 Apr 2025 12:43:56 +0200
Message-ID: <20250408104922.161349932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 5608ddf6e94c41a673170b2a7e3aad485fd8b88a ]

Break when we get to the end of the supported pipes
rather than continuing the loop.

Reviewed-by: Shaoyun.liu <Shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a52077b6b6f7 ("drm/amdgpu/mes: enable compute pipes across all MEC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index 709c11cbeabd8..c16ad5f790d15 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -147,7 +147,7 @@ int amdgpu_mes_init(struct amdgpu_device *adev)
 	for (i = 0; i < AMDGPU_MES_MAX_COMPUTE_PIPES; i++) {
 		/* use only 1st MEC pipes */
 		if (i >= adev->gfx.mec.num_pipe_per_mec)
-			continue;
+			break;
 		adev->mes.compute_hqd_mask[i] = 0xc;
 	}
 
-- 
2.39.5



