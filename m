Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF00E2566;
	Tue, 27 May 2025 17:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368288; cv=none; b=nb86V14i6huhQVVGN6U5aGuw8zjS3xOI0dl4/Ad0uPFRdPavPsfeFbuSpEa7CNmrmIwuNspk83GOrocirJ+j32gmOOYecFbVqwp9jyh/CpZFtb6czxboT8/0H4OcKsJx3+F5Glc4Tc2XHAGrfvT0mduSPCLQfWKmJPV3WNfaqZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368288; c=relaxed/simple;
	bh=fpFf4U1GyBHs+Sr8DEcqp7aHQThkiG86+BLcte0QuWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Im2HqdXf3KBhBOcGFjvtWT/2tYg/LIAcHMzThutWvx35j54E81w6iV+p+9iNLuepJrvn2uHf+YVQiVT2cNerOvrZKNcTa9Stw67hVeDxjH4lewZFnENTYc2Aj4XWz5ENwy4IvB/eeZpMzrdcDe2OGd31U8lP8boZBAqJ3ru2GWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXcOA20k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXcOA20k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECC9C4CEE9;
	Tue, 27 May 2025 17:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368288;
	bh=fpFf4U1GyBHs+Sr8DEcqp7aHQThkiG86+BLcte0QuWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXcOA20kmX4EdfztbdrhmgYHBZI9L5G19C6L7Cu4JeyOjwP2m57rzmHxbS4SHzk2f
	 BFY0s8wr6jzm/EIw2yCOb+rlASNUw8RBcvQNiMqLPZ/TZC51O/U1mT7RrBKnyOiS45
	 y+Zy0HXqhzB+sW5qFUmCXLjozmLb1XAO5CWaeM2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 642/783] drm/amdkfd: Fix error handling for missing PASID in kfd_process_device_init_vm
Date: Tue, 27 May 2025 18:27:19 +0200
Message-ID: <20250527162539.287123985@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 2b04d04de956b44cc140d45cf8ebccfb378ce3bf ]

In the kfd_process_device_init_vm function, a valid error code is now
returned when the associated Process Address Space ID (PASID) is not
present.

If the address space virtual memory (avm) does not have an associated
PASID, the function sets the ret variable to -EINVAL before proceeding
to the error handling section. This ensures that the calling function,
such as kfd_ioctl_acquire_vm, can appropriately handle the error,
thereby preventing any issues during virtual memory initialization.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_process.c:1694 kfd_process_device_init_vm()
warn: missing error code 'ret'

drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_process.c
    1647 int kfd_process_device_init_vm(struct kfd_process_device *pdd,
    1648                                struct file *drm_file)
    1649 {
    ...
    1690
    1691         if (unlikely(!avm->pasid)) {
    1692                 dev_warn(pdd->dev->adev->dev, "WARN: vm %p has no pasid associated",
    1693                                  avm);
--> 1694                 goto err_get_pasid;

ret = -EINVAL?

    1695         }

Fixes: 8544374c0f82 ("drm/amdkfd: Have kfd driver use same PASID values from graphic driver")
Reported by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Xiaogang Chen <xiaogang.chen@amd.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index a7e0a16dac47b..3f411922534b3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1711,6 +1711,7 @@ int kfd_process_device_init_vm(struct kfd_process_device *pdd,
 	if (unlikely(!avm->pasid)) {
 		dev_warn(pdd->dev->adev->dev, "WARN: vm %p has no pasid associated",
 				 avm);
+		ret = -EINVAL;
 		goto err_get_pasid;
 	}
 
-- 
2.39.5



