Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AFE194A64;
	Thu,  5 Sep 2024 09:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529775; cv=none; b=AEZRj9J6YVHuGCECA22vD0C9nEx1qryV6Lkr32LwY+a7y3Gxrf7BhunlgfNrwHhqD7l72mthkvl6U0qmmHyk2OjETLW6VpmgdKyL9xDTF/vGPfbXhn0czfO6uKAe0aAN0mmrK901PjL4EI/4Mqaz765Usc/jA9wRK/J6kCh5n+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529775; c=relaxed/simple;
	bh=bJv0bQGQc97qNyfVxm24zc/6RLBVhyvLVUJv5KTO74g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gGyMdXDkZgbSCMfpdVGaPRP+GMGYp9OxWw4TaeNQHItaRXooo6eMYnHYnRyeoy2HCFADLyShgwJCpP6TblqKVekhhd0UPkHVPS8df+alFj1XxytNgujEm1AeQq7JplgFEjyM40TTI5yya6HxVS7ObPKAjjqpZ+sReL96g/pJlf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjk4A7fD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjk4A7fD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD41C4CEC4;
	Thu,  5 Sep 2024 09:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529775;
	bh=bJv0bQGQc97qNyfVxm24zc/6RLBVhyvLVUJv5KTO74g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjk4A7fDQWG3snzQqEJS9RkgY5y5jJVfGWHxQFnq9dXvrXdT8UIo3Ca4+PbvjE+il
	 4GI6sNUmTd6vLzv/zwIOUPEPZd8A3qh9f/MrjCOeez1LQsFOMToow9ciNfzMwsM9kf
	 0XQmfy1D0tsb46ZgBFHkYNTV1OVDHsdJYn5frdJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 139/184] drm/amdgu: fix Unintentional integer overflow for mall size
Date: Thu,  5 Sep 2024 11:40:52 +0200
Message-ID: <20240905093737.643778578@linuxfoundation.org>
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

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit c09d2eff81a997c169e0cacacd6b60c5e3aa33f2 ]

Potentially overflowing expression mall_size_per_umc * adev->gmc.num_umc with type unsigned int (32 bits, unsigned)
is evaluated using 32-bit arithmetic,and then used in a context that expects an expression of type u64 (64 bits, unsigned).

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index f1b08893765c..1ea55ee4796e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1597,7 +1597,7 @@ static int amdgpu_discovery_get_mall_info(struct amdgpu_device *adev)
 		break;
 	case 2:
 		mall_size_per_umc = le32_to_cpu(mall_info->v2.mall_size_per_umc);
-		adev->gmc.mall_size = mall_size_per_umc * adev->gmc.num_umc;
+		adev->gmc.mall_size = (uint64_t)mall_size_per_umc * adev->gmc.num_umc;
 		break;
 	default:
 		dev_err(adev->dev,
-- 
2.43.0



