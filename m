Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAC1284B4F;
	Wed, 23 Apr 2025 15:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420640; cv=none; b=kT0NClQ/1KBsxiGhBw5e2tKNQxh8FrjQRYJ39q6vxOy4ZTG2ybGUKgy5gktu868NOuu5GxsarEt+56XYfacf6o7KSbS+ebDGEwhROva+Ls6tbapbZsHZfFcbaCbWXNxsChQbuZNJLIsXE8FHR3WQ+RBvjz9k8pIqVPSCTJ648gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420640; c=relaxed/simple;
	bh=CG+Q8psRAcIaU0BC1neXbOhDebygTEWD/TpgSRPSWOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f22Skm8m06xtgc9YWcWBHyuHKP2AsgVvHRoDt/YHqn8yopAT+ld0HpkghQ2GxtJF63CmNTV5EAbedgzKYHNVtoLsF+JzvHOjLcHMfXm5XfhZp2YP6KN7oWzsr7FkK04oPz4PV7ogklgGPuaMxqgnxsVxgsM0KMjmL27HUrNH4ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKmu313q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKmu313q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA28DC4CEE2;
	Wed, 23 Apr 2025 15:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420640;
	bh=CG+Q8psRAcIaU0BC1neXbOhDebygTEWD/TpgSRPSWOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKmu313qrTu6mBb1qWKYxLP70pWfCzCoMlic6rGbxy/5argJ0h/t+27bNCfzwdjxo
	 +xDskqmcnlJ5xrL5mKKMP6S76eZzB4aiaBNgRs5ZN7aVyclPXjNU1h9jJ6yQCMDPKn
	 R15Piv5tKlov+Pu+6jpiiPWgcLMkcbNXlJQC61rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/291] drm/amdgpu: handle amdgpu_cgs_create_device() errors in amd_powerplay_create()
Date: Wed, 23 Apr 2025 16:40:56 +0200
Message-ID: <20250423142627.112983328@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eae4b4826f043..ab8ae74646649 100644
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



