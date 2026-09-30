Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3628C327BEC;
	Wed, 30 Sep 2026 18:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794522; cv=none; b=hiOQCpVUJtjDo4JEYokb9U0q/qRrnt3/lD8E4Bd+xfWSpEhRQj/PkOmdDOY4aNtvrCluaYQQXJzbO3dl5/OceI2DIy6zPz2Afp9MYGPCG83zvDYp3fEvrCKecKGJhscK0kdYVldLXb0qyWq4FmAul+CBFVArgDBkX3jBtuAhkvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794522; c=relaxed/simple;
	bh=DmeBo7PKJuMUsDznEtm20wr9x3xPzDNKtLkSQeQ4niM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEgmPh6dIJHRF48RVUa0ok4uZvVXaw8cWhUxY2fhoR6lUGFVr4HxTh5YJIEbjLvZrnxF/W02h57HZ1XyDCpbahppP5nU975ci2JGQi4IaKCT+iQrWisLvG5KbdMn5Yvtg3ZNj6SzBRVeLyprYW9lMSRyGjVGj6Pi/G+keCYGa1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jaxchiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jaxchiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEA51F000FF;
	Wed, 30 Sep 2026 18:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794520;
	bh=jBFAw7hNU+HiyG4aWQzuBMEv5Did0gnmfO0Cr6z5dB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jaxchiT8Vb0OtfyXf09Ex7IK30ek6qeUYV0icjynQCSs33QXYyS8tRR8qC2rJzGa
	 u5dkze2bKR6ACrfxsMcD78Jg0t7FC9QZoMJ7wy/QJ99h/aBpz1Ua4Eshfr5UZLCbRH
	 /QB9+lCkm9QtN0G9LT5c0r9pRj3cRIzImiJcCGzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0241/1193] drm/amdkfd: check find_first_zero_bit before __set_bit on kfd->doorbell_bitmap
Date: Wed, 30 Sep 2026 17:15:25 +0200
Message-ID: <20260930152439.546939240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 516bf737a5602875f6c28d1028967837c8edf2c0 ]

If inx from find_first_zero_bit is beyond range not need set doorbell_bitmap.

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2664ce9143d174651a793d96a6a2326050c4f45a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index 05c74887fd6fd..fdcf7f2d1b5b4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -153,14 +153,16 @@ void __iomem *kfd_get_kernel_doorbell(struct kfd_dev *kfd,
 	u32 inx;
 
 	mutex_lock(&kfd->doorbell_mutex);
+
 	inx = find_first_zero_bit(kfd->doorbell_bitmap, PAGE_SIZE / sizeof(u32));
+	if (inx >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS) {
+		mutex_unlock(&kfd->doorbell_mutex);
+		return NULL;
+	}
 
 	__set_bit(inx, kfd->doorbell_bitmap);
 	mutex_unlock(&kfd->doorbell_mutex);
 
-	if (inx >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
-		return NULL;
-
 	*doorbell_off = amdgpu_doorbell_index_on_bar(kfd->adev,
 						     kfd->doorbells,
 						     inx,
-- 
2.53.0



