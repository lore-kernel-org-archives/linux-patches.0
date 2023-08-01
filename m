Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A771FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FBAC433C9;
	Tue,  1 Aug 2023 09:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883221;
	bh=4QR4i/5FCmjj8vvofHns45GjYebhTG+h+CyJAUo12YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkzXth8VRWquiON6+S2T32R12FGVb111gHBBqB/Neh10rwjhFwO7xLqPxiV2fLzx+
	 0sEdoif+AcnzsruIZBszUXbOWhmvujOS/DLpDE9JjwcGdIxhx0TlTm/tDUl+WO6wRD
	 jWPT7uqKFUvSWi4h/wObokHM9f1ZhIV9fEVOpI8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 129/239] drm/amd: Fix an error handling mistake in psp_sw_init()
Date: Tue,  1 Aug 2023 11:19:53 +0200
Message-ID: <20230801091930.372701769@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit c01aebeef3ce45f696ffa0a1303cea9b34babb45 ]

If the second call to amdgpu_bo_create_kernel() fails, the memory
allocated from the first call should be cleared.  If the third call
fails, the memory from the second call should be cleared.

Fixes: b95b5391684b ("drm/amdgpu/psp: move PSP memory alloc from hw_init to sw_init")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index e4757a2807d9a..db820331f2c61 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -491,11 +491,11 @@ static int psp_sw_init(void *handle)
 	return 0;
 
 failed2:
-	amdgpu_bo_free_kernel(&psp->fw_pri_bo,
-			      &psp->fw_pri_mc_addr, &psp->fw_pri_buf);
-failed1:
 	amdgpu_bo_free_kernel(&psp->fence_buf_bo,
 			      &psp->fence_buf_mc_addr, &psp->fence_buf);
+failed1:
+	amdgpu_bo_free_kernel(&psp->fw_pri_bo,
+			      &psp->fw_pri_mc_addr, &psp->fw_pri_buf);
 	return ret;
 }
 
-- 
2.40.1



