Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9157715884E;
	Tue, 23 Jul 2024 18:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760290; cv=none; b=jSV1AgiDyGyw5qOtQfgEPvMQmJf9VYBQzFaOYVFcIujBgCuSoCsnUdZ1JME82SNO21eHbH/CyMm9+T0wNmxXtiii7ulEUCUdbNjHaClHenGB6Q7yNU6W55bQVKrV8v8kuNU2vG+AbJGAUejD2NlV2d+z8HDV6jbNT28SH5pPnag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760290; c=relaxed/simple;
	bh=pls9xlFRbgz3HLpfc5XxKThWBQwLeoIB87OCaboCxDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTomYz8jHjyxUdtfSCXqLFfGpnF4C+YLcElfXQwObL80Np0EcNlfL2k2tA4MCgP1/eo1OOxaXrh/kEwNEaEt7BOmeiJllBeNfC54ROPc8VsfLCLvOjktfFUsIdV36UdKzut9DeDe2/pkODZjqAzvbQskJ1u4jVgd3DPDc+y8gKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XL/Go3DO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XL/Go3DO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEB9C4AF0A;
	Tue, 23 Jul 2024 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760290;
	bh=pls9xlFRbgz3HLpfc5XxKThWBQwLeoIB87OCaboCxDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XL/Go3DO9fqDR+2l2EcAfNT2fTQmeq9ub67Vz7i03nvXfEv+dL/2ANADjl2WxO3xR
	 M+2acvoSJr7NvDJRF+OFZkF90/OwDKw723M6CLEytSSl8/CBTvZn0NodTkeObJ+98o
	 B0gdzBUYjU95JvDSnHurReDX6IAae8v5+N48fKZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 138/163] drm/radeon: check bo_va->bo is non-NULL before using it
Date: Tue, 23 Jul 2024 20:24:27 +0200
Message-ID: <20240723180148.803901828@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 3fec3acdaf284..27225d1fe8d2e 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -641,7 +641,7 @@ static void radeon_gem_va_update_vm(struct radeon_device *rdev,
 	if (r)
 		goto error_unlock;
 
-	if (bo_va->it.start)
+	if (bo_va->it.start && bo_va->bo)
 		r = radeon_vm_bo_update(rdev, bo_va, bo_va->bo->tbo.resource);
 
 error_unlock:
-- 
2.43.0



