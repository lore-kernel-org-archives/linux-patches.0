Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CA4156F29;
	Tue, 23 Jul 2024 18:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759353; cv=none; b=UKRo+cuhclsd7IYJYEqy7O0vHHyusAj056t0ooJjcEZwc9kORLNkF/kg/33+3R10X02gg0hTJCjwOwhA5EXHfTo2XH8xRv9Ap40wVeDOGWokaTbuVdL3XEzdfsxuqRzN8tamU1KXuI/HDpcFclrChCGaefASDMSKWI273AU1Z8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759353; c=relaxed/simple;
	bh=IaaX61ONWNEyDPqPvo4D6ZiT4p7pFwKB0XE6eh6dPmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkPNFFcDUJV3MOz2lpNQSUbEvGw240AgBnF4zNrGiUbCsrp121ZzFGKuM7h36hdiYS1PL1jUM/h31vn2PkYyPrW3Gu0xsMeev0c87BSeLzeUczgBXW8LVgXxoAQv5rO5zcyKSyKFm8/Fc/o2U3qai/teWh+eD0POZX0y8rYzTLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQ1CWY1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQ1CWY1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D54C4AF0A;
	Tue, 23 Jul 2024 18:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759353;
	bh=IaaX61ONWNEyDPqPvo4D6ZiT4p7pFwKB0XE6eh6dPmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQ1CWY1jEMAbEbvGI0YmtZur3SkQBEytFq2j4RXnK94WEbIvxcenRlchCL5BMzWlK
	 XXwO5WddGNNGUBvRNbEuzDZ4t6GWaVxR+ETeH8GL1VGDL+GaQBbWOH82rYehKymwKw
	 qUSO/9KnD+cjbChjrWGgdz15UWY/ZO5zV8MAqRKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/105] drm/radeon: check bo_va->bo is non-NULL before using it
Date: Tue, 23 Jul 2024 20:24:04 +0200
Message-ID: <20240723180406.597169390@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit 6fb15dcbcf4f212930350eaee174bb60ed40a536 ]

The call to radeon_vm_clear_freed might clear bo_va->bo, so
we have to check it before dereferencing it.

Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index 75d79c3110389..3388a3d21d2c0 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -657,7 +657,7 @@ static void radeon_gem_va_update_vm(struct radeon_device *rdev,
 	if (r)
 		goto error_unlock;
 
-	if (bo_va->it.start)
+	if (bo_va->it.start && bo_va->bo)
 		r = radeon_vm_bo_update(rdev, bo_va, bo_va->bo->tbo.resource);
 
 error_unlock:
-- 
2.43.0



