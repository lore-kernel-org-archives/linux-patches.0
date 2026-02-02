Received: from n169-112.mail.139.com (n169-112.mail.139.com [120.232.169.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326592C237F
	for <patches@lists.linux.dev>; Mon,  2 Feb 2026 07:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770019147; cv=none; b=dRaBSYVLMGcI4nRm2CxlQR2v2xWZ+9Q7wkOcV0nC2VUhpR9neHKvInDA3lpaA2oLEypx3YFxx8vbfgioNiMl9AbY3o8aednSkvnkNE0uZI7KPWlkoLjPO12u6//BKUy/lDRqha++st8zBNjYovHTTnNR6Nqte4yFpsS9Bm2n6rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770019147; c=relaxed/simple;
	bh=cmBlgaXEpfurE/glj7lwr6dyYgsmqCQjq3X6IKWuPfc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nCUOREMqgOvnyDKFdVb3BlHlC2tQ8kDUz1k6G4GsqVAIPWxmJeV/TbIsivHteX8cwbs3VrCOLug59PgbjinferVgUAdnw2r6a0+CS6yX56+n5H8szIrXzdIs+F33+V+XIppsTVs+HejvsYnyGnEyg9qWscQRSLTMXqYWmxGZNTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=Ru87Sg2J; arc=none smtp.client-ip=120.232.169.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="Ru87Sg2J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=Ru87Sg2J4uUcZvOOY0u4R1y0rScgFix+Fg13nGRGqpYiaXWvhYa8/7S4rABN01KpqwqIzlSY/O/pr
	 5NYTrjvPrF5Z+W1Tkmfut0Ycc+afSCBkOaeKBtIHYCjjTgqdh1F4sGUEbGOGlYZaYnBYt91Un1tJ9j
	 +F+7LppXinG47VkM=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-27-12032 (RichMail) with SMTP id 2f0069805926d3d-01d60;
	Mon, 02 Feb 2026 15:58:35 +0800 (CST)
X-RM-TRANSID:2f0069805926d3d-01d60
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	rbmccav@gmail.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	alexander.deucher@amd.com,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	daniel@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.1.y] drm/radeon: delete radeon_fence_process in is_signaled, no deadlock
Date: Mon,  2 Feb 2026 15:58:55 +0800
Message-Id: <20260202075855.947632-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Robert McClinton <rbmccav@gmail.com>

[ Upstream commit 9eb00b5f5697bd56baa3222c7a1426fa15bacfb5 ]

Delete the attempt to progress the queue when checking if fence is
signaled. This avoids deadlock.

dma-fence_ops::signaled can be called with the fence lock in unknown
state. For radeon, the fence lock is also the wait queue lock. This can
cause a self deadlock when signaled() tries to make forward progress on
the wait queue. But advancing the queue is unneeded because incorrectly
returning false from signaled() is perfectly acceptable.

Link: https://github.com/brave/brave-browser/issues/49182
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4641
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Robert McClinton <rbmccav@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 527ba26e50ec2ca2be9c7c82f3ad42998a75d0db)
Cc: stable@vger.kernel.org
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
---
 drivers/gpu/drm/radeon/radeon_fence.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 73e3117420bf..1f2a12a43dd3 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -362,14 +362,6 @@ static bool radeon_fence_is_signaled(struct dma_fence *f)
 		return true;
 	}
 
-	if (down_read_trylock(&rdev->exclusive_lock)) {
-		radeon_fence_process(rdev, ring);
-		up_read(&rdev->exclusive_lock);
-
-		if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq) {
-			return true;
-		}
-	}
 	return false;
 }
 
-- 
2.34.1


