Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC5D37267E;
	Sat, 12 Sep 2026 10:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207396; cv=none; b=GF75Mnt5MmpeGEr5Q58PyZ+fKd56gQc5a+PSDQ9ALtxmRIBs5tJF158CkbjHNhdr7exFIiGw/wz06tI7N4OfmrUaEl8A2eIRRiBuekPQhq1JUF3u1B0ofptbMQy+z5UAh5TP503FE+2eVHmYmz5CqYLsEsoRcqtI6nkm6Dq+9A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207396; c=relaxed/simple;
	bh=2nEn68bWPtxebwhpuuqFGK+B+msB4iO3shlCfKUsbCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8zGhkQZ2SY1dklZYNuDHcQWYugW/Yu0P/ZaHfAOwyZhXSbWwHy20iS9hC57av7KYcJzF5kZtXyF7R3lCAwXQ8vlPiXdVrlcc+ijpV1NuNo7Ifzh33j5wFm8AfVo8L3SRzlbk5Ibz2wjoJEpyPzr72/9G7za3pYpDcVc98YDLGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3WpmF+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3WpmF+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E091C1F000FF;
	Sat, 12 Sep 2026 10:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207394;
	bh=8QlIhwt73MnAP3BMACujSDpbbI4NIYtRo8Q6arkYPRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3WpmF+GgIYb7ovpbVSrcDdLZn6kXUn3Yo3lBpDcaUkpBmyhvcSHPa83+IMSnEuGY
	 Qo8uQVBC9U40+Y2pBVhKHIZ8W5uQr6ElNbbuemah1XroVTikXohAjxzFF1XycaJp1s
	 MnococFpluk9d+TYs9P9xYs5ljjKzIYPyReFDwmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoffrey McRae <geoffrey.mcrae@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0403/1518] drm/amd/display: Fix DM I2C teardown race
Date: Sat, 12 Sep 2026 08:42:52 +0200
Message-ID: <20260912065632.571475031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey McRae <geoffrey.mcrae@amd.com>

[ Upstream commit e4ae30a12aa95942814957d8bc1ce7366a7107d7 ]

DM I2C adapters can remain visible to userspace while DM teardown is
already in progress. A concurrent i2c-dev transfer may then enter
amdgpu_dm_i2c_xfer() after the backing DM state has been torn down,
leading to a NULL pointer dereference.

Create a devres group around the DM I2C adapter lifetime and release it
at the start of dm_hw_fini(), before HPD, IRQ, and DM state are torn
down. This removes the I2C adapters first and waits for in-flight users
to drain before the structures used by amdgpu_dm_i2c_xfer() disappear.

This fixes a teardown ordering race seen during device removal:

BUG: kernel NULL pointer dereference
RIP: amdgpu_dm_i2c_xfer+0x122/0x1c0 [amdgpu]
Call Trace:
__i2c_transfer
i2c_transfer
i2cdev_ioctl_rdwr

Fixes: 5b3eca05cfb0 ("drm/amd/display: Use devm_i2c_add_adapter to simplify i2c cleanup logic")
Signed-off-by: Geoffrey McRae <geoffrey.mcrae@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 +++++++++++++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  7 +++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9bce65ca29b02..06eb499f13637 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3040,17 +3040,26 @@ static int dm_hw_init(struct amdgpu_ip_block *ip_block)
 	struct amdgpu_device *adev = ip_block->adev;
 	int r;
 
+	adev->dm.i2c_devres_group = devres_open_group(adev->dev, NULL, GFP_KERNEL);
+	if (!adev->dm.i2c_devres_group)
+		return -ENOMEM;
+
 	/* Create DAL display manager */
 	r = amdgpu_dm_init(adev);
 	if (r)
-		return r;
+		goto err_release_i2c;
 	amdgpu_dm_hpd_init(adev);
 
 	r = dm_oem_i2c_hw_init(adev);
 	if (r)
 		drm_info(adev_to_drm(adev), "Failed to add OEM i2c bus\n");
 
+	devres_close_group(adev->dev, adev->dm.i2c_devres_group);
 	return 0;
+
+err_release_i2c:
+	devres_release_group(adev->dev, adev->dm.i2c_devres_group);
+	return r;
 }
 
 /**
@@ -3065,6 +3074,9 @@ static int dm_hw_fini(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
 
+	if (adev->dm.i2c_devres_group)
+		devres_release_group(adev->dev, adev->dm.i2c_devres_group);
+
 	amdgpu_dm_hpd_fini(adev);
 
 	amdgpu_dm_irq_fini(adev);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index cd362d22a2774..caf6f7387a20a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -664,6 +664,13 @@ struct amdgpu_display_manager {
 	 */
 	void *bb_from_dmub;
 
+	/**
+	 * @i2c_devres_group:
+	 *
+	 * Devres group for DM i2c adapter lifetime management.
+	 */
+	void *i2c_devres_group;
+
 	/**
 	 * @oem_i2c:
 	 *
-- 
2.53.0



