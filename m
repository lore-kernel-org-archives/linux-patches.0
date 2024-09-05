Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C661156225;
	Thu,  5 Sep 2024 09:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530186; cv=none; b=ljUaG4o3RoooSaDdk0UJAa44q+MyOJhFHm1PHYDe1ZhXkb7u+cz5QZcOu/qL2Qx1pUVhOd5Wm/QnK30PuFCvrRmbx63piKqmcZ2NoVL/jTDMB4kPfwMX28e5+H47ZhA3aIE/akVuG9nxtVHDfIrMrqQWJROcqBCrWHnxoXYSNiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530186; c=relaxed/simple;
	bh=o4lAQQ11AIYlfo7WVnm6k76UbqW1SgPGNJ2MswBmPB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OICt0s/qYDACXTIrl6Ho5nvS/is7h/JGAruilji9eaClZwr5S0ooQMTUGyEEFbuyrj+R6lpRycZDCNTFnOkmo2OuX5dKegEOcPSuE1WJbnzVU7T3rTPVir6s9z9ThdMggk4julB+8Gc/jrMSREU8IvQ2zJ+MUjUCSUm7sa4e6C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0v7jKgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0v7jKgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AF0C4CEC3;
	Thu,  5 Sep 2024 09:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530186;
	bh=o4lAQQ11AIYlfo7WVnm6k76UbqW1SgPGNJ2MswBmPB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0v7jKgXX163VwhQbCGp3c4bbzy4IIE0Aj5ZzsbR/HhA7oo3YWLmnC1BWTehd+Vb6
	 oi52g7k1qFGcKeBVH82cuGXndyN0nPguTvuajFtUY0JIoDx2TKApOgJTgpcdPhHCen
	 I+RWhJt+4aTxPkPz7oDSAjwVVF3rg0GFJqvqv7ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/132] drm/amdgpu: fix dereference after null check
Date: Thu,  5 Sep 2024 11:41:07 +0200
Message-ID: <20240905093725.363182117@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 251627c91f98..9c99d69b4b08 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5236,7 +5236,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
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



