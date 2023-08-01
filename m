Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772011F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA0AC433C8;
	Tue,  1 Aug 2023 09:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881973;
	bh=EcqhSCjgIROBiFLPRFCf18cataeVuyiG4n5wDIhvlLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVBRM1PQFME2MaRe7K8TZldmdSJUa0glkNwAKmYK3PYEyWw6mfy9EV+kUkQXt+CFy
	 pcfqXNOa5enFEFQ7SDCvM45d20cVIIxk/n729JNytmQBZhaOMJThdvEuPmEo3ULUZM
	 SCEb7kMWqd3BPrGiWM0/zi3EmHelNNQkwIrx6L6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/155] drm/amd: Fix an error handling mistake in psp_sw_init()
Date: Tue,  1 Aug 2023 11:20:08 +0200
Message-ID: <20230801091913.631606534@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
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
index 65744c3bd3648..f305a0f8e9b9a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -341,11 +341,11 @@ static int psp_sw_init(void *handle)
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



