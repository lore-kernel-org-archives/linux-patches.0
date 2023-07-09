Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405F0522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B91C433C7;
	Sun,  9 Jul 2023 11:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902272;
	bh=qcO0iz418YlP6gSZ9QjziD+r+knxu5g0imMkY1gpVc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSI5QrNGzaR+o9vxIQunJDWHh0OKUxEAbx4w5i8WqzFRPIEOrpxlEO0+LOAL3cskr
	 c8Gv++YMb6qHjFRUcNJUBKCS/I82qK2LPSjraKcRvlrC+JF+gefAuKZf2GW7hoAa/A
	 ukNHTYNgcol2YMeeA8N8evA2lrhGZnYXB3sICjjM=
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
Subject: [PATCH 6.3 317/431] drm/amdgpu: Fix usage of UMC fill record in RAS
Date: Sun,  9 Jul 2023 13:14:25 +0200
Message-ID: <20230709111458.612176044@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index 63dfcc98152d5..b3daca6372a90 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -170,8 +170,7 @@ static int amdgpu_reserve_page_direct(struct amdgpu_device *adev, uint64_t addre
 
 	memset(&err_rec, 0x0, sizeof(struct eeprom_table_record));
 	err_data.err_addr = &err_rec;
-	amdgpu_umc_fill_error_record(&err_data, address,
-			(address >> AMDGPU_GPU_PAGE_SHIFT), 0, 0);
+	amdgpu_umc_fill_error_record(&err_data, address, address, 0, 0);
 
 	if (amdgpu_bad_page_threshold != 0) {
 		amdgpu_ras_add_bad_pages(adev, err_data.err_addr,
-- 
2.39.2



