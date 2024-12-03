Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8591F76C0;
	Tue,  3 Dec 2024 15:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240994; cv=none; b=D0EtAjt6d7XkUa/VGWtZokAiywgEhAjlkVNUFhQemkeg7Ig6WkimxYnD1GThDRCl6zoc0V4mNUqSenaOqNOa+LjHZXeNSmSESmhv3ZTGKHIpbNP/8thhQsklQyVWdPV2z1vH+p2V2e9HPIEJGscKAWQy4yi1ESQWzW+Of6yHRjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240994; c=relaxed/simple;
	bh=+MhOUOZLdHtqJNIP6yut3jwXrt3DTpNOvtxPWXTnLps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KsO3RH7zl17OsstoKZPI+B7Hi1ueMaYieglAXe/wkCqylLbMgb8OS0mEfDu0CLKPvLF6uZp5QkAESjkoyJOMpqY0Yl52WYBBuQxWRLCp80bOKGpZFkU9RaEMHzRZpLmpDV9S7noD1wqBvFFTFYmLmE0dJTLCkz+mm6p9J8O9Euc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDtZvbCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDtZvbCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EC5C4CED6;
	Tue,  3 Dec 2024 15:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240994;
	bh=+MhOUOZLdHtqJNIP6yut3jwXrt3DTpNOvtxPWXTnLps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDtZvbCxTkziOhFnTIhixbE2mw/UfWa/y/jjf/4ESSN5bjO5p/R0Xjpr2LSuIpQPj
	 iCZEaQlmxuI27m9y0cnGndZZaOxGXwnNOOjfQa6Dw8l+QE+o7XnYIWzSuvfGOvhgSE
	 GHsNOuFvAddaiCCRik6PZjb7ZvWYCxing2o3xI3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/826] drm/amdkfd: Use dynamic allocation for CU occupancy array in kfd_get_cu_occupancy()
Date: Tue,  3 Dec 2024 15:40:22 +0100
Message-ID: <20241203144755.273732137@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 922f0e00017b09d9d47e3efac008c8b20ed546a0 ]

The `kfd_get_cu_occupancy` function previously declared a large
`cu_occupancy` array as a local variable, which could lead to stack
overflows due to excessive stack usage. This commit replaces the static
array allocation with dynamic memory allocation using `kcalloc`,
thereby reducing the stack size.

This change avoids the risk of stack overflows in kernel space,  in
scenarios where `AMDGPU_MAX_QUEUES` is large. The  allocated memory is
freed using `kfree` before the function returns  to prevent memory
leaks.

Fixes the below with gcc W=1:
drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_process.c: In function ‘kfd_get_cu_occupancy’:
drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_process.c:322:1: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]
  322 | }
      | ^

Fixes: 6ae9e1aba97e ("drm/amdkfd: Update logic for CU occupancy calculations")
Cc: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Suggested-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index d4aa843aacfdd..6bab6fc6a35d6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -271,11 +271,9 @@ static int kfd_get_cu_occupancy(struct attribute *attr, char *buffer)
 	struct kfd_process *proc = NULL;
 	struct kfd_process_device *pdd = NULL;
 	int i;
-	struct kfd_cu_occupancy cu_occupancy[AMDGPU_MAX_QUEUES];
+	struct kfd_cu_occupancy *cu_occupancy;
 	u32 queue_format;
 
-	memset(cu_occupancy, 0x0, sizeof(cu_occupancy));
-
 	pdd = container_of(attr, struct kfd_process_device, attr_cu_occupancy);
 	dev = pdd->dev;
 	if (dev->kfd2kgd->get_cu_occupancy == NULL)
@@ -293,6 +291,10 @@ static int kfd_get_cu_occupancy(struct attribute *attr, char *buffer)
 	wave_cnt = 0;
 	max_waves_per_cu = 0;
 
+	cu_occupancy = kcalloc(AMDGPU_MAX_QUEUES, sizeof(*cu_occupancy), GFP_KERNEL);
+	if (!cu_occupancy)
+		return -ENOMEM;
+
 	/*
 	 * For GFX 9.4.3, fetch the CU occupancy from the first XCC in the partition.
 	 * For AQL queues, because of cooperative dispatch we multiply the wave count
@@ -318,6 +320,7 @@ static int kfd_get_cu_occupancy(struct attribute *attr, char *buffer)
 
 	/* Translate wave count to number of compute units */
 	cu_cnt = (wave_cnt + (max_waves_per_cu - 1)) / max_waves_per_cu;
+	kfree(cu_occupancy);
 	return snprintf(buffer, PAGE_SIZE, "%d\n", cu_cnt);
 }
 
-- 
2.43.0



