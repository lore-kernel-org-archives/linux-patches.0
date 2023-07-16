Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F94D8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8054C433C8;
	Sun, 16 Jul 2023 20:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538313;
	bh=AcWtZuvJMBQWsl+Hq4xNLyPtoh7RARy/BYNDpaEPaFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7i7ZcyTH4eW1dLAyYI5kUCBT4AkKDGSjT/Y7dDY967PULBW2QEFliMJnKslBx0UD
	 8KFRw4SSWTrkofW6uk8OxubvK9+spN1zAkyjR3G+b7HdSgHJEmUJfiHF4kCiDK+fUX
	 eng7Sr0bGUpr7MMFXLSZkHD2M3XqJIaEHDFxM02E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 407/800] drm/amdgpu: Fix usage of UMC fill record in RAS
Date: Sun, 16 Jul 2023 21:44:20 +0200
Message-ID: <20230716194958.525742080@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 71344a718a9fda8c551cdc4381d354f9a9907f6f ]

The fixed commit listed in the Fixes tag below, introduced a bug in
amdgpu_ras.c::amdgpu_reserve_page_direct(), in that when introducing the new
amdgpu_umc_fill_error_record() and internally in that new function the physical
address (argument "uint64_t retired_page"--wrong name) is right-shifted by
AMDGPU_GPU_PAGE_SHIFT. Thus, in amdgpu_reserve_page_direct() when we pass
"address" to that new function, we should NOT right-shift it, since this
results, erroneously, in the page address to be 0 for first
2^(2*AMDGPU_GPU_PAGE_SHIFT) memory addresses.

This commit fixes this bug.

Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Alex Deucher <Alexander.Deucher@amd.com>
Fixes: 400013b268cb ("drm/amdgpu: add umc_fill_error_record to make code more simple")
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Link: https://lore.kernel.org/r/20230610113536.10621-1-luben.tuikov@amd.com
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 3ab8a88789c8f..dcca63019ea76 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -171,8 +171,7 @@ static int amdgpu_reserve_page_direct(struct amdgpu_device *adev, uint64_t addre
 
 	memset(&err_rec, 0x0, sizeof(struct eeprom_table_record));
 	err_data.err_addr = &err_rec;
-	amdgpu_umc_fill_error_record(&err_data, address,
-			(address >> AMDGPU_GPU_PAGE_SHIFT), 0, 0);
+	amdgpu_umc_fill_error_record(&err_data, address, address, 0, 0);
 
 	if (amdgpu_bad_page_threshold != 0) {
 		amdgpu_ras_add_bad_pages(adev, err_data.err_addr,
-- 
2.39.2



