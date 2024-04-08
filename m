Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A017B3E5;
	Mon,  8 Apr 2024 13:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582968; cv=none; b=NZrjU33gIkOsOXTCNXG3/rLidvpvGOyphCShvcr07vuZFQWrWf1CU1DA/K5nfcIQZD3ddzB7rrwVNFc2X83VRbzG88Agdm5zjvjwPM/8BWO9HFQuJS8PuSGrfy4oHoyhcm5EnElFwPBnlrBBC93xT8pbP8Uwx1TJH4AVtcHwX78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582968; c=relaxed/simple;
	bh=jeiVoOkx/9LkAYveFcMOIcbByBH9Ujtyu1juird9of0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s9WnTK0PwI0nakcWPVJ21NgkcMPA2TABKxRW/h7wWX160ofRIJZ55DhD6XfMseh6/A/SbjxuP0iYV/LUV5j1fual+LrxFiG+HcX1QDj0JS9BAihnVseRkdefmzPhcWUq77Qz6TxvSsgxAxbk9kV+OZH7KkMsKb3fJzck6QOL4ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVFbyirU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVFbyirU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE0FC433C7;
	Mon,  8 Apr 2024 13:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582967;
	bh=jeiVoOkx/9LkAYveFcMOIcbByBH9Ujtyu1juird9of0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVFbyirUINGAZniPRJMrj2ixsAR1RB4L6Y1f2FlVDqeT1OVY27+MFLaDYRT15wp5N
	 u0YJi/KA5yTA8EyeABkIwpIA7XQB1rJwWCpZjO0rwxLWV62ZmN899uVjBr5rnrJoe1
	 AdN2WPDrsh2UGE3CgeodgsfbeCaLX13nn8G//M8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/252] drm/amd: Add concept of running prepare_suspend() sequence for IP blocks
Date: Mon,  8 Apr 2024 14:57:16 +0200
Message-ID: <20240408125310.894521807@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit cb11ca3233aa3303dc11dca25977d2e7f24be00f ]

If any IP blocks allocate memory during their hw_fini() sequence
this can cause the suspend to fail under memory pressure.  Introduce
a new phase that IP blocks can use to allocate memory before suspend
starts so that it can potentially be evicted into swap instead.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ca299b4512d4 ("drm/amd: Flush GFXOFF requests in prepare stage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 12 +++++++++++-
 drivers/gpu/drm/amd/include/amd_shared.h   |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 707c17641c757..4ebe42395708f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4107,7 +4107,7 @@ static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
 int amdgpu_device_prepare(struct drm_device *dev)
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
-	int r;
+	int i, r;
 
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
@@ -4117,6 +4117,16 @@ int amdgpu_device_prepare(struct drm_device *dev)
 	if (r)
 		return r;
 
+	for (i = 0; i < adev->num_ip_blocks; i++) {
+		if (!adev->ip_blocks[i].status.valid)
+			continue;
+		if (!adev->ip_blocks[i].version->funcs->prepare_suspend)
+			continue;
+		r = adev->ip_blocks[i].version->funcs->prepare_suspend((void *)adev);
+		if (r)
+			return r;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/include/amd_shared.h b/drivers/gpu/drm/amd/include/amd_shared.h
index abe829bbd54af..a9880fc531955 100644
--- a/drivers/gpu/drm/amd/include/amd_shared.h
+++ b/drivers/gpu/drm/amd/include/amd_shared.h
@@ -295,6 +295,7 @@ struct amd_ip_funcs {
 	int (*hw_init)(void *handle);
 	int (*hw_fini)(void *handle);
 	void (*late_fini)(void *handle);
+	int (*prepare_suspend)(void *handle);
 	int (*suspend)(void *handle);
 	int (*resume)(void *handle);
 	bool (*is_idle)(void *handle);
-- 
2.43.0



