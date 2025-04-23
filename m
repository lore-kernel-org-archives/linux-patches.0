Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1DD266B4B;
	Wed, 23 Apr 2025 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420727; cv=none; b=MMWT93yc5CcDK7yOXz9K2Zse9VcCfJ0IqsNR687hcDYk1XnlkIKpeVGUnbOLdb3AbHL6NNWS9kBxS59RQiXtjQcO1zED+t21AWSXH/tBRUlgCQ4bLSSXhGyp6ThLSMg7y3EV1MTNHAuFLm2GJeLCBHxzTR3e0gh+YSLQVMnWZI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420727; c=relaxed/simple;
	bh=QuUKNH5G/+a2iAdI6/0/9RiV8L2t5y2XKIeQBSHy4UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8FMArpuMXk7NCXMU69Xz2zojo9EcxC+YKeFryi+xQdXEsT7BXIiR5zcHdUMLiDG89J3OEeCUtNvrH5y3JXaiKzeVTRTalgpD9N3GfCGM7azc3mu2OdZRBmB0KMYAmdiSPX0VkSDZDHziYHR1icsZ961N3XnnO7mGjnEvQcg4xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jj/H0LGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jj/H0LGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15F6C4CEE2;
	Wed, 23 Apr 2025 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420727;
	bh=QuUKNH5G/+a2iAdI6/0/9RiV8L2t5y2XKIeQBSHy4UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jj/H0LGdAc8esNKoIEd+BoQjRAFTXxn4CY4bAjjGdafajeACuh0nw2TbU/ZOTeR+d
	 G++DAlR65mhfRokTUWUxT18XCR5eCBn6GHYEVfog3rKg+QjOj0F/FOh90am6qT/iap
	 ax0ifvDJaK45mlWwPq6WWn2W6PjqfxmTQYLSfOYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/393] drm/amdgpu: handle amdgpu_cgs_create_device() errors in amd_powerplay_create()
Date: Wed, 23 Apr 2025 16:40:03 +0200
Message-ID: <20250423142647.702162863@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 1435e895d4fc967d64e9f5bf81e992ac32f5ac76 ]

Add error handling to propagate amdgpu_cgs_create_device() failures
to the caller. When amdgpu_cgs_create_device() fails, release hwmgr
and return -ENOMEM to prevent null pointer dereference.

[v1]->[v2]: Change error code from -EINVAL to -ENOMEM. Free hwmgr.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index 86f95a291d65f..bef6578ac4bfe 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -51,6 +51,11 @@ static int amd_powerplay_create(struct amdgpu_device *adev)
 	hwmgr->adev = adev;
 	hwmgr->not_vf = !amdgpu_sriov_vf(adev);
 	hwmgr->device = amdgpu_cgs_create_device(adev);
+	if (!hwmgr->device) {
+		kfree(hwmgr);
+		return -ENOMEM;
+	}
+
 	mutex_init(&hwmgr->msg_lock);
 	hwmgr->chip_family = adev->family;
 	hwmgr->chip_id = adev->asic_type;
-- 
2.39.5



