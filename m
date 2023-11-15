Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0A03DB9D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXbdorcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A9BC433C9;
	Wed, 15 Nov 2023 19:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078194;
	bh=rk8i1Rxt/IDOh1cEtKs63Qvs1c+Vp7IcmqaK9EsAOxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXbdorcIm3OU1E7DdEkdLRJuMj0h4VQjp4CvGR0V/H3NIlRcs+lPAqCp5a8bsYztZ
	 AZnisloNR2Yx9H0Qxv1auggWKrj2DhHVV7OsK4gTQWO1b3nqpM22CulDCOodyHQF6+
	 JciWE8TR4EW2V8dc27FQCiZUuOLjjAXFjSBfOC+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiaogang.Chen" <xiaogang.chen@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/379] drm/amdkfd: fix some race conditions in vram buffer alloc/free of svm code
Date: Wed, 15 Nov 2023 14:23:30 -0500
Message-ID: <20231115192653.116675597@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 7bfaa160caed8192f8262c4638f552cad94bcf5a ]

This patch fixes:
1: ref number of prange's svm_bo got decreased by an async call from hmm. When
wait svm_bo of prange got released we shoul also wait prang->svm_bo become NULL,
otherwise prange->svm_bo may be set to null after allocate new vram buffer.

2: During waiting svm_bo of prange got released in a while loop should reschedule
current task to give other tasks oppotunity to run, specially the the workque
task that handles svm_bo ref release, otherwise we may enter to softlock.

Signed-off-by: Xiaogang.Chen <xiaogang.chen@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 63feea08904cb..d7e758c86a0b8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -487,11 +487,11 @@ svm_range_validate_svm_bo(struct amdgpu_device *adev, struct svm_range *prange)
 
 	/* We need a new svm_bo. Spin-loop to wait for concurrent
 	 * svm_range_bo_release to finish removing this range from
-	 * its range list. After this, it is safe to reuse the
-	 * svm_bo pointer and svm_bo_list head.
+	 * its range list and set prange->svm_bo to null. After this,
+	 * it is safe to reuse the svm_bo pointer and svm_bo_list head.
 	 */
-	while (!list_empty_careful(&prange->svm_bo_list))
-		;
+	while (!list_empty_careful(&prange->svm_bo_list) || prange->svm_bo)
+		cond_resched();
 
 	return false;
 }
-- 
2.42.0



