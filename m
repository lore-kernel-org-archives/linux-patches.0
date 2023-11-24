Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EF539FC6;
	Fri, 24 Nov 2023 18:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1nuyeNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15BBC433C7;
	Fri, 24 Nov 2023 18:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849181;
	bh=v1DI7ROfTUWGkEvJ4WKAmMdZVvJsQu6S9j+MmK637a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1nuyeNrtd+alZ6VFcAdYK3Ja8fkz6tI1tRhUTNhEU80a8EI/Sn6IF8bBXd0yBvsH
	 7MTKX0a0DY92SrxToRCReUeM1fwb4N2lUPWEhYo5ecUhZ1XspAZwZ2TnWG0VC0fH9g
	 aAnvNXm6rzVEuXpcl4koMo+JjNRw1S3T/Ard0Li8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/530] drm/amdkfd: Fix a race condition of vram buffer unref in svm code
Date: Fri, 24 Nov 2023 17:43:41 +0000
Message-ID: <20231124172029.733637426@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 709c348261618da7ed89d6c303e2ceb9e453ba74 ]

prange->svm_bo unref can happen in both mmu callback and a callback after
migrate to system ram. Both are async call in different tasks. Sync svm_bo
unref operation to avoid random "use-after-free".

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Jesse Zhang <Jesse.Zhang@amd.com>
Tested-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 2a42fbddcb7ae..2591bdfcc2289 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -628,8 +628,15 @@ svm_range_vram_node_new(struct kfd_node *node, struct svm_range *prange,
 
 void svm_range_vram_node_free(struct svm_range *prange)
 {
-	svm_range_bo_unref(prange->svm_bo);
-	prange->ttm_res = NULL;
+	/* serialize prange->svm_bo unref */
+	mutex_lock(&prange->lock);
+	/* prange->svm_bo has not been unref */
+	if (prange->ttm_res) {
+		prange->ttm_res = NULL;
+		mutex_unlock(&prange->lock);
+		svm_range_bo_unref(prange->svm_bo);
+	} else
+		mutex_unlock(&prange->lock);
 }
 
 struct kfd_node *
-- 
2.42.0



