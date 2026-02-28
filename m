Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A59313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300989; cv=none; b=KxFRRXWri169cvDCkCNmkgjqtMGI2+Ea03+dr+txMC12xLRqkcQTLAcqUd5OZg/IjJK5pA7zDBJlP/FE9ZbzdXHlGk0Ry+D1jz28A+ki2xquNegG01mYUKr0r+TFZ8+IvfX7jIbKdmx9KGb6v8EsU25F7hiOkM72Rlhe0LeBABI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300989; c=relaxed/simple;
	bh=9WsAo2Ugs0V8Qdj254ysnVVQAIKuGRQi2/3/rIE0ixA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYUyrRG8bZK0JO4MXOtMBltk02qpCm4X8VmKUt7MbEHFVra8GYIh2lE8dHDKghHo/Kvy70+WEr4CFQoWzVhvLwUKLW7fLNCQO1hiRdzA61uOMNBL5Z9mFRLbodYGfa8tpnZ6+a4uEREWyepotJ1i7Qxt4q4BFTnC7unUEi0jiLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dv1sw8L/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dv1sw8L/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0DCC19423;
	Sat, 28 Feb 2026 17:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300989;
	bh=9WsAo2Ugs0V8Qdj254ysnVVQAIKuGRQi2/3/rIE0ixA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dv1sw8L/L1NybPN3NQVefm6jDyNqj5bgrk1g+BUl05ia0vZQbk4rQ0ngsmEtrv91B
	 HHYSASVN69LEYYoZF2kx2+JY+xgmSY5f5VVSfG+VgIauCPBQysy+1Wiiqyl5Gu+0Fp
	 Vmn+UHxUq2L4UbmTxa6aDetQZdKlKB2hmZxiOxz6im/mekLxHPJQnt2fQtU9LZJZdk
	 iXgGqOMl80XODjiLssSLcRIax2IeyCZOaklNxbxBkgiW1nxODLuJwx14O+xoGQD78B
	 camU1BSUTctcK/bfmn/S6pybowZDQoqvL1IBIxoqE3EGLhDqD8ysVUTLF2iLgh9rNY
	 iTAIzENCvvHDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Philip Yang <Philip.Yang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/752] drm/amdkfd: Handle GPU reset and drain retry fault race
Date: Sat, 28 Feb 2026 12:37:10 -0500
Message-ID: <20260228174750.1542406-119-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 5b57c3c3f22336e8fd5edb7f0fef3c7823f8eac1 ]

Only check and drain IH1 ring if CAM is not enabled.

If GPU is under reset, don't access IH to drain retry fault.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 49dd0a81114e4..6daa70ace261f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -33,6 +33,7 @@
 #include "amdgpu_hmm.h"
 #include "amdgpu.h"
 #include "amdgpu_xgmi.h"
+#include "amdgpu_reset.h"
 #include "kfd_priv.h"
 #include "kfd_svm.h"
 #include "kfd_migrate.h"
@@ -2343,6 +2344,9 @@ static void svm_range_drain_retry_fault(struct svm_range_list *svms)
 
 		pr_debug("drain retry fault gpu %d svms %p\n", i, svms);
 
+		if (!down_read_trylock(&pdd->dev->adev->reset_domain->sem))
+			continue;
+
 		amdgpu_ih_wait_on_checkpoint_process_ts(pdd->dev->adev,
 				pdd->dev->adev->irq.retry_cam_enabled ?
 				&pdd->dev->adev->irq.ih :
@@ -2352,6 +2356,7 @@ static void svm_range_drain_retry_fault(struct svm_range_list *svms)
 			amdgpu_ih_wait_on_checkpoint_process_ts(pdd->dev->adev,
 				&pdd->dev->adev->irq.ih_soft);
 
+		up_read(&pdd->dev->adev->reset_domain->sem);
 
 		pr_debug("drain retry fault gpu %d svms 0x%p done\n", i, svms);
 	}
@@ -2535,7 +2540,7 @@ svm_range_unmap_from_cpu(struct mm_struct *mm, struct svm_range *prange,
 		adev = pdd->dev->adev;
 
 		/* Check and drain ih1 ring if cam not available */
-		if (adev->irq.ih1.ring_size) {
+		if (!adev->irq.retry_cam_enabled && adev->irq.ih1.ring_size) {
 			ih = &adev->irq.ih1;
 			checkpoint_wptr = amdgpu_ih_get_wptr(adev, ih);
 			if (ih->rptr != checkpoint_wptr) {
-- 
2.51.0

