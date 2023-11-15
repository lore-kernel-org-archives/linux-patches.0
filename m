Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205173EA97
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyvVSZ+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3034C433C8;
	Wed, 15 Nov 2023 19:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076379;
	bh=PgptFvmtga0CCK3OC/pJLBVOK0e8GPm6F8djoXz8W2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyvVSZ+cQX0s9fgHmfX74D7dV+bWO5XN9w087CoitIC5i/7BbQVNU+rGiIAjbxTF2
	 N/pKLmWtcL54zisWV8i6IaU+qshUS2RbohFIIQsvwwF8VMVf/eOOR5RNY/gZD9B+Do
	 ULoKgV/bnbeqxVMYWDFQbFZx9XpO2kMfUZUvtWVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiaogang.Chen" <xiaogang.chen@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 230/550] drm/amdkfd: fix some race conditions in vram buffer alloc/free of svm code
Date: Wed, 15 Nov 2023 14:13:34 -0500
Message-ID: <20231115191616.660302802@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 5ff1a5a89d968..a9b57c66cb7d7 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -484,11 +484,11 @@ svm_range_validate_svm_bo(struct kfd_node *node, struct svm_range *prange)
 
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



