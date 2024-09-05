Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6342314A08E;
	Thu,  5 Sep 2024 09:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529943; cv=none; b=IBTmQSHWhCilsYg8V9An3ZeB+Xls9fIp+JQRrEwmnzKQOK2xAJrJGORYELSQR8sqBLQBL95qFWvYNsTBOIUoqouRaeurClz15D1A6yWx3zBRxc7abcxL8TtK339KvWeZcWYCd5rTnEyUUwD99tCN+6kK5xvQApRuM/D0bmYK13U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529943; c=relaxed/simple;
	bh=mJhmp/6A0q+bHszcci7QJSHBjPbBqF2N9kaK5RDAnio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JdNsOvs03Ow+9urArxZ62n9a8y/PofJzaq309PB9ZQaEAHqS3RuC/zoqAVvw9uB+F5fHoHadxz0FGC7BQ/wDXElxM1EiLi7Mbn3hldwmBf5Q6MC5p6XP6GCz+tefWcVAQbNF64HPGFtDBhZ4VeT4Bv4eePXPEOvGo1Ha3jkdU/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pqZO9vO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pqZO9vO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDCFC4CEC4;
	Thu,  5 Sep 2024 09:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529943;
	bh=mJhmp/6A0q+bHszcci7QJSHBjPbBqF2N9kaK5RDAnio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pqZO9vOEhaicIfJu5SUg/It2ba4hsSk4IPN39Kfn9zUdDTBRvw0wK6tij9CLg0Wg
	 I1K3zkdhZn4Z+7+H16vBqgA94Mu5hH1tfWUyHhx6DD1d27F3TVvvmnPb3XZCIPGjOZ
	 0t9niAxGU84CLPW3J/d1PTJzQtiN1u9g35tHExo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 164/184] drm/amdgpu: add lock in amdgpu_gart_invalidate_tlb
Date: Thu,  5 Sep 2024 11:41:17 +0200
Message-ID: <20240905093738.742341837@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit 18f2525d31401e5142db95ff3a6ec0f4147be818 ]

We need to take the reset domain lock before flush hdp. We can't put the
lock inside amdgpu_device_flush_hdp itself because it is used during
reset where we already take the write side lock.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
index c623e23049d1..a6ddffbf8b4d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
@@ -34,6 +34,7 @@
 #include <asm/set_memory.h>
 #endif
 #include "amdgpu.h"
+#include "amdgpu_reset.h"
 #include <drm/drm_drv.h>
 #include <drm/ttm/ttm_tt.h>
 
@@ -408,7 +409,10 @@ void amdgpu_gart_invalidate_tlb(struct amdgpu_device *adev)
 		return;
 
 	mb();
-	amdgpu_device_flush_hdp(adev, NULL);
+	if (down_read_trylock(&adev->reset_domain->sem)) {
+		amdgpu_device_flush_hdp(adev, NULL);
+		up_read(&adev->reset_domain->sem);
+	}
 	for_each_set_bit(i, adev->vmhubs_mask, AMDGPU_MAX_VMHUBS)
 		amdgpu_gmc_flush_gpu_tlb(adev, 0, i, 0);
 }
-- 
2.43.0



