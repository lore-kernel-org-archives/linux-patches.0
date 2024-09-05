Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46B71922CC;
	Thu,  5 Sep 2024 10:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530658; cv=none; b=THzwmASAje2leV7I+nBj6nvsakbLlcpNYHxJSMdLFkrUlTTbJYJ5HUuS5xZ4jsJ9Wo+Ru5pqNiAHIgl2xiV1iQw40ANQ+Rf3Q/iRAeBGr/gWe6r82hxbPTjqrhg0rESPWU9Y7HUe7ESH3v0odDhWZG59GyrtlxGvDUzOs02YEdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530658; c=relaxed/simple;
	bh=5EVpQklEWOCbW/3PNxIbNV/9oRwMlxpOGCO+2xzEBy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlmbJQQDj42Jj+ZBhSIL14d1AA+Xuv3azDSM8vJ5SF/kPJxteiJioVk2nfPkxVPD6dP6UgQ5WrK9bEVrGzLrbSkvXMSjM8Tdb1u8sARNbA8rJxVRWMQCRq26iEUqacloqU6OwgwpFPbFrKMU9epi3pOSwTwiJ+GlKz81DOmXUh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYY4Lx9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYY4Lx9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20385C4CEC3;
	Thu,  5 Sep 2024 10:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530657;
	bh=5EVpQklEWOCbW/3PNxIbNV/9oRwMlxpOGCO+2xzEBy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYY4Lx9eGrSVXWNzBXbVaiCTy8YD3eGtli579iS0gkehGaBbejD5M9dg88f8efqxd
	 qWibFeFLLTDEnLgM6AZDsokhhVoxTPuBzSrn5CzIsWSEq4CSQW9Y8Fu2pdgvuATxaA
	 uWcv78pUnS5HYrzal5itRAaZIDMEYFi81FCAiUV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/101] drm/amdgpu: fix dereference after null check
Date: Thu,  5 Sep 2024 11:41:33 +0200
Message-ID: <20240905093718.524788020@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit b1f7810b05d1950350ac2e06992982974343e441 ]

check the pointer hive before use.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 1319fdd37e7a..1d0f6628f1d6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5391,7 +5391,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	 * to put adev in the 1st position.
 	 */
 	INIT_LIST_HEAD(&device_list);
-	if (!amdgpu_sriov_vf(adev) && (adev->gmc.xgmi.num_physical_nodes > 1)) {
+	if (!amdgpu_sriov_vf(adev) && (adev->gmc.xgmi.num_physical_nodes > 1) && hive) {
 		list_for_each_entry(tmp_adev, &hive->device_list, gmc.xgmi.head) {
 			list_add_tail(&tmp_adev->reset_list, &device_list);
 			if (gpu_reset_for_dev_remove && adev->shutdown)
-- 
2.43.0



