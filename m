Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B9531D749;
	Mon, 27 Oct 2025 18:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590970; cv=none; b=cVbsJYkgYINyfP64KFhn4pLQQTH8K4XeX3NkJijQtKeUghm9dHPqDyfi2XtzeHXzJCaOgA/nvTUr8nKUlQrRHOdIWqao3IvZHyth1ESWxWQ/8M5arfPuNj0qhS+q5GfYbplEKGDtNDmKak8ck++MAnlVRCrRPmusx95xagOwKxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590970; c=relaxed/simple;
	bh=IvlUxOgMoor7Ma2xVKe9fR159u5NgEJNZSBI/cdIqqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni8SttFB8BBFmg82u0bLqrOZY+ekPoaaBMTbIfdgz9RU3vVRj6VlkMO6gx7kgOBT9yzUL8vcDHvMahAv+5UDHUMq1QrYeAasWllwXz8BDQIrDq9Q/LulKiF96Plnh+SKbkYKCFRUZfy/AWgU3O74nBxssqVqJwCOlCxouLaxaVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwzfI1RE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwzfI1RE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E850C4CEF1;
	Mon, 27 Oct 2025 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590969;
	bh=IvlUxOgMoor7Ma2xVKe9fR159u5NgEJNZSBI/cdIqqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwzfI1REHm9l4kP00x+G8pwDkwEROSFVFLOLPfh1mCMhSxD8lDF/OwZp5Fwh8hLVw
	 pdM2OqkhmvYebr43EEKnaGx4iKO9Hj4xd6kIeyHKsTM4RxJDF83vCDAt38b3Xdj9F8
	 o4bbr57xcbZjjt1J8EuES7T2GgeUg7J+J6bZorkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Eslam Khafagy <eslam.medhat1993@gmail.com>
Subject: [PATCH 5.10 018/332] drm/amd/display: Fix potential null dereference
Date: Mon, 27 Oct 2025 19:31:11 +0100
Message-ID: <20251027183525.104899003@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Artemiev <Igor.A.Artemiev@mcst.ru>

commit 52f1783ff4146344342422c1cd94fcb4ce39b6fe upstream.

The adev->dm.dc pointer can be NULL and dereferenced in amdgpu_dm_fini()
without checking.

Add a NULL pointer check before calling dc_dmub_srv_destroy().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9a71c7d31734 ("drm/amd/display: Register DMUB service with DC")
Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Eslam Khafagy <eslam.medhat1993@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1142,7 +1142,8 @@ static void amdgpu_dm_fini(struct amdgpu
 		dc_deinit_callbacks(adev->dm.dc);
 #endif
 
-	dc_dmub_srv_destroy(&adev->dm.dc->ctx->dmub_srv);
+	if (adev->dm.dc)
+		dc_dmub_srv_destroy(&adev->dm.dc->ctx->dmub_srv);
 
 	if (adev->dm.dmub_bo)
 		amdgpu_bo_free_kernel(&adev->dm.dmub_bo,


