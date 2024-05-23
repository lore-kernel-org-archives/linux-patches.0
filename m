Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AE314A62D;
	Thu, 23 May 2024 13:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470154; cv=none; b=nbCYAElEIOiXqOmgpe/1bQcqXKILTS2My/QLPjAJugB2IHCjLD0kivo735E2UPZjzmtvUkABE8rGcgjMADtbjPR6wBi+LWyKxcZMfvySVDQqAsgHT7bNCvSK6ljlfj1Z9axzPeflJ7o4PbubHE3xKqWdHGw3trioqUGTKalLPew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470154; c=relaxed/simple;
	bh=nC9MKH36BwmDcvKmySAppRVVvi5opCHrYE92n7Y9Hg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=giA3Wk3mhBbVhhQlwm10jci7IdEsqqf3+BV6MKmeL+KqOl9Dnap5BzKmjFZe++oEnNP5Zn9/1koI+eDXjEmqI5vLYSk/AxrbanGBNx+boxKEkvyRkGpw86SJ3Mf8lvdki0PDDT1P1dBf1Qw8TfJiu4qiLGCiLYhA2frc3OkaP5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjnh2gfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjnh2gfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21C3C32781;
	Thu, 23 May 2024 13:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470154;
	bh=nC9MKH36BwmDcvKmySAppRVVvi5opCHrYE92n7Y9Hg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjnh2gfMwFZUEIQSSCojL5/9aGLV1l3ZJrxp5vf10hkF73/mQqphtT5CsQ5oDM3Uv
	 U4BsKfafwBceW/w2jaG1UJEk6dRHOz+AAD/cG30aV5n9rbto4x1tCGjsq52jEbCt7q
	 SqA9L0w8sQ2gxZlghxUWls9JYvU2ITnWE5ud6GDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 5.4 13/16] drm/amdgpu: Fix possible NULL dereference in amdgpu_ras_query_error_status_helper()
Date: Thu, 23 May 2024 15:12:46 +0200
Message-ID: <20240523130326.247877616@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit b8d55a90fd55b767c25687747e2b24abd1ef8680 upstream.

Return invalid error code -EINVAL for invalid block id.

Fixes the below:

drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:1183 amdgpu_ras_query_error_status_helper() error: we previously assumed 'info' could be null (see line 1176)

Suggested-by: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Ajay: applied AMDGPU_RAS_BLOCK_COUNT condition to amdgpu_ras_error_query()
       as amdgpu_ras_query_error_status_helper() not present in v5.10, v5.4
       amdgpu_ras_query_error_status_helper() was introduced in 8cc0f5669eb6]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -594,6 +594,9 @@ int amdgpu_ras_error_query(struct amdgpu
 	if (!obj)
 		return -EINVAL;
 
+	if (!info || info->head.block == AMDGPU_RAS_BLOCK_COUNT)
+		return -EINVAL;
+
 	switch (info->head.block) {
 	case AMDGPU_RAS_BLOCK__UMC:
 		if (adev->umc.funcs->query_ras_error_count)


