Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950A428CF52;
	Wed, 23 Apr 2025 15:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421422; cv=none; b=H5eq0a6g+q2Wiei4op3mCSNFx96qWwrYXKpRdOSvNTxRvkaSy74DsvRWvZrukW0jJkqdxuhFG/iXNNkqwLYXUoeYiOdeNRvXifvz/jFpI4vihKy5BMx5W+w8iMLNDjo5jDDV4LrVi+FTii+1mEaKJYU7S+zTmRWDnHzCkSNlxMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421422; c=relaxed/simple;
	bh=GxCRJM/nGm1Auv3K60Lz6L3E9jf6jK69X5sJCbSB5HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO2ijOq+XjRrsoSmKvHhlV4TfSFPS/iLOWcTPNF9DA5Kl0P12sAsPDwRTgbyiwDoA71yQid0vWi/BWRWRpkirQna0t8HFvcwzrULPkJix8FS1a69apGDENGqJXnvxUPmD2aYMU7cxMKco4kvZYViG6dli0g3OxhRW15Dj/MYvoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZ65GTh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZ65GTh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C173AC4CEE2;
	Wed, 23 Apr 2025 15:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421421;
	bh=GxCRJM/nGm1Auv3K60Lz6L3E9jf6jK69X5sJCbSB5HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZ65GTh4lYghvTElYTRy1gnefGf15SQKe+0Tv5cg3/BXDbCgRXtCwMuwC4hj6xhwa
	 84CALXnVToPUMO2Y1x3P4gjQEtBF7wH3PtEAk6O6ePrBTA+esRALyUD9GoZQ2nuorO
	 Vk0TyX83GOAzRZyYxKJZS0OZ0tngdN9MuK8Y9SkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Shaoyun.liu" <Shaoyun.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 188/241] drm/amdgpu/mes12: optimize MES pipe FW version fetching
Date: Wed, 23 Apr 2025 16:44:12 +0200
Message-ID: <20250423142628.202294010@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 34779e14461cf715238dec5fd43a1e11977ec115 upstream.

Don't fetch it again if we already have it.  It seems the
registers don't reliably have the value at resume in some
cases.

Fixes: 785f0f9fe742 ("drm/amdgpu: Add mes v12_0 ip block support (v4)")
Reviewed-by: Shaoyun.liu <Shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9e7b08d239c2f21e8f417854f81e5ff40edbebff)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -1390,17 +1390,20 @@ static int mes_v12_0_queue_init(struct a
 		mes_v12_0_queue_init_register(ring);
 	}
 
-	/* get MES scheduler/KIQ versions */
-	mutex_lock(&adev->srbm_mutex);
-	soc21_grbm_select(adev, 3, pipe, 0, 0);
+	if (((pipe == AMDGPU_MES_SCHED_PIPE) && !adev->mes.sched_version) ||
+	    ((pipe == AMDGPU_MES_KIQ_PIPE) && !adev->mes.kiq_version)) {
+		/* get MES scheduler/KIQ versions */
+		mutex_lock(&adev->srbm_mutex);
+		soc21_grbm_select(adev, 3, pipe, 0, 0);
 
-	if (pipe == AMDGPU_MES_SCHED_PIPE)
-		adev->mes.sched_version = RREG32_SOC15(GC, 0, regCP_MES_GP3_LO);
-	else if (pipe == AMDGPU_MES_KIQ_PIPE && adev->enable_mes_kiq)
-		adev->mes.kiq_version = RREG32_SOC15(GC, 0, regCP_MES_GP3_LO);
+		if (pipe == AMDGPU_MES_SCHED_PIPE)
+			adev->mes.sched_version = RREG32_SOC15(GC, 0, regCP_MES_GP3_LO);
+		else if (pipe == AMDGPU_MES_KIQ_PIPE && adev->enable_mes_kiq)
+			adev->mes.kiq_version = RREG32_SOC15(GC, 0, regCP_MES_GP3_LO);
 
-	soc21_grbm_select(adev, 0, 0, 0, 0);
-	mutex_unlock(&adev->srbm_mutex);
+		soc21_grbm_select(adev, 0, 0, 0, 0);
+		mutex_unlock(&adev->srbm_mutex);
+	}
 
 	return 0;
 }


